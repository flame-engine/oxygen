part of oxygen;

@immutable

/// A InitObject defines the parameters with which components get initialized.
abstract class InitObject {}

/// A Component is a way to store data for an Entity.
///
/// It does not define any kind of behaviour because that is handled by the systems.
abstract class Component<T extends InitObject> extends PoolObject {
  /// The [InitObject] of this component.
  ///
  /// Used to ensure the right data is passed along to the [init].
  Type get initType => T;

  @override
  void init([covariant T data]);

  @override
  void reset();
}
