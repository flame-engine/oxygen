part of oxygen;

abstract class PoolObject<T> {
  /// The pool from which the object came from.
  ObjectPool _pool;

  /// Initialize this object.
  ///
  /// See [ObjectPool.acquire] for more information on how this gets called.
  void init([T data]);

  /// Reset this object.
  void reset();

  /// Release this object back into the pool.
  void dispose() => _pool?.release(this);
}
