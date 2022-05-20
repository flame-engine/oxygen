import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class MockMask extends Mock implements Mask {}

void main() {
  group('Worlds', () {
    group('registerPool', () {
      test('should be added to poolCached', () {
        final world = World(const Config(entities: 1, pools: 1));

        expect(world.poolCached, hasLength(0));
        expect(world.poolsCount, equals(0));
        expect(world.filtersByIncludedComponents, hasLength(1));
        expect(world.filtersByExcludedComponents, hasLength(1));
        world.registerPool(_Component1.new);

        expect(world.poolCached, hasLength(1));
        expect(world.poolsCount, equals(1));
      });

      test(
        'must resize filtersByIncludedComponents and '
        'filtersByExcludedComponents when their size equals pools count',
        () {
          final world = World(const Config(entities: 1, pools: 1));

          expect(world.filtersByIncludedComponents, hasLength(1));
          expect(world.filtersByExcludedComponents, hasLength(1));
          world.registerPool(_Component1.new);
          world.registerPool(_Component2.new);

          expect(world.filtersByIncludedComponents, hasLength(2));
          expect(world.filtersByExcludedComponents, hasLength(2));
        },
      );
    });

    group('getPool', () {
      test('should returned pool', () {
        final world = World()..registerPool(_Component1.new);

        expect(
          world.getPool(_Component1.new),
          isA<ComponentPool<_Component1>>(),
        );
      });

      test(
        'should be throw assert error when pool is not registered',
        () {
          final world = World(Config(pools: 1, entities: 1));

          world.getPool(_Component1.new);
          world.getPool(_Component2.new);
          world.getPool(_Component3.new);
          world.getPool(_Component4.new);
          world.getPool(_Component5.new);
          world.getPool(_Component6.new);
          world.getPool(_Component7.new);
          world.getPool(_Component8.new);


          // expect(world.getPool<_Component1>, throwsA(isA<AssertionError>()));
          // expect(world.getPool<_Component1>, throwsA(isA<AssertionError>()));
        },
      );
    });

    group('createEntity', () {
      test('should be create new entity', () {
        final world = World();

        final entity = world.createEntity();
        expect(entity, equals(0));
      });

      test('should be change entity data', () {
        final world = World();

        final entity = world.createEntity();

        expect(world.entities[entity].isAlive, isTrue);
      });

      test(
        'should be changed entity.isAlive when created from recycledEntities',
        () {
          final world = World();
          final entity = world.createEntity();
          world.deleteEntity(entity);

          expect(world.entities[entity].isAlive, isFalse);

          final newEntity = world.createEntity();

          expect(world.entities[newEntity].isAlive, isTrue);
        },
      );
    });

    group('deleteEntity', () {
      test('should be change entity.isAlive', () {
        final world = World();
        final entity1 = world.createEntity();
        final entity2 = world.createEntity();

        expect(world.entities[entity1].isAlive, isTrue);
        expect(world.entities[entity2].isAlive, isTrue);
        world.deleteEntity(entity1);
        world.deleteEntity(entity2);
        expect(world.entities[entity1].isAlive, isFalse);
        expect(world.entities[entity2].isAlive, isFalse);
      });

      test('should be add entity to recycledEntities list', () {
        final world = World();
        final entity1 = world.createEntity();
        final entity2 = world.createEntity();

        world.deleteEntity(entity1);
        world.deleteEntity(entity2);
        expect(world.recycledEntities[0], entity1);
        expect(world.recycledEntities[1], entity2);
      });

      test('should be nothing when entity is < 0', () {
        final world = World();
        final entity = world.createEntity();

        expect(world.entities[entity].isAlive, isTrue);
        world.deleteEntity(entity);
        expect(world.entities[entity].isAlive, isFalse);
        expect(world.recycledEntitiesCount, 1);

        world.deleteEntity(entity);
        expect(world.entities[entity].isAlive, isFalse);
        expect(world.recycledEntitiesCount, 1);
      });

      test('should be resize recycledEntities', () {
        final world = World(
          const Config(
            entities: 1,
            pools: 1,
            recycledEntities: 1,
            poolCapacity: 1,
          ),
        );
        final entity1 = world.createEntity();
        final entity2 = world.createEntity();
        expect(world.recycledEntities, hasLength(1));

        world.deleteEntity(entity1);
        world.deleteEntity(entity2);
        expect(world.recycledEntities, hasLength(2));
      });

      test('should be delete components from entity', () {
        final world = World();
        final pool1 = world.registerPool(_Component1.new);
        final pool2 = world.registerPool(_Component2.new);
        final entity1 = world.createEntity();
        final entity2 = world.createEntity();
        pool1
          ..add(entity1)
          ..add(entity2);
        pool2.add(entity2);

        expect(world.entities[entity1].componentsCount, 1);
        expect(world.entities[entity2].componentsCount, 2);
        expect(pool1.has(entity1), isTrue);
        expect(pool1.has(entity2), isTrue);
        expect(pool2.has(entity1), isFalse);
        expect(pool2.has(entity2), isTrue);

        world.deleteEntity(entity1);
        expect(world.entities[entity1].componentsCount, 0);
        world.deleteEntity(entity2);
        expect(world.entities[entity2].componentsCount, 0);
      });
    });

    // TODO(danCrane): complete the tests
    group('onEntityChangeInternal', () {});

    group('checkFilter', () {
      test(
        'should return a filter that is already registered, regardless of the '
        'order of the added components',
        () {
          final world = World();
          world.registerPool(_Component1.new);
          world.registerPool(_Component2.new);
          world.registerPool(_Component3.new);
          world.registerPool(_Component4.new);

          final filter = world
              .filter<_Component1>(_Component1.new)
              .include<_Component2>(_Component2.new)
              .exclude<_Component3>(_Component3.new)
              .exclude<_Component4>(_Component4.new)
              .end();

          final filter2 = world
              .filter<_Component2>(_Component2.new)
              .include<_Component1>(_Component1.new)
              .exclude<_Component4>(_Component4.new)
              .exclude<_Component3>(_Component3.new)
              .end();

          expect(filter, equals(filter2));
        },
      );

      test('should be added entities when created filter', () {
        final world = World();
        final pool = world.registerPool(_Component1.new);
        final e1 = world.createEntity();
        world.createEntity();
        final e3 = world.createEntity();
        pool
          ..add(e1)
          ..add(e3);

        final filter = world.filter<_Component1>(_Component1.new).end();

        expect(filter, hasLength(2));
        expect(filter.denseEntities[0], equals(e1));
        expect(filter.denseEntities[1], equals(e3));
      });

      test('should be added filter to filters lists', () {
        final world = World();
        final pool1 = world.registerPool(_Component1.new);
        final pool2 = world.registerPool(_Component2.new);

        expect(world.filtersByIncludedComponents[pool1.id], isEmpty);
        expect(world.filtersByExcludedComponents[pool2.id], isEmpty);
        final filter = world
            .filter<_Component1>(_Component1.new)
            .exclude<_Component2>(_Component2.new)
            .end();
        expect(world.filtersByIncludedComponents[pool1.id], hasLength(1));
        expect(
          world.filtersByIncludedComponents[pool1.id].first,
          equals(filter),
        );
        expect(world.filtersByExcludedComponents[pool2.id], hasLength(1));
        expect(
          world.filtersByExcludedComponents[pool2.id].first,
          equals(filter),
        );
      });
    });

    // TODO(danCrane): complete the tests
    group('isMaskCompatible', () {
      test('should be returned true when entity is compatible with mask', () {
        final world = World();
        final entity = world.createEntity();

        final p1 = world.registerPool(_Component1.new);
        final p2 = world.registerPool(_Component2.new);

        p1.add(entity);

        final mask = MockMask();
        when(() => mask.includeCount).thenReturn(1);
        when(() => mask.excludeCount).thenReturn(1);
        when(() => mask.includeList).thenReturn(Uint8List(4)..[0] = p1.id);
        when(() => mask.excludeList).thenReturn(Uint8List(4)..[0] = p2.id);

        expect(world.isMaskCompatible(mask, entity), isTrue);
      });

      test(
        'should be returned false when entity is not compatible with mask',
        () {
          final world = World();
          final entity = world.createEntity();

          final p1 = world.registerPool(_Component1.new);
          final p2 = world.registerPool(_Component2.new);

          final mask = MockMask();
          when(() => mask.includeCount).thenReturn(1);
          when(() => mask.excludeCount).thenReturn(1);
          when(() => mask.includeList).thenReturn(Uint8List(4)..[0] = p1.id);
          when(() => mask.excludeList).thenReturn(Uint8List(4)..[0] = p2.id);

          expect(world.isMaskCompatible(mask, entity), isFalse);
        },
      );
    });

    // TODO(danCrane): complete the tests
    group('isMaskCompatibleWithout', () {
      test('should be returned true when entity is compatible with mask', () {
        final world = World();
        final entity = world.createEntity();

        final p1 = world.registerPool(_Component1.new);
        final p2 = world.registerPool(_Component2.new);

        p1.add(entity);

        final mask = MockMask();
        when(() => mask.includeCount).thenReturn(1);
        when(() => mask.excludeCount).thenReturn(1);
        when(() => mask.includeList).thenReturn(Uint8List(1)..[0] = p1.id);
        when(() => mask.excludeList).thenReturn(Uint8List(1)..[0] = p2.id);

        expect(world.isMaskCompatibleWithout(mask, entity, p2.id), isTrue);
      });
    });
  });
}

class _Component1 extends Component {}

class _Component2 extends Component {}

class _Component3 extends Component {}

class _Component4 extends Component {}
class _Component5 extends Component {}
class _Component6 extends Component {}
class _Component7 extends Component {}
class _Component8 extends Component {}
