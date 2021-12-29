import 'package:oxygen/oxygen.dart';
import 'package:benchmark/benchmark.dart';

void main() {
  group('World', () {
    group('Without world creation', () {
      World? world;

      setUpEach(() => world = World());

      tearDownEach(() => world = null);

      benchmark('World with 100000 entities', () {
        for (var i = 0; i < 100000; i++) {
          world!.createEntity();
        }
      });
    });

    group('With world creation', () {
      benchmark('World with 100000 entities', () {
        final world = World();
        for (var i = 0; i < 100000; i++) {
          world.createEntity();
        }
      });
    });
  });
}
