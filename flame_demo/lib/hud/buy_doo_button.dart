import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pylons_component.dart';
import '../recipe.dart';

class BuyDooButton extends StatelessWidget {
  const BuyDooButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: PylonsComponent.instance.ready && recipeGetDoo.executeCheck(Provider.of<GameStateNotifier>(context)) ? () {
      PylonsComponent.instance.executeRecipe(recipeGetDoo.sdkRecipe, [], [
            (exec) {
          gameStateNotifier.updateDoo(true);
          gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 60);
        }
      ]);
    } : null, child: PylonsComponent.instance.ready && recipeGetDoo.executeCheck(Provider.of<GameStateNotifier>(context, listen: false)) ?
    Row(children: [
      Expanded(child: Image.asset("assets/images/normal_lock.png", height: 50)),
      const Expanded(child: Text("Buy a Doo (70 whatsits)", style: TextStyle(fontSize: 16)))
    ]) : null);
  }
}