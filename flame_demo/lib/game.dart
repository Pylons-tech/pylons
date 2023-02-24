import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:pylons_flame_demo/doohickey.dart';
import 'package:pylons_flame_demo/pylons_component.dart';

class PylonsGame extends FlameGame with HasTappableComponents {
  @override
  Future<void> onLoad() async {
    addAll([
        PylonsComponent("appFlameClicker"),
        await Doohickey.create()
      ]);
  }
}