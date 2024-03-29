part of oxygen;

/// Manages all registered systems.
class SystemManager {
  /// The world in which this manager lives.
  final World world;

  /// All the registered systems.
  final List<System> _systems = [];

  UnmodifiableListView<System> get systems => UnmodifiableListView(_systems);

  final Map<Type, System> _systemsByType = {};

  SystemManager(this.world);

  /// Initialize all the systems that are registered.
  void init() {
    for (final system in _systems) {
      system.init();
    }
  }

  /// Register a system.
  ///
  /// If a given system type has already been added, it will simply return.
  void registerSystem<T extends System>(T system) {
    assert(system.world == null, '$T is already registered');
    if (_systemsByType.containsKey(system.runtimeType)) {
      return;
    }
    system.world = world;
    _systems.add(system);
    _systemsByType[T] = system;

    _systems.sort((a, b) => a.priority - b.priority);
  }

  /// Deregister a previously registered system.
  ///
  /// If the given system type is not found, it will simply return.
  void deregisterSystem(Type systemType) {
    if (!_systemsByType.containsKey(systemType)) {
      return;
    }
    final system = _systemsByType.remove(systemType);
    system?.dispose();
    _systems.remove(system);

    _systems.sort((a, b) => a.priority - b.priority);
  }

  /// Execute all the systems that are registered.
  void _execute(double delta) {
    for (final system in _systems) {
      system.execute(delta);
    }
  }
}
