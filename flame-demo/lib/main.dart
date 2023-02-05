import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'game.dart';
import 'hud.dart';

class GameStateNotifier extends ChangeNotifier {
  String profileName = "Please wait";
  String line2 = "Tap screen once \nprofile is retrieved";
  bool hasThingamabob = false;
  int whatsits = 0;

  void updateName (String name) {
    profileName = name;
    notifyListeners();
  }

  void updateLine2 (String line) {
    line2 = line;
    notifyListeners();
  }

  void updateWhatsits (int whatsits) {
    this.whatsits = whatsits;
    notifyListeners();
  }

  void updateThingamabob (bool hasThingamabob) {
    this.hasThingamabob = hasThingamabob;
    notifyListeners();
  }
}

late GameStateNotifier hudNotifier;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PylonsWallet.setup(mode: PylonsMode.prod, host: 'testapp_flutter');
  hudNotifier = GameStateNotifier();
  final game = PylonsGame();
  runApp(GameWidget(
    game: game,
    overlayBuilderMap: {
      'HudOverlay': (BuildContext context, PylonsGame game) {
        return ChangeNotifierProvider.value(value: hudNotifier, child: const Hud());
      }
    },
    initialActiveOverlays: const ["HudOverlay"],
  ));
}