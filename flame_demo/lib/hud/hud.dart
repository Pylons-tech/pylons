import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/hud/loading.dart';
import 'package:pylons_flame_demo/hud/text_display.dart';
import 'package:pylons_flame_demo/hud/upgrade_button.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_flame_demo/recipe.dart';

import '../debug.dart';

const imagePathThingamabob = "assets/images/spinning_wheel.png";
const imagePathDoo = "assets/images/normal_lock.png";
const imagePathHickey = "assets/images/key_3.png";
const imagePathDoohickey = "assets/images/normal_Du_Temples_flying_machine.png";
const captionThingamabob = "Buy a Thingamabob (10 whatsits)";
const captionDoo = "Buy a Doo (70 whatsits)";
const captionHickey = "Buy a Hickey (60 whatsits)";
const captionDoohickey = "Craft a Doohickey";

class Hud extends StatelessWidget {
  const Hud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = "${Provider.of<GameStateNotifier>(context).line2}\n"
        "${Provider.of<GameStateNotifier>(context).whatsits.toInt()}";
    return SizedBox.expand(child: Provider.of<GameStateNotifier>(context, listen: false).initialized ? Column(
      children: [
        TextDisplay(text: text),
        UpgradeButton(recipe: recipeGetThingamabob, imagePath: imagePathThingamabob, caption: captionThingamabob, callback: () {
          gameStateNotifier.updateThingamabob(true);
          gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 10);
        }),
        UpgradeButton(recipe: recipeGetDoo, imagePath: imagePathDoo, caption: captionDoo, callback: () {
          gameStateNotifier.updateDoo(true);
          gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 60);
        }),
        UpgradeButton(recipe: recipeGetHickey, imagePath: imagePathHickey, caption: captionHickey, callback: () {
          gameStateNotifier.updateHickey(true);
          gameStateNotifier.updateWhatsits(Provider.of<GameStateNotifier>(context, listen: false).whatsits - 60);
        }),
        UpgradeButton(recipe: recipeGetDoohickey, imagePath: imagePathDoohickey, caption: captionDoohickey, callback: () {
          gameStateNotifier.updateDoo(false);
          gameStateNotifier.updateHickey(false);
          gameStateNotifier.updateDoohickey(true);
        }, itemFunc: () {
          if (Debug.isOfflineBuild) {
            return [];
          } else {
            return [Provider.of<GameStateNotifier>(context, listen: false).itemDoo!, Provider.of<GameStateNotifier>(context, listen: false).itemHickey!];
          }
        }),
        const Spacer(),
        Align(alignment: Alignment.bottomLeft, child: Row(
          children: [
            Provider.of<GameStateNotifier>(context, listen: false).hasThingamabob ? Image.asset(imagePathThingamabob, height: 70) : Container(),
            Provider.of<GameStateNotifier>(context, listen: false).hasDoo ? Image.asset(imagePathDoo, height: 70) : Container(),
            Provider.of<GameStateNotifier>(context, listen: false).hasHickey ? Image.asset(imagePathHickey, height: 70) : Container(),
            Provider.of<GameStateNotifier>(context, listen: false).hasDoohickey ? Image.asset(imagePathDoohickey, height: 70) : Container(),
          ],
        ))
      ],
    ) : const Loading());
  }
}