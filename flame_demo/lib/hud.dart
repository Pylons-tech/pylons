import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_flame_demo/pylons_component.dart';
import 'package:pylons_flame_demo/recipe.dart';

class Hud extends StatelessWidget {
  const Hud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = "${Provider.of<GameStateNotifier>(context).line2}\n"
        "${Provider.of<GameStateNotifier>(context).whatsits.toInt()}\n"
        "${thingamabobString(context)}";
    return Column(
      children: [
        Text(text, style: const TextStyle(fontSize: 42)),
        MaterialButton(onPressed: PylonsComponent.instance.ready && recipeGetThingamabob.executeCheck(Provider.of<GameStateNotifier>(context)) ? () {
          PylonsComponent.instance.executeRecipe(recipeGetThingamabob.sdkRecipe, [], [
                (exec) {
              gameStateNotifier.updateThingamabob(true);
              gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 10);
            }
          ]);
        } : null, child: PylonsComponent.instance.ready && recipeGetThingamabob.executeCheck(Provider.of<GameStateNotifier>(context, listen: false)) ?
        Row(children: [
          Image.asset("assets/images/spinning_wheel.png", height: 40),
          const Text("Buy a Thingamabob (10 whatsits)", style: TextStyle(fontSize: 42))
        ]) : null)
      ],
    );
  }

  String thingamabobString (BuildContext context) {
    if (Provider.of<GameStateNotifier>(context).hasThingamabob) {
      return "Thingamabob acquired";
    } else {
      return "";
    }
  }
}