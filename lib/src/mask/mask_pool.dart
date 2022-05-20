
import 'dart:collection';

import 'mask.dart';

typedef MaskBuilder = Mask Function();

class MaskPool {
  final int _capacity;
  final _masks = Queue<Mask>();
  final MaskBuilder builder;

  int get size => _masks.length;

  MaskPool(this._capacity, this.builder)
      : assert(_capacity > 0, 'Capacity must be > 0') {
    _expand();
  }

  /// Take a [Mask] from the pool.
  Mask take() {
    if (_masks.isEmpty) {
      _expand();
    }

    return _masks.removeLast();
  }

  /// Release a [Mask] back into the pool.
  void release(Mask mask) => _masks.addLast(mask);

  void _expand() {
    _masks.addAll(Iterable.generate(_capacity, (index) => builder()));
  }
}
