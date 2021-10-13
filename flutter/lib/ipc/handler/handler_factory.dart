import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cook_book_handler.dart';


class HandlerFactory {

  static const String GET_COOKBOOKS = 'getCookbooks';
  static const String GET_PROFILE = 'getProfile';
  static const String GET_RECIPE = 'getRecipes';
  static const String GET_TRADES = 'getTrades';
  static const String TX_BUY_ITEMS = 'txBuyItem';
  static const String TX_BUY_PYLONS = 'txBuyPylons';
  static const String TX_CREATE_COOKBOOK = 'txCreateCookbook';
  static const String TX_CREATE_RECIPE = 'txCreateRecipe';
  static const String TX_UPDATE_COOKBOOK = 'txUpdateCookbook';
  static const String TX_UPDATE_RECIPE = 'txUpdateRecipe';
  static const String TX_ENABLE_RECIPE = 'txEnableRecipe';
  static const String TX_DISABLE_RECIPE = 'txDisableRecipe';
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






  BaseHandler getHandler(List<String> message) {


    final key = message[1];

    if(key == TX_CREATE_COOKBOOK){
      return CreateCookBookHandler(message);
    }



    return CreateCookBookHandler([]);
  }
}
