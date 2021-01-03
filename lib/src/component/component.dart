part of oxygen;

@immutable
abstract class InitObject {}

abstract class Component<T extends InitObject> extends PoolObject {
  Type get initType => T;

  @override
  void init([covariant T data]);

  @override
  void reset();
}
