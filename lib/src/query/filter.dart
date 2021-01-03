part of oxygen;

abstract class Filter<T extends Component> {
  Filter() : assert(T != Component);

  String get filterId;

  Type get type => T;

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
