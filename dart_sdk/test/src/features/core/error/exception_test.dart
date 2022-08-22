import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should create cookbook not owned exception ', () {
    var cookbookNotOwnedException = CookbookNotOwnedException(
        MOCK_COOKBOOK_ID, MOCK_RECIPE_ID, MOCK_ERR_CODE);
    expect(MOCK_COOKBOOK_ID, cookbookNotOwnedException.cookbook);
    expect(MOCK_RECIPE_ID, cookbookNotOwnedException.cbSender);
    expect(MOCK_ERR_CODE, cookbookNotOwnedException.errMsg);
  });

  test('should create cookbook not owned exception ', () {
    var itemDoesntExists = ItemDoesNotExistException(
      MOCK_ITEM_ID,
      MOCK_ERR_CODE,
    );
    expect(MOCK_ITEM_ID, itemDoesntExists.item);
    expect(MOCK_ERR_CODE, itemDoesntExists.errMsg);
  });

  test('should create recipe doesnt exists exception ', () {
    var recipeDoesntExists = RecipeDoesNotExistException(
        MOCK_COOKBOOK_ID, MOCK_RECIPE_NAME, MOCK_ERR_CODE);
    expect(MOCK_COOKBOOK_ID, recipeDoesntExists.cookbook);
    expect(MOCK_RECIPE_NAME, recipeDoesntExists.recipeName);
    expect(true, recipeDoesntExists.recipeId.isEmpty);
    expect(MOCK_ERR_CODE, recipeDoesntExists.errMsg);
  });

  test('should create recipe state exception exception ', () {
    var recipeDoesntExists = RecipeStateException(
        MOCK_COOKBOOK_ID, MOCK_RECIPE_NAME, MOCK_RECIPE_ID, MOCK_ERR_CODE);
    expect(MOCK_COOKBOOK_ID, recipeDoesntExists.cookbook);
    expect(MOCK_RECIPE_NAME, recipeDoesntExists.recipeName);
    expect(MOCK_RECIPE_ID, recipeDoesntExists.recipeId);
    expect(MOCK_ERR_CODE, recipeDoesntExists.errMsg);
  });

  test('should create response exception', () {
    var responseException = ResponseException('', MOCK_ERR_CODE);
    expect(responseException.errMsg, MOCK_ERR_CODE);
  });

  test('should create wallet initialization not done error', () {
    var responseException = WalletInitializationNotDone(MOCK_ERR_CODE);
    expect(responseException.errMsg, MOCK_ERR_CODE);
  });
}
