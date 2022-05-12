import 'dart:typed_data';
import 'package:meta/meta.dart';

@internal
extension ResizeUint8List on Uint8List {
  Uint8List resize([int? capacity]) {
    var size = capacity ?? length;

    if (size <= length) {
      size = length << 1;
    }

    final newList = Uint8List(size);

    final max = length;
    for (var i = 0; i < max; i++) {
      newList[i] = this[i];
    }

    return newList;
  }
}

@internal
extension ResizeUint32List on Uint32List {
  Uint32List resize([int? capacity]) {
    var size = capacity ?? length;

    if (size <= length) {
      size = size << 1;
    }

    final newList = Uint32List(size);

    final max = length;
    for (var i = 0; i < max; i++) {
      newList[i] = this[i];
    }

    return newList;
  }
}

@internal
extension MaskList on Uint8List {
  bool containsValue(int value, int end) {
    var result = false;

    for (var i = 0; i < end; i++) {
      if (this[i] == value) {
        return result = true;
      }
    }
    return result;
  }

  Uint8List sortTo(int end) =>
      (BytesBuilder()..add(getRange(0, end).toList()..sort())).takeBytes();
}
