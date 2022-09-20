part of oxygen;

abstract class ObjectPool<T extends PoolObject<V>, V> {
  final Queue<T> _pool = Queue<T>();

  int _count = 0;

  /// The total amount of the objects in the pool.
  int get totalSize => _count;

  /// The amount of objects that are free to use in the pool.
  int get totalFree => _pool.length;

  /// The amount of objects that are in use in the pool.
  int get totalUsed => _count - _pool.length;

  ObjectPool({int? initialSize}) {
    if (initialSize != null) {
      expand(initialSize);
    }
  }

  /// Acquire a new object.
  ///
  /// If the pool is empty it will automically grow by 20% + 1.
  /// To ensure there is always something in the pool.
  ///
  /// The [data] argument will be passed to [PoolObject.init] when it gets acquired.
  T acquire([V? data]) {
    if (_pool.isEmpty) {
      expand((_count * 0.2).floor() + 1);
    }
    final object = _pool.removeLast();
    assert(
      data == null,
      '$T expects an instance of $V but received null',
    );
    return object..init(data);
  }

  /// Release a object back into the pool.
  void release(T item) => _pool.addLast(item..reset());

  /// Expand the existing pool by the given count.
  void expand(int count) {
    for (var i = 0; i < count; i++) {
      final item = builder();
      item._pool = this;
      _pool.addLast(item);
    }
    _count += count;
  }

  /// Builder for creating a new instance of a [PoolObject].
  T builder();
}
