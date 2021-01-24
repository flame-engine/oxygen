# Component

A Component is a way to store data for an Entity. It does not define any kind of behaviour because that is handled by the systems. A Component can be anything you want, there is no defacto standard for implementing one:
```dart
class YourComponent extends Component {
  int yourProperty;

  @override
  void init([data]) {
    yourProperty = 10;
  }

  @override
  void reset() {
    yourProperty = null;
  }
}

void main() {
  // ...
  final yourEntity = world.createEntity()
    ..add<YourComponent, void>();
  // ...
}
```
> Components have their own object pool, and each instance will be acquired and released from that pool when needed. The `init` method will be called on acquire, and the `reset` method on release. Therefore components do not use constructors. See [Object Pooling](./object_pooling.md) for more information.

## Initializing a Component with data

You can also pass data to the `init` method. To ensure proper handling of the data you first have to tell the Component what kind of init data it will receive:
```dart
class YourComponent extends Component<int> {
  int yourProperty;

  @override
  void init([int data]) {
    yourPoperty = data;
  }

  @override
  void reset() {
    yourProperty = null;
  }
}
```

You can then add your Component to an Entity and pass along the required data:
```dart
void main() {
  // ...
  final yourEntity = world.createEntity()
    ..add<YourComponent, int>(10) // With data
    ..add<YourComponent, int>(); // Without data
  // ...
}
```

The data can be `null` and only an instance of the given type or a type that extends from that type is allowed. If any other type is given an assertion exception will be thrown.

## Single value components

Whenever you need to define a Component that only holds a single value you can make use of the `ValueComponent` class. With the `ValueComponent` you can easily define single value components:
```dart
class PositionComponent extends ValueComponent<Position> {}
 
void main() {
  // ...
  final entity = world.createEntity()
    ..add<PositionComponent, Position>(Position(0, 0));
  // ...
  // You can then retrieve the position value.
  final position = entity.get<PositionComponent>().value;
  // ...
}
```

## Registering a Component

When you want to create an Entity with certain components in a World, you first have to let your World know which components there are. You do that by registering it using a `builder` closure:
```dart
world.registerComponent(() => YourComponent());
```

This `builder` closure will be automatically called whenever the pool for this component is empty and new instances are required. See [Component Pooling](./object_pooling.md#component-pooling) for more information.
