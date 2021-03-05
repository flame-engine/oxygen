# Entity

An Entity is a simple "container" for components. It serves no purpose apart from being an abstraction container around the components.

## Creating an Entity

You can create an entity by using the [World](./world.md):
```dart
final entity = world.createEntity('Optional name');
```

## Adding Components

After you have created an entity you can easily add new components:
```dart
entity
  ..add<YourComponentA, YourInitDataA>(someInitData);
  ..add<YourComponentB, YourInitDataB>(someOtherInitData);
```

Only one instance of the same Component can be added to an Entity. After adding it to an Entity all the queries that are subscribed will be updated.

For more information about components and how they work see the [Component documentation](./component.md).

## Retrieving Components
```dart
final yourComponent = entity.get<YourComponent>();
yourComponent?.property = someValue;
```

## Checking if it has a Component
```dart
if (entity.has<YourComponent>()) {
  final yourComponent = entity.get<YourComponent>()!;
  // ...
}
```

## Removing Components
```dart
entity.removeComponent<YourComponent>();
```

This will mark the Component for removal but won't be immediately disposed until the end of the last update cycle. This allows systems to react to the data inside the Component.