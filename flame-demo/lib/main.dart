import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'game.dart';
import 'hud.dart';

class NameNotifier extends ChangeNotifier {
  String profileName = "Please wait";

  void updateName (String name) {
    profileName = name;
    notifyListeners();
  }
}

late NameNotifier nameNotifier;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PylonsWallet.setup(mode: PylonsMode.prod, host: 'testapp_flutter');
  nameNotifier = NameNotifier();
  final game = PylonsGame();
  runApp(GameWidget(
    game: game,
    overlayBuilderMap: {
      'HudOverlay': (BuildContext context, PylonsGame game) {
        return ChangeNotifierProvider.value(value: nameNotifier, child: const Hud());
      }
    },
    initialActiveOverlays: const ["HudOverlay"],
  ));
}