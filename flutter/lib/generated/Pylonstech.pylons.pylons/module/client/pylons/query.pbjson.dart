///
//  Generated code. Do not modify.
//  source: pylons/query.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const QueryGetUsernameByAddressRequest$json = const {
  '1': 'QueryGetUsernameByAddressRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

const QueryGetAddressByUsernameRequest$json = const {
  '1': 'QueryGetAddressByUsernameRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

const QueryGetUsernameByAddressResponse$json = const {
  '1': 'QueryGetUsernameByAddressResponse',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Username', '8': const {}, '10': 'username'},
  ],
};

const QueryGetAddressByUsernameResponse$json = const {
  '1': 'QueryGetAddressByUsernameResponse',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.AccountAddr', '8': const {}, '10': 'address'},
  ],
};

const QueryGetTradeRequest$json = const {
  '1': 'QueryGetTradeRequest',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 4, '10': 'ID'},
  ],
};

const QueryGetTradeResponse$json = const {
  '1': 'QueryGetTradeResponse',
  '2': const [
    const {'1': 'Trade', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Trade', '8': const {}, '10': 'Trade'},
  ],
};

const QueryListItemByOwnerRequest$json = const {
  '1': 'QueryListItemByOwnerRequest',
  '2': const [
    const {'1': 'owner', '3': 1, '4': 1, '5': 9, '10': 'owner'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

const QueryListItemByOwnerResponse$json = const {
  '1': 'QueryListItemByOwnerResponse',
  '2': const [
    const {'1': 'Items', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Item', '8': const {}, '10': 'Items'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
  '7': const {},
};

const QueryGetGoogleInAppPurchaseOrderRequest$json = const {
  '1': 'QueryGetGoogleInAppPurchaseOrderRequest',
  '2': const [
    const {'1': 'PurchaseToken', '3': 1, '4': 1, '5': 9, '10': 'PurchaseToken'},
  ],
};

const QueryGetGoogleInAppPurchaseOrderResponse$json = const {
  '1': 'QueryGetGoogleInAppPurchaseOrderResponse',
  '2': const [
    const {'1': 'Order', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.GoogleInAppPurchaseOrder', '8': const {}, '10': 'Order'},
  ],
};

const QueryListExecutionsByItemRequest$json = const {
  '1': 'QueryListExecutionsByItemRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ItemID', '3': 2, '4': 1, '5': 9, '10': 'ItemID'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
  '7': const {},
};

const QueryListExecutionsByItemResponse$json = const {
  '1': 'QueryListExecutionsByItemResponse',
  '2': const [
    const {'1': 'CompletedExecutions', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'CompletedExecutions'},
    const {'1': 'PendingExecutions', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'PendingExecutions'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

const QueryListExecutionsByRecipeRequest$json = const {
  '1': 'QueryListExecutionsByRecipeRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'RecipeID', '3': 2, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
  '7': const {},
};

const QueryListExecutionsByRecipeResponse$json = const {
  '1': 'QueryListExecutionsByRecipeResponse',
  '2': const [
    const {'1': 'CompletedExecutions', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'CompletedExecutions'},
    const {'1': 'PendingExecutions', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'PendingExecutions'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

const QueryGetExecutionRequest$json = const {
  '1': 'QueryGetExecutionRequest',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const QueryGetExecutionResponse$json = const {
  '1': 'QueryGetExecutionResponse',
  '2': const [
    const {'1': 'Execution', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'Execution'},
    const {'1': 'Completed', '3': 2, '4': 1, '5': 8, '10': 'Completed'},
  ],
};

const QueryListRecipesByCookbookRequest$json = const {
  '1': 'QueryListRecipesByCookbookRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

const QueryListRecipesByCookbookResponse$json = const {
  '1': 'QueryListRecipesByCookbookResponse',
  '2': const [
    const {'1': 'Recipes', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Recipe', '8': const {}, '10': 'Recipes'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

const QueryGetItemRequest$json = const {
  '1': 'QueryGetItemRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const QueryGetItemResponse$json = const {
  '1': 'QueryGetItemResponse',
  '2': const [
    const {'1': 'Item', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Item', '8': const {}, '10': 'Item'},
  ],
};

const QueryGetRecipeRequest$json = const {
  '1': 'QueryGetRecipeRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const QueryGetRecipeResponse$json = const {
  '1': 'QueryGetRecipeResponse',
  '2': const [
    const {'1': 'Recipe', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Recipe', '8': const {}, '10': 'Recipe'},
  ],
};

const QueryListCookbooksByCreatorRequest$json = const {
  '1': 'QueryListCookbooksByCreatorRequest',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

const QueryListCookbooksByCreatorResponse$json = const {
  '1': 'QueryListCookbooksByCreatorResponse',
  '2': const [
    const {'1': 'Cookbooks', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Cookbook', '8': const {}, '10': 'Cookbooks'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

const QueryGetCookbookRequest$json = const {
  '1': 'QueryGetCookbookRequest',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const QueryGetCookbookResponse$json = const {
  '1': 'QueryGetCookbookResponse',
  '2': const [
    const {'1': 'Cookbook', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Cookbook', '8': const {}, '10': 'Cookbook'},
  ],
};

