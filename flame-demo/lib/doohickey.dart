import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/game.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_flame_demo/pylons_component.dart';
import 'package:pylons_flame_demo/recipe.dart';

class Doohickey extends PositionComponent with TapCallbacks {
  Doohickey() : super(size: Vector2(80, 60));
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
          hudNotifier.updateName(prf?.username != null ? prf!.username : "ERROR");
          return;
        }
      ]);
    } else {
      _timeSinceLastProfileFetch += dt;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    final hit = children
        .whereType<PositionComponent>()
        .where(
          (component) => component.containsLocalPoint(
        position - component.position,
      ),
    ).toList();
    if (hit.isEmpty) return;
    if (_dispatchedAction == false && PylonsComponent.instance.lastProfile != null) {
      _dispatchedAction = true;
      if (recipeGet10Whatsits.executeCheck(Provider.of<GameStateNotifier>(game.buildContext!))) {
        PylonsComponent.instance.executeRecipe(recipeGet10Whatsits.sdkRecipe, [], [
              (exec) {
            _dispatchedAction = false;
            hudNotifier.updateLine2("Got 10 whatsits!");
            hudNotifier.updateWhatsits(Provider.of<GameStateNotifier>(game.buildContext!).whatsits + 10);
          }
        ]);
      } else {
        PylonsComponent.instance.executeRecipe(recipeGetWhatsit.sdkRecipe, [], [
              (exec) {
            _dispatchedAction = false;
            hudNotifier.updateLine2("Got 1 whatsit!");
            hudNotifier.updateWhatsits(Provider.of<GameStateNotifier>(game.buildContext!).whatsits + 1);
          }
        ]);
      }
    }
  }
}