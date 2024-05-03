import 'package:flutter/foundation.dart';
import 'package:pylons_sdk/low_level.dart';

class SdkProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  String cookBookId = "demo_game_cookbook${DateTime.now()}";

  void increment() {
    _count++;
    notifyListeners();
  }

  void createCookBook() async {
    var cookBook = Cookbook(
      creator: "",
      id: cookBookId,
      name: "demo game cook book",
      description: "this is guide purpose demo game guide",
      developer: "ABC",
      version: "v0.0.1",
      supportEmail: "abc@yopmail.com",
      enabled: true,
    );

    try {
      var response = await PylonsWallet.instance.txCreateCookbook(cookBook);

      print(response);

      print("createCookBook");
    } catch (_) {
      print(_);
    }
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
