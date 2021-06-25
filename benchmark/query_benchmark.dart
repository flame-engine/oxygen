import 'package:oxygen/oxygen.dart';
import 'package:benchmark/benchmark.dart';

class Test100Component extends Component<void> {
  @override
  void init([void data]) {}

  @override
  void reset() {}
}

class Test50Component extends Component<void> {
  @override
  void init([void data]) {}

  @override
  void reset() {}
}

void main() {
  group('Query', () {
    group('With 100000 entities', () {
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

      benchmark('creating a Query that matches 100% of all the entities', () {
        queryManager?.createQuery([Has<Test100Component>()]);
      });

      benchmark('creating a Query that matches 50% of all the entities', () {
        queryManager?.createQuery([Has<Test50Component>()]);
      });
    });
  });
}
