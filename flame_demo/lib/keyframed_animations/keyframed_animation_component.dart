import 'package:flame/components.dart';
import 'package:pylons_flame_demo/keyframed_animations/extensions.dart';

/// Extends SpriteAnimationComponent with support for simple keyframe-based animations
/// that transition between different sprite animation loops and permit interpolated
/// scaling/rotation.
class KeyframedAnimationComponent extends SpriteAnimationComponent {
  double _currentFrameTime = 0;
  int _currentFrameIndex = 0;
  bool _paused;
  bool get paused => _paused;
  KeyframedAnimation? _currentAnimation;
  String get currentAnimationKey => _currentAnimation?.name ?? "";
  final Map<String, KeyframedAnimation> animMap;
  final String initialAnimationKey;

  KeyframedAnimationComponent(this.animMap, this.initialAnimationKey, this._paused);

  @override
  void onMount() {
    if (initialAnimationKey.isNotEmpty) {
      playAnimation(initialAnimationKey);
    }
  }

  /// Override with a function to be called when an animation starts
  void onAnimationStart(String previousAnimation, String nextAnimation) {

  }

  /// Override with a function to be called when an animation stops early
  void onAnimationStop(String animation) {

  }

  /// Override with a function to be called when an animation finishes
  void onAnimationDone(String animation) {

  }

  /// Override with a function to be called when an animation loops
  void onAnimationLoop(String animation) {

  }

  /// Override with a function to be called when an animation pauses
  void onAnimationPause(String animation) {

  }

  /// Override with a function to be called when an animation unpauses
  void onAnimationUnpause(String animation) {

  }

  @override
  void update(double dt) {
    if (_currentAnimation != null) {
      _currentFrameTime += dt;

      final Keyframe framedata;
      final bool animDone;
      final bool frameDone;

      // Are we done w/ the current keyframe?
      if (_currentFrameTime >= _currentAnimation!.frameData[_currentFrameIndex].transitionTime) {
        _currentFrameTime = _currentAnimation!.frameData[_currentFrameIndex].transitionTime; // clamp
        frameDone = true;
      } else {
        frameDone = false;
      }

      // Interpolate framedata if not last frame of animation; otherwise, just use last frame
      if (_currentFrameIndex + 1 < _currentAnimation!.frameData.length) {
        framedata = _currentAnimation!.frameData[_currentFrameIndex].lerp(_currentAnimation!.frameData[_currentFrameIndex + 1], _currentFrameTime);
        animDone = false;
      } else {
        framedata = _currentAnimation!.frameData[_currentFrameIndex];
        animDone = true;
      }

      scale = framedata.scale;
      angle = framedata.angle;
      animation = framedata.baseAnim;

      if (frameDone) {
        _currentFrameTime = 0;
        if (animDone) {
          switch (_currentAnimation!.endBehavior) {
            case AnimationEndBehavior.playOnce:
              onAnimationDone(_currentAnimation!.name);
              break;
            case AnimationEndBehavior.loop:
              onAnimationLoop(_currentAnimation!.name);
              _currentFrameIndex = 0;
              break;
          }
        } else {
          // Move to next frame
          _currentFrameIndex++;
        }
      }
    }
  }

  void playAnimation(String animation) {
    final anim = animMap[animation];
    if (anim == null) {
      throw Exception("No animation $animation in map");
    }
    final lastAnim = _currentAnimation?.name ?? "";
    _currentFrameTime = 0;
    _currentFrameIndex = 0;
    _currentAnimation = anim;
    onAnimationStart(lastAnim, animation);
  }

  void pause() {
    if (_currentAnimation == null) {
      throw Exception("Not playing an animation");
    }
    if (_paused) {
      throw Exception("Already paused");
    }
    _paused = true;
    onAnimationPause(_currentAnimation!.name);
  }

  void unpause() {
    if (_currentAnimation == null) {
      throw Exception("Not playing an animation");
    }
    if (!_paused) {
      throw Exception("Not paused");
    }
    _paused = false;
    onAnimationUnpause(_currentAnimation!.name);
  }

  void stop () {
    if (_currentAnimation == null) {
      throw Exception("Not playing an animation");
    }
    final lastAnim = _currentAnimation!.name;
    _currentFrameTime = 0;
    _currentFrameIndex = 0;
    _currentAnimation = null;
    onAnimationStop(lastAnim);
  }

  void reset () {
    if (_paused) unpause();
    if (_currentAnimation != null) stop();
    playAnimation(initialAnimationKey);
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
