import 'package:oxygen/oxygen.dart';

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
    world = World();
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
