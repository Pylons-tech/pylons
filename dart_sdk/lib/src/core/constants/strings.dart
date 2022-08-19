/// Contains string constants.
///
/// TODO: should these be split into multiple classes based on usage?
class Strings {
  static const String GO_TO_PYLONS = 'goToPylons';
  static const String GET_COOKBOOK = 'getCookbook';
  static const String GET_PROFILE = 'getProfile';
  static const String GET_RECIPES = 'getRecipes';
  static const String GET_RECIPE = 'getRecipe';
  static const String GET_TRADES = 'getTrades';
  static const String GET_EXECUTION_BY_RECIPE_ID = 'getExecutionByRecipeId';
  static const String GET_EXECUTION_BY_ID = 'getExecutionById';
  static const String GET_ITEMS_BY_OWNER = 'getItemsByOwner';
  static const String GET_ITEM_BY_ID = 'getItemById';
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
  static const String ERR_MALFORMED_RECIPES = 'malformedRecipes';
  static const String ERR_MALFORMED_RECIPE = 'malformedRecipe';
  static const String ERR_MALFORMED_USER_INFO = 'malformedUserInfo';
  static const String ERR_MALFORMED_EXECUTION = 'malformedExecution';
  static const String ERR_MALFORMED_ITEM = 'malformedItem';
  static const String ERR_JSON_EXPECTED = 'Json Object Expected';
  static const String ERR_MALFORMED_COOKBOOK = 'malformedCookbook';
  static const String ERR_MALFORMED_ITEMS_LIST = 'malformedItemsList';
  static const String ERR_MALFORMED_TRADES = 'malformedTrades';
  static const String COOKBOOK_ID = 'cookbookId';
  static const String RECIPE_ID = 'recipeId';
  static const String ITEM_ID = 'itemId';
  static const String VERSION = 'version';
  static const String OWNER_ADDRESS = 'ownerAddress';
  static const String EXECUTION_ID = 'executionId';
  static const String CREATOR = 'creator';
  static const String ACTION_DONE = 'Message Dispatched';
  static const String SHOW_STRIPE = 'showStripe';
}

const kRecipeNameLength = 8;

const kRecipeDescriptionLength = 20;

const kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=tech.pylons.wallet';
const kAppStoreUrl = 'https://apps.apple.com/app/1598732789';
