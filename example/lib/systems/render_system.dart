import 'package:example/utils/color.dart';
import 'package:example/components/color_component.dart';
import 'package:example/components/name_component.dart';
import 'package:example/utils/terminal.dart';
import 'package:example/utils/vector2.dart';
import 'package:oxygen/oxygen.dart';

import '../components/render_component.dart';
import '../components/position_component.dart';

class RenderSystem extends System {
  late Query query;

  @override
  void init() {
    query = createQuery([
      Has<RenderComponent>(),
      Has<PositionComponent>(),
    ]);
  }

  @override
  void execute(delta) {
    query.entities.forEach((entity) {
      final position = entity.get<PositionComponent>()!;
      final key = entity.get<RenderComponent>()!.value;
      final color = entity.get<ColorComponent>()?.value ?? Colors.white;

      terminal
        ..save()
        ..translate(position.x!, position.y!)
        ..draw(key!, foregroundColor: color);
      if (entity.has<NameComponent>()) {
        final name = entity.get<NameComponent>()!.value!;
        terminal
          ..translate(-(name.length ~/ 2), 1)
          ..draw(name);
      }
      terminal.restore();
    });

    terminal.draw('delta: $delta', foregroundColor: Colors.green);
    terminal.draw(
      'entites: ${world!.entities.length}',
      foregroundColor: Colors.green,
      position: Vector2(0, 1),
    );
  }
}
