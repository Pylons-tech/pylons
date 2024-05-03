import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  PylonsWallet.setup(mode: PylonsMode.prod, host: 'game_guide');
  // runApp(const MyApp());

  final game = FlameGame();
  runApp(GameWidget(game: game));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Placeholder(),
    );
  }
}
