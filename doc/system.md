# System

Systems contain the logic for components. They can update data stored in the components. They query on components to get the entities that fit their Query. And they can iterate through those entities each execution frame.

A System is build up as followed:
```dart
class YourSystem extends System {
  @override
  void init() { }

  @override
  void execute(double delta) { }
```

The `init()` will be called whenever the World that [the System is registered to](./world.md#registering-a-system) is [initialized](./world.md#initializing). And the `execute(delta)` will be called every time the World gets [executed](./world.md#executing).

## Queries

A System can create queries on entities to filter through them based on their components:
```dart
class YourSystem extends System {
  Query query;

  @override
  void init() { 
    query = createQuery([Has<YourComponent>()]);
  }

  @override
  void execute(double delta) { 
    query.entities.forEach((entity) {
      final yourComponent = entity.get<YourComponent>();
    });
  }
}
```

For more information about queries and how they work see the [Query documentation](./query.md).
