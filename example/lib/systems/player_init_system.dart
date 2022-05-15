import 'package:example/components/direction_component.dart';
import 'package:example/components/name_component.dart';
import 'package:example/components/player_component.dart';
import 'package:example/components/position_component.dart';
import 'package:example/components/render_component.dart';
import 'package:example/utils/terminal.dart';

import 'package:oxygen/oxygen.dart';

class PlayerInitSystem implements InitSystem {
  @override
  void init(Systems systems) {
    final player = systems.world.createEntity();
    systems.world.getPool<PlayerComponent>().add(player);
    systems.world.getPool<NameComponent>().add(player).init('Tim');
    systems.world.getPool<RenderComponent>().add(player).init('🐥');
    systems.world
        .getPool<DirectionComponent>()
        .add(player)
        .init(Direction.right);
    systems.world
        .getPool<PositionComponent>()
        .add(player)
        .init(terminal.viewport.center);
  }
}
