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
  });
}
