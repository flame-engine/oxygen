part of oxygen;

class World {
  final HashMap<String, dynamic> _storedItems = HashMap();

  UnmodifiableListView<Entity> get entities {
    return UnmodifiableListView(entityManager._entities);
  }

  late EntityManager entityManager;

  late ComponentManager componentManager;

  late SystemManager systemManager;

  World() {
    entityManager = EntityManager(this);
    componentManager = ComponentManager(this);
    systemManager = SystemManager(this);
  }

  /// Store extra data.
  void store<T>(String key, T item) => _storedItems[key] = item;

  /// Retrieve extra data.
  T? retrieve<T>(String key) => _storedItems[key];

  /// Remove extra data.
  void remove(String key) => _storedItems[key] = null;

  @mustCallSuper

  /// Initialize the World.
  ///
  /// Will initialize all the registered [System]s.
  void init() {
    systemManager.init();
  }

  /// Register a [System].
  ///
  /// Keep in mind you can't share the same instance of system across multiple worlds.
  void registerSystem<T extends System>(T system) {
    systemManager.registerSystem(system);
  }

  /// Deregister a registered [System].
  void deregisterSystem<T extends System>() {
    systemManager.deregisterSystem(T);
  }

  /// Register a [Component] builder.
  void registerComponent<T extends Component<V>, V>(
    ComponentBuilder<T> builder,
  ) {
    componentManager.registerComponent(builder);
  }

  /// Create a new [Entity].
  Entity createEntity([String? name]) => entityManager.createEntity(name);

  /// Execute everything in the World once.
  void execute(double delta) {
    systemManager._execute(delta);
    entityManager.processRemovedEntities();
  }
}
