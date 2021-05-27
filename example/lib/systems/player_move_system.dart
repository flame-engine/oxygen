import 'package:example/components/color_component.dart';
import 'package:example/components/direction_component.dart';
import 'package:example/components/player_component.dart';
import 'package:example/components/position_component.dart';
import 'package:example/components/render_component.dart';
import 'package:example/components/velocity_component.dart';
import 'package:example/utils/color.dart';
import 'package:example/utils/keyboard.dart';
import 'package:example/utils/vector2.dart';
import 'package:oxygen/oxygen.dart';

class PlayerMoveSystem extends System {
  late Query query;

  late int _nextShot;

  @override
  void init() {
    _nextShot = 0;
    query = createQuery([
      Has<PlayerComponent>(),
      Has<PositionComponent>(),
      Has<DirectionComponent>(),
    ]);
  }

  void setDirection(Direction dir, Entity entity) {
    query.entities.first.get<DirectionComponent>()!.value = dir;
  }

  Direction getDirection(Entity entity) {
    return query.entities.first.get<DirectionComponent>()!.value!;
  }

  @override
  void execute(delta) {
    final player = query.entities.first;
    final position = player.get<PositionComponent>()!;

    if (keyboard.isPressed(Key.w)) {
      position.y = position.y! - 1;
      setDirection(Direction.up, player);
    } else if (keyboard.isPressed(Key.s)) {
      position.y = position.y! + 1;
      setDirection(Direction.down, player);
    } else if (keyboard.isPressed(Key.a)) {
      position.x = position.x! - 1;
      setDirection(Direction.left, player);
    } else if (keyboard.isPressed(Key.d)) {
      position.x = position.x! + 1;
      setDirection(Direction.right, player);
    }

    if (keyboard.isPressed(Key.space) &&
        _nextShot < DateTime.now().millisecondsSinceEpoch) {
      _nextShot = DateTime.now().millisecondsSinceEpoch + 500;
      final direction = getDirection(player);
      world!.createEntity()
        ..add<VelocityComponent, Vector2>(
          Vector2(
            direction == Direction.left
                ? -1
                : direction == Direction.right
                    ? 1
                    : 0,
            direction == Direction.up
                ? -1
                : direction == Direction.down
                    ? 1
                    : 0,
          ),
        )
        ..add<RenderComponent, String>('♥')
        ..add<ColorComponent, Color>(Colors.red)
        ..add<PositionComponent, Vector2>(Vector2(position.x!, position.y!));
    }
  }
}
