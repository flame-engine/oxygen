import 'package:example/utils/color.dart';

import 'package:oxygen/oxygen.dart';

class ColorComponent extends Component {
  Color? color;

  @override
  void init([Color? color]) => this.color = color ?? Colors.white;

  @override
  void reset() => color = null;
}
