import 'package:flutter/foundation.dart';
import 'package:pylons_sdk/low_level.dart';
import 'package:fixnum/fixnum.dart';

class SdkProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  String cookBookId = "demo_game_cookbook";

  void increment() {
    _count++;
    notifyListeners();
  }

  ///* method for creating cookbook
  void createCookBook() async {
    ///* wallet address
    var cookBook = Cookbook(
      creator: cookBookId,
      id: "demoGameCookbook",
      name: "demo game cook book guide",
      description: "this is guide purpose demo game guide for the developer",
      developer: "Ahsan Ali",
      version: "v0.0.1",
      supportEmail: "support@pylons.tech",
      enabled: true,
    );

    /// From there we can use response.success to see if our cookbook creation was successful!
    /// Note that a cookbook can only be created once, so be sure to add the proper code logic to keep this action from happening more than once!

    var response = await PylonsWallet.instance.txCreateCookbook(cookBook);

    print(response);
  }

  ///* method for creating recipe
  void createRecipe() async{
    var recipe = Recipe(
      cookbookId: cookBookId,
      id: "recipeId",
      nodeVersion: Int64(),
      name: "free recipe",
      description: "this is free receipe",
      version: "v0.1.3",
      coinInputs: [
        CoinInput(),
      ],
      itemInputs: [],
      costPerBlock: Coin(denom: "upylon", amount: "0"),
      entries: EntriesList(),
      outputs: [],
      blockInterval: Int64(0),
      enabled: false,
      extraInfo: "extraInfo",
    );

    var response = await PylonsWallet.instance.txCreateRecipe(recipe);

    print(response);
  }

  ///* method for creating transaction
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
