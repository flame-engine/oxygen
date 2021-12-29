part of oxygen;

/// An Entity is a simple "container" for components.
///
/// It serves no purpose apart from being an abstraction container around the components.
class Entity extends PoolObject<String> {
  /// The manager that handles all the entities.
  final EntityManager _entityManager;

  /// Map of all the components added.
  final List<Component?> _components;

  final List<Type> _componentsToRemove = [];

  /// Set of all the component types that are added.
  final Set<Type> _componentTypes = {};

  /// Internal identifier.
  int? id;

  /// Indication if this entity is no longer "in this world".
  bool alive = false;

  /// Optional name to identify an entity by.
  String? name;

  Entity(this._entityManager, int componentLength)
      : id = _entityManager._nextEntityId++,
        _components = List.filled(componentLength, null);

  /// Retrieves a Component by Type.
  ///
  /// If the component is not registered, it will return `null`.
  T? get<T extends Component>(ComponentHandle<T> handle) {
    assert(
      T != Component || T != ValueComponent,
      'An implemented Component was expected',
    );
    return _components[handle.id] as T?;
  }

  /// Check if a component is added.
  bool has<T extends Component>() => _componentTypes.contains(T);

  /// Add a component.
  void add<T extends Component<V>, V>([V? data]) {
    assert(
      T != Component || T != ValueComponent,
      'An implemented Component was expected',
    );
    _entityManager.addComponentToEntity<T, V>(this, data);
  }

  /// Remove a component.
  void remove<T extends Component>() {
    assert(
      T != Component || T != ValueComponent,
      'An implemented Component was expected',
    );
    _entityManager.removeComponentFromEntity<T>(this);
  }

  @override
  void init([String? name]) {
    alive = true;
    this.name = name;
  }

  @override
  void reset() {
    id = null;
    alive = false;
    _components.clear();
    _componentTypes.clear();
  }

  @override
  void dispose() => _entityManager.removeEntity(this);
}
