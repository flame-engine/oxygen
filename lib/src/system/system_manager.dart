part of oxygen;

class SystemManager {
  final World world;

  List<System> _systems = [];

  SystemManager(this.world);

  void init() {
    for (final system in _systems) {
      system.init();
    }
  }

  void registerSystem<T extends System>(T system) {
    assert(system.world == null, '$T is already registered');
    system.world = this.world;
    _systems.add(system);
    _systems.sort((a, b) => a.priority - b.priority);
  }

  void _execute() {
    for (final system in _systems) {
      system.execute();
    }
  }
}
