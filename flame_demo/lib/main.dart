import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'game.dart';
import 'hud/hud.dart';

class GameStateNotifier extends ChangeNotifier {
  String profileName = "Please wait";
  String line2 = "";
  bool hasThingamabob = false;
  bool hasDoo = false;
  bool hasHickey = false;
  bool hasDoohickey = false;
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

  void updateDoo (bool hasDoo) {
    this.hasDoo = hasDoo;
    notifyListeners();
  }

  void updateHickey (bool hasHickey) {
    this.hasHickey = hasHickey;
    notifyListeners();
  }

  void updateDoohickey (bool hasDoohickey) {
    this.hasDoohickey = hasDoohickey;
    notifyListeners();
  }
}

late GameStateNotifier gameStateNotifier;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PylonsWallet.setup(mode: PylonsMode.prod, host: 'testapp_flutter');
  gameStateNotifier = GameStateNotifier();
  final game = PylonsGame();
  runApp(ChangeNotifierProvider.value(value: gameStateNotifier, child: GameWidget(
    game: game,
    overlayBuilderMap: {
      'HudOverlay': (BuildContext context, PylonsGame game) {
        return const Hud();
      }
    },
    initialActiveOverlays: const ["HudOverlay"],
  )));
}