import '../filter/filter.dart';
import '../world.dart';

/// Systems contain the logic for components.
///
/// They can update data stored in the components.
/// They filter components to get entities matching their [Filter].
/// And they can iterate through those entities each execution frame.
abstract class BaseSystem {}

abstract class InitSystem extends BaseSystem {
  /// Called during [Systems.init].
  void init(Systems systems);
}

abstract class RunSystem extends BaseSystem {
  /// Called during [Systems.run].
  void run(Systems systems, double dt);
}

abstract class DestroySystem extends BaseSystem {
  /// Called during [Systems.destroy].
  void destroy(Systems systems);
}

/// Manages all registered systems.
class Systems {
  final World _world;
  final _allSystems = <BaseSystem>[];
  final _runSystems = <RunSystem>[];

  World get world => _world;

  Systems(World world) : _world = world;

  void init() {
    for (final system in _allSystems) {
      if (system is InitSystem) {
        system.init(this);
      }
      if (system is RunSystem) {
        _runSystems.add(system);
      }
    }
  }

  void add(BaseSystem system) {
    _allSystems.add(system);
  }

  void run(double dt) {
    final length = _runSystems.length;
    for (var i = 0; i < length; i++) {
      _runSystems[i].run(this, dt);
    }
  }

  void destroy() {
    for (var i = _allSystems.length - 1; i >= 0; i--) {
      final system = _allSystems[i];
      if (system is DestroySystem) {
        system.destroy(this);
      }
    }

    _allSystems.clear();
    _runSystems.clear();
  }
}
