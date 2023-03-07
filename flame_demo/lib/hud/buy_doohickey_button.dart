import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pylons_component.dart';
import '../recipe.dart';

class BuyDoohickeyButton extends StatelessWidget {
  const BuyDoohickeyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: PylonsComponent.instance.ready && recipeGetDoohickey.executeCheck(Provider.of<GameStateNotifier>(context)) ? () {
      PylonsComponent.instance.executeRecipe(recipeGetDoohickey.sdkRecipe,
          [Provider.of<GameStateNotifier>(context, listen: false).itemDoo!, Provider.of<GameStateNotifier>(context, listen: false).itemHickey!], [
            (exec) {
          gameStateNotifier.updateDoo(false);
          gameStateNotifier.updateHickey(false);
          gameStateNotifier.updateDoohickey(true);
          gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 60);
        }
      ]);
    } : null, child: PylonsComponent.instance.ready && recipeGetDoohickey.executeCheck(Provider.of<GameStateNotifier>(context, listen: false)) ?
    Row(children: [
      Expanded(child: Image.asset("assets/images/normal_Du_Temples_flying_machine.png", height: 50)),
      const Expanded(child: Text("Craft a Doohickey", style: TextStyle(fontSize: 16)))
    ]) : null);
  }
}