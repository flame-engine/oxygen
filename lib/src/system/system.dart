part of oxygen;

/// Systems contain the logic for components.
///
/// They can update data stored in the components.
/// They query on components to get the entities that fit their Query.
/// And they can iterate through those entities each execution frame.
abstract class System {
  /// The world to which this system belongs to.
  World? world;

  /// The priority of this system.
  ///
  /// Used to set the priority of this system compared to the other systems.
  /// A System with a priority of 1 will go before a System with a priority of 2.
  ///
  /// It can't be changed at runtime.
  final int priority;

  System({this.priority = 0});

  /// Initialize the System.
  void init();

  /// Disposing of the System.
  @mustCallSuper
  void dispose() {
    world = null;
  }

  /// Create a new Query to filter entites.
  Query createQuery(Iterable<Filter> filters) =>
      world!.entityManager._queryManager.createQuery(filters);

  /// Execute the System.
  void execute(double delta);
}
