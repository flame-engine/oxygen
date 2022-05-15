import 'package:example/components/atack_component.dart';
import 'package:example/components/bullet_component.dart';
import 'package:example/components/bullet_move_component.dart';
import 'package:example/components/direction_component.dart';
import 'package:example/components/position_component.dart';
import 'package:example/components/render_component.dart';

import 'package:oxygen/oxygen.dart';

class BulletSpawnerSystem implements RunSystem, InitSystem {
  late final ComponentPool<PositionComponent> _positionPool;
  late final ComponentPool<DirectionComponent> _directionPool;
  late final ComponentPool<BulletMoveComponent> _bulletMovePool;
  late final ComponentPool<BulletComponent> _bulletPool;
  late final ComponentPool<RenderComponent> _renderPool;

  @override
  void init(Systems systems) {
    _positionPool = systems.world.getPool<PositionComponent>();
    _directionPool = systems.world.getPool<DirectionComponent>();
    _bulletMovePool = systems.world.getPool<BulletMoveComponent>();
    _bulletPool = systems.world.getPool<BulletComponent>();
    _renderPool = systems.world.getPool<RenderComponent>();
  }

  @override
  void run(Systems systems, double dt) {
    final filter = systems.world
        .filter<PositionComponent>()
        .include<AtackComponent>()
        .include<DirectionComponent>()
        .end();

    for (final entity in filter) {
      final position = _positionPool.get(entity);
      final direction = _directionPool.get(entity).direction;
      final spawnPosition = direction.toVector().translate(
            position.x!,
            position.y!,
          );
      print(direction);

      final bullet = systems.world.createEntity();
      _bulletPool.add(bullet);
      _bulletMovePool.add(bullet);
      _positionPool.add(bullet).init(spawnPosition);
      _directionPool.add(bullet).init(direction);
      _renderPool.add(bullet).init('🥚');
    }
  }
}
