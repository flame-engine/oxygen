import 'package:oxygen/oxygen.dart';

class PositionInit extends InitObject {
  final double x;

  final double y;

  PositionInit(this.x, this.y);
}

class PositionComponent extends Component<PositionInit> {
  double x;

  double y;

  @override
  void init([covariant PositionInit data]) {
    x = data?.x ?? 0;
    y = data?.y ?? 0;
  }

  @override
  void reset() {
    x = y = null;
  }
}
