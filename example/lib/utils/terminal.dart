import 'dart:io';

import 'package:example/utils/color.dart';
import 'package:example/utils/vector2.dart';
import 'package:example/utils/rect.dart';

const ESCAPE = '\x1B';

final Terminal terminal = Terminal._();

class Terminal {
  Rect get viewport => Rect.fromLTWH(
        0,
        0,
        stdout.terminalColumns,
        stdout.terminalLines,
      );

  bool hideCursor = true;

  late List<String> buffer;

  Terminal._() {
    if (!stdout.supportsAnsiEscapes) {
      throw Exception(
        'Sorry only terminals that support ANSI escapes are supported',
      );
    }
    buffer = [if (hideCursor) _escape('?25l') else _escape('?25h')];

    ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
      clear();
      stdout.write(_escape('?25h'));
      exit(0);
    });
  }

  final List<Vector2> _positions = [Vector2.zero()];
  Vector2 get _position => _positions.last;
  set _position(Vector2 position) {
    _positions.last = position;
  }

  void translate(int x, int y) {
    _position = _position.translate(x, y);
    buffer.add(_escape('${_position.y};${_position.x}H'));
  }

  String _escape(String data) => '$ESCAPE[$data';

  void draw(
    String data, {
    Vector2 position = const Vector2.zero(),
    Color foregroundColor = Colors.white,
    Color backgroundColor = Colors.black,
  }) {
    position = _position.translate(position.x, position.y);
    buffer.addAll([
      _escape('${position.y + 1};${position.x}H'),
      _escape('38;2;${foregroundColor.toRGB()}m'),
      _escape('48;2;${backgroundColor.toRGB()}m'),
      data,
    ]);
  }

  void clear() => stdout.write('$ESCAPE[2J$ESCAPE[0;0H');

  void save() => _positions.add(_position);

  void restore() => _positions.removeLast();

  void render() {
    for (final line in buffer) {
      stdout.write(line);
    }
    buffer = [if (hideCursor) _escape('?25l') else _escape('?25h')];
    _position = Vector2.zero();
  }
}
