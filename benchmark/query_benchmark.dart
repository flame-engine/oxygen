import 'package:oxygen/oxygen.dart';
import 'package:benchmark/benchmark.dart';

import 'utils/components/test_100_component.dart';
import 'utils/components/test_50_component.dart';

void main() {
  group('Query', () {
    group('With 100k entities', () {
      World? world;

      QueryManager? queryManager;

      setUp(() {
        world = World();
        world!.registerComponent(() => Test100Component());
        world!.registerComponent(() => Test50Component());
        for (var i = 0; i < 100000; i++) {
          final entity = world!.createEntity();

          entity.add<Test100Component, void>();
          if (i % 2 == 0) {
            entity.add<Test50Component, void>();
          }
        }
        queryManager = QueryManager(world!.entityManager);
      });

      tearDown(() {
        world = null;
        queryManager = null;
      });

      group('100%', () {
        benchmark('creating a Query that matches 100% of all the entities', () {
          queryManager!.createQuery([Has<Test100Component>()]);
        });
      });

      group('50%', () {
        benchmark('creating a Query that matches 50% of all the entities', () {
          queryManager!.createQuery([Has<Test50Component>()]);
        });
      });
    });
  });
}
