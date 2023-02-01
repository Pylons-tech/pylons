import 'package:dartz/dartz.dart';
import 'package:pylons_sdk/pylons_sdk.dart' as sdk;

/// Helper class that bundles a SDK recipe w/ a function we can run to check if we can execute it.
class Recipe {
  final sdk.Recipe sdkRecipe;
  final Function1<void, bool> executeCheck;

  Recipe(this.sdkRecipe, this.executeCheck);
}

final recipeGetCharacter = Recipe(sdk.Recipe.let("RecipeTestAppGetCharacter"), (_) {
  return true; // no conditions on executing this
});