part of oxygen;

/// A Component is a way to store data for an Entity.
///
/// It does not define any kind of behaviour because that is handled by the systems.
abstract class Component<T> extends PoolObject<T> {}
