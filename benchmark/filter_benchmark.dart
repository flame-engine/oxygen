import 'package:benchmark/benchmark.dart';
import 'package:oxygen/oxygen.dart';

class Test100Component extends Component {}

class Test50Component extends Component {}

void main() {
  group('Filter', () {
    group('With 100k entities', () {
      World? world;

      setUp(() {
        world = World();
        final pool100 = world!.registerPool(Test100Component.new);
        final pool50 = world!.registerPool(Test50Component.new);
        for (var i = 0; i < 100000; i++) {
          final entity = world!.createEntity();

          pool100.add(entity);
          if (i.isEven) {
            pool50.add(entity);
          }
        }
      });

      tearDown(() {
        world = null;
      });

      benchmark('creating a Filter that matches 100% of all the entities', () {
        world!.filter<Test100Component>().end();
      });

      benchmark('creating a Filter that matches 50% of all the entities', () {
        world!.filter<Test50Component>().end();
      });
    });
  });
}
