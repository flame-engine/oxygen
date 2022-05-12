import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../components/component.dart';
import '../components/component_pool.dart';
import '../filter/filter.dart';
import '../helpers.dart';
import 'mask_delegate.dart';

/// Stores lists of include and exclude [ComponentPool.id].
class Mask {
  final MaskDelegate _delegate;

  /// List of include [ComponentPool.id].
  @internal
  Uint8List includeList;
  @internal
  int includeCount = 0;

  /// List of exclude [ComponentPool.id].
  @internal
  Uint8List excludeList;
  @internal
  int excludeCount = 0;

  /// Unique hash based on the length of [includeList], [excludeList] and
  /// [ComponentPool.id] within them.
  @internal
  int hash = 0;

  Mask(MaskDelegate delegate)
      : _delegate = delegate,
        includeList = Uint8List(8),
        excludeList = Uint8List(4);

  Mask include<T extends Component>() {
    final poolId = _delegate.getPool<T>().id;

    assert(
      !includeList.containsValue(poolId, includeCount),
      '$T is already in the include list',
    );
    assert(
      !excludeList.containsValue(poolId, excludeCount),
      '$T is already in the exclude list',
    );

    if (includeCount == includeList.length) {
      includeList = includeList.resize();
    }

    includeList[includeCount++] = poolId;

    return this;
  }

  Mask exclude<T extends Component>() {
    final poolId = _delegate.getPool<T>().id;

    assert(
      !includeList.containsValue(poolId, includeCount),
      '$T is already in the include list',
    );
    assert(
      !excludeList.containsValue(poolId, excludeCount),
      '$T is already in the exclude list',
    );

    if (excludeCount == excludeList.length) {
      excludeList = excludeList.resize();
    }

    excludeList[excludeCount++] = poolId;

    return this;
  }

  /// Returns a filter with entities based on [includeList] and [excludeList].
  ///
  /// capacity -- specifies the number of entities that can be in the filter.
  /// This is a flexible parameter, if you exceed the [capacity] limit,
  /// the list of entities will automatically be expanded.
  Filter end([int capacity = 512]) {
    includeList = includeList.sortTo(includeCount);
    excludeList = excludeList.sortTo(excludeCount);

    hash = includeCount + excludeCount;
    for (var i = 0; i < includeCount; i++) {
      hash = hash * 314 + includeList[i];
    }
    for (var i = 0; i < excludeCount; i++) {
      hash = hash * 314 - excludeList[i];
    }

    final result = _delegate.checkFilter(this, capacity);

    if (!result.isNew) {
      _recycle();
    }

    return result.filter;
  }

  /// Resets the data. Must be called before release to the pool if a filter
  /// with this mask exists.
  void _reset() {
    includeCount = 0;
    excludeCount = 0;
    hash = 0;
  }

  /// Resets the data and release the mask back to the pool.
  /// Must be called when a filter already exists.
  void _recycle() {
    _reset();
    _delegate.onMaskRecycle(this);
  }
}
