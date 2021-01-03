part of oxygen;

abstract class ObjectPool<T extends PoolObject> {
  Queue<T> _pool = Queue<T>();

  int _count = 0;

  /// The total amount of the objects in the pool.
  int get totalSize => _count;

  /// The amount of objects that are free to use in the pool.
  int get totalFree => _pool.length;

  /// The amount of objects that are in use in the pool.
  int get totalUsed => _count - _pool.length;

  ObjectPool({int initialSize}) {
    if (initialSize != null) {
      expand(initialSize);
    }
  }

  /// Acquire a new object.
  ///
  /// If the pool is empty it will automically grow by 20% + 1.
  /// To ensure there is always something in the pool.
  T acquire([data]) {
    if (_pool.length <= 0) {
      expand((_count * 0.2).floor() + 1);
    }

    return _pool.removeLast()..init(data);
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

  /// Builder that fills the pool.
  T builder();
}
