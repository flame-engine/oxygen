import 'dart:io';

import 'package:oxygen/oxygen.dart';

import 'systems/move_system.dart';
import 'systems/render_system.dart';
import 'components/position_component.dart';
import 'components/render_component.dart';

const TARGET_FPS = 2;
const FRAME_TIME = 1000 ~/ TARGET_FPS;

void main(List<String> arguments) {
  if (!stdout.supportsAnsiEscapes) {
    throw Exception(
      'Sorry only terminals that support ANSI escapes are supported',
    );
  }

  final world = World();

  world.registerSystem(MoveSystem());
  world.registerSystem(RenderSystem());
  world.registerComponent(() => PositionComponent());
  world.registerComponent(() => RenderComponent());

  var offset = 0;
  for (var y = .0; y < stdout.terminalLines; y++) {
    for (var x = .0; x < 3; x++) {
      world.createEntity()
        ..add<RenderComponent>()
        ..add<PositionComponent>(PositionInit(x + offset, y));
    }
    offset++;
  }

  world.init();

  var watch = Stopwatch()..start();
  var last = watch.elapsedMilliseconds;

  void run() {
    final time = watch.elapsedMilliseconds;
    final delta = time - last;
    world.execute(delta / FRAME_TIME);
    last = time;

    sleep(Duration(milliseconds: FRAME_TIME));
    run();
  }
  run();
}
