import 'package:oxygen/oxygen.dart';

import 'components/atack_component.dart';
import 'components/bullet_component.dart';
import 'components/bullet_move_component.dart';
import 'components/color_component.dart';
import 'components/direction_component.dart';
import 'components/name_component.dart';
import 'components/player_component.dart';
import 'components/position_component.dart';
import 'components/render_component.dart';
import 'components/unit_move_component.dart';
import 'systems/bullet_move_system.dart';
import 'systems/bullet_spawner_system.dart';
import 'systems/clean_atack_system.dart';
import 'systems/clean_bullet_system.dart';
import 'systems/clean_move_command_system.dart';
import 'systems/player_atack_input_system.dart';
import 'systems/player_init_system.dart';
import 'systems/player_move_input_system.dart';
import 'systems/render_system.dart';
import 'systems/unit_move_system.dart';
import 'utils/game.dart';

void main() => ExampleGame();

class ExampleGame extends Game {
  late World world;
  late Systems systems;

  @override
  void onLoad() {
    world = World()
      ..registerPool(PositionComponent.new)
      ..registerPool(RenderComponent.new)
      ..registerPool(ColorComponent.new)
      ..registerPool(NameComponent.new)
      ..registerPool(UnitMoveComponent.new)
      ..registerPool(BulletMoveComponent.new)
      ..registerPool(BulletComponent.new)
      ..registerPool(DirectionComponent.new)
      ..registerPool(PlayerComponent.new)
      ..registerPool(AtackComponent.new);
    systems = Systems(world)
      ..add(PlayerInitSystem())
      ..add(PlayerMoveInputSystem())
      ..add(PlayerAtackInputSystem())
      ..add(UnitMoveSystem())
      ..add(BulletSpawnerSystem())
      ..add(BulletMoveSystem())
      ..add(CleanUnitMoveSystem())
      ..add(CleanAtackSystem())
      ..add(CleanBulletSystem())
      ..add(RenderSystem())
      ..init();
  }

  @override
  void update(double delta) => systems.run(delta);
}
