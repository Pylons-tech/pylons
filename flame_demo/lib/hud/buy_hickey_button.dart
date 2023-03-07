import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pylons_component.dart';
import '../recipe.dart';

class BuyHickeyButton extends StatelessWidget {
  const BuyHickeyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: PylonsComponent.instance.ready && recipeGetHickey.executeCheck(Provider.of<GameStateNotifier>(context)) ? () {
      PylonsComponent.instance.executeRecipe(recipeGetHickey.sdkRecipe, [], [
            (exec) {
          gameStateNotifier.updateHickey(true);
          gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 60);
        }
      ]);
    } : null, child: PylonsComponent.instance.ready && recipeGetHickey.executeCheck(Provider.of<GameStateNotifier>(context, listen: false)) ?
    Row(children: [
      Expanded(child: Image.asset("assets/images/key_3.png", height: 50)),
      const Expanded(child: Text("Buy a Hickey (60 whatsits)", style: TextStyle(fontSize: 16)))
    ]) : null);
  }
}