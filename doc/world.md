# World

A World is a container for Entities, Components and Systems (ECS). So a World is quite important for the ECS, but you are not restricted to a single world. You can have multiple worlds running at the same time, or just a few and switch certain worlds off and on depending on your gameplay:
```dart
final world = World();
```

## Registering a Component

When you want to create a Entity with certain components in a World, you first have to let your World know which components there are. You do that by registering it using a `builder` closure:
```dart
world.registerComponent(() => YourComponent());
```

This `builder` closure will be automatically called whenever the pool for this component is empty, and new instances are required. See [Component Pooling](./object_pooling.md#component-pooling) for more information.

## Registering a System

To register a System to the world you can pass an instance like so:
```dart
world.registerSystem(YourSystem());
```

Keep in mind, you **cannot** reuse system instances over multiple worlds, it will throw an assertion error if that happens. Just pass a new instance to the `registerSystem` method for each world that you want your system to be part of.

## Creating an Entity

When you have registered all your components you can then start creating entities in your world:
```dart
world.createEntity('Optional name');
```

## Initializing

After adding all your components and systems you can initialize the world:
```dart
world.init();
```

This will initialize all the systems and make sure everything is in place.

## Executing

Now we can execute the world by passing the delta since the last execution time:
```dart
world.execute(delta);
```

This will run everything in the world once. You would normally call this somewhere in your game loop.

## Storing data

It is also possible to store extra data in a World. This data will be accessable to anyone who has access to the World. It allows for passing data between systems or passing references that multiple systems need:
```dart
// Storing
world.store('yourKey', yourValue);

// Retrieving
final yourValue = world.retrieve<YourType>('yourKey');

// Removing
world.remove('yourKey');
```