import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_guide/game.dart';
import 'package:game_guide/sdk_provider.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  PylonsWallet.setup(mode: PylonsMode.prod, host: 'game_guide');
  // runApp(const MyApp());

  final myGame = RouterGame();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SdkProvider()),
      ],
      child: GameWidget(
        game: myGame,
        backgroundBuilder: (context) => Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
  );
}

