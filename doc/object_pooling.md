# Object Pooling
From [Wikipedia](https://en.wikipedia.org/wiki/Object_pool_pattern):
> The object pool pattern is a software creational design pattern that uses a set of initialized objects kept ready to use – a "pool" – rather than allocating and destroying them on demand. A client of the pool will request an object from the pool and perform operations on the returned object. When the client has finished, it returns the object to the pool rather than destroying it; this can be done manually or automatically.

In this implementation the object pool works as explained above, and it is able to grown on-demand. By passing a `builder` closure to the constructor it can create new objects when there are no more objects in a pool. It will automatically grow by 20% whenever a pool is empty, ensuring there will always be objects to return. 

There is currently no [high water mark](https://en.wikipedia.org/wiki/High_water_mark) in place, so the pool will grow indefinitely.

## Component Pooling
Each Component has its own object pool, Oxygen does this to ensure there is no overhead for creating new instances. This is especially useful when your game is constantly adding and removing components from entities. It also ensures the garbage collector won't have to be called quite as often, ensuring a better performance (this is especially true for the web).

So whenever a Component is added to an Entity:
```dart
entity.addComponent<AComponent>();
```
it will try and reuse a `AComponent` instance, from the `AComponent` pool. It won't allocate a new instance if there are still instances left in the pool, it will be returned to the pool by calling:
```dart
entity.removeComponent<AComponent>();
```
