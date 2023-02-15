import 'package:flame/components.dart';

class KeyframedAnimationComponent extends SpriteAnimationComponent {
  final Map<String, KeyframedAnimation> animMap;
  double currentFrameTime;
  Keyframe currentKeyframe;


  @override
  void update(double dt) {

    //scale =
  }

  void playAnimation(String animation) {

  }

  void playKeyframe(Keyframe keyframe) {

  }

  void pause() {

  }

  void stop () {

  }

  void reset () {

  }
}

class KeyframedAnimation {
  final String name;
  final List<Keyframe> frameData;

  KeyframedAnimation(this.name, this.frameData);
}

class Keyframe {
  final double transitionTime;
  final double angle;
  final double priority;
  final Vector2 scale;
  final SpriteAnimation baseAnim;

  Keyframe(this.transitionTime, this.angle, this.priority, this.scale, this.baseAnim);

  Keyframe lerp (Keyframe other, double t) {
    final SpriteAnimation anim;
    if (t / transitionTime > priority / (priority + other.priority)) {
      anim = baseAnim;
    } else {
      anim = other.baseAnim;
    }
    return Keyframe(transitionTime.lerp(other.transitionTime, t), angle.lerp(other.angle, t), 0, Vector2.copy(scale)..lerp(other.scale, t), anim);
  }
}

extension DoubleLerp on double {
  double lerp (double other, double t) => this + (other - this) * t;
}