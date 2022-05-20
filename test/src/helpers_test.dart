import 'dart:typed_data';

import 'package:oxygen/src/helpers.dart';
import 'package:test/test.dart';

void main() {
  group('ResizeUint8List', () {
    test('should be set new size', () {
      final list = Uint8List(4);

      expect(list.resize(6), hasLength(6));
    });

    test(
      'should be set length << 1 when size is not passed',
      () {
        final list = Uint8List(4);

        expect(list.resize(), hasLength(8));
      },
    );

    test(
      'should be set length << 1 when the transmitted size is less than the '
      'current list length',
      () {
        final list = Uint8List(4);

        expect(list.resize(2), hasLength(8));
      },
    );
  });

  group('ResizeUint32List', () {
    test('should be set new size', () {
      final list = Uint8List(4);

      expect(list.resize(6), hasLength(6));
    });

    test(
      'should be set length << 1 when size is not passed',
      () {
        final list = Uint8List(4);

        expect(list.resize(), hasLength(8));
      },
    );

    test(
      'should be set length << 1 when the transmitted size is less than the '
      'current list length',
      () {
        final list = Uint8List(4);

        expect(list.resize(2), hasLength(8));
      },
    );
  });

  group('MaskList', () {
    group('containsValue', () {
      test('should be returned true when value contains before limiting', () {
        final list = Uint8List(8)..[3] = 1;

        expect(list.containsValue(1, 8), isTrue);
      });

      test('should be returned false when value is not contains ', () {
        final list = Uint8List(8)..[3] = 1;

        expect(list.containsValue(2, 8), false);
      });

      test(
          'should be returned false when value is not contains before limiting',
          () {
        final list = Uint8List(8)..[3] = 1;

        expect(list.containsValue(1, 2), isFalse);
      });
    });

    group('sortTo', () {
      test('should be sorted to the limit', () {
        final list = Uint8List(4)
          ..[0] = 3
          ..[1] = 2
          ..[3] = 1;
        final expectedValue = Uint8List(4)
          ..[0] = 0
          ..[1] = 1
          ..[2] = 2
          ..[3] = 3;

        expect(list.sortTo(4), equals(expectedValue));
      });

      test('should be trimmed to the transferred size ', () {
        final list = Uint8List(4)
          ..[0] = 3
          ..[1] = 1
          ..[2] = 2;
        final expectedValue = Uint8List(3)
          ..[0] = 1
          ..[1] = 2
          ..[2] = 3;

        expect(list.sortTo(3), equals(expectedValue));
        expect(list.sortTo(3), hasLength(3));
      });
    });
  });
}
