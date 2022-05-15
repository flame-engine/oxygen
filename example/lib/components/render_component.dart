import 'package:oxygen/oxygen.dart';

class RenderComponent extends Component {
  String? char;

  @override
  void init([String? char]) => this.char = char ?? '';

  @override
  void reset() => char = null;
}
