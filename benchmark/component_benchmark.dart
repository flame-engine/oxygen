// Dont use forEcah method! See details:
// https://itnext.io/comparing-darts-loops-which-is-the-fastest-731a03ad42a2
// ignore_for_file: prefer_foreach

import 'package:benchmark/benchmark.dart';
import 'package:oxygen/oxygen.dart';

void main() {
  group('Component', () {
    group('With 100k entities', () {
      World? world;

      Filter? filter100;
      Filter? filter50;

      ComponentPool<Test100Component>? pool100;
      ComponentPool<Test50Component>? pool50;

      setUp(() {
        world = World();
        pool100 = world!.getPool(Test100Component.new);
        pool50 = world!.getPool(Test50Component.new);

        for (var i = 0; i < 100000; i++) {
          final entity = world!.createEntity();

          pool100!.add(entity);
          if (i.isEven) {
            pool50!.add(entity);
          }
        }

        filter100 = world!.filter(Test100Component.new).end();
        filter50 = world!.filter(Test50Component.new).end();
      });

      tearDown(() {
        world = null;
      });

      group('100%', () {
        benchmark('Iterate over 100% of the entities without getting', () {
          for (final _ in filter100!) {}
        });

        benchmark('Iterate over 100% of the entities with getting', () {
          for (final entity in filter100!) {
            pool100!.get(entity);
          }
        });
      });

      group('50%', () {
        benchmark('Iterate over 50% of the entities without getting', () {
          for (final _ in filter50!) {}
        });

        benchmark('Iterate over 50% of the entities with getting', () {
          for (final entity in filter50!) {
            pool50!.get(entity);
          }
        });
      });
    });
  });
}

class Test100Component extends Component {}

class Test50Component extends Component {}
