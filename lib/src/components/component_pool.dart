import 'dart:typed_data';

import './component.dart';
import '../entity/entity.dart';
import '../helpers.dart';
import '../world.dart';

typedef ComponentBuilder<T> = T Function();

/// A ComponentPool is a way to store data for an [Entity].
///
/// Provides an api to add/request/remove components on an entity.
///
/// https://austinmorlan.com/posts/entity_component_system/#the-component-array
class ComponentPool<T extends Component> {
  final int _id;
  final World _world;

  /// Used to create a list of [_components] when a ComponentPool is
  /// initialized, or when all elements from [_components] are assigned to
  /// entities.
  final ComponentBuilder<T> _componentBuilder;

  /// List of components. Each element can be attached to one entity.
  ///
  /// Element index of 0 is reserved and is not used.
  final List<T> _components;
  int _componentsCount = 1;

  /// Stores the index of the [Component] that is attached to the entity.
  ///
  /// The index is an entity. The value is the index of the [Component] stored
  /// in [_components].
  Uint32List _entityToComponentIndex;
  Uint32List _recycledComponentIndexes;
  int _recycledIndexesCount = 0;

  int get id => _id;

  ComponentPool(
    World world,
    ComponentBuilder<T> componentBuilder,
    int id,
    int capacity,
  )   : _world = world,
        _componentBuilder = componentBuilder,
        _id = id,
        _components = List.generate(
          capacity + 1,
          (index) => componentBuilder(),
        ),
        _entityToComponentIndex = Uint32List(capacity),
        _recycledComponentIndexes = Uint32List(capacity);

  T add(Entity entity) {
    assert(_world.isEntityAliveInternal(entity), 'Entity was removed.');
    assert(
      _entityToComponentIndex[entity] == 0,
      'Component $T already attached to entity.',
    );

    int index;
    if (_recycledIndexesCount > 0) {
      index = _recycledComponentIndexes[--_recycledIndexesCount];
    } else {
      index = _componentsCount;
      // Fill when _components is filled out.
      if (_componentsCount == _components.length) {
        _components.addAll(
          Iterable.generate(_componentsCount, (i) => _componentBuilder()),
        );
      }
    }
    _componentsCount++;
    _components[index].init();
    _entityToComponentIndex[entity] = index;
    _world.onEntityChangeInternal(entity, _id, true);
    _world.entities[entity].componentsCount++;

    return _components[index];
  }

  void delete(Entity entity) {
    assert(_world.isEntityAliveInternal(entity), 'Entity was removed.');

    final recycledIndex = _entityToComponentIndex[entity];
    if (recycledIndex > 0) {
      _world.onEntityChangeInternal(entity, _id, false);
      // Fill when _recycledComponentIndexes is filled out.
      if (_recycledIndexesCount == _recycledComponentIndexes.length) {
        _recycledComponentIndexes = _recycledComponentIndexes.resize();
      }
      _recycledComponentIndexes[_recycledIndexesCount++] = recycledIndex;
      _components[recycledIndex].reset();
      _entityToComponentIndex[entity] = 0;
      final entityData = _world.entities[entity];
      entityData.componentsCount--;
      _componentsCount--;
      if (entityData.componentsCount == 0) {
        _world.deleteEntity(entity);
      }
    }
  }

  T get(Entity entity) {
    assert(_world.isEntityAliveInternal(entity), 'Entity was removed.');
    assert(
      _entityToComponentIndex[entity] != 0,
      'Cant get $T. Component not attached',
    );

    return _components[_entityToComponentIndex[entity]];
  }

  bool has(Entity entity) {
    assert(_world.isEntityAliveInternal(entity), 'Entity was removed.');

    return _entityToComponentIndex[entity] > 0;
  }

  void resize(int capacity) {
    _entityToComponentIndex = _entityToComponentIndex.resize(capacity);
  }
}
