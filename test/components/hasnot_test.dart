import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class ComponentA extends ValueComponent<void> {}

class ComponentB extends ValueComponent<void> {}

class InitSystem extends System {
  late final Query initQuery;
  late final Query query;
  @override
  void init() {
    initQuery = createQuery([Has<ComponentA>(), HasNot<ComponentB>()]);
    query = createQuery([Has<ComponentA>(), Has<ComponentB>()]);
  }

  @override
  void execute(double delta) {
    for (final entity in initQuery.entities) {
      entity.add<ComponentB, void>();
    }
  }
}

void main() {
  group('component', () {
    test('HasNot should filter newly added components.', () {
      final world = World();
      world.registerComponent<ComponentA, void>(() => ComponentA());
      world.registerComponent<ComponentB, void>(() => ComponentB());
      final initSystem = InitSystem();
      world.registerSystem(initSystem);
      world.init();
      final entity = world.createEntity('Test')..add<ComponentA, void>();
      expect(initSystem.initQuery.entities.length, 1,
          reason: 'initQuery should have the single added entity');
      expect(initSystem.query.entities.length, 0,
          reason: 'query should not have the single added entity');
      world.execute(1);
      expect(entity.has<ComponentB>(), true,
          reason: 'Entity should have ComponentB');
      expect(initSystem.initQuery.entities.length, 0,
          reason:
              'initQuery should not have the entity after ComponentB was added.');
      expect(initSystem.query.entities.length, 1,
          reason: 'query should have the entity after ComponentB was added.');
    });
  });
}
