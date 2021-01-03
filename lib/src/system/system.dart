part of oxygen;

abstract class System {
  List<Entity> get entities => world.entities;

  World world;

  int priority = 0;

  System({this.priority = 0});

  void init();

  Query createQuery(Iterable<Filter> filters) =>
      world.entityManager._queryManager.createQuery(filters);
    
  void execute();
}
