import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pylons_flame_demo/game.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_flame_demo/pylons_component.dart';

class Doohickey extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;
  double _timeSinceLastProfileFetch = 0;
  static const double _profileLifespan = 15; // seconds
  bool _dispatchedAction = false;
  late PylonsGame game;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void onMount() {
    super.onMount();
    game = findGame() as PylonsGame;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_timeSinceLastProfileFetch > _profileLifespan && _dispatchedAction == false) {
      _dispatchedAction = true;
      PylonsComponent.instance.getProfile([
        (prf) {
          _timeSinceLastProfileFetch = 0;
          _dispatchedAction = false;
          nameNotifier.updateName(prf?.username != null ? prf!.username : "ERROR");
          return;
        }
      ]);
    } else {
      _timeSinceLastProfileFetch += dt;
    }
  }
}