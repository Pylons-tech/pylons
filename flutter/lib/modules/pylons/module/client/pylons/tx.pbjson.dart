///
//  Generated code. Do not modify.
//  source: pylons/tx.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const MsgCheckExecution$json = const {
  '1': 'MsgCheckExecution',
  '2': const [
    const {'1': 'ExecID', '3': 1, '4': 1, '5': 9, '10': 'ExecID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'PayToComplete', '3': 3, '4': 1, '5': 8, '10': 'PayToComplete'},
  ],
};

const MsgCheckExecutionResponse$json = const {
  '1': 'MsgCheckExecutionResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
    const {'1': 'Output', '3': 3, '4': 1, '5': 12, '10': 'Output'},
  ],
};

const MsgCreateAccount$json = const {
  '1': 'MsgCreateAccount',
  '2': const [
    const {'1': 'Requester', '3': 1, '4': 1, '5': 9, '10': 'Requester'},
  ],
};

const MsgCreateExecutionResponse$json = const {
  '1': 'MsgCreateExecutionResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgCreateCookbook$json = const {
  '1': 'MsgCreateCookbook',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'Name', '3': 2, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'Description', '3': 3, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'Version', '3': 4, '4': 1, '5': 9, '10': 'Version'},
    const {'1': 'Developer', '3': 5, '4': 1, '5': 9, '10': 'Developer'},
    const {'1': 'SupportEmail', '3': 6, '4': 1, '5': 9, '10': 'SupportEmail'},
    const {'1': 'Level', '3': 7, '4': 1, '5': 3, '10': 'Level'},
    const {'1': 'Sender', '3': 8, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'CostPerBlock', '3': 9, '4': 1, '5': 3, '10': 'CostPerBlock'},
  ],
};

