import 'package:example/utils/vector2.dart';

import 'package:oxygen/oxygen.dart';

class PositionComponent extends Component {
  int? x;
  int? y;

  @override
  void init([Vector2? data]) {
    x = data?.x ?? 0;
    y = data?.y ?? 0;
  }

  @override
  void reset() {
    x = y = null;
  }
}
