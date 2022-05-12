import 'package:benchmark/benchmark.dart';
import 'package:oxygen/oxygen.dart';

class TestObject extends Component {
  int? value;

  @override
  void init([int? data]) {
    value = data ?? 0;
  }

  @override
  void reset() {
    value = null;
  }
}

void main() {
  group('ObjectPool', () {
    group('creating ComponentPool', () {
      late World world;

      setUp(() {
        world = World();
      });

      benchmark('with 100k instances', () {
        ComponentPool<TestObject>(world, TestObject.new, 0, 100000);
      });
    });

    group('registered ComponentPool', () {
      late World world;
      final entities = <Entity>[];
      late ComponentPool<TestObject> pool;

      setUp(() {
        world = World();
        pool = world.registerPool(TestObject.new);
        for (var i = 0; i <= 100000; i++) {
          entities.add(world.createEntity());
        }
      });

      benchmark('add 100k entities', () {
        final length = entities.length;
        for (var i = 0; i < length; i++) {
          pool.add(entities[i]);
        }
      });
    });
  });
}
