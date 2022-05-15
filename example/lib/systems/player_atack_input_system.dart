import 'package:example/components/atack_component.dart';
import 'package:example/components/player_component.dart';
import 'package:example/utils/keyboard.dart';

import 'package:oxygen/oxygen.dart';

class PlayerAtackInputSystem implements RunSystem, InitSystem {
  late final ComponentPool<AtackComponent> _atackPool;

  @override
  void init(Systems systems) {
    _atackPool = systems.world.getPool<AtackComponent>();
  }

  @override
  void run(Systems systems, double dt) {
    final filter = systems.world.filter<PlayerComponent>().end();

    for (final entity in filter) {
      if (keyboard.isPressed(Key.space)) {
        _atackPool.add(entity);
      }
    }
  }
}
