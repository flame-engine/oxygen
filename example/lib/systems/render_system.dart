import 'package:example/components/color_component.dart';
import 'package:example/components/name_component.dart';
import 'package:example/components/position_component.dart';
import 'package:example/components/render_component.dart';
import 'package:example/utils/color.dart';
import 'package:example/utils/terminal.dart';
import 'package:example/utils/vector2.dart';
import 'package:oxygen/oxygen.dart';

class RenderSystem implements RunSystem {
  @override
  void run(Systems systems, double dt) {
    final filter = systems.world
        .filter<RenderComponent>()
        .include<PositionComponent>()
        .end();
    final positionPool = systems.world.getPool<PositionComponent>();
    final renderPool = systems.world.getPool<RenderComponent>();
    final colorPool = systems.world.getPool<ColorComponent>();
    final namePool = systems.world.getPool<NameComponent>();

    for (final entity in filter) {
      final position = positionPool.get(entity);
      final key = renderPool.get(entity).char ?? '';
      var color = Colors.white;
      if (colorPool.has(entity)) {
        color = colorPool.get(entity).color!;
      }

      terminal
        ..save()
        ..translate(position.x!, position.y!)
        ..draw(key, foregroundColor: color);

      if (namePool.has(entity)) {
        final name = namePool.get(entity).name!;
        terminal
          ..translate(-(name.length ~/ 2), 1)
          ..draw(name);
      }
      terminal.restore();
    }

    terminal.draw('delta: $dt', foregroundColor: Colors.green);
    terminal.draw(
      'entites: ${systems.world.entitiesCount}',
      foregroundColor: Colors.green,
      position: const Vector2(0, 1),
    );
    terminal.draw(
      ' W A S D | Move Tim\n'
      '   Space | Shoot',
      foregroundColor: Colors.green,
      position: terminal.viewport.bottomLeft.translate(0, -2),
    );
  }
}
