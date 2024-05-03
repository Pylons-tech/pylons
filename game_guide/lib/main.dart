import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_guide/game.dart';
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

class SdkProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void createCookBook() {
    print("createCookBook");
  }

  void createRecipe() {
    print("createRecipe");
  }

  void createTransaction() {
    print("createTransaction");
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
