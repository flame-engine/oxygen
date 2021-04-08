part of oxygen;

/// Manages all the queries to ensure we don't duplicate lists.
class QueryManager {
  /// The manager that handles all the entities.
  final EntityManager entityManager;

  /// Cache of all the created queries.
  ///
  /// If a new [Query] is requested then [_createKey] is used to check
  /// if we already have the requested query in cache and return that one instead.
  final Map<String, Query> _queries = {};

  QueryManager(this.entityManager);

  void _onEntityRemoved(Entity entity) {
    for (final query in _queries.values) {
      if (query._entities.contains(entity)) {
        query._entities.remove(entity);
      }
    }
  }

  void _onComponentAddedToEntity(Entity entity, Type componentType) {
    for (final query in _queries.values) {
      // Entity should only be added when all the following conditions are met:
      // - the Entity matches the complete query.
      // - the Entity is not already part of the query.
      if (query.match(entity) && !query._entities.contains(entity)) {
        query._entities.add(entity);
      }
    }
  }

  void _onComponentRemovedFromEntity(Entity entity, Type componentType) {
    for (final query in _queries.values) {
      // Entity should only be removed when all the following conditions are met:
      // - the Entity matches the complete query.
      // - the Entity is not already part of the query.
      if (!query.match(entity) && query._entities.contains(entity)) {
        query._entities.remove(
            entity); // TODO: This should be removed after the frame and not directy on the list
      }
    }
  }

  /// Creates a unique key to identify a [Query] by.
  String _createKey(Iterable<Filter> filters) {
    return filters.map((f) {
      if (!entityManager.world.componentManager.components.contains(f.type)) {
        throw Exception(
          'Tried to query on ${f.type}, but this component has not yet been registered to the World',
        );
      }
      return f.filterId;
    }).join('-');
  }

  /// Create or retrieve a cached query.
  Query createQuery(Iterable<Filter> filters) {
    return _queries.update(
      _createKey(filters),
      (value) => value,
      ifAbsent: () => Query(entityManager, filters),
    );
  }
}
