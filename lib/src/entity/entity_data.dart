class EntityData {
  bool isAlive;

  /// Number of components attached to the given entity.
  int componentsCount;

  EntityData({this.isAlive = false, this.componentsCount = 0});
}
