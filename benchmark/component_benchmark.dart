import 'package:oxygen/oxygen.dart';
import 'package:benchmark/benchmark.dart';

import 'utils/components/test_100_component.dart';
import 'utils/components/test_50_component.dart';

void main() {
  group('Component', () {
    group('With 100k entities', () {
      World? world;

      QueryManager? queryManager;

      Query? query100;
      Query? query50;

      ComponentHandle<Test100Component>? handle100;
      ComponentHandle<Test50Component>? handle50;

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

        query100 = queryManager!.createQuery([Has<Test100Component>()]);
        handle100 = world!.componentManager.ref<Test100Component>();

        query50 = queryManager!.createQuery([Has<Test50Component>()]);
        handle50 = world!.componentManager.ref<Test50Component>();
      });

      tearDown(() {
        world = null;
        queryManager = null;
      });

      group('100%', () {
        benchmark('Iterate over 100% of the entities without getting', () {
          for (final _ in query100!.entities) {}
        });

        benchmark('Iterate over 100% of the entities with getting', () {
          for (final entity in query100!.entities) {
            entity.get(handle100!);
          }
        });
      });

      group('50%', () {
        benchmark('Iterate over 50% of the entities without getting', () {
          for (final _ in query50!.entities) {}
        });

        benchmark('Iterate over 50% of the entities with getting', () {
          for (final entity in query50!.entities) {
            entity.get(handle50!);
          }
        });
      });
    });
  });
}
