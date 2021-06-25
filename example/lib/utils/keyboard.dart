import 'dart:io';

enum Key {
  w,
  a,
  s,
  d,
  space,
}

final keyboard = Keyboard._();

class Keyboard {
  final List<Key> _keysPressed = [];

  bool isPressed(Key key) => _keysPressed.contains(key);

  Keyboard._() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    stdin.listen((event) {
      switch (event.first) {
        case 32:
          _keysPressed.add(Key.space);
          break;
        case 119:
          _keysPressed.add(Key.w);
          break;
        case 97:
          _keysPressed.add(Key.a);
          break;
        case 115:
          _keysPressed.add(Key.s);
          break;
        case 100:
          _keysPressed.add(Key.d);
          break;
      }
    });
  }

  void clear() => _keysPressed.clear();
}
