import 'keyboard.dart';
import 'terminal.dart';

const kTargetFps = 120;
const kFrameTime = 1000 ~/ kTargetFps;

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

    update(elapsed / kFrameTime);

    keyboard.clear();

    terminal.clear();
    terminal.render();

    Future<void>.delayed(const Duration(milliseconds: kFrameTime))
        .then((_) => loop());
  }

  void onLoad();

  void update(double delta);
}
