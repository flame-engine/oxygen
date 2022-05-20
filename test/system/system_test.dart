import 'package:mocktail/mocktail.dart';
import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class MockWorld extends Mock implements World {}

class MockInitSystem extends Mock implements InitSystem {}

class MockRunSystem extends Mock implements RunSystem {}

class MockDestroySystem extends Mock implements DestroySystem {}

void main() {
  late World world;
  late InitSystem initSystem1;
  late InitSystem initSystem2;
  late RunSystem runSystem1;
  late RunSystem runSystem2;
  late DestroySystem destroySystem1;
  late DestroySystem destroySystem2;

  setUp(() {
    world = MockWorld();
    initSystem1 = MockInitSystem();
    initSystem2 = MockInitSystem();
    runSystem1 = MockRunSystem();
    runSystem2 = MockRunSystem();
    destroySystem1 = MockDestroySystem();
    destroySystem2 = MockDestroySystem();
  });

  group('Systems', () {
    test('should be call init method of all InitSystem', () {
      final systems = Systems(world)
        ..add(initSystem1)
        ..add(initSystem2)
        ..add(runSystem1)
        ..add(runSystem2)
        ..add(destroySystem1)
        ..add(destroySystem2);
      when(() => initSystem1.init(systems)).thenReturn(null);
      when(() => initSystem2.init(systems)).thenReturn(null);

      systems.init();

      verify(() => initSystem1.init(systems)).called(1);
      verify(() => initSystem2.init(systems)).called(1);

      verifyNever(() => runSystem1.run(systems, 0));
      verifyNever(() => runSystem2.run(systems, 0));
      verifyNever(() => destroySystem1.destroy(systems));
      verifyNever(() => destroySystem1.destroy(systems));
    });

    test('should be call run method of all RunSystem', () {
      final systems = Systems(world)
        ..add(initSystem1)
        ..add(initSystem2)
        ..add(runSystem1)
        ..add(runSystem2)
        ..add(destroySystem1)
        ..add(destroySystem2);
      when(() => runSystem1.run(systems, 0)).thenReturn(null);
      when(() => runSystem1.run(systems, 0)).thenReturn(null);

      systems
        ..init()
        ..run(0);

      verify(() => runSystem1.run(systems, 0)).called(1);
      verify(() => runSystem2.run(systems, 0)).called(1);

      verify(() => initSystem1.init(systems)).called(1);
      verify(() => initSystem2.init(systems)).called(1);
      verifyNever(() => destroySystem1.destroy(systems));
      verifyNever(() => destroySystem1.destroy(systems));
    });

    test('should be call destroy method of all DestroySystem', () {
      final systems = Systems(world)
        ..add(initSystem1)
        ..add(initSystem2)
        ..add(runSystem1)
        ..add(runSystem2)
        ..add(destroySystem1)
        ..add(destroySystem2);
      when(() => destroySystem1.destroy(systems)).thenReturn(null);
      when(() => destroySystem2.destroy(systems)).thenReturn(null);

      systems.destroy();

      verify(() => destroySystem1.destroy(systems)).called(1);
      verify(() => destroySystem2.destroy(systems)).called(1);

      verifyNever(() => initSystem1.init(systems));
      verifyNever(() => initSystem2.init(systems));
      verifyNever(() => runSystem1.run(systems, 0));
      verifyNever(() => runSystem2.run(systems, 0));
    });
  });
}
