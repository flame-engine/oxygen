import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'components/component.dart';
import 'components/component_pool.dart';
import 'entity/entity.dart';
import 'entity/entity_data.dart';
import 'filter/filter.dart';
import 'helpers.dart';
import 'mask/mask.dart';
import 'mask/mask_delegate.dart';
import 'mask/mask_pool.dart';
import 'world_config.dart';

class World implements MaskDelegate {
  final Config _config;
  @internal
  final List<EntityData> entities;
  int _entitiesCount;
  @internal
  Uint32List recycledEntities;
  @internal
  int recycledEntitiesCount;
  final List<ComponentPool> _pools;
  int _poolsCount;
  @internal
  final Map<Type, ComponentPool> poolCached;
  @internal
  final Map<int, Filter> hashedFilters;
  @internal
  final List<Filter> allFilters;
  @internal
  final List<List<Filter>> filtersByIncludedComponents;
  @internal
  final List<List<Filter>> filtersByExcludedComponents;
  bool _destroyed;
  late final MaskPool _maskPool;

  int getComponentCount(Entity entity) => entities[entity].componentsCount;
  bool isUsedEntity(Entity entity) => entities[entity].isAlive;
  int get entitiesCount => _entitiesCount - recycledEntitiesCount;
  int get worldSize => entities.length;
  int get poolsCount => _poolsCount;
  bool get isAlive => !_destroyed;

  World([this._config = const Config()])
      : entities = List.generate(_config.entities, (_) => EntityData()),
        recycledEntities = Uint32List(_config.recycledEntities),
        _entitiesCount = 0,
        recycledEntitiesCount = 0,
        _pools = <ComponentPool>[],
        poolCached = <Type, ComponentPool>{},
        filtersByIncludedComponents = List.generate(_config.pools, (_) => []),
        filtersByExcludedComponents = List.generate(_config.pools, (_) => []),
        _poolsCount = 0,
        hashedFilters = <int, Filter>{},
        allFilters = <Filter>[],
        _destroyed = false {
    // TODO(danCrane): capacity maskPool
    _maskPool = MaskPool(64, () => Mask(this));
  }

  ComponentPool<T> registerPool<T extends Component>(T Function() generator) {
    return poolCached.putIfAbsent(T, () {
      final pool = ComponentPool<T>(
        this,
        generator,
        _poolsCount,
        _config.poolCapacity,
      );

      if (filtersByIncludedComponents.length == _poolsCount ||
          filtersByExcludedComponents.length == _poolsCount) {
        filtersByIncludedComponents.addAll(
          Iterable.generate(_config.pools, (_) => []),
        );
        filtersByExcludedComponents.addAll(
          Iterable.generate(_config.pools, (_) => []),
        );
      }

      _pools.add(pool);
      _poolsCount++;

      return pool;
    }) as ComponentPool<T>;
  }

  /// Returns the registered [ComponentPool].
  @override
  ComponentPool<T> getPool<T extends Component>() {
    assert(
      poolCached[T] != null,
      'Pool of $T does`t registered',
    );

    return poolCached[T]! as ComponentPool<T>;
  }

  Entity createEntity() {
    Entity entity;
    if (recycledEntitiesCount > 0) {
      entity = recycledEntities[--recycledEntitiesCount];
      final entityData = entities[entity];
      entityData.isAlive = true;
    } else {
      // New entity.
      if (_entitiesCount == entities.length) {
        // Resize entities and component pools.
        entities.addAll(List.generate(_entitiesCount, (_) => EntityData()));
        for (var i = 0; i < _poolsCount; i++) {
          _pools[i].resize(_entitiesCount);
        }
        final length = allFilters.length;
        for (var i = 0; i < length; i++) {
          allFilters[i].resizeSparseEntities(_entitiesCount);
        }
      }
      entity = _entitiesCount++;
      entities[entity].isAlive = true;
    }

    return entity;
  }

