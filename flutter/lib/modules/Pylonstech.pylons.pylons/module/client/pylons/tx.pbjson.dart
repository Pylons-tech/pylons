///
//  Generated code. Do not modify.
//  source: pylons/tx.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const MsgUpdateAccount$json = const {
  '1': 'MsgUpdateAccount',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

const MsgUpdateAccountResponse$json = const {
  '1': 'MsgUpdateAccountResponse',
};

const MsgCreateAccount$json = const {
  '1': 'MsgCreateAccount',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

const MsgCreateAccountResponse$json = const {
  '1': 'MsgCreateAccountResponse',
};

const MsgFulfillTrade$json = const {
  '1': 'MsgFulfillTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 4, '10': 'ID'},
    const {'1': 'coinInputsIndex', '3': 3, '4': 1, '5': 4, '10': 'coinInputsIndex'},
    const {'1': 'items', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'items'},
  ],
};

const MsgFulfillTradeResponse$json = const {
  '1': 'MsgFulfillTradeResponse',
};

const MsgCreateTrade$json = const {
  '1': 'MsgCreateTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'coinInputs', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinInput', '8': const {}, '10': 'coinInputs'},
    const {'1': 'itemInputs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemInput', '8': const {}, '10': 'itemInputs'},
    const {'1': 'coinOutputs', '3': 4, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'itemOutputs', '3': 5, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'itemOutputs'},
    const {'1': 'extraInfo', '3': 6, '4': 1, '5': 9, '10': 'extraInfo'},
  ],
};

const MsgCreateTradeResponse$json = const {
  '1': 'MsgCreateTradeResponse',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 4, '10': 'ID'},
  ],
};

const MsgCancelTrade$json = const {
  '1': 'MsgCancelTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 4, '10': 'ID'},
  ],
};

const MsgCancelTradeResponse$json = const {
  '1': 'MsgCancelTradeResponse',
};

const MsgCompleteExecutionEarly$json = const {
  '1': 'MsgCompleteExecutionEarly',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const MsgCompleteExecutionEarlyResponse$json = const {
  '1': 'MsgCompleteExecutionEarlyResponse',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const MsgTransferCookbook$json = const {
  '1': 'MsgTransferCookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'recipient', '3': 3, '4': 1, '5': 9, '10': 'recipient'},
  ],
};

const MsgTransferCookbookResponse$json = const {
  '1': 'MsgTransferCookbookResponse',
};

const MsgGoogleInAppPurchaseGetCoins$json = const {
  '1': 'MsgGoogleInAppPurchaseGetCoins',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'productID', '3': 2, '4': 1, '5': 9, '10': 'productID'},
    const {'1': 'purchaseToken', '3': 3, '4': 1, '5': 9, '10': 'purchaseToken'},
    const {'1': 'receiptDataBase64', '3': 4, '4': 1, '5': 9, '10': 'receiptDataBase64'},
    const {'1': 'signature', '3': 5, '4': 1, '5': 9, '10': 'signature'},
  ],
};

const MsgGoogleInAppPurchaseGetCoinsResponse$json = const {
  '1': 'MsgGoogleInAppPurchaseGetCoinsResponse',
};

const MsgSendItems$json = const {
  '1': 'MsgSendItems',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'receiver', '3': 2, '4': 1, '5': 9, '10': 'receiver'},
    const {'1': 'items', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'items'},
  ],
};

const MsgSendItemsResponse$json = const {
  '1': 'MsgSendItemsResponse',
};

const MsgExecuteRecipe$json = const {
  '1': 'MsgExecuteRecipe',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbookID', '3': 2, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'recipeID', '3': 3, '4': 1, '5': 9, '10': 'recipeID'},
    const {'1': 'coinInputsIndex', '3': 4, '4': 1, '5': 4, '10': 'coinInputsIndex'},
    const {'1': 'itemIDs', '3': 5, '4': 3, '5': 9, '8': const {}, '10': 'itemIDs'},
  ],
};

const MsgExecuteRecipeResponse$json = const {
  '1': 'MsgExecuteRecipeResponse',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const MsgSetItemString$json = const {
  '1': 'MsgSetItemString',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbookID', '3': 2, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'ID', '3': 4, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'field', '3': 5, '4': 1, '5': 9, '10': 'field'},
    const {'1': 'value', '3': 6, '4': 1, '5': 9, '10': 'value'},
  ],
};

const MsgSetItemStringResponse$json = const {
  '1': 'MsgSetItemStringResponse',
};

const MsgCreateRecipe$json = const {
  '1': 'MsgCreateRecipe',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbookID', '3': 2, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'coinInputs', '3': 7, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinInput', '8': const {}, '10': 'coinInputs'},
    const {'1': 'itemInputs', '3': 8, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemInput', '8': const {}, '10': 'itemInputs'},
    const {'1': 'entries', '3': 9, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.EntriesList', '8': const {}, '10': 'entries'},
    const {'1': 'outputs', '3': 10, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.WeightedOutputs', '8': const {}, '10': 'outputs'},
    const {'1': 'blockInterval', '3': 11, '4': 1, '5': 3, '10': 'blockInterval'},
    const {'1': 'enabled', '3': 12, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'extraInfo', '3': 13, '4': 1, '5': 9, '10': 'extraInfo'},
  ],
};

const MsgCreateRecipeResponse$json = const {
  '1': 'MsgCreateRecipeResponse',
};

const MsgUpdateRecipe$json = const {
  '1': 'MsgUpdateRecipe',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbookID', '3': 2, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'coinInputs', '3': 7, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinInput', '8': const {}, '10': 'coinInputs'},
    const {'1': 'itemInputs', '3': 8, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemInput', '8': const {}, '10': 'itemInputs'},
    const {'1': 'entries', '3': 9, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.EntriesList', '8': const {}, '10': 'entries'},
    const {'1': 'outputs', '3': 10, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.WeightedOutputs', '8': const {}, '10': 'outputs'},
    const {'1': 'blockInterval', '3': 11, '4': 1, '5': 3, '10': 'blockInterval'},
    const {'1': 'enabled', '3': 12, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'extraInfo', '3': 13, '4': 1, '5': 9, '10': 'extraInfo'},
  ],
};

const MsgUpdateRecipeResponse$json = const {
  '1': 'MsgUpdateRecipeResponse',
};

const MsgCreateCookbook$json = const {
  '1': 'MsgCreateCookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'developer', '3': 5, '4': 1, '5': 9, '10': 'developer'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'supportEmail', '3': 7, '4': 1, '5': 9, '10': 'supportEmail'},
    const {'1': 'costPerBlock', '3': 8, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'costPerBlock'},
    const {'1': 'enabled', '3': 9, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

const MsgCreateCookbookResponse$json = const {
  '1': 'MsgCreateCookbookResponse',
};

const MsgUpdateCookbook$json = const {
  '1': 'MsgUpdateCookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'developer', '3': 5, '4': 1, '5': 9, '10': 'developer'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'supportEmail', '3': 7, '4': 1, '5': 9, '10': 'supportEmail'},
    const {'1': 'costPerBlock', '3': 8, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'costPerBlock'},
    const {'1': 'enabled', '3': 9, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

const MsgUpdateCookbookResponse$json = const {
  '1': 'MsgUpdateCookbookResponse',
};
