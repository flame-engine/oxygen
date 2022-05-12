import 'package:mocktail/mocktail.dart';
import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class MockMask extends Mock implements Mask {}

void main() {
  late Mask mask;

  setUp(() {
    mask = MockMask();
  });

  group('Filter', () {
    group('addEntity', () {
      test('should be added entities to denseEntities', () {
        final filter = Filter(mask, 10, 10);
        const entity1 = 1;
        const entity2 = 3;
        const entity3 = 2;

        filter
          ..addEntity(entity1)
          ..addEntity(entity2)
          ..addEntity(entity3);

        expect(filter.denseEntities[0], equals(entity1));
        expect(filter.denseEntities[1], equals(entity2));
        expect(filter.denseEntities[2], equals(entity3));
        expect(filter.entitiesCount, equals(3));
        expect(filter, hasLength(3));
      });

      test(
        'must be added entity index +1 from denseEntities to the sparseEntities',
        () {
          final filter = Filter(mask, 10, 10);
          const entity1 = 1;
          const entity2 = 3;
          const entity3 = 2;

          filter
            ..addEntity(entity1)
            ..addEntity(entity2)
            ..addEntity(entity3);

          expect(filter.sparseEntities[entity1], equals(1));
          expect(filter.sparseEntities[entity2], equals(2));
          expect(filter.sparseEntities[entity3], equals(3));
          expect(filter.entitiesCount, equals(3));
          expect(filter, hasLength(3));
        },
      );

      test('should not be added entity when the filter is blocked', () {
        final filter = Filter(mask, 10, 10, 1);
        const entity1 = 1;
        const entity2 = 2;

        filter
          ..addEntity(entity1)
          ..addEntity(entity2);

        expect(filter.entitiesCount, equals(0));
        expect(filter, hasLength(0));
        expect(filter.denseEntities[0], equals(0));
        expect(filter.denseEntities[1], equals(0));
        expect(filter.sparseEntities[entity1], equals(0));
        expect(filter.sparseEntities[entity2], equals(0));
      });

      test('should be resized denseEntities', () {
        final filter = Filter(mask, 1, 2);

        expect(filter.denseEntities, hasLength(1));

        filter
          ..addEntity(0)
          ..addEntity(1);

        expect(filter.denseEntities, hasLength(2));
      });
    });

    group('removeEntity', () {
      test('should be removed entity', () {
        final filter = Filter(mask, 4, 4);
        const entity = 1;

        filter.addEntity(entity);
        expect(filter.entitiesCount, equals(1));
        expect(filter.length, equals(1));

        filter.removeEntity(entity);
        expect(filter.entitiesCount, equals(0));
        expect(filter, hasLength(0));
      });
      test(
        'must be packed entities when entity was remover from the middle',
        () {
          final filter = Filter(mask, 10, 10);
          const entity1 = 1;
          const entity2 = 3;
          const entity3 = 2;
          const entity4 = 4;

          filter
            ..addEntity(entity1)
            ..addEntity(entity2)
            ..addEntity(entity3)
            ..addEntity(entity4);

          expect(filter.denseEntities[0], equals(entity1));
          expect(filter.denseEntities[1], equals(entity2));
          expect(filter.denseEntities[2], equals(entity3));
          expect(filter.denseEntities[3], equals(entity4));

          filter.removeEntity(entity2);
          expect(filter.denseEntities[0], equals(entity1));
          expect(filter.denseEntities[1], equals(entity4));
          expect(filter.denseEntities[2], equals(entity3));
        },
      );
    });

    group('addOperation', () {
      test('should be returned false when lockCount <= 0', () {
        final filter = Filter(mask, 4, 4);

        expect(filter.addOperation(true, 0), equals(false));
      });

      test('should be change operationsCount', () {
        final filter = Filter(mask, 4, 4, 1)..addOperation(true, 0);

        expect(filter.operationsCount, equals(1));
      });

      test('should be added new operations', () {
        final filter = Filter(mask, 4, 4, 1)
          ..addOperation(true, 0)
          ..addOperation(false, 1);

        expect(filter.operations[0].added, equals(true));
        expect(filter.operations[0].entity, equals(0));
        expect(filter.operations[1].added, equals(false));
        expect(filter.operations[1].entity, equals(1));
      });
    });

    group('unlock', () {
      test('should be decreased lockCount', () {
        final filter = Filter(mask, 10, 10, 1);

        expect(filter.lockCount, equals(1));
        filter.unlock();
        expect(filter.lockCount, equals(0));
      });

      test(
        'should be processed operations list when lockCount == 0 && '
        'operationsCount > 0',
        () {
          final filter = Filter(mask, 10, 10, 1);
          const entity1 = 1;
          const entity2 = 2;
          const entity3 = 4;

          filter
            ..addEntity(entity1)
            ..addEntity(entity2)
            ..addEntity(entity3);

          expect(filter.operationsCount, equals(3));

          filter.unlock();
          expect(filter.lockCount, equals(0));
        },
      );
    });
    test(
      'should be increase [lockCount] during iteration',
      () {
        final filter = Filter(mask, 10, 10);

        filter
          ..addEntity(1)
          ..addEntity(3)
          ..addEntity(5);

        for (final _ in filter) {
          expect(filter.lockCount, equals(1));
          for (final _ in filter) {
            expect(filter.lockCount, equals(2));
            for (final _ in filter) {
              expect(filter.lockCount, equals(3));
            }
          }
        }
      },
    );
  });
}