const MsgCreateCookbookResponse$json = const {
  '1': 'MsgCreateCookbookResponse',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'CookbookID'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 3, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgCreateRecipe$json = const {
  '1': 'MsgCreateRecipe',
  '2': const [
    const {'1': 'RecipeID', '3': 1, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'Name', '3': 2, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'CookbookID', '3': 3, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'CoinInputs', '3': 4, '4': 3, '5': 11, '6': '.pylons.CoinInput', '8': const {}, '10': 'CoinInputs'},
    const {'1': 'ItemInputs', '3': 5, '4': 3, '5': 11, '6': '.pylons.ItemInput', '8': const {}, '10': 'ItemInputs'},
    const {'1': 'Outputs', '3': 6, '4': 3, '5': 11, '6': '.pylons.WeightedOutputs', '8': const {}, '10': 'Outputs'},
    const {'1': 'BlockInterval', '3': 7, '4': 1, '5': 3, '10': 'BlockInterval'},
    const {'1': 'Sender', '3': 8, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Description', '3': 9, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'Entries', '3': 10, '4': 1, '5': 11, '6': '.pylons.EntriesList', '8': const {}, '10': 'Entries'},
    const {'1': 'ExtraInfo', '3': 11, '4': 1, '5': 9, '10': 'ExtraInfo'},
  ],
};

const MsgCreateRecipeResponse$json = const {
  '1': 'MsgCreateRecipeResponse',
  '2': const [
    const {'1': 'RecipeID', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'RecipeID'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 3, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgCreateTrade$json = const {
  '1': 'MsgCreateTrade',
  '2': const [
    const {'1': 'CoinInputs', '3': 1, '4': 3, '5': 11, '6': '.pylons.CoinInput', '8': const {}, '10': 'CoinInputs'},
    const {'1': 'ItemInputs', '3': 2, '4': 3, '5': 11, '6': '.pylons.TradeItemInput', '8': const {}, '10': 'ItemInputs'},
    const {'1': 'CoinOutputs', '3': 3, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'CoinOutputs'},
    const {'1': 'ItemOutputs', '3': 4, '4': 3, '5': 11, '6': '.pylons.Item', '8': const {}, '10': 'ItemOutputs'},
    const {'1': 'ExtraInfo', '3': 5, '4': 1, '5': 9, '10': 'ExtraInfo'},
    const {'1': 'Sender', '3': 6, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const MsgCreateTradeResponse$json = const {
  '1': 'MsgCreateTradeResponse',
  '2': const [
    const {'1': 'TradeID', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'TradeID'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 3, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgDisableRecipe$json = const {
  '1': 'MsgDisableRecipe',
  '2': const [
    const {'1': 'RecipeID', '3': 1, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const MsgDisableRecipeResponse$json = const {
  '1': 'MsgDisableRecipeResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgDisableTrade$json = const {
  '1': 'MsgDisableTrade',
  '2': const [
    const {'1': 'TradeID', '3': 1, '4': 1, '5': 9, '10': 'TradeID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const MsgDisableTradeResponse$json = const {
  '1': 'MsgDisableTradeResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgEnableRecipe$json = const {
  '1': 'MsgEnableRecipe',
  '2': const [
    const {'1': 'RecipeID', '3': 1, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const MsgEnableRecipeResponse$json = const {
  '1': 'MsgEnableRecipeResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgEnableTrade$json = const {
  '1': 'MsgEnableTrade',
  '2': const [
    const {'1': 'TradeID', '3': 1, '4': 1, '5': 9, '10': 'TradeID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const MsgEnableTradeResponse$json = const {
  '1': 'MsgEnableTradeResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgExecuteRecipe$json = const {
  '1': 'MsgExecuteRecipe',
  '2': const [
    const {'1': 'RecipeID', '3': 1, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'ItemIDs', '3': 3, '4': 3, '5': 9, '10': 'ItemIDs'},
  ],
};

const MsgExecuteRecipeResponse$json = const {
  '1': 'MsgExecuteRecipeResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
    const {'1': 'Output', '3': 3, '4': 1, '5': 12, '10': 'Output'},
  ],
};

const MsgFiatItem$json = const {
  '1': 'MsgFiatItem',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'Doubles', '3': 2, '4': 3, '5': 11, '6': '.pylons.DoubleKeyValue', '8': const {}, '10': 'Doubles'},
    const {'1': 'Longs', '3': 3, '4': 3, '5': 11, '6': '.pylons.LongKeyValue', '8': const {}, '10': 'Longs'},
    const {'1': 'Strings', '3': 4, '4': 3, '5': 11, '6': '.pylons.StringKeyValue', '8': const {}, '10': 'Strings'},
    const {'1': 'Sender', '3': 5, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'TransferFee', '3': 6, '4': 1, '5': 3, '10': 'TransferFee'},
  ],
};

const MsgFiatItemResponse$json = const {
  '1': 'MsgFiatItemResponse',
  '2': const [
    const {'1': 'ItemID', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'ItemID'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 3, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgFulfillTrade$json = const {
  '1': 'MsgFulfillTrade',
  '2': const [
    const {'1': 'TradeID', '3': 1, '4': 1, '5': 9, '10': 'TradeID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'ItemIDs', '3': 3, '4': 3, '5': 9, '10': 'ItemIDs'},
  ],
};

const MsgFulfillTradeResponse$json = const {
  '1': 'MsgFulfillTradeResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgGetPylons$json = const {
  '1': 'MsgGetPylons',
  '2': const [
    const {'1': 'Amount', '3': 1, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'Amount'},
    const {'1': 'Requester', '3': 2, '4': 1, '5': 9, '10': 'Requester'},
  ],
};

const MsgGetPylonsResponse$json = const {
  '1': 'MsgGetPylonsResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgGoogleIAPGetPylons$json = const {
  '1': 'MsgGoogleIAPGetPylons',
  '2': const [
    const {'1': 'ProductID', '3': 1, '4': 1, '5': 9, '10': 'ProductID'},
    const {'1': 'PurchaseToken', '3': 2, '4': 1, '5': 9, '10': 'PurchaseToken'},
    const {'1': 'ReceiptDataBase64', '3': 3, '4': 1, '5': 9, '10': 'ReceiptDataBase64'},
    const {'1': 'Signature', '3': 4, '4': 1, '5': 9, '10': 'Signature'},
    const {'1': 'Requester', '3': 5, '4': 1, '5': 9, '10': 'Requester'},
  ],
};

const MsgGoogleIAPGetPylonsResponse$json = const {
  '1': 'MsgGoogleIAPGetPylonsResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgSendCoins$json = const {
  '1': 'MsgSendCoins',
  '2': const [
    const {'1': 'Amount', '3': 1, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'Amount'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Receiver', '3': 3, '4': 1, '5': 9, '10': 'Receiver'},
  ],
};

const MsgSendCoinsResponse$json = const {
  '1': 'MsgSendCoinsResponse',
};

const MsgSendItems$json = const {
  '1': 'MsgSendItems',
  '2': const [
    const {'1': 'ItemIDs', '3': 1, '4': 3, '5': 9, '10': 'ItemIDs'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Receiver', '3': 3, '4': 1, '5': 9, '10': 'Receiver'},
  ],
};

const MsgSendItemsResponse$json = const {
  '1': 'MsgSendItemsResponse',
  '2': const [
    const {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 2, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgUpdateItemString$json = const {
  '1': 'MsgUpdateItemString',
  '2': const [
    const {'1': 'Field', '3': 1, '4': 1, '5': 9, '10': 'Field'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 9, '10': 'Value'},
    const {'1': 'Sender', '3': 3, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'ItemID', '3': 4, '4': 1, '5': 9, '10': 'ItemID'},
  ],
};

const MsgUpdateItemStringResponse$json = const {
  '1': 'MsgUpdateItemStringResponse',
  '2': const [
    const {'1': 'Status', '3': 1, '4': 1, '5': 9, '10': 'Status'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
  ],
};

const MsgUpdateCookbook$json = const {
  '1': 'MsgUpdateCookbook',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'Description', '3': 2, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'Version', '3': 3, '4': 1, '5': 9, '10': 'Version'},
    const {'1': 'Developer', '3': 4, '4': 1, '5': 9, '10': 'Developer'},
    const {'1': 'SupportEmail', '3': 5, '4': 1, '5': 9, '10': 'SupportEmail'},
    const {'1': 'Sender', '3': 6, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const MsgUpdateCookbookResponse$json = const {
  '1': 'MsgUpdateCookbookResponse',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'CookbookID'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 3, '4': 1, '5': 9, '10': 'Status'},
  ],
};

const MsgUpdateRecipe$json = const {
  '1': 'MsgUpdateRecipe',
  '2': const [
    const {'1': 'Name', '3': 1, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'CookbookID', '3': 2, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'CoinInputs', '3': 4, '4': 3, '5': 11, '6': '.pylons.CoinInput', '8': const {}, '10': 'CoinInputs'},
    const {'1': 'ItemInputs', '3': 5, '4': 3, '5': 11, '6': '.pylons.ItemInput', '8': const {}, '10': 'ItemInputs'},
    const {'1': 'Outputs', '3': 6, '4': 3, '5': 11, '6': '.pylons.WeightedOutputs', '8': const {}, '10': 'Outputs'},
    const {'1': 'BlockInterval', '3': 7, '4': 1, '5': 3, '10': 'BlockInterval'},
    const {'1': 'Sender', '3': 8, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Description', '3': 9, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'Entries', '3': 10, '4': 1, '5': 11, '6': '.pylons.EntriesList', '8': const {}, '10': 'Entries'},
  ],
};

const MsgUpdateRecipeResponse$json = const {
  '1': 'MsgUpdateRecipeResponse',
  '2': const [
    const {'1': 'RecipeID', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'RecipeID'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
    const {'1': 'Status', '3': 3, '4': 1, '5': 9, '10': 'Status'},
  ],
};

