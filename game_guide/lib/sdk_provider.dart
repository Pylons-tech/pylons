
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

    try {
      var response = await PylonsWallet.instance.txCreateCookbook(cookBook);

      print(response);

      print("createCookBook");
    } catch (_) {
      print(_);
    }
  }

  ///* method for creating recipe
  void createRecipe() {
    var recipe = Recipe(
        cookbookId: cookBookId,
        id: "recipeId",
        nodeVersion: Int64(),
        name: "LOUD's Wooden sword lv1 buy recipe",
        description: "this recipe is used to buy wooden sword lv1.",
        version: "v0.1.3",
        coinInputs: [],
        itemInputs: [],
        costPerBlock: Coin(denom: "upylon", amount: "1000000"),
        entries: EntriesList(coinOutputs: [], itemOutputs: [
          ItemOutput(
            id: "copper_sword_lv1",
            doubles: [],
            longs: [],
            strings: [],
            mutableStrings: [],
            transferFee: [],
            tradePercentage: DecString.decStringFromDouble(0.1),
            tradeable: true,
          ),
        ], itemModifyOutputs: []),
        outputs: [
          WeightedOutputs(entryIds: ["copper_sword_lv1"], weight: Int64(1))
        ],
        blockInterval: Int64(0),
        enabled: false,
        extraInfo: "extraInfo");



    print("createRecipe");
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
