import 'package:oxygen/oxygen.dart';
import 'package:benchmark/benchmark.dart';

import 'utils/components/test_100_component.dart';
import 'utils/components/test_50_component.dart';

void main() {
  group('Component', () {
    group('With 100000 entities', () {
      World? world;

      QueryManager? queryManager;

      Query? query100;
      Query? query50;

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

        query100 = queryManager?.createQuery([Has<Test100Component>()]);
        query50 = queryManager?.createQuery([Has<Test50Component>()]);
      });

      tearDown(() {
        world = null;
        queryManager = null;
      });

      group('100%', () {
        benchmark('Iterate over 100% entities without getting', () {
          for (final _ in query100!.entities) {}
        });

        benchmark('Iterate over 100% entities with getting', () {
          for (final entity in query100!.entities) {
            entity.get<Test100Component>();
          }
        });
      });

      group('50%', () {
        benchmark('Iterate over 50% entities without getting', () {
          for (final _ in query50!.entities) {}
        });

        benchmark('Iterate over 50% entities with getting', () {
          for (final entity in query50!.entities) {
            entity.get<Test50Component>();
          }
        });
      });
    });
  });
}
