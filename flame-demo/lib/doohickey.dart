import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/game.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_flame_demo/pylons_component.dart';
import 'package:pylons_flame_demo/recipe.dart';
import 'package:flame/cache.dart';

class Doohickey extends PositionComponent with TapCallbacks {
  Doohickey() : super(size: Vector2(80, 80), position: Vector2(100, 500), anchor: Anchor.center);
  bool _dispatchedAction = false;
  late PylonsGame game;
  late final Sprite baseSprite;
  late final Sprite skullSprite;
  late final Sprite wheelSprite;
  late final Component lv1Component;
  late final Component lv2Component;

  @override
  void render(Canvas canvas) {
    baseSprite.render(canvas);
  }

  @override
  void onLoad() async {
    baseSprite = Sprite(await Flame.images.load('Star_many_pointed_star.png'));
    skullSprite = Sprite(await Flame.images.load('Skull_alien_goofy_skull.png'));
    wheelSprite = Sprite(await Flame.images.load('spinning_wheel.png'));

    await add(SpriteComponent(sprite: skullSprite, size: Vector2(50, 50), anchor: Anchor.center));
  }

  @override
  void onMount() {
    super.onMount();
    game = findGame() as PylonsGame;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_dispatchedAction == false && PylonsComponent.instance.lastProfile == null && PylonsComponent.instance.ready) {
      initialStateSetup();
    }
    if (Provider.of<GameStateNotifier>(game.buildContext!, listen: false).hasThingamabob) {
      (children.first as SpriteComponent).sprite = wheelSprite;
    }
  }

  void initialStateSetup() {
    _dispatchedAction = true;
    PylonsComponent.instance.getProfile([
          (prf) {
        _dispatchedAction = false;
        gameStateNotifier.updateName(prf?.username != null ? prf!.username : "ERROR");
        gameStateNotifier.updateWhatsits(prf?.coins["appFlameClicker/whatsit"]?.toInt() ?? 0);
        try {
          prf?.items.firstWhere((item) => item.getString("entityType") == "thingamabob");
          gameStateNotifier.updateThingamabob(true);
        } on StateError {
          // swallow it - nothing to do here
        }
        return;
      }
    ]);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_dispatchedAction == false && PylonsComponent.instance.lastProfile != null) {
      _dispatchedAction = true;
      if (recipeGet10Whatsits.executeCheck(Provider.of<GameStateNotifier>(game.buildContext!, listen: false))) {
        PylonsComponent.instance.executeRecipe(recipeGet10Whatsits.sdkRecipe, [], [
              (exec) {
            _dispatchedAction = false;
            gameStateNotifier.updateLine2("Got 10 whatsits!");
            gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(game.buildContext!, listen: false).whatsits + 10);
          }
        ]);
      } else {
        PylonsComponent.instance.executeRecipe(recipeGetWhatsit.sdkRecipe, [], [
              (exec) {
            _dispatchedAction = false;
            gameStateNotifier.updateLine2("Got 1 whatsit!");
            gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(game.buildContext!, listen: false).whatsits + 1);
          }
        ]);
      }
    }
  }
}