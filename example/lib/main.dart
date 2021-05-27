import 'package:example/components/color_component.dart';
import 'package:example/components/direction_component.dart';
import 'package:example/components/name_component.dart';
import 'package:example/components/player_component.dart';
import 'package:example/components/velocity_component.dart';
import 'package:example/systems/player_move_system.dart';
import 'package:example/utils/color.dart';
import 'package:example/utils/game.dart';
import 'package:example/utils/vector2.dart';
import 'package:example/utils/terminal.dart';
import 'package:oxygen/oxygen.dart';

import 'systems/move_system.dart';
import 'systems/render_system.dart';
import 'components/position_component.dart';
import 'components/render_component.dart';

void main() => ExampleGame();

class ExampleGame extends Game {
  late World world;

  @override
  void onLoad() {
    world = World();

    world.registerSystem(PlayerMoveSystem());
    world.registerSystem(MoveSystem());
    world.registerSystem(RenderSystem());
    world.registerComponent(() => DirectionComponent());
    world.registerComponent(() => VelocityComponent());
    world.registerComponent(() => PositionComponent());
    world.registerComponent(() => PlayerComponent());
    world.registerComponent(() => RenderComponent());
    world.registerComponent(() => ColorComponent());
    world.registerComponent(() => NameComponent());

    world.createEntity()
      ..add<NameComponent, String>('Boi')
      ..add<DirectionComponent, Direction>(Direction.right)
      ..add<ColorComponent, Color>(Colors.red)
      ..add<RenderComponent, String>('█')
      ..add<PositionComponent, Vector2>(
        terminal.viewport.center.translate(0, -10),
      );

    world.createEntity()
      ..add<NameComponent, String>('Tim')
      ..add<DirectionComponent, Direction>(Direction.right)
      ..add<PlayerComponent, void>()
      ..add<RenderComponent, String>('█')
      ..add<PositionComponent, Vector2>(terminal.viewport.center);

    world.init();
  }

  @override
  void update(double delta) => world.execute(delta);
}
