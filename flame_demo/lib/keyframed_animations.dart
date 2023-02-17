import 'package:flame/components.dart';

class KeyframedAnimationComponent extends SpriteAnimationComponent {
  double currentFrameTime = 0;
  int currentFrameIndex = 0;
  KeyframedAnimation? currentAnimation;
  final Map<String, KeyframedAnimation> animMap;
  String initialAnimationKey;

  KeyframedAnimationComponent(this.animMap, this.initialAnimationKey);

  /// override w/ a function to be called when an animation finishes
  void onAnimationDone(String animation) {

  }

  /// override w/ a function to be called when an animation loops
  void onAnimationLoop(String animation) {

  }

  @override
  void update(double dt) {
    if (currentAnimation != null) {
      currentFrameTime += dt;

      final Keyframe framedata;
      final bool animDone;
      final bool frameDone;

      // Are we done w/ the current keyframe?
      if (currentFrameTime >= currentAnimation!.frameData[currentFrameIndex].transitionTime) {
        currentFrameTime = currentAnimation!.frameData[currentFrameIndex].transitionTime; // clamp
        frameDone = true;
      } else {
        frameDone = false;
      }

      // Interpolate framedata if not last frame of animation; otherwise, just use last frame
      if (currentFrameIndex <= currentAnimation!.frameData.length) {
        framedata = currentAnimation!.frameData[currentFrameIndex].lerp(currentAnimation!.frameData[currentFrameIndex + 1], currentFrameTime);
        animDone = false;
      } else {
        framedata = currentAnimation!.frameData[currentFrameIndex];
        animDone = true;
      }

      scale = framedata.scale;
      angle = framedata.angle;
      animation = framedata.baseAnim;

      if (frameDone) {
        currentFrameTime = 0;
        if (animDone) {
          switch (currentAnimation!.endBehavior) {
            case AnimationEndBehavior.playOnce:
              onAnimationDone(currentAnimation!.name);
              break;
            case AnimationEndBehavior.loop:
              onAnimationLoop(currentAnimation!.name);
              currentFrameIndex = 0;
              break;
          }
        } else {
          // Move to next frame
          currentFrameIndex++;
        }
      }
    }
  }

  void playAnimation(String animation) {

  }

  void pause() {

  }

  void stop () {

  }

  void reset () {

  }
}

enum AnimationEndBehavior {
  playOnce,
  loop
}

class KeyframedAnimation {
  /// Must be the same string used for the animation's key in the animMap.
  final String name;
  final List<Keyframe> frameData;
  final AnimationEndBehavior endBehavior;

  KeyframedAnimation(this.name, this.frameData, this.endBehavior);
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