import 'package:oxygen/oxygen.dart';

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
