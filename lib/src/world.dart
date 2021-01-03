part of oxygen;

class World {
  final HashMap<String, dynamic> _storedItems = HashMap();

  Iterable<Entity> get entities => entityManager._entities;

  EntityManager entityManager;

  ComponentManager componentManager;

  SystemManager systemManager;

  World() {
    entityManager = EntityManager(this);
    componentManager = ComponentManager(this);
    systemManager = SystemManager(this);
  }

  void store<T>(String key, T item) => _storedItems[key] = item;

  T retrieve<T>(String key) => _storedItems[key];

  void remove(String key) => _storedItems[key] = null;

  @mustCallSuper
  void init() {
    systemManager.init();
  }

  void registerSystem<T extends System>(T system) {
    systemManager.registerSystem(system);
  }

  void registerComponent<T extends Component>(ComponentBuilder<T> builder) {
    componentManager.registerComponent(builder);
  }

  Entity createEntity([String name]) => entityManager.createEntity(name);

  void execute() {
    systemManager._execute();
    entityManager.processRemovedEntities();
  }
}
