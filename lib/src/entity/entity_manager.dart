part of oxygen;

/// ObjectPool for entities.
class EntityPool extends ObjectPool<Entity, String> {
  /// The manager that handles all the entities.
  EntityManager entityManager;

  EntityPool(this.entityManager) : super();

  @override
  Entity builder() => Entity(
        entityManager,
        entityManager.world.componentManager._componentId,
      );
}

/// Manages all the entities in a [World].
///
/// **Note**: Technically speaking we can have multiple types of entities, there
/// is nothing implemented on the [World] for it yet but this manager would be
/// able to handle that easily.
class EntityManager {
  /// The [World] which this manager belongs to.
  final World world;

  /// Active entities in the [world].
  final List<Entity> _entities = [];

  /// Entities that have components that should be removed.
  final List<Entity> _entitiesWithRemovedComponents = [];

  /// Entities that are ready to be removed.
  final List<Entity> _entitiesToRemove = [];

  /// Entities with names are easily accesable this way.
  final Map<String, Entity> _entitiesByName = {};

  /// The pool from which entities are pulled and released into.
  late EntityPool _entityPool;

  /// The next identifier for an [Entity].
  int _nextEntityId = 0;

  /// [QueryManager] that handles the queries.
  late QueryManager _queryManager;

  EntityManager(this.world) {
    _entityPool = EntityPool(this);
    _queryManager = QueryManager(this);
  }

  /// Get an entity by name.
  Entity? getEntityByName(String name) => _entitiesByName[name];

  /// Create a new entity.
  ///
  /// Will acquire a new entity from the pool, and initialize it.
  Entity createEntity([String? name]) {
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
  /// The [data] argument has to be of the type [V].
  void addComponentToEntity<T extends Component<V>, V>(Entity entity, V? data) {
    assert(T != Component, 'An implemented Component was expected');
    assert(
      world.componentManager.components.contains(T),
      'Component $T has not been registered to the World',
    );

    if (entity._componentTypes.contains(T)) {
      return; // Entity already has an instance of the component.
    }

    final componentPool = world.componentManager.getComponentPool<T, V>();
    final component = componentPool.acquire(data);

    entity._componentTypes.add(T);
    entity._components[world.componentManager._componentIds[T]!] = component;
    _queryManager._onComponentAddedToEntity(entity, T);
  }

  /// Remove and dispose a component by generics.
  void removeComponentFromEntity<T extends Component>(Entity entity) {
    assert(T != Component, 'An implemented Component was expected');
    assert(
      world.componentManager.components.contains(T),
      'Component $T has not been registered to the World',
    );
    return _markComponentForRemoval(entity, T);
  }

  /// Mark a component for removal.
  void _markComponentForRemoval(Entity entity, Type componentType) {
    if (!entity._componentTypes.contains(componentType) ||
        entity._componentsToRemove.contains(componentType)) {
      return;
    }
    _entitiesWithRemovedComponents.add(entity);
    entity._componentsToRemove.add(componentType);
  }

  /// Remove and dispose a component.
  void _removeComponentFromEntity(Entity entity, Type componentType) {
    if (!entity._componentTypes.contains(componentType)) {
      return;
    }

    entity._componentTypes.remove(componentType);
    final component = entity._components.removeAt(
      world.componentManager._componentIds[componentType]!,
    );
    component?.dispose();

    _queryManager._onComponentRemovedFromEntity(entity, componentType);
  }

  /// Removes all the components the given entity has.
  void _removeAllComponentFromEntity(Entity entity) {
    // Make a copy so we can update this set while looping over it.
    final componentsToRemove = entity._componentsToRemove.toSet();
    for (final componentType in componentsToRemove) {
      _removeComponentFromEntity(entity, componentType);
    }

    // Make a copy so we can update this set while looping over it.
    final componentTypes = entity._componentTypes.toSet();
    for (final componentType in componentTypes) {
      _removeComponentFromEntity(entity, componentType);
    }
  }

  /// Mark an entity for removal.
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
    _entitiesToRemove.clear();
  }

  /// Fully release and reset an entity.
  void _releaseEntity(Entity entity) {
    _removeAllComponentFromEntity(entity);
    _queryManager._onEntityRemoved(entity);

    _entities.remove(entity);
    if (_entitiesByName.containsKey(entity.name)) {
      _entitiesByName.remove(entity.name);
    }
    entity._pool?.release(entity);
  }
}
