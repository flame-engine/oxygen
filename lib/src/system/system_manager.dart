part of oxygen;

/// Manages all registered systems.
class SystemManager {
  /// The world in which this manager lives.
  final World world;

  /// All the registered systems.
  final List<System> _systems = [];

  SystemManager(this.world);

  /// Initialize all the systems that are registered.
  void init() {
    for (final system in _systems) {
      system.init();
    }
  }

  /// Register a new system.
  void registerSystem<T extends System>(T system) {
    assert(system.world == null, '$T is already registered');
    system.world = world;
    _systems.add(system);
    _systems.sort((a, b) => a.priority - b.priority);
  }

  /// Execute all the systems that are registered.
  void _execute(double delta) {
    for (final system in _systems) {
      system.execute(delta);
    }
  }
}
