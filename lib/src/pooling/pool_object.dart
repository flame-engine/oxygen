part of oxygen;

abstract class PoolObject<T> {
  ObjectPool _pool;

  void init([T data]);

  void reset();

  void dispose() => _pool?.release(this);
}
