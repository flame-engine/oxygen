import 'package:example/utils/vector2.dart';

class Rect {
  final int left;
  final int top;
  final int right;
  final int bottom;

  int get width => right - left;
  int get height => bottom - top;

  Vector2 get topLeft => Vector2(left, top);
  Vector2 get topRight => Vector2(left + width, top);
  Vector2 get bottomLeft => Vector2(left, top + height);
  Vector2 get bottomRight => Vector2(left + width, top + height);
  Vector2 get center => Vector2(left + width ~/ 2, top + height ~/ 2);

  const Rect.fromLTRB(this.left, this.top, this.right, this.bottom);

  const Rect.fromLTWH(int left, int top, int width, int height)
      : this.fromLTRB(left, top, left + width, top + height);

  bool contains(Vector2 position) {
    return position.x >= left &&
        position.x < right &&
        position.y >= top &&
        position.y < bottom;
  }
}
