import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart';
import 'package:pylons_sdk/pylons_sdk.dart' hide Recipe;

import '../main.dart';
import '../pylons_component.dart';
import '../recipe.dart';

List<Item> _dummyCb () => [];

class UpgradeButton extends StatelessWidget {
  const UpgradeButton({Key? key, required this.recipe, required this.imagePath, required this.caption, required this.callback, this.itemFunc = _dummyCb}) : super(key: key);

  final Recipe recipe;
  final String imagePath;
  final String caption;
  final Function callback;
  final Function0<List<Item>> itemFunc;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: PylonsComponent.instance.ready && recipe.executeCheck(Provider.of<GameStateNotifier>(context)) ? () {
      PylonsComponent.instance.executeRecipe(recipe.sdkRecipe, itemFunc(), [
            (exec) { callback(); }
      ]);
    } : null, child: PylonsComponent.instance.ready && recipe.executeCheck(Provider.of<GameStateNotifier>(context, listen: false)) ?
    Container(color: Colors.grey, child:Row(children: [
      Expanded(child: Image.asset(imagePath, height: 70)),
      Expanded(child: Text(caption, style: const TextStyle(fontSize: 16, color:  Colors.white)))
    ]) ): null);
  }
}