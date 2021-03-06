# Query

A Query is a way to retrieve entities by matching their components against the Query filters. They are used by systems to retrieve the entities they care about:
```dart
class YourSystem extends System {
  late Query query;

  @override
  void init() { 
    query = createQuery([Has<YourComponent>()]);
  }

  @override
  void execute(double delta) { 
    query.entities.forEach((entity) {
      final yourComponent = entity.get<YourComponent>();
      // ...
    });
  }
}
```

A query will always be updated with entities that match its filters. So whenever an entity's component list changes it will be reflected in all the queries.

## Filters

Queries are able to use filters to define how the entities should be matched.

### Has<Component> filter

This filter checks if an entity has the given component:
```dart
final query = createQuery([
    Has<YourComponentA>(),
    Has<YourComponentB>(),
]);

// query.entities will contain all the entities that have both YourComponentA and YourComponentB.
```

### HasNot<Component> filter

This filter checks if an entity does **not** have the given component:
```dart
final query = createQuery([
    Has<YourComponentA>(),
    Has<YourComponentB>(),
    HasNot<YourComponentC>(),
]);

// query.entities will contain all the entities that have both YourComponentA and YourComponentB and NOT YourComponentC.
```