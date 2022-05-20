import 'package:meta/meta.dart';

@internal
class FilterOperation {
  bool added;
  int entity;

  FilterOperation([this.added = false, this.entity = 0]);
}
