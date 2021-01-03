part of oxygen;

class EntityPool extends ObjectPool<Entity> {
  EntityManager entityManager;

  EntityPool(this.entityManager) : super();

  @override
  Entity builder() => Entity(this.entityManager);
}

class EntityManager {
  final World world;

  List<Entity> _entities = [];

  List<Entity> _entitiesToRemove = [];

  Map<String, Entity> _entitiesByName = {};

  EntityPool _entityPool;

  int _nextEntityId = 0;

  QueryManager _queryManager;

  EntityManager(this.world) {
    _entityPool = EntityPool(this);
    _queryManager = QueryManager(this);
  }

  Entity getEntityByName(String name) => _entitiesByName[name];

  Entity createEntity([String name]) {
    final entity = _entityPool.acquire(name);
    if (name != null) {
      _entitiesByName[name] = entity;
    }

    _entities.add(entity);
    return entity;
  }

  void addComponentToEntity<T extends Component>(
    Entity entity,
    InitObject data,
  ) {
    assert(T != Component, 'An implemented Component was expected');
    assert(
      world.componentManager.components.contains(T),
      'Component $T has not been registered to the World',
    );

    if (entity._componentTypes.contains(T)) {
      return; // Entity already has an instance of the component.
    }

    final componentPool = world.componentManager.getComponentPool(T);
    final component = componentPool.acquire(data);

    assert(
      data == null || data.runtimeType == component.initType,
      'Component $T expects an InitObject of type ${component.initType} but received ${data.runtimeType}',
    );

    entity._componentTypes.add(T);
    entity._components[T] = component;
    _queryManager._onComponentAddedToEntity(entity, T);
  }

  void removeComponentFromEntity<T extends Component>(Entity entity) {
    assert(T != Component, 'An implemented Component was expected');
    assert(
      world.componentManager.components.contains(T),
      'Component $T has not been registered to the World',
    );
    return _removeComponentFromEntity(entity, T);
  }

  void _removeComponentFromEntity(Entity entity, Type componentType) {
    if (!entity._componentTypes.contains(componentType)) {
      return;
    }

    entity._componentTypes.remove(componentType);
    final component = entity._components.remove(componentType);
    component.dispose();

    _queryManager._onComponentRemovedFromEntity(entity, componentType);
  }

  void removeAllComponentFromEntity(Entity entity) {
    final componentTypes = entity._componentTypes.toSet();
    for (final componentType in componentTypes) {
      _removeComponentFromEntity(entity, componentType);
    }
  }

  void removeEntity(Entity entity) {
    if (!_entities.contains(entity) || _entitiesToRemove.contains(entity)) {
      return;
    }

    entity.alive = false;

    _entitiesToRemove.add(entity);
  }

  void processRemovedEntities() {
    _entitiesToRemove.forEach(_releaseEntity);
    _entitiesToRemove = [];
  }

  void _releaseEntity(Entity entity) {
    // TODO: This was part of removeEntity but it changes lists that we loop through. But now each entity or components that gets removed, will still be in the query of the next system.
    removeAllComponentFromEntity(entity);
    _queryManager._onEntityRemoved(entity);

    _entities.remove(entity);
    if (_entitiesByName.containsKey(entity.name)) {
      _entitiesByName.remove(entity.name);
    }
    entity._pool.release(entity);
  }
}
