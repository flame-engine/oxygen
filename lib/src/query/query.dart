part of oxygen;

class Query {
  /// The manager that handles all the entities.
  final EntityManager entityManager;

  /// The unique filters to filter by.
  final Iterable<Filter> _filters;

  /// Entities that are found through [_filters].
  List<Entity> entities = [];

  Query(this.entityManager, this._filters)
      : assert(_filters != null && _filters.isNotEmpty) {
    for (final entity in entityManager._entities) {
      if (match(entity)) {
        entities.add(entity);
      }
    }
  }

  /// Check if given entity matches against the query.
  bool match(Entity entity) => _filters.every((filter) => filter.match(entity));
}
