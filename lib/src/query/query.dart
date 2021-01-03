part of oxygen;

class Query {
  final EntityManager entityManager;

  Iterable<Filter> _filters = [];

  List<Entity> entities = [];

  Query(this.entityManager, this._filters) {
    for (final entity in entityManager._entities) {
      if (match(entity)) {
        entities.add(entity);
      }
    }
  }

  bool match(Entity entity) => _filters.every((filter) => filter.match(entity));
}
