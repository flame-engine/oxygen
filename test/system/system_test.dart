import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class SystemA extends System {
  SystemA() : super(priority: 2);

  @override
  void execute(double delta) {}

  @override
  void init() {}
}

class SystemB extends System {
  SystemB() : super(priority: 1);

  @override
  void execute(double delta) {}

  @override
  void init() {}
}

class SystemC extends System {
  SystemC() : super(priority: 0);

  @override
  void execute(double delta) {}

  @override
  void init() {}
}

class SystemD extends System {
  SystemD() : super(priority: 1);
  @override
  void execute(double delta) {}

  @override
  void init() {}
}

void main() {
  group('System', () {
    group('registerSystem -', () {
      test('Priority should be in the right order', () {
        final systemA = SystemA();
        final systemB = SystemB();
        final systemC = SystemC();
        final systemD = SystemD();

        final world = World()
          ..registerSystem(systemA)
          ..registerSystem(systemB)
          ..registerSystem(systemC)
          ..registerSystem(systemD)
          ..init();

        expect(
          world.systemManager.systems,
          equals([systemC, systemB, systemD, systemA]),
        );
      });

      test('Should not be added if the system type is already registered', () {
        final world = World()
          ..registerSystem(SystemA())
          ..registerSystem(SystemA())
          ..registerSystem(SystemA())
          ..registerSystem(SystemA())
          ..init();

        expect(world.systemManager.systems, hasLength(1));
      });

      test(
          'The "system.world == null assertion" should occur when adding a '
          'system with an initialized world', () {
        final system = SystemA();
        final world = World()..registerSystem(system);

        expect(
          () => world..registerSystem(system),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}
