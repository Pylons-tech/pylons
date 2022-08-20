import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';

import '../../../pylons_sdk.dart';

class ValidateRecipe {
  /// Verifies that all of a recipe's outputs are accessible, and that it
  /// doesn't refer to any outputs that are not present.
  static void validate(Recipe recipe) {
    if (recipe.name.length <= kRecipeNameLength) {
      throwError(recipe, 'Recipe name should have more than 8 characters');
    }

    if (recipe.cookbookId.isEmpty) {
      throwError(recipe, 'Invalid CookbookId');
    }

    if (recipe.id.isEmpty) {
      throwError(recipe, 'Invalid Recipe ID');
    }

    if (recipe.itemInputs
        .where((recipe) => recipe.id.isEmpty)
        .toList()
        .isNotEmpty) {
      throwError(recipe, 'Invalid Item ID');
    }

    if (costPerBlockIsEmpty(recipe)) {
      throwError(recipe, 'Cost Per Block is Empty');
    }

    var found = <String>[];
    var reFound = <String>[];
    var orphanOutputs = <String>[];
    var unknownOutputs = <String>[];
    for (var output in recipe.outputs) {
      for (var entry in output.entryIds) {
        if (!found.contains(entry)) found.add(entry);
      }
    }
    for (var entryId in found) {
      for (var output in recipe.entries.coinOutputs) {
        if (found.contains(output.id) && !reFound.contains(output.id)) {
          reFound.add(output.id);
        } else {
          orphanOutputs.add(output.id);
        }
      }
      for (var output in recipe.entries.itemOutputs) {
        if (found.contains(output.id) && !reFound.contains(output.id)) {
          reFound.add(output.id);
        } else {
          orphanOutputs.add(output.id);
        }
      }
      if (!reFound.contains(entryId)) unknownOutputs.add(entryId);
    }
    if (unknownOutputs.isNotEmpty || orphanOutputs.isNotEmpty) {
      throw RecipeValidationException(
          recipe.cookbookId,
          recipe.name,
          recipe.id,
          'Recipe validation failed\nUnknown entry ids:\n\n'
          '${const JsonEncoder().convert(unknownOutputs)}\n\n'
          'Orphaned entries:\n\n'
          '${const JsonEncoder().convert(orphanOutputs)}');
    }
  }

  static bool costPerBlockIsEmpty(Recipe recipe) =>
      !(recipe.costPerBlock.hasAmount() && recipe.costPerBlock.hasDenom());

  static void throwError(Recipe recipe, String error) {
    throw RecipeValidationException(
        recipe.cookbookId, recipe.name, recipe.id, error);
  }
}
