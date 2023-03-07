

import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:pylons_flame_demo/clickable.dart';
import 'package:pylons_flame_demo/pylons_component.dart';
import 'package:pylons_flame_demo/text.dart';
import 'package:pylons_flame_demo/whatsit.dart';

import 'main.dart';

class PylonsGame extends FlameGame with HasTappables {
  bool dispatchedAction = false;

  @override
  Color backgroundColor() => const Color(0xFFFF00FF);

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(Vector2(450, 800));
    addAll([
        PylonsComponent("appFlameClicker"),
        await Doohickey.create()
      ]);
  }

  void initialStateSetup() {
    dispatchedAction = true;
    PylonsComponent.instance.getProfile([
          (prf) {
        dispatchedAction = false;
        gameStateNotifier.updateName(prf?.username != null ? prf!.username : "ERROR");
        gameStateNotifier.updateLine2(tapToCollectWhatsits);
        gameStateNotifier.updateWhatsits(prf?.coins["appFlameClicker/whatsit"]?.toInt() ?? 0);
        try {
          prf?.items.firstWhere((item) => item.getString("entityType") == "thingamabob");
          gameStateNotifier.updateThingamabob(true);
          Whatsit.addToN(gameStateNotifier.whatsits, this);
        } on StateError {
          // swallow it - nothing to do here
        }
        return;
      }
    ]);
  }
}