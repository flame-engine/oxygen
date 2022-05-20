import 'package:example/utils/vector2.dart';

import 'package:oxygen/oxygen.dart';

class DirectionComponent extends Component {
  late Direction direction;

  @override
  void init([Direction direction = Direction.idle]) {
    this.direction = direction;
  }

  @override
  void reset() => direction = Direction.idle;
}

enum Direction { up, down, left, right, idle }

extension DirectionVector on Direction {
  Vector2 toVector() {
    switch (this) {
      case Direction.up:
        return const Vector2(0, -1);
      case Direction.down:
        return const Vector2(0, 1);
      case Direction.left:
        return const Vector2(-1, 0);
      case Direction.right:
        return const Vector2(1, 0);
      default:
        return const Vector2.zero();
    }
  }
}
