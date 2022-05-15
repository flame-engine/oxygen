import 'package:example/components/unit_move_component.dart';
import 'package:oxygen/oxygen.dart';

class CleanUnitMoveSystem implements RunSystem, InitSystem {
  late final ComponentPool<UnitMoveComponent> _moveCommandPool;

  @override
  void init(Systems systems) {
    _moveCommandPool = systems.world.getPool<UnitMoveComponent>();
  }

  @override
  void run(Systems systems, double delta) {
    final filter = systems.world.filter<UnitMoveComponent>().end();

    for (final entity in filter) {
      _moveCommandPool.delete(entity);
    }
  }
}
