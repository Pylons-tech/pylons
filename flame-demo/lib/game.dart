import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:pylons_flame_demo/pylons_component.dart';

class PylonsGame extends FlameGame{
  @override
  Future<void> onLoad() async {
    add(
      PylonsComponent()
    );
  }
}