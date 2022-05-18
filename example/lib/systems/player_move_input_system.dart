import 'package:example/components/direction_component.dart';
import 'package:example/components/player_component.dart';
import 'package:example/components/unit_move_component.dart';
import 'package:example/utils/keyboard.dart';

import 'package:oxygen/oxygen.dart';

class PlayerMoveInputSystem implements RunSystem, InitSystem {
  late final ComponentPool<UnitMoveComponent> _moveCommandPool;
  late final ComponentPool<DirectionComponent> _directionPool;

  @override
  void init(Systems systems) {
    _moveCommandPool = systems.world.getPool(UnitMoveComponent.new);
    _directionPool = systems.world.getPool(DirectionComponent.new);
  }

  @override
  void run(Systems systems, double dt) {
    final filter = systems.world
        .filter(PlayerComponent.new)
        .include(DirectionComponent.new)
        .end();

    for (final entity in filter) {
      if (keyboard.isPressed(Key.w)) {
        _setDirection(entity, Direction.up);
      } else if (keyboard.isPressed(Key.s)) {
        _setDirection(entity, Direction.down);
      } else if (keyboard.isPressed(Key.a)) {
        _setDirection(entity, Direction.left);
      } else if (keyboard.isPressed(Key.d)) {
        _setDirection(entity, Direction.right);
      }
    }
  }

  void _setDirection(Entity entity, Direction direction) {
    _moveCommandPool.add(entity);
    _directionPool.get(entity).init(direction);
  }
}
