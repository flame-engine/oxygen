import 'package:example/components/bullet_move_component.dart';
import 'package:example/components/direction_component.dart';
import 'package:example/components/position_component.dart';

import 'package:oxygen/oxygen.dart';

class BulletMoveSystem implements RunSystem, InitSystem {
  late final ComponentPool<PositionComponent> _positionPool;
  late final ComponentPool<DirectionComponent> _directionPool;

  @override
  void init(Systems systems) {
    _positionPool = systems.world.getPool<PositionComponent>();
    _directionPool = systems.world.getPool<DirectionComponent>();
  }

  @override
  void run(Systems systems, double delta) {
    final filter = systems.world
        .filter<DirectionComponent>()
        .include<PositionComponent>()
        .include<BulletMoveComponent>()
        .end();

    for (final entity in filter) {
      final position = _positionPool.get(entity);
      final direction = _directionPool.get(entity).direction.toVector();

      position.x = position.x! + direction.x;
      position.y = position.y! + direction.y;
    }
  }
}
