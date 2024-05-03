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

    ///* pylo1vn4p3v0u7l3c6jqup5j8fmhxnfumzl2094gtrc

    var cookBook = Cookbook(
      creator: "pylo1vn4p3v0u7l3c6jqup5j8fmhxnfumzl2094gtrc",
      id: "demoGameCookbook",
      name: "demo game cook book guide",
      description: "this is guide purpose demo game guide for the developer",
      developer: "Ahsan Ali",
      version: "v0.0.1",
      supportEmail: "support@pylons.tech",
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
