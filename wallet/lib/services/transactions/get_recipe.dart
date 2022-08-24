import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pylons_wallet/model/recipe_json.dart';
import 'package:pylons_wallet/utils/base_env.dart';

class GetRecipe {
  BaseEnv baseEnv;

  GetRecipe(this.baseEnv);

  Future<Either<Exception, RecipeJson>> getRecipe(
      String cookbookID, String recipeID) async {
    try {
      final uri = Uri.parse(
        "${baseEnv.baseApiUrl}/pylons/recipe/$cookbookID/$recipeID",
      );
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final recipeMap = jsonDecode(response.body) as Map<String, dynamic>;
        final recipeJson = RecipeJson.fromJson(recipeMap);
        return Right(recipeJson);
      }

      return Left(Exception(response.reasonPhrase));
    } catch (error) {
      return Left(Exception(error.toString()));
    }
  }

  Future<Either<Exception, List<RecipeJson>>> getRecipes() async {
    try {
      final uri = Uri.parse(
        "${baseEnv.baseApiUrl}/pylons/recipes/",
      );
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final list = jsonDecode(response.body) as Map<String, dynamic>;
        final recipes = list["Recipes"] as List;
        final recipeJsons = <RecipeJson>[];
        for (final element in recipes) {
          recipeJsons.add(RecipeJson.fromJson({'Recipe': element}));
        }

        return Right(recipeJsons);
      }

      return Left(Exception(response.reasonPhrase));
    } catch (error) {
      return Left(Exception(error.toString()));
    }
  }
}
