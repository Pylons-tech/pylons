import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'keyframed_animations/keyframed_animation_component.dart';

const _animDefault = "default";

late final Map<String, KeyframedAnimation> _animMap;

bool _initializedAnims = false;

int _noWhatsits = 0;

class Whatsit extends KeyframedAnimationComponent {
  Whatsit() : super(_animMap, _animDefault, false);

  static Future<Whatsit> create() async {
    if (!_initializedAnims) {
      final _defaultAnim = KeyframedAnimation(_animDefault, [
        Keyframe(1/2, 0, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Skull_alien_goofy_skull.png'))], stepTime: 0.02)),
        Keyframe(1/2, 90, .5, Vector2.all(0.9), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Skull_alien_goofy_skull.png'))], stepTime: 0.02)),
        Keyframe(1/2, 180, 1, Vector2.all(0.6), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Skull_alien_goofy_skull.png'))], stepTime: 0.02)),
        Keyframe(1/2, 270, .5, Vector2.all(0.9), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Skull_alien_goofy_skull.png'))], stepTime: 0.02)),
        Keyframe(1/60, 360, 1, Vector2.all(1), SpriteAnimation.spriteList([Sprite(await Flame.images.load('Skull_alien_goofy_skull.png'))], stepTime: 0.02))
      ],AnimationEndBehavior.loop);
      _animMap = {_animDefault : _defaultAnim};
      _initializedAnims = true;
    }
    return Whatsit();
  }

  static Future<void> addToN(int n, Component parent) async {
    for (var i = _noWhatsits; i < n; i++) {
      final whatsit = await create();
      whatsit.position = Vector2.random();
      // todo: eliminate magic numbers (work out a saner way to do positioning tho)
      whatsit.position.x *= 250;
      whatsit.position.y *= 1000;
      whatsit.size = Vector2(24, 24);
      parent.add(whatsit);
      _noWhatsits++;
    }
  }
}