import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class TestComponent extends ValueComponent<void> {}

class ComponentAdderSystem extends System {
  late Query query;
  @override
  void init() {
    query = createQuery([HasNot<TestComponent>()]);
  }

  @override
  void execute(double delta) {
    for (final entity in query.entities) {
      entity.add<TestComponent, void>();
    }
  }
}

class ComponentRemoverSystem extends System {
  late Query query;
  @override
  void init() {
    query = createQuery([Has<TestComponent>()]);
  }

  @override
  void execute(double delta) {
    for (final entity in query.entities) {
      entity.remove<TestComponent>();
    }
  }
}

void main() {
  group('Component', () {
    test('Components should be added and removed from entities.', () {
      final world = World();
      world.registerComponent<TestComponent, void>(TestComponent.new);
      world.registerSystem(ComponentRemoverSystem());
      world.registerSystem(ComponentAdderSystem());
      var testEntity = world.createEntity('Test Entity');
      world.init();

      expect(
        false,
        testEntity.has<TestComponent>(),
        reason: 'Entity has component it shouldnt.',
      );

      world.execute(1);

      testEntity = world.entities.first;
      expect(
        true,
        testEntity.has<TestComponent>(),
        reason: 'Entity does not have required component.',
      );

      world.execute(1);

      testEntity = world.entities.first;
      expect(
        false,
        testEntity.has<TestComponent>(),
        reason: 'Entity has component it shouldnt.',
      );
    });
  });
}
