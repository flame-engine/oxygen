import 'package:oxygen/oxygen.dart';

class NameComponent extends Component {
  String? name;
  @override
  void init([String? name]) => this.name = name ?? '';

  @override
  void reset() => name = null;
}
