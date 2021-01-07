# Component

A Component is a way to store data for an Entity. It does not define any kind of behaviour because that is handled by the systems. A Component can be anything you want, there is no defacto standard for implementing one:
```dart
class YourComponent extends Component {
  int yourProperty;

  @override
  void init([InitObject data]) {
    yourPoperty = 10;
  }

  @override
  void reset() {
    yourProperty = null;
  }
}

void main() {
  // ...
  final yourEntity = world.createEntity()
    ..add<YourComponent>();
  // ...
}
```
> Components are part of their own object pool, and each instance will be acquired and released from that pool when needed. The `init` will be called on acquire, and the `reset` on release. Therefore components do not use constructors. See [Object Pooling](./object_pooling.md) for more information.

## InitObject

The `InitObject` defines the parameters with which components get initialized. By default it wont have any properties, but we can extends it to define custom properties that can be used in the Component:
```dart
class YourInit extends InitObject {
  final int yourProperty;

  YourInit({this.yourProperty});
}
```
> Each property in an `InitObject` should be final, as it is a immutable class.

Now we can make the Component aware of his own `InitObject` like so:
```dart
class YourComponent extends Component<YourInit> {
  int yourProperty;

  @override
  void init([YourInit data]) {
    yourPoperty = data.yourProperty;
  }

  @override
  void reset() {
    yourProperty = null;
  }
}

void main() {
  // ...
  final yourEntity = world.createEntity()
    ..add<YourComponent>(YourInit(yourProperty: 10));
  // ...
}
```

## Registering a Component

When you want to create an Entity with certain components in a World, you first have to let your World know which components there are. You do that by registering it using a `builder` closure:
```dart
world.registerComponent(() => YourComponent());
```

This `builder` closure will be automatically called whenever the pool for this component is empty and new instances are required. See [Component Pooling](./object_pooling.md#component-pooling) for more information.
