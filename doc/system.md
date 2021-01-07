# System

Systems contain the logic for components. They can update data stored in the components. They query on components to get the entities that fit their Query. And they can iterate through those entities each execution frame.

A System is build up as followed:
```dart
class YourSystem extends System {
  @override
  void init() { }

  @override
  void execute(double delta) { }
}
```

The `init()` method will be called whenever the World that [the System is registered to](./world.md#registering-a-system) is [initialized](./world.md#initializing). And the `execute(delta)` method will be called every time the World gets [executed](./world.md#executing).

## Registering a System

To register a System to the world you can pass an instance like this:
```dart
world.registerSystem(YourSystem());
```

Keep in mind, you **cannot** reuse system instances over multiple worlds, it will throw an assertion error if that happens. Just pass a new instance to the `registerSystem` method for each world that you want your system to be part of.

## Deregistering a System

To deregister a System from the world:
```dart
world.deregisterSystem<YourSystem>();
```

## Execution order

Systems are executed in the order they are registed to the World. But each system can define it's own priority to ensure it gets executed before others:
```dart
class YourSystem extends System {
  @override
  final priority = 2;

  @override
  void init() { }

  @override
  void execute(double delta) { }
}
```

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
