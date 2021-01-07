part of oxygen;

typedef ComponentBuilder<T> = T Function();

/// ObjectPool for a type of Component.
class ComponentPool<T extends Component> extends ObjectPool<T> {
  final ComponentBuilder<T> componentBuilder;

  ComponentPool(this.componentBuilder) : super();

  @override
  T builder() => componentBuilder();
}

/// Manages all the components in a [World].
class ComponentManager {
  /// The World which this manager belongs to.
  final World world;

  /// List of registered components.
  final List<Type> components = [];

  /// Map of [ObjectPool]s for each kind of registered [Component].
  final Map<Type, ComponentPool<Component>> _componentPool = {};

  ComponentManager(this.world);

  /// Check if a component is registered.
  bool hasComponent<T extends Component>() => components.contains(T);

  /// Register a component.
  ///
  /// If a component is already registered it will just return.
  /// The [builder] is used for pooling.
  void registerComponent<T extends Component>(T Function() builder) {
    if (components.contains(T)) {
      return;
    }

    components.add(T);
    _componentPool[T] = ComponentPool(builder);
  }

  ComponentPool getComponentPool(Type component) => _componentPool[component];
}
