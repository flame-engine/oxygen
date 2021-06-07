import 'package:example/components/position_component.dart';
import 'package:example/components/velocity_component.dart';
import 'package:example/utils/terminal.dart';
import 'package:example/utils/vector2.dart';
import 'package:oxygen/oxygen.dart';

class MoveSystem extends System {
  late Query query;

  @override
  void init() {
    query = createQuery([
      Has<VelocityComponent>(),
      Has<PositionComponent>(),
    ]);
  }

  @override
  void execute(delta) {
    for (final entity in query.entities) {
      final position = entity.get<PositionComponent>()!;
      final velocity = entity.get<VelocityComponent>()!;

      position.x = position.x! + velocity.x!;
      position.y = position.y! + velocity.y!;

      if (!terminal.viewport.contains(Vector2(position.x!, position.y!))) {
        entity.dispose();
      }
    }
  }
}
