import 'dart:collection';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../entity/entity.dart';
import '../helpers.dart';
import '../mask/mask.dart';
import 'filter_operation.dart';

class Filter extends IterableBase<Entity> {
  final Mask _mask;

  /// Packaged entities.
  Uint32List _denseEntities;
  int _entitiesCount = 0;

  /// Stores index of the entity from [_denseEntities].
  ///
  /// Index is incremented by 1 when added.
  Uint32List _sparseEntities;

  /// List of operations performed during the iteration of the entities.
  @internal
  final List<FilterOperation> operations;
  @internal
  int operationsCount = 0;

  /// _lockCount can be > 1 when a nested iteration occurs.
  @internal
  int lockCount;
  int get entitiesCount => _entitiesCount;
  @internal
  Mask get mask => _mask;
  @internal
  Uint32List get denseEntities => _denseEntities;
  @internal
  Uint32List get sparseEntities => _sparseEntities;

  Filter(
    Mask mask,
    int denseCapacity,
    int sparseCapacity, [
    @visibleForTesting this.lockCount = 0,
  ])  : _mask = mask,
        _denseEntities = Uint32List(denseCapacity),
        _sparseEntities = Uint32List(sparseCapacity),
        // TODO(danCrane): set size of operations
        operations = List.generate(512, (_) => FilterOperation());

  @internal
  void resizeSparseEntities(int capacity) {
    _sparseEntities = _sparseEntities.resize(capacity);
  }

  @internal
  void addEntity(int entity) {
    if (addOperation(true, entity)) {
      return;
    }

    if (_entitiesCount == _denseEntities.length) {
      _denseEntities = _denseEntities.resize();
    }
    _denseEntities[_entitiesCount++] = entity;
    _sparseEntities[entity] = _entitiesCount;
  }

  @internal
  void removeEntity(int entity) {
    if (addOperation(false, entity)) {
      return;
    }

    final idx = _sparseEntities[entity] - 1;
    _sparseEntities[entity] = 0;
    _entitiesCount--;
    if (idx < _entitiesCount) {
      _denseEntities[idx] = _denseEntities[_entitiesCount];
      _sparseEntities[_denseEntities[idx]] = idx + 1;
    }
  }

  /// Adds operation to [operations] during an iteration of an entity.
  /// This is necessary to have an up-to-date set of entities in the filter.
  @internal
  bool addOperation(bool added, int entity) {
    if (lockCount <= 0) {
      return false;
    }

    if (operationsCount == operations.length) {
      operations.addAll(
        Iterable.generate(operationsCount, (_) => FilterOperation()),
      );
    }
    final op = operations[operationsCount++];
    op.added = added;
    op.entity = entity;

    return true;
  }

  /// Is automatically called after completing an iteration to update the
  /// [_denseEntities] and [_sparseEntities].
  @internal
  void unlock() {
    --lockCount;

    if (lockCount == 0 && operationsCount > 0) {
      for (var i = 0; i < operationsCount; i++) {
        final operation = operations[i];
        if (operation.added) {
          addEntity(operation.entity);
        } else {
          removeEntity(operation.entity);
        }
      }
      operationsCount = 0;
    }
  }

  @override
  Iterator<int> get iterator {
    lockCount++;

    return FilterIterator(this);
  }
}

class FilterIterator extends Iterator<Entity> {
  final Filter _filter;
  final Uint32List _entities;
  final int _count;
  int _index;

  FilterIterator(Filter filter)
      : _filter = filter,
        _entities = filter._denseEntities,
        _count = filter._entitiesCount,
        _index = -1;

  @override
  Entity get current => _entities[_index];

  @override
  bool moveNext() {
    if (++_index < _count) {
      return true;
    } else {
      _filter.unlock();
      return false;
    }
  }
}
