part of oxygen;

class QueryManager {
  final EntityManager entityManager;

  Map<String, Query> _queries = {};

  QueryManager(this.entityManager);

  void _onEntityRemoved(Entity entity) {
    for (final query in _queries.values) {
      if (query.entities.contains(entity)) {
        query.entities.remove(entity);
      }
    }
  }

  void _onComponentAddedToEntity(Entity entity, Type componentType) {
    for (final query in _queries.values) {
      // Entity should only be added when all the following conditions are met:
      // - the Entity matches the complete query.
      // - the Entity is not already part of the query.
      if (query.match(entity) && !query.entities.contains(entity)) {
        query.entities.add(entity);
      }
    }
  }

  void _onComponentRemovedFromEntity(Entity entity, Type componentType) {
    for (final query in _queries.values) {
      // Entity should only be removed when all the following conditions are met:
      // - the Entity matches the complete query.
      // - the Entity is not already part of the query.
      if (!query.match(entity) && query.entities.contains(entity)) {
        query.entities.remove(entity);
      }
    }
  }

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

  Query createQuery(Iterable<Filter> filters) {
    return _queries.update(
      _createKey(filters),
      (value) => value,
      ifAbsent: () => Query(entityManager, filters),
    );
  }
}
