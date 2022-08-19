import 'dart:convert';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_stripe_account_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/execute_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_execution_by_id_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_execution_by_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_item_by_id_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_list_by_owner_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_profile_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_recipes_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_trades_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_recipe_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';

class HandlerFactory {
  static const String GO_TO_PYLONS = 'goToPylons';
  static const String GET_COOKBOOK = 'getCookbook';
  static const String GET_PROFILE = 'getProfile';
  static const String GET_RECIPES = 'getRecipes';
  static const String GET_RECIPE = 'getRecipe';
  static const String GET_EXECUTION_BY_RECIPE_ID = 'getExecutionByRecipeId';
  static const String GET_TRADES = 'getTrades';
  static const String SHOW_STRIPE = 'showStripe';
  static const String GET_ITEM_BY_ID = 'getItemById';
  static const String GET_ITEMS_BY_OWNER = 'getItemsByOwner';
  static const String GET_EXECUTION_BY_ID = 'getExecutionById';
  static const String TX_BUY_ITEMS = 'txBuyItem';
  static const String TX_BUY_PYLONS = 'txBuyPylons';
  static const String TX_CREATE_COOKBOOK = 'txCreateCookbook';
  static const String TX_CREATE_RECIPE = 'txCreateRecipe';
  static const String TX_UPDATE_COOKBOOK = 'txUpdateCookbook';
  static const String TX_UPDATE_RECIPE = 'txUpdateRecipe';
  static const String TX_EXECUTE_RECIPE = 'txExecuteRecipe';
  static const String TX_PLACE_FOR_SALE = 'txPlaceForSale';
  static const String ERR_NODE = 'node';
  static const String ERR_PROFILE_DOES_NOT_EXIST = 'profileDoesNotExist';
  static const String ERR_PAYMENT_NOT_VALID = 'paymentNotValid';
  static const String ERR_INSUFFICIENT_FUNDS = 'insufficientFunds';
  static const String ERR_COOKBOOK_ALREADY_EXISTS = 'cookbookAlreadyExists';
  static const String ERR_COOKBOOK_DOES_NOT_EXIST = 'cookbookDoesNotExist';
  static const String ERR_COOKBOOK_NOT_OWNED = 'cookbookNotOwned';
  static const String ERR_RECIPE_ALREADY_EXISTS = 'recipeAlreadyExists';
  static const String ERR_RECIPE_DOES_NOT_EXIST = 'recipeDoesNotExist';
  static const String ERR_RECIPE_NOT_OWNED = 'recipeNotOwned';
  static const String ERR_RECIPE_ALREADY_ENABLED = 'recipeAlreadyEnabled';
  static const String ERR_RECIPE_ALREADY_DISABLED = 'recipeAlreadyDisabled';
  static const String ERR_ITEM_DOES_NOT_EXIST = 'itemDoesNotExist';
  static const String ERR_ITEM_NOT_OWNED = 'itemNotOwned';
  static const String ERR_MISSING_ITEM_INPUTS = 'missingItemInputs';
  static const String ERR_SOMETHING_WENT_WRONG = 'somethingWentWrong';
  static const String ERR_USER_DECLINED = 'userDeclined';
  static const String ERR_FETCHING_WALLETS = 'walletsNotFetched';
  static const String ERR_CANNOT_FETCH_RECIPE = 'recipeCannotBeFetched';
  static const String ERR_SIG_TRANSACTION = 'errorSigningTransaction';
  static const String ERR_CANNOT_FETCH_USERNAME = 'cannotFetchUsername';
  static const String ERR_CANNOT_FETCH_RECIPES = 'cannotFetchRecipes';
  static const String ERR_CANNOT_FETCH_ITEM = 'cannotFetchItem';
  static const String ERR_CANNOT_FETCH_COOKBOOK = 'cannotFetchCookbook';
  static const String ERR_CANNOT_FETCH_TRADES = 'cannotFetchTrades';
  static const String COOKBOOK_ID = 'cookbookId';
  static const String OWNER_ADDRESS = 'ownerAddress';
  static const String RECIPE_ID = 'recipeId';
  static const String ITEM_ID = 'itemId';
  static const String EXECUTION_ID = 'executionId';
  static const String CREATOR = 'creator';

  BaseHandler getHandler(SdkIpcMessage sdkipcMessage) {
    final actionsHandler = <String, BaseHandler>{
      TX_CREATE_COOKBOOK: CreateCookbookHandler(sdkipcMessage),
      TX_UPDATE_COOKBOOK: UpdateCookbookHandler(sdkipcMessage),
      TX_CREATE_RECIPE: CreateRecipeHandler(sdkipcMessage),
      TX_EXECUTE_RECIPE: ExecuteRecipeHandler(sdkipcMessage),
      TX_UPDATE_RECIPE: UpdateRecipeHandler(sdkipcMessage),
      GET_PROFILE: GetProfileHandler(sdkipcMessage),
      GET_RECIPES: GetRecipesHandler(sdkipcMessage),
      GET_COOKBOOK: GetCookbookHandler(sdkipcMessage),
      GET_RECIPE: GetRecipeHandler(sdkipcMessage),
      GET_EXECUTION_BY_RECIPE_ID: GetExecutionByRecipe(sdkipcMessage),
      GET_ITEM_BY_ID: GetItemByIdHandler(sdkipcMessage),
      GET_ITEMS_BY_OWNER: GetItemsByOwnerHandler(sdkipcMessage),
      GET_EXECUTION_BY_ID: GetExecutionByIdHandler(sdkipcMessage),
      GET_TRADES: GetTradesHandler(sdkipcMessage),
      SHOW_STRIPE: CreateStripeAccountHandler(sdkipcMessage),
    };

    if (actionsHandler.containsKey(sdkipcMessage.action)) {
      return actionsHandler[sdkipcMessage.action]!;
    }

    throw "Corresponding Action Not Found";
  }
}

extension HandlerValues on BaseHandler {
  String getName() {
    final json = jsonDecode(sdkIpcMessage.json) as Map;
    if (json.keys.contains("name")) {
      return json["name"].toString();
    }
    return "";
  }
}