  void deleteEntity(Entity entity) {
    final entityData = entities[entity];

    if (!entityData.isAlive) {
      return;
    }

    // Delete components.
    if (entityData.componentsCount > 0) {
      var index = 0;
      // TODO(dan): need more tests
      while (entityData.componentsCount > 0 && index < _poolsCount) {
        if (_pools[index].has(entity)) {
          _pools[index].delete(entity);
        }
        index++;
      }

      return;
    }

    entityData.isAlive = false;
    if (recycledEntitiesCount == recycledEntities.length) {
      recycledEntities = recycledEntities.resize();
    }
    recycledEntities[recycledEntitiesCount++] = entity;
  }

  Mask filter<T extends Component>() => _maskPool.take()..include<T>();

  void destroy() {
    _destroyed = true;
    for (var i = _entitiesCount - 1; i >= 0; i--) {
      final entityData = entities[i];

      if (entityData.componentsCount > 0) {
        deleteEntity(i);
      }
    }
    _pools.clear();
    poolCached.clear();
    hashedFilters.clear();
    allFilters.clear();
    filtersByIncludedComponents.clear();
    filtersByExcludedComponents.clear();
  }

  @internal
  bool isEntityAliveInternal(Entity entity) =>
      entity >= 0 && entity < _entitiesCount && entities[entity].isAlive;

  @internal
  void onEntityChangeInternal(Entity entity, int componentId, bool added) {
    final includeList = filtersByIncludedComponents[componentId];
    final excludeList = filtersByExcludedComponents[componentId];
    if (added) {
      // Add component.
      if (includeList.isNotEmpty) {
        for (final filter in includeList) {
          if (isMaskCompatible(filter.mask, entity)) {
            filter.addEntity(entity);
          }
        }
      }
      if (excludeList.isNotEmpty) {
        for (final filter in excludeList) {
          if (isMaskCompatibleWithout(filter.mask, entity, componentId)) {
            filter.removeEntity(entity);
          }
        }
      }
    } else {
      // Remove component.
      if (includeList.isNotEmpty) {
        for (final filter in includeList) {
          if (isMaskCompatible(filter.mask, entity)) {
            filter.removeEntity(entity);
          }
        }
      }
      if (excludeList.isNotEmpty) {
        for (final filter in excludeList) {
          if (isMaskCompatibleWithout(filter.mask, entity, componentId)) {
            filter.addEntity(entity);
          }
        }
      }
    }
  }

  /// Checks if the [Entity] has in the mask.
  @internal
  bool isMaskCompatible(Mask mask, Entity entity) {
    for (var i = 0; i < mask.includeCount; i++) {
      if (!_pools[mask.includeList[i]].has(entity)) {
        return false;
      }
    }
    for (var i = 0; i < mask.excludeCount; i++) {
      if (_pools[mask.excludeList[i]].has(entity)) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the [Entity] has in the mask without component.
  @internal
  bool isMaskCompatibleWithout(Mask mask, Entity entity, int componentId) {
    for (var i = 0; i < mask.includeCount; i++) {
      final poolId = mask.includeList[i];
      if (poolId == componentId || !_pools[poolId].has(entity)) {
        return false;
      }
    }
    for (var i = 0; i < mask.excludeCount; i++) {
      final poolId = mask.excludeList[i];
      if (poolId != componentId && _pools[poolId].has(entity)) {
        return false;
      }
    }
    return true;
  }

  @override
  @internal
  FilterCheckResult checkFilter(Mask mask, [int capacity = 512]) {
    final hash = mask.hash;
    final exists = hashedFilters[hash];

    if (exists != null) {
      return FilterCheckResult(exists, false);
    }

    final filter = Filter(mask, capacity, entities.length);
    hashedFilters[hash] = filter;
    allFilters.add(filter);

    for (var i = 0; i < mask.includeCount; i++) {
      filtersByIncludedComponents[mask.includeList[i]].add(filter);
    }
    for (var i = 0; i < mask.excludeCount; i++) {
      filtersByExcludedComponents[mask.excludeList[i]].add(filter);
    }
    for (var entity = 0; entity < _entitiesCount; entity++) {
      final entityData = entities[entity];
      if (entityData.componentsCount > 0 && isMaskCompatible(mask, entity)) {
        filter.addEntity(entity);
      }
    }

    return FilterCheckResult(filter, true);
  }

  @override
  @internal
  void onMaskRecycle(Mask mask) => _maskPool.release(mask);
}
