import 'package:flutter_test/flutter_test.dart';

import 'package:oxygen/oxygen.dart';

class TestObject extends PoolObject<int> {
  int value;

  @override
  void init([int data]) {
    value = data ?? 0;
  }

  @override
  void reset() {
    value = null;
  }
}

class TestPool extends ObjectPool<TestObject> {
  TestPool({int initialSize}) : super(initialSize: initialSize);

  @override
  TestObject builder() => TestObject();
}

void main() {
  group('ObjectPool', () {
    test('Should construct a pool with the initialSize', () {
      const initialSize = 1;
      final pool = TestPool(initialSize: initialSize);

      expect(pool.totalSize, initialSize);
      expect(pool.totalFree, initialSize);
      expect(pool.totalUsed, 0);
    });

    test('Should acquire an instance from the pool and release it', () {
      const initialSize = 1;
      const instanceValue = 5;

      final pool = TestPool(initialSize: initialSize);
      final instance = pool.acquire(instanceValue);

      expect(instance.value, instanceValue);
      expect(pool.totalSize, initialSize);
      expect(pool.totalFree, initialSize - 1);
      expect(pool.totalUsed, initialSize);

      pool.release(instance);

      expect(instance.value, null);
      expect(pool.totalSize, initialSize);
      expect(pool.totalFree, initialSize);
      expect(pool.totalUsed, 0);
    });

    test('Should automatically expand by 20% + 1 when pool is empty', () {
      const initialSize = 10;
      final pool = TestPool(initialSize: initialSize);
      List.generate(initialSize, (index) => pool.acquire());

      expect(pool.totalSize, initialSize);
      expect(pool.totalFree, 0);
      expect(pool.totalUsed, initialSize);

      final expandingValue = (initialSize * 0.2).floor() + 1;
      final expectedSize = initialSize + expandingValue;
      final leftOver = expandingValue - 1; // 1 because we acquire once.

      pool.acquire();

      expect(pool.totalSize, expectedSize);
      expect(pool.totalFree, leftOver);
      expect(pool.totalUsed, expectedSize - leftOver);
    });
  });
}
