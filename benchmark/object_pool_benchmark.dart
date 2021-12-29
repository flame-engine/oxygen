import 'package:benchmark/benchmark.dart';

import 'utils/test_pool.dart';

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
