class Vector2 {
  final int x;
  final int y;

  const Vector2(this.x, this.y);

  const Vector2.zero()
      : x = 0,
        y = 0;

  Vector2 translate(int x, int y) => Vector2(this.x + x, this.y + y);

  Vector2 operator +(Vector2 other) {
    return Vector2(x + other.x, y + other.y);
  }
}
