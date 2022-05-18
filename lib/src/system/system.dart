import '../filter/filter.dart';
import '../world.dart';
import '../world_config.dart';

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
  final World _defaultWorld;
  final _worlds = <String, World>{};
  final _allSystems = <BaseSystem>[];
  final _runSystems = <RunSystem>[];
  var _runSystemsCount = 0;

  World get world => _defaultWorld;

  Systems(World world) : _defaultWorld = world;

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

  void add(BaseSystem system) => _allSystems.add(system);

  /// It's useful to use a separate world for short-lived entity-events, since
  /// each world has a size of [Config.entities] * [Config.pools]. That is,
  /// if you have 100k entities for units in a world, and you suddenly create
  /// one entity-events with a "Click" component, a pool with a huge size will
  /// be created for that component, which will eventually lead to irrational
  /// memory allocation.
  void addWorld(String name, World world) =>
      _worlds.putIfAbsent(name, () => world);

  World getWorld(String name) => _worlds[name] ?? _defaultWorld;

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
