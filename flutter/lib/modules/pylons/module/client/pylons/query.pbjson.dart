///
//  Generated code. Do not modify.
//  source: pylons/query.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const AddrFromPubKeyRequest$json = const {
  '1': 'AddrFromPubKeyRequest',
  '2': const [
    const {'1': 'hex_pub_key', '3': 1, '4': 1, '5': 9, '10': 'hexPubKey'},
  ],
};

const AddrFromPubKeyResponse$json = const {
  '1': 'AddrFromPubKeyResponse',
  '2': const [
    const {'1': 'Bech32Addr', '3': 1, '4': 1, '5': 9, '10': 'Bech32Addr'},
  ],
};

const CheckGoogleIAPOrderRequest$json = const {
  '1': 'CheckGoogleIAPOrderRequest',
  '2': const [
    const {'1': 'purchaseToken', '3': 1, '4': 1, '5': 9, '10': 'purchaseToken'},
  ],
};

const CheckGoogleIAPOrderResponse$json = const {
  '1': 'CheckGoogleIAPOrderResponse',
  '2': const [
    const {'1': 'purchaseToken', '3': 1, '4': 1, '5': 9, '10': 'purchaseToken'},
    const {'1': 'exist', '3': 2, '4': 1, '5': 8, '10': 'exist'},
  ],
};

const GetCookbookRequest$json = const {
  '1': 'GetCookbookRequest',
  '2': const [
    const {'1': 'cookbookID', '3': 1, '4': 1, '5': 9, '10': 'cookbookID'},
  ],
};

