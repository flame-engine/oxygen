import 'package:example/utils/keyboard.dart';
import 'package:example/utils/terminal.dart';

const TARGET_FPS = 120;
const FRAME_TIME = 1000 ~/ TARGET_FPS;

abstract class Game {
  final Stopwatch _stopwatch;

  late int _previous;

  Game() : _stopwatch = Stopwatch()..start() {
    onLoad();

    _previous = _stopwatch.elapsedMilliseconds;

    loop();
  }

  void loop() {
    final current = _stopwatch.elapsedMilliseconds;
    final elapsed = current - _previous;
    _previous = current;

    update(elapsed / FRAME_TIME);

    keyboard.clear();

    terminal.clear();
    terminal.render();

    Future.delayed(Duration(milliseconds: FRAME_TIME)).then((value) => loop());
  }

  void onLoad();

  void update(double delta);
}
