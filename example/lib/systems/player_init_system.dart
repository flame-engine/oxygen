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
    systems.world.getPool(PlayerComponent.new).add(player);
    systems.world.getPool(NameComponent.new).add(player).init('Tim');
    systems.world.getPool(RenderComponent.new).add(player).init('🐥');
    systems.world
        .getPool(DirectionComponent.new)
        .add(player)
        .init(Direction.right);
    systems.world
        .getPool(PositionComponent.new)
        .add(player)
        .init(terminal.viewport.center);
  }
}
