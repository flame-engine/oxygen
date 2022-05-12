import 'package:benchmark/benchmark.dart';
import 'package:oxygen/oxygen.dart';

void main() {
  group('World', () {
    group('Without world creation', () {
      World? world;

      setUpEach(() => world = World());

      tearDownEach(() => world = null);

      benchmark('World with 100k entities', () {
        for (var i = 0; i < 100000; i++) {
          world?.createEntity();
        }
      });
    });

    group('With world creation', () {
      benchmark('World with 100k entities', () {
        final world = World();
        for (var i = 0; i < 100000; i++) {
          world.createEntity();
        }
      });
    });
  });
}
