import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:flame_test/flame_test.dart";
import 'package:pylons_flame_demo/keyframed_animations/keyframed_animation_component.dart';

bool _initializedAnims = false;
late final KeyframedAnimation _defaultAnim;

class _TestKeyframedAnimationComponent extends KeyframedAnimationComponent {
  _TestKeyframedAnimationComponent() : super({"testAnim" : _defaultAnim}, "testAnim", false);

  static Future<_TestKeyframedAnimationComponent> create() async {
    if (!_initializedAnims) {
      _defaultAnim = KeyframedAnimation("testAnim", [
        Keyframe(1, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Star_many_pointed_star.png'))], stepTime: 0.02))
      ],AnimationEndBehavior.playOnce);
      _initializedAnims = true;
    }

    return _TestKeyframedAnimationComponent();
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
  });
}