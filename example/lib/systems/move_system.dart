import 'dart:io';

import 'package:oxygen/oxygen.dart';

import '../components/position_component.dart';

class MoveSystem extends System {
  Query query;

  @override
  void init() {
    query = createQuery([
      Has<PositionComponent>(),
    ]);
  }

  @override
  void execute() {
    final delta = world.retrieve<double>('delta');

    query.entities.forEach((entity) {
      final position = entity.getComponent<PositionComponent>();
      
      if (position.x < stdout.terminalColumns) {
        position.x += 1 * delta;
      } else {
        position.x = 0;
      }

      if (position.y < stdout.terminalLines) {
        position.y += 1 * delta;
      } else {
        position.y = 0;
      }
    });
  }
}
