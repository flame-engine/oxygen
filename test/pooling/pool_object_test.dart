import 'package:test/test.dart';

import 'package:oxygen/oxygen.dart';

class TestObject extends PoolObject<int> {
  @override
  void init([int data]) {}

  @override
  void reset() {}
}

class TestPool extends ObjectPool<TestObject, int> {
  TestPool({int initialSize}) : super(initialSize: initialSize);

  @override
  TestObject builder() => TestObject();
}

const initialSize = 1;

void main() {
  group('PoolObject', () {
    TestPool pool;

    setUp(() {
      pool = TestPool(initialSize: initialSize);
    });

    test('Should be able to dispose itself', () {
      final instance = pool.acquire();

      expect(pool.totalSize, initialSize);
      expect(pool.totalFree, initialSize - 1);
      expect(pool.totalUsed, initialSize);

      instance.dispose();

      expect(pool.totalSize, initialSize);
      expect(pool.totalFree, initialSize);
      expect(pool.totalUsed, 0);
    });
  });
}
