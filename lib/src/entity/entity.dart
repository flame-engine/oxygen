part of oxygen;

class Entity extends PoolObject<String> {
  final EntityManager _entityManager;

  final Map<Type, Component> _components = {};

  final Set<Type> _componentTypes = Set();

  int id;

  bool alive = false;

  String name;

  Entity(this._entityManager) : id = _entityManager._nextEntityId++;

  T get<T extends Component>() {
    assert(T != Component, 'An implemented Component was expected');
    return _components[T];
  }

  bool has<T extends Component>() => _componentTypes.contains(T);

  void add<T extends Component>([InitObject data]) {
    assert(T != Component, 'An implemented Component was expected');
    _entityManager.addComponentToEntity<T>(this, data);
  }

  void remove<T extends Component>() {
    assert(T != Component, 'An implemented Component was expected');
    _entityManager.removeComponentFromEntity<T>(this);
  }

  @override
  void init([String name]) {
    id = _entityManager._nextEntityId++;
    alive = true;
    this.name = name ?? '';
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
