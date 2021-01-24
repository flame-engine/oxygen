import 'package:oxygen/oxygen.dart';

class Position {
  final double x;

  final double y;

  Position(this.x, this.y);
}

class PositionComponent extends Component<Position> {
  double x;

  double y;

  @override
  void init([Position data]) {
    x = data?.x ?? 0;
    y = data?.y ?? 0;
  }

  @override
  void reset() {
    x = y = null;
  }
}
