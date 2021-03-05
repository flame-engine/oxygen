part of oxygen;

/// With the [ValueComponent] you can easily define single value components.
class ValueComponent<T> extends Component<T> {
  T? value;

  @override
  void init([T? data]) => value = data;

  @override
  void reset() => value = null;
}
