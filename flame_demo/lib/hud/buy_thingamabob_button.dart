import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pylons_component.dart';
import '../recipe.dart';

class BuyThingamabobButton extends StatelessWidget {
  const BuyThingamabobButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: PylonsComponent.instance.ready && recipeGetThingamabob.executeCheck(Provider.of<GameStateNotifier>(context)) ? () {
      PylonsComponent.instance.executeRecipe(recipeGetThingamabob.sdkRecipe, [], [
            (exec) {
          gameStateNotifier.updateThingamabob(true);
          gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 10);
        }
      ]);
    } : null, child: PylonsComponent.instance.ready && recipeGetThingamabob.executeCheck(Provider.of<GameStateNotifier>(context, listen: false)) ?
    Row(children: [
      Expanded(child: Image.asset("assets/images/spinning_wheel.png", height: 50)),
      const Expanded(child: Text("Buy a Thingamabob (10 whatsits)", style: TextStyle(fontSize: 16)))
    ]) : null);
  }
}