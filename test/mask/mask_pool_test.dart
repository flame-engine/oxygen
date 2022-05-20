import 'package:mocktail/mocktail.dart';
import 'package:oxygen/oxygen.dart';
import 'package:oxygen/src/mask/mask_pool.dart';
import 'package:test/test.dart';

class MockMask extends Mock implements Mask {}

void main() {
  late Mask mask;

  setUp(() {
    mask = MockMask();
  });

  group('MaskPool', () {
    test('must be throwed assertation error when capacity is < 1', () {
      expect(() => MaskPool(0, () => mask), throwsA(isA<AssertionError>()));
    });

    test('must be filled when the it is initialized', () {
      final pool = MaskPool(10, () => mask);

      expect(pool.size, equals(10));
    });

    test('take method should be generate mask when pool is empty', () {
      final pool = MaskPool(2, () => mask);

      pool.take();
      pool.take();
      expect(pool.size, equals(0));
      pool.take();
      expect(pool.size, equals(1));
    });

    test('should be release mask', () {
      final pool = MaskPool(10, () => mask);

      final takedMask = pool.take();
      expect(pool.size, equals(9));
      pool.release(takedMask);
      expect(pool.size, equals(10));
    });
  });
}
