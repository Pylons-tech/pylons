import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'game.dart';
import 'hud/hud.dart';

class GameStateNotifier extends ChangeNotifier {
  String profileName = "Please wait";
  String line2 = "";
  bool initialized = false;
  bool hasThingamabob = false;
  bool hasDoo = false;
  bool hasHickey = false;
  bool hasDoohickey = false;
  Item? itemThingamabob;
  Item? itemDoo;
  Item? itemHickey;
  Item? itemDoohickey;
  int whatsits = 0;

  void updateInitialized () {
    initialized = true;
    notifyListeners();
  }

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

  void updateThingamabob (bool hasThingamabob, {Item? item}) {
    this.hasThingamabob = hasThingamabob;
    itemThingamabob = item;
    notifyListeners();
  }

  void updateDoo (bool hasDoo, {Item? item}) {
    this.hasDoo = hasDoo;
    itemDoo = item;
    notifyListeners();
  }

  void updateHickey (bool hasHickey, {Item? item}) {
    this.hasHickey = hasHickey;
    itemHickey = item;
    notifyListeners();
  }

  void updateDoohickey (bool hasDoohickey, {Item? item}) {
    this.hasDoohickey = hasDoohickey;
    itemDoohickey = item;
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