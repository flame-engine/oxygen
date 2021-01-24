import 'dart:io';

import 'package:oxygen/oxygen.dart';

import '../components/render_component.dart';
import '../components/position_component.dart';

class RenderSystem extends System {
  Query query;

  @override
  void init() {
    query = createQuery([
      Has<RenderComponent>(),
      Has<PositionComponent>(),
    ]);
  }

  @override
  void execute(delta) {
    stdout.write('\x1B[2J\x1B[0;0H');

    query.entities.forEach((entity) {
      final position = entity.get<PositionComponent>();
      final key = entity.get<RenderComponent>().value;

      stdout.write('\x1B[${position.y.toInt()};${position.x.toInt()}H');
      stdout.write(key);
    });

    stdout.write('\x1B[0;0HDelta: $delta');
  }
}
