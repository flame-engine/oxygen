part of oxygen;

/// ObjectPool for entities.
class EntityPool extends ObjectPool<Entity> {
  /// The manager that handles all the entities.
  EntityManager entityManager;

  EntityPool(this.entityManager) : super();

  @override
  Entity builder() => Entity(entityManager);
}

/// Manages all the entities in a [World].
///
/// **Note**: Technically speaking we can have multiple types of entities,
/// there is nothing implemented on the [World] for it yet
/// but this manager would be able to handle that easily.
class EntityManager {
  /// The World where this manager belongs to.
  final World world;

  /// Active entities in the world.
  final List<Entity> _entities = [];

  /// Entities that are ready to be removed.
  List<Entity> _entitiesToRemove = [];

  /// Entities with names are easy accesable this way.
  final Map<String, Entity> _entitiesByName = {};

  /// The pool from which entities are pulled and released into.
  EntityPool _entityPool;

  /// The next identifier for an [Entity].
  int _nextEntityId = 0;

  /// QueryManager for this type of [Entity].
  QueryManager _queryManager;

  EntityManager(this.world) {
    _entityPool = EntityPool(this);
    _queryManager = QueryManager(this);
  }

  /// Get a entity by name.
  ///
  /// Will return `null` if none is found.
  Entity getEntityByName(String name) => _entitiesByName[name];

  /// Create a new entity.
  ///
  /// Will acquire a new entity from the pool, and initialize it.
  Entity createEntity([String name]) {
    final entity = _entityPool.acquire(name);
    entity.id = _nextEntityId++;

    if (name != null) {
      _entitiesByName[name] = entity;
    }

    _entities.add(entity);
    return entity;
  }

  /// Add given component to an entity.
  ///
  /// If the entity already has that component it will just return.
  ///
  /// The [data] argument has to be of the expected [InitObject]
  /// variant for the given component.
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

  /// Remove and dispose a component by generic.
  void removeComponentFromEntity<T extends Component>(Entity entity) {
    assert(T != Component, 'An implemented Component was expected');
    assert(
      world.componentManager.components.contains(T),
      'Component $T has not been registered to the World',
    );
    return _removeComponentFromEntity(entity, T);
  }

  /// Remove and dispose a component.
  void _removeComponentFromEntity(Entity entity, Type componentType) {
    if (!entity._componentTypes.contains(componentType)) {
      return;
    }

    entity._componentTypes.remove(componentType);
    final component = entity._components.remove(componentType);
    component.dispose();

    _queryManager._onComponentRemovedFromEntity(entity, componentType);
  }

  /// Removes all the components the given entity has.
  void removeAllComponentFromEntity(Entity entity) {
    // Make a copy so we can update this set while looping over it.
    final componentTypes = entity._componentTypes.toSet();
    for (final componentType in componentTypes) {
      _removeComponentFromEntity(entity, componentType);
    }
  }

  /// Set an entity for removal.
  ///
  /// It will be fully removed in the next execute cycle.
  void removeEntity(Entity entity) {
    if (!_entities.contains(entity) || _entitiesToRemove.contains(entity)) {
      return;
    }

    entity.alive = false;

    _entitiesToRemove.add(entity);
  }

  /// Process all removed entities from the last execute cycle.
  void processRemovedEntities() {
    _entitiesToRemove.forEach(_releaseEntity);
    _entitiesToRemove = [];
  }

  /// Fully release and reset an entity.
  void _releaseEntity(Entity entity) {
    removeAllComponentFromEntity(entity);
    _queryManager._onEntityRemoved(entity);

    _entities.remove(entity);
    if (_entitiesByName.containsKey(entity.name)) {
      _entitiesByName.remove(entity.name);
    }
    entity._pool.release(entity);
  }
}
