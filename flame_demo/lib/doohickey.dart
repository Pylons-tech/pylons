import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/game.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_flame_demo/pylons_component.dart';
import 'package:pylons_flame_demo/recipe.dart';

import 'keyframed_animations/keyframed_animation_component.dart';

const _tapLine = "Tap to collect whatsits";
const _waitLine = "Collecting whatsits...";

const _animIdle = "idle";
const _animClick = "click";
const _animLocked = "locked";

bool _initializedAnims = false;
late final KeyframedAnimation _idleAnim;
late final KeyframedAnimation _clickAnim;
late final KeyframedAnimation _lockedAnim;

class Doohickey extends KeyframedAnimationComponent with TapCallbacks {
  static Future<Doohickey> create() async {
    if (!_initializedAnims) {
      _idleAnim = KeyframedAnimation(_animIdle, [
        Keyframe(1, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Star_many_pointed_star.png'))], stepTime: 0.02))
      ],AnimationEndBehavior.loop);
      _lockedAnim = KeyframedAnimation(_animLocked, [
        Keyframe(0.5, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('hourglass_3.png'))], stepTime: 0.02)),
        Keyframe(0.5, 0, 1, Vector2.all(0.75), SpriteAnimation.spriteList([Sprite(await Flame.images.load('hourglass_3.png'))], stepTime: 0.02)),
        Keyframe(0.5, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('hourglass_3.png'))], stepTime: 0.02))
      ],AnimationEndBehavior.loop);
      _clickAnim = KeyframedAnimation(_animClick, [
        Keyframe(0.5, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('normal_money.png'))], stepTime: 0.02)),
        Keyframe(0.5, 0, 1, Vector2.all(0.75), SpriteAnimation.spriteList([Sprite(await Flame.images.load('normal_money.png'))], stepTime: 0.02)),
        Keyframe(0.5, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('normal_money.png'))], stepTime: 0.02))
      ],AnimationEndBehavior.playOnce);
      _initializedAnims = true;
    }
    return Doohickey();
  }

  Doohickey() : super({_animIdle : _idleAnim, _animClick : _clickAnim, _animLocked : _lockedAnim}, _animIdle, false);
  bool _dispatchedAction = false;
  late PylonsGame game;
  late final Component lv1Component;
  late final Component lv2Component;

  @override
  void onMount() {
    super.onMount();
    game = findGame() as PylonsGame;
    size = Vector2(80, 80);
    position = Vector2(100, 500);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_dispatchedAction == false && PylonsComponent.instance.lastProfile == null && PylonsComponent.instance.ready) {
      initialStateSetup();
    }
  }

  @override
  void onAnimationDone(String animation) {
    if (animation == _animClick) {
      playAnimation(_animLocked);
      gameStateNotifier.updateLine2(_waitLine);
      if (recipeGet10Whatsits.executeCheck(Provider.of<GameStateNotifier>(game.buildContext!, listen: false))) {
        PylonsComponent.instance.executeRecipe(recipeGet10Whatsits.sdkRecipe, [], [
              (exec) async {
            _dispatchedAction = false;
            gameStateNotifier.updateLine2("Got 10 whatsits!");
            gameStateNotifier.updateLine2(_tapLine);
            gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(game.buildContext!, listen: false).whatsits + 10);
            playAnimation(_animIdle);
          }
        ]);
      } else {
        PylonsComponent.instance.executeRecipe(recipeGetWhatsit.sdkRecipe, [], [
              (exec) async {
            _dispatchedAction = false;
            gameStateNotifier.updateLine2("Got 1 whatsit!");
            gameStateNotifier.updateLine2(_tapLine);
            gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(game.buildContext!, listen: false).whatsits + 1);
            playAnimation(_animIdle);
          }
        ]);
      }
    }
  }

  void initialStateSetup() {
    _dispatchedAction = true;
    PylonsComponent.instance.getProfile([
          (prf) {
        _dispatchedAction = false;
        gameStateNotifier.updateName(prf?.username != null ? prf!.username : "ERROR");
        gameStateNotifier.updateLine2(_tapLine);
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
      playAnimation(_animClick);
    }
  }
}