import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'hud.dart';

class NameNotifier extends ChangeNotifier {
  String profileName = "???";

  void updateName (String name) {
    profileName = name;
    notifyListeners();
  }
}

late NameNotifier nameNotifier;

void main() {
  nameNotifier = NameNotifier();
  final game = PylonsGame();
  runApp(GameWidget(
    game: game,
    overlayBuilderMap: {
      'HudOverlay': (BuildContext context, PylonsGame game) {
        return const Hud();
      }
    },
    initialActiveOverlays: const ["HudOverlay"],
  ));
}