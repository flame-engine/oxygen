import 'package:example/components/bullet_component.dart';
import 'package:example/components/position_component.dart';
import 'package:example/utils/terminal.dart';
import 'package:example/utils/vector2.dart';

import 'package:oxygen/oxygen.dart';

class CleanBulletSystem implements RunSystem, InitSystem {
  late final ComponentPool<PositionComponent> _positionPool;

  @override
  void init(Systems systems) {
    _positionPool = systems.world.getPool(PositionComponent.new);
  }

  @override
  void run(Systems systems, double delta) {
    final filter = systems.world.filter(BulletComponent.new).end();

    for (final entity in filter) {
      final position = _positionPool.get(entity);

      if (!terminal.viewport.contains(Vector2(position.x!, position.y!))) {
        systems.world.deleteEntity(entity);
      }
    }
  }
}
