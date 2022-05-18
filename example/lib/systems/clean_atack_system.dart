import 'package:example/components/atack_component.dart';

import 'package:oxygen/oxygen.dart';

class CleanAtackSystem implements RunSystem, InitSystem {
  late final ComponentPool<AtackComponent> _atackPool;

  @override
  void init(Systems systems) {
    _atackPool = systems.world.getPool(AtackComponent.new);
  }

  @override
  void run(Systems systems, double delta) {
    final filter = systems.world.filter(AtackComponent.new).end();

    for (final entity in filter) {
      _atackPool.delete(entity);
    }
  }
}
