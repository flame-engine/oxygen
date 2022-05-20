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
          world!.createEntity();
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

    group('getPool', () {
      group('with init', () {
        final world = World();
        for (var i = 0; i < 100000; i++) {
          world.createEntity();
        }
        world.getPool(_TestComponent.new);
        world.getPool(_TestComponen2.new);
        world.getPool(_TestComponen3.new);
        world.getPool(_TestComponen4.new);
        world.getPool(_TestComponen5.new);
        world.getPool(_TestComponen6.new);
        world.getPool(_TestComponen7.new);
        world.getPool(_TestComponen8.new);
        world.getPool(_TestComponen9.new);
        world.getPool(_TestComponen10.new);
        world.getPool(_TestComponen11.new);
        world.getPool(_TestComponen12.new);
        world.getPool(_TestComponen13.new);
        world.getPool(_TestComponen14.new);
        world.getPool(_TestComponen15.new);
        world.getPool(_TestComponen16.new);
        world.getPool(_TestComponen17.new);
        world.getPool(_TestComponen18.new);
        world.getPool(_TestComponen19.new);
        world.getPool(_TestComponen20.new);
        world.getPool(_TestComponen21.new);
        world.getPool(_TestComponen22.new);
        world.getPool(_TestComponen23.new);
        world.getPool(_TestComponen24.new);
        world.getPool(_TestComponen25.new);
        world.getPool(_TestComponen26.new);
        world.getPool(_TestComponen27.new);
        world.getPool(_TestComponen28.new);
        world.getPool(_TestComponen29.new);
        world.getPool(_TestComponen30.new);
        world.getPool(_TestComponen31.new);
        world.getPool(_TestComponen32.new);
        world.getPool(_TestComponen33.new);
        world.getPool(_TestComponen34.new);
        world.getPool(_TestComponen35.new);
        world.getPool(_TestComponen36.new);
        world.getPool(_TestComponen37.new);
        world.getPool(_TestComponen38.new);
        world.getPool(_TestComponen39.new);
        world.getPool(_TestComponen40.new);
        benchmark('World with 100k entities', () {
          world.getPool(_TestComponent.new);
          world.getPool(_TestComponen2.new);
          world.getPool(_TestComponen3.new);
          world.getPool(_TestComponen4.new);
          world.getPool(_TestComponen5.new);
          world.getPool(_TestComponen6.new);
          world.getPool(_TestComponen7.new);
          world.getPool(_TestComponen8.new);
          world.getPool(_TestComponen9.new);
          world.getPool(_TestComponen10.new);
          world.getPool(_TestComponen11.new);
          world.getPool(_TestComponen12.new);
          world.getPool(_TestComponen13.new);
          world.getPool(_TestComponen14.new);
          world.getPool(_TestComponen15.new);
          world.getPool(_TestComponen16.new);
          world.getPool(_TestComponen17.new);
          world.getPool(_TestComponen18.new);
          world.getPool(_TestComponen19.new);
          world.getPool(_TestComponen20.new);
          world.getPool(_TestComponen21.new);
          world.getPool(_TestComponen22.new);
          world.getPool(_TestComponen23.new);
          world.getPool(_TestComponen24.new);
          world.getPool(_TestComponen25.new);
          world.getPool(_TestComponen26.new);
          world.getPool(_TestComponen27.new);
          world.getPool(_TestComponen28.new);
          world.getPool(_TestComponen29.new);
          world.getPool(_TestComponen30.new);
          world.getPool(_TestComponen31.new);
          world.getPool(_TestComponen32.new);
          world.getPool(_TestComponen33.new);
          world.getPool(_TestComponen34.new);
          world.getPool(_TestComponen35.new);
          world.getPool(_TestComponen36.new);
          world.getPool(_TestComponen37.new);
          world.getPool(_TestComponen38.new);
          world.getPool(_TestComponen39.new);
          world.getPool(_TestComponen40.new);
        });
      });
      group('without init', () {
        final world = World();
        for (var i = 0; i < 100000; i++) {
          world.createEntity();
        }

        benchmark('World with 100k entities', () {
          world.getPool(_TestComponent.new);
          world.getPool(_TestComponen2.new);
          world.getPool(_TestComponen3.new);
          world.getPool(_TestComponen4.new);
          world.getPool(_TestComponen5.new);
          world.getPool(_TestComponen6.new);
          world.getPool(_TestComponen7.new);
          world.getPool(_TestComponen8.new);
          world.getPool(_TestComponen9.new);
          world.getPool(_TestComponen10.new);
          world.getPool(_TestComponen11.new);
          world.getPool(_TestComponen12.new);
          world.getPool(_TestComponen13.new);
          world.getPool(_TestComponen14.new);
          world.getPool(_TestComponen15.new);
          world.getPool(_TestComponen16.new);
          world.getPool(_TestComponen17.new);
          world.getPool(_TestComponen18.new);
          world.getPool(_TestComponen19.new);
          world.getPool(_TestComponen20.new);
          world.getPool(_TestComponen21.new);
          world.getPool(_TestComponen22.new);
          world.getPool(_TestComponen23.new);
          world.getPool(_TestComponen24.new);
          world.getPool(_TestComponen25.new);
          world.getPool(_TestComponen26.new);
          world.getPool(_TestComponen27.new);
          world.getPool(_TestComponen28.new);
          world.getPool(_TestComponen29.new);
          world.getPool(_TestComponen30.new);
          world.getPool(_TestComponen31.new);
          world.getPool(_TestComponen32.new);
          world.getPool(_TestComponen33.new);
          world.getPool(_TestComponen34.new);
          world.getPool(_TestComponen35.new);
          world.getPool(_TestComponen36.new);
          world.getPool(_TestComponen37.new);
          world.getPool(_TestComponen38.new);
          world.getPool(_TestComponen39.new);
          world.getPool(_TestComponen40.new);
        });
      });
    });
  });
}

class _TestComponent extends Component {}

class _TestComponen2 extends Component {}

class _TestComponen3 extends Component {}

class _TestComponen4 extends Component {}

class _TestComponen5 extends Component {}

class _TestComponen6 extends Component {}

class _TestComponen7 extends Component {}

class _TestComponen8 extends Component {}

class _TestComponen9 extends Component {}

class _TestComponen10 extends Component {}

class _TestComponen11 extends Component {}

class _TestComponen12 extends Component {}

class _TestComponen13 extends Component {}

class _TestComponen14 extends Component {}

class _TestComponen15 extends Component {}

class _TestComponen16 extends Component {}

class _TestComponen17 extends Component {}

class _TestComponen18 extends Component {}

class _TestComponen19 extends Component {}

class _TestComponen20 extends Component {}

class _TestComponen21 extends Component {}

class _TestComponen22 extends Component {}

class _TestComponen23 extends Component {}

class _TestComponen24 extends Component {}

class _TestComponen25 extends Component {}

class _TestComponen26 extends Component {}

class _TestComponen27 extends Component {}

class _TestComponen28 extends Component {}

class _TestComponen29 extends Component {}

class _TestComponen30 extends Component {}

class _TestComponen31 extends Component {}

class _TestComponen32 extends Component {}

class _TestComponen33 extends Component {}

class _TestComponen34 extends Component {}

class _TestComponen35 extends Component {}

class _TestComponen36 extends Component {}

class _TestComponen37 extends Component {}

class _TestComponen38 extends Component {}

class _TestComponen39 extends Component {}

class _TestComponen40 extends Component {}
