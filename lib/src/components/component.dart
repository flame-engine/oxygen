import '../entity/entity.dart';

/// A [Component] is a way to store data for an [Entity].
///
/// It does not define any kind of behaviour because that is handled by the systems.
abstract class Component {
  void init() {}
  void reset() {}
}

abstract class ComponentValue<T> extends Component {
  T? value;

  @override
  void init() {}
  @override
  void reset() {}
}
