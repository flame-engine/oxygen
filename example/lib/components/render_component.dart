import 'package:oxygen/oxygen.dart';

class RenderInit extends InitObject {
  final String key;

  RenderInit(this.key) : assert(key.length == 1);
}

class RenderComponent extends Component<RenderInit> {
  String key;

  @override
  void init([covariant RenderInit data]) {
    key = data?.key ?? '#';
  }

  @override
  void reset() {
    key = null;
  }
}
