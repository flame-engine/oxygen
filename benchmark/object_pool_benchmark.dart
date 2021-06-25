import 'package:oxygen/oxygen.dart';
import 'package:benchmark/benchmark.dart';

class TestObject extends PoolObject<int> {
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

class TestPool extends ObjectPool<TestObject, int> {
  TestPool({int initialSize = 100000}) : super(initialSize: initialSize);

  @override
  TestObject builder() => TestObject();
}

void main() {
  group('ObjectPool', () {
    benchmark('new ObjectPool with 100000 instances', () {
      TestPool(initialSize: 100000);
    });

    benchmark('new ObjectPool with 0 instances that grows to 100000', () {
      final pool = TestPool(initialSize: 0);
      for (var i = 0; i < 100000; i++) {
        pool.acquire();
      }
    });
  });
}
