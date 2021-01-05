part of oxygen;

///
abstract class Filter<T extends Component> {
  Filter() : assert(T != Component);

  /// Unique identifier.
  String get filterId;

  Type get type => T;

  /// Method for matching an [Entity] against this filter.
  bool match(Entity entity);
}

class Has<T extends Component> extends Filter<T> {
  @override
  String get filterId => 'Has<$T>';

  @override
  bool match(Entity entity) => entity._componentTypes.contains(T);
}

class HasNot<T extends Component> extends Filter<T> {
  @override
  String get filterId => 'HasNot<$T>';

  @override
  bool match(Entity entity) => !entity._componentTypes.contains(T);
}
