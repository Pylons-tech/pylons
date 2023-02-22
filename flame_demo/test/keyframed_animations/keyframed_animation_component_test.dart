import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:flame_test/flame_test.dart";
import 'package:pylons_flame_demo/keyframed_animations/keyframed_animation_component.dart';

bool _initializedAnims = false;
late final KeyframedAnimation _defaultAnim;
late final KeyframedAnimation _otherAnim;

class _TestKeyframedAnimationComponent extends KeyframedAnimationComponent {
  bool looped = false;
  bool stopped = false;
  _TestKeyframedAnimationComponent() : super({"testAnim" : _defaultAnim, "otherAnim" : _otherAnim}, "testAnim", false);

  static Future<_TestKeyframedAnimationComponent> create() async {
    if (!_initializedAnims) {
      _defaultAnim = KeyframedAnimation("testAnim", [
        Keyframe(1, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Star_many_pointed_star.png'))], stepTime: 0.02))
      ],AnimationEndBehavior.playOnce);
      _otherAnim = KeyframedAnimation("otherAnim", [
        Keyframe(.25, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Star_many_pointed_star.png'))], stepTime: 0.02)),
        Keyframe(.25, 90, 1, Vector2.all(30), SpriteAnimation.spriteList([Sprite(await Flame.images.load('normal_money.png'))], stepTime: 0.04))
      ],AnimationEndBehavior.loop);
      _initializedAnims = true;
    }

    return _TestKeyframedAnimationComponent();
  }

  @override
  void onAnimationLoop(String animation) {
    looped = true;
  }

  @override
  void onAnimationDone(String animation) {
    stopped = true;
  }
}

void main() {
  group('KeyframedAnimationComponent', () {
    testWithFlameGame('Plays the default animation on mount', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();
      expect(component.currentAnimationKey, "testAnim", reason : "Component should play default animation on mount");
    });

    testWithFlameGame('Pauses', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();
      component.pause();
      expect(component.paused, true, reason : "Should be paused");
    });

    testWithFlameGame('Unpauses', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();
      component.pause();
      component.unpause();
      expect(component.paused, false, reason : "Should not be paused");
    });

    testWithFlameGame('Sprite changes at appropriate intervals when playing animation', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();

      component.playAnimation("otherAnim");
      game.update(3333);
      game.update(1);
      expect(component.animation!.totalDuration(), .04, reason : "Should be playing second animation clip");
    });

    testWithFlameGame('Scale/angle change at appropriate intervals when playing animation', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();
      component.playAnimation("otherAnim");
      game.update(3333);
      game.update(1);
      expect(component.scale.x > 1, true, reason : "Scale should be affected by animation");
      expect(component.angle > 0, true, reason : "Angle should be affected by animation");
    });

    testWithFlameGame('Animation loops when it should', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();
      component.playAnimation("otherAnim");
      game.update(1500);
      game.update(1);
      expect(component.looped, true, reason : "Should have looped");
    });

    testWithFlameGame('''Animation doesn't loop when it shouldn't''', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();
      await Future.delayed(const Duration(seconds: 1));
      expect(component.looped, false, reason : "Should not have looped");
    });

    testWithFlameGame('''Can't play nonexistent animation''', (game) async {
      WidgetsFlutterBinding.ensureInitialized();
      final component = await _TestKeyframedAnimationComponent.create();
      game.add(component);
      await game.ready();
      expect(() => component.playAnimation("not_an_animation"),  throwsException, reason : "Should not play animation if doesn't exist");
    });
  });
}