const GetCookbookResponse$json = const {
  '1': 'GetCookbookResponse',
  '2': const [
    const {'1': 'NodeVersion', '3': 1, '4': 1, '5': 9, '10': 'NodeVersion'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'Name', '3': 3, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'Description', '3': 4, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'Version', '3': 5, '4': 1, '5': 9, '10': 'Version'},
    const {'1': 'Developer', '3': 6, '4': 1, '5': 9, '10': 'Developer'},
    const {'1': 'Level', '3': 7, '4': 1, '5': 3, '10': 'Level'},
    const {'1': 'SupportEmail', '3': 8, '4': 1, '5': 9, '10': 'SupportEmail'},
    const {'1': 'CostPerBlock', '3': 9, '4': 1, '5': 3, '10': 'CostPerBlock'},
    const {'1': 'Sender', '3': 10, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const GetExecutionRequest$json = const {
  '1': 'GetExecutionRequest',
  '2': const [
    const {'1': 'executionID', '3': 1, '4': 1, '5': 9, '10': 'executionID'},
  ],
};

const GetExecutionResponse$json = const {
  '1': 'GetExecutionResponse',
  '2': const [
    const {'1': 'NodeVersion', '3': 1, '4': 1, '5': 9, '10': 'NodeVersion'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'RecipeID', '3': 3, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'CookbookID', '3': 4, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'CoinsInput', '3': 5, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'CoinsInput'},
    const {'1': 'ItemInputs', '3': 6, '4': 3, '5': 11, '6': '.pylons.Item', '8': const {}, '10': 'ItemInputs'},
    const {'1': 'BlockHeight', '3': 7, '4': 1, '5': 3, '10': 'BlockHeight'},
    const {'1': 'Sender', '3': 8, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Completed', '3': 9, '4': 1, '5': 8, '10': 'Completed'},
  ],
};

const GetItemRequest$json = const {
  '1': 'GetItemRequest',
  '2': const [
    const {'1': 'itemID', '3': 1, '4': 1, '5': 9, '10': 'itemID'},
  ],
};

const GetItemResponse$json = const {
  '1': 'GetItemResponse',
  '2': const [
    const {'1': 'item', '3': 1, '4': 1, '5': 11, '6': '.pylons.Item', '8': const {}, '10': 'item'},
  ],
};

const GetRecipeRequest$json = const {
  '1': 'GetRecipeRequest',
  '2': const [
    const {'1': 'recipeID', '3': 1, '4': 1, '5': 9, '10': 'recipeID'},
  ],
};

const GetRecipeResponse$json = const {
  '1': 'GetRecipeResponse',
  '2': const [
    const {'1': 'NodeVersion', '3': 1, '4': 1, '5': 9, '10': 'NodeVersion'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'CookbookID', '3': 3, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'Name', '3': 4, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'CoinInputs', '3': 5, '4': 3, '5': 11, '6': '.pylons.CoinInput', '8': const {}, '10': 'CoinInputs'},
    const {'1': 'ItemInputs', '3': 6, '4': 3, '5': 11, '6': '.pylons.ItemInput', '8': const {}, '10': 'ItemInputs'},
    const {'1': 'Entries', '3': 7, '4': 1, '5': 11, '6': '.pylons.EntriesList', '8': const {}, '10': 'Entries'},
    const {'1': 'Outputs', '3': 8, '4': 3, '5': 11, '6': '.pylons.WeightedOutputs', '8': const {}, '10': 'Outputs'},
    const {'1': 'Description', '3': 9, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'BlockInterval', '3': 10, '4': 1, '5': 3, '10': 'BlockInterval'},
    const {'1': 'Sender', '3': 11, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Disabled', '3': 12, '4': 1, '5': 8, '10': 'Disabled'},
  ],
};

const GetTradeRequest$json = const {
  '1': 'GetTradeRequest',
  '2': const [
    const {'1': 'tradeID', '3': 1, '4': 1, '5': 9, '10': 'tradeID'},
  ],
};

const GetTradeResponse$json = const {
  '1': 'GetTradeResponse',
  '2': const [
    const {'1': 'NodeVersion', '3': 1, '4': 1, '5': 9, '10': 'NodeVersion'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'CoinInputs', '3': 3, '4': 3, '5': 11, '6': '.pylons.CoinInput', '8': const {}, '10': 'CoinInputs'},
    const {'1': 'ItemInputs', '3': 4, '4': 3, '5': 11, '6': '.pylons.TradeItemInput', '8': const {}, '10': 'ItemInputs'},
    const {'1': 'CoinOutputs', '3': 5, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'CoinOutputs'},
    const {'1': 'ItemOutputs', '3': 6, '4': 3, '5': 11, '6': '.pylons.Item', '8': const {}, '10': 'ItemOutputs'},
    const {'1': 'ExtraInfo', '3': 7, '4': 1, '5': 9, '10': 'ExtraInfo'},
    const {'1': 'Sender', '3': 8, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'FulFiller', '3': 9, '4': 1, '5': 9, '10': 'FulFiller'},
    const {'1': 'Disabled', '3': 10, '4': 1, '5': 8, '10': 'Disabled'},
    const {'1': 'Completed', '3': 11, '4': 1, '5': 8, '10': 'Completed'},
  ],
};

const ItemsByCookbookRequest$json = const {
  '1': 'ItemsByCookbookRequest',
  '2': const [
    const {'1': 'cookbookID', '3': 1, '4': 1, '5': 9, '10': 'cookbookID'},
  ],
};

const ItemsByCookbookResponse$json = const {
  '1': 'ItemsByCookbookResponse',
  '2': const [
    const {'1': 'Items', '3': 1, '4': 3, '5': 11, '6': '.pylons.Item', '8': const {}, '10': 'Items'},
  ],
};

const ItemsBySenderRequest$json = const {
  '1': 'ItemsBySenderRequest',
  '2': const [
    const {'1': 'sender', '3': 1, '4': 1, '5': 9, '10': 'sender'},
  ],
};

const ItemsBySenderResponse$json = const {
  '1': 'ItemsBySenderResponse',
  '2': const [
    const {'1': 'Items', '3': 1, '4': 3, '5': 11, '6': '.pylons.Item', '8': const {}, '10': 'Items'},
  ],
};

const ListCookbookRequest$json = const {
  '1': 'ListCookbookRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const ListCookbookResponse$json = const {
  '1': 'ListCookbookResponse',
  '2': const [
    const {'1': 'Cookbooks', '3': 1, '4': 3, '5': 11, '6': '.pylons.Cookbook', '8': const {}, '10': 'Cookbooks'},
  ],
};

const ListExecutionsRequest$json = const {
  '1': 'ListExecutionsRequest',
  '2': const [
    const {'1': 'sender', '3': 1, '4': 1, '5': 9, '10': 'sender'},
  ],
};

const ListExecutionsResponse$json = const {
  '1': 'ListExecutionsResponse',
  '2': const [
    const {'1': 'Executions', '3': 1, '4': 3, '5': 11, '6': '.pylons.Execution', '8': const {}, '10': 'Executions'},
  ],
};

const GetLockedCoinsRequest$json = const {
  '1': 'GetLockedCoinsRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const GetLockedCoinsResponse$json = const {
  '1': 'GetLockedCoinsResponse',
  '2': const [
    const {'1': 'NodeVersion', '3': 1, '4': 1, '5': 9, '10': 'NodeVersion'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Amount', '3': 3, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'Amount'},
  ],
};

const GetLockedCoinDetailsRequest$json = const {
  '1': 'GetLockedCoinDetailsRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const GetLockedCoinDetailsResponse$json = const {
  '1': 'GetLockedCoinDetailsResponse',
  '2': const [
    const {'1': 'sender', '3': 1, '4': 1, '5': 9, '10': 'sender'},
    const {'1': 'Amount', '3': 2, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'Amount'},
    const {'1': 'LockCoinTrades', '3': 3, '4': 3, '5': 11, '6': '.pylons.LockedCoinDescribe', '8': const {}, '10': 'LockCoinTrades'},
    const {'1': 'LockCoinExecs', '3': 4, '4': 3, '5': 11, '6': '.pylons.LockedCoinDescribe', '8': const {}, '10': 'LockCoinExecs'},
  ],
};

const ListRecipeRequest$json = const {
  '1': 'ListRecipeRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const ListRecipeResponse$json = const {
  '1': 'ListRecipeResponse',
  '2': const [
    const {'1': 'recipes', '3': 1, '4': 3, '5': 11, '6': '.pylons.Recipe', '8': const {}, '10': 'recipes'},
  ],
};

const ListRecipeByCookbookRequest$json = const {
  '1': 'ListRecipeByCookbookRequest',
  '2': const [
    const {'1': 'cookbookID', '3': 1, '4': 1, '5': 9, '10': 'cookbookID'},
  ],
};

const ListRecipeByCookbookResponse$json = const {
  '1': 'ListRecipeByCookbookResponse',
  '2': const [
    const {'1': 'recipes', '3': 1, '4': 3, '5': 11, '6': '.pylons.Recipe', '8': const {}, '10': 'recipes'},
  ],
};

const ListShortenRecipeRequest$json = const {
  '1': 'ListShortenRecipeRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const ListShortenRecipeResponse$json = const {
  '1': 'ListShortenRecipeResponse',
  '2': const [
    const {'1': 'recipes', '3': 1, '4': 3, '5': 11, '6': '.pylons.ShortenRecipe', '8': const {}, '10': 'recipes'},
  ],
};

const ListShortenRecipeByCookbookRequest$json = const {
  '1': 'ListShortenRecipeByCookbookRequest',
  '2': const [
    const {'1': 'cookbookID', '3': 1, '4': 1, '5': 9, '10': 'cookbookID'},
  ],
};

const ListShortenRecipeByCookbookResponse$json = const {
  '1': 'ListShortenRecipeByCookbookResponse',
  '2': const [
    const {'1': 'recipes', '3': 1, '4': 3, '5': 11, '6': '.pylons.ShortenRecipe', '8': const {}, '10': 'recipes'},
  ],
};

const ListTradeRequest$json = const {
  '1': 'ListTradeRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const ListTradeResponse$json = const {
  '1': 'ListTradeResponse',
  '2': const [
    const {'1': 'trades', '3': 1, '4': 3, '5': 11, '6': '.pylons.Trade', '8': const {}, '10': 'trades'},
  ],
};

const PylonsBalanceRequest$json = const {
  '1': 'PylonsBalanceRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const PylonsBalanceResponse$json = const {
  '1': 'PylonsBalanceResponse',
  '2': const [
    const {'1': 'balance', '3': 1, '4': 1, '5': 3, '10': 'balance'},
  ],
};

