import 'package:dartz/dartz.dart';
import 'package:pylons_flame_demo/main.dart';
import 'package:pylons_sdk/pylons_sdk.dart' as sdk;

/// Helper class that bundles a SDK recipe w/ a function we can run to check if we can execute it.
class Recipe {
  final sdk.Recipe sdkRecipe;
  final Function1<GameStateNotifier, bool> executeCheck;

  Recipe(this.sdkRecipe, this.executeCheck);
}

late final Recipe recipeGetWhatsit;
late final Recipe recipeGet10Whatsits;
late final Recipe recipeGetThingamabob;