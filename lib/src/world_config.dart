class Config {
  final int entities;
  final int recycledEntities;
  final int pools;
  final int poolCapacity;
  final int poolRecycled;

  const Config({
    this.entities = 512,
    this.recycledEntities = 512,
    this.pools = 512,
    this.poolCapacity = 512,
    this.poolRecycled = 512,
  });
}
