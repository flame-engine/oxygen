import 'package:mocktail/mocktail.dart';
import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class MockWorld extends Mock implements World {}

class MockComponent extends Mock implements Component {}

void main() {
  late World world;
  late Component component;

  setUp(() {
    world = MockWorld();
    component = MockComponent();
  });

  group('Pool', () {
    group('add', () {
      test(
        'should be throwed assertion exception when entity was removed',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(false);

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);

          expect(() => pool.add(0), throwsA(isA<AssertionError>()));
        },
      );

      test(
        'should be throwed assertion exception when entity was attached',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);
          pool.add(0);

          expect(() => pool.add(0), throwsA(isA<AssertionError>()));
        },
      );

      test('should be call init method of component', () {
        when(() => world.isEntityAliveInternal(0)).thenReturn(true);
        when(() => world.entities[0].isAlive).thenReturn(true);
        when(() => world.entities).thenReturn(
          [EntityData(isAlive: true)],
        );

        final pool = ComponentPool(world, () => component, 0, 10);
        pool.add(0);

        verify(component.init).called(1);
      });

      test('should be call world.onEntityChangeInternal', () {
        when(() => world.isEntityAliveInternal(0)).thenReturn(true);
        when(() => world.entities[0].isAlive).thenReturn(true);
        when(() => world.entities).thenReturn(
          [EntityData(isAlive: true)],
        );

        final pool = ComponentPool(world, _TestComponent.new, 0, 10);
        pool.add(0);

        verify(() => world.onEntityChangeInternal(0, 0, true)).called(1);
      });
    });

    group('delete', () {
      test(
        'should be throwed assertion exception when entity was removed',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(false);

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);

          expect(() => pool.delete(0), throwsA(isA<AssertionError>()));
        },
      );

      test(
        'should be call world.onEntityChangeInternal',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);
          pool.add(0);
          pool.delete(0);

          verify(() => world.onEntityChangeInternal(0, 0, false)).called(1);
        },
      );

      test(
        'should be call world.deleteEntity',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);
          pool.add(0);
          pool.delete(0);

          verify(() => world.deleteEntity(0)).called(1);
        },
      );

      test(
        'should be delete entity from component',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);
          pool.add(0);
          pool.delete(0);

          expect(pool.has(0), isFalse);
        },
      );
    });

    group('get', () {
      test(
        'should be throwed assertion exception when entity was removed',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(false);

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);

          expect(() => pool.get(0), throwsA(isA<AssertionError>()));
        },
      );

      test(
        'should be throwed assertion exception when component is not attached',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);

          expect(() => pool.get(0), throwsA(isA<AssertionError>()));
        },
      );

      test(
        'should be get component',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);
          pool.add(0);

          expect(pool.get(0), isA<_TestComponent>());
          expect(pool.get(0).x, equals(10));
        },
      );
    });

    group('has', () {
      test(
        'should be throwed assertion exception when entity was removed',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(false);

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);

          expect(() => pool.has(0), throwsA(isA<AssertionError>()));
        },
      );

      test(
        'should be returned false when entity dosnt attached to component',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);

          expect(pool.has(0), isFalse);
        },
      );

      test(
        'should be returned true when entity is attached to component',
        () {
          when(() => world.isEntityAliveInternal(0)).thenReturn(true);
          when(() => world.entities[0].isAlive).thenReturn(true);
          when(() => world.entities).thenReturn(
            [EntityData(isAlive: true)],
          );

          final pool = ComponentPool(world, _TestComponent.new, 0, 10);
          pool.add(0);

          expect(pool.has(0), isTrue);
        },
      );
    });
  });
}

class _TestComponent extends Component {
  int x = 0;
  @override
  void init() {
    x = 10;
  }

  @override
  void reset() {
    x = -10;
  }
}
