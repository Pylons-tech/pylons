import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/hud/buy_doohickey_button.dart';
import 'package:pylons_flame_demo/hud/buy_hickey_button.dart';
import 'package:pylons_flame_demo/hud/buy_thingamabob_button.dart';
import 'package:pylons_flame_demo/hud/text_display.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_flame_demo/pylons_component.dart';
import 'package:pylons_flame_demo/recipe.dart';

import 'buy_doo_button.dart';

class Hud extends StatelessWidget {
  const Hud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = "${Provider.of<GameStateNotifier>(context).line2}\n"
        "${Provider.of<GameStateNotifier>(context).whatsits.toInt()}\n"
        "${thingamabobString(context)}";
    return Column(
      children: [
        TextDisplay(text: text),
        const BuyThingamabobButton(),
        const BuyDooButton(),
        const BuyHickeyButton(),
        const BuyDoohickeyButton()
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