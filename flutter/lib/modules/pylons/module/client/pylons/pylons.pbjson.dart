///
//  Generated code. Do not modify.
//  source: pylons/pylons.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const EntriesList$json = const {
  '1': 'EntriesList',
  '2': const [
    const {'1': 'CoinOutputs', '3': 1, '4': 3, '5': 11, '6': '.pylons.CoinOutput', '8': const {}, '10': 'CoinOutputs'},
    const {'1': 'ItemOutputs', '3': 2, '4': 3, '5': 11, '6': '.pylons.ItemOutput', '8': const {}, '10': 'ItemOutputs'},
    const {'1': 'ItemModifyOutputs', '3': 3, '4': 3, '5': 11, '6': '.pylons.ItemModifyOutput', '8': const {}, '10': 'ItemModifyOutputs'},
  ],
};

const CoinInput$json = const {
  '1': 'CoinInput',
  '2': const [
    const {'1': 'Coin', '3': 1, '4': 1, '5': 9, '10': 'Coin'},
    const {'1': 'Count', '3': 2, '4': 1, '5': 3, '10': 'Count'},
  ],
};

const CoinOutput$json = const {
  '1': 'CoinOutput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'Coin', '3': 2, '4': 1, '5': 9, '10': 'Coin'},
    const {'1': 'Count', '3': 3, '4': 1, '5': 9, '10': 'Count'},
  ],
};

const DoubleInputParam$json = const {
  '1': 'DoubleInputParam',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'MinValue', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'MinValue'},
    const {'1': 'MaxValue', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'MaxValue'},
  ],
};

const DoubleWeightRange$json = const {
  '1': 'DoubleWeightRange',
  '2': const [
    const {'1': 'Lower', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'Lower'},
    const {'1': 'Upper', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'Upper'},
    const {'1': 'Weight', '3': 3, '4': 1, '5': 3, '10': 'Weight'},
  ],
};

const LongParam$json = const {
  '1': 'LongParam',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Rate', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'Rate'},
    const {'1': 'WeightRanges', '3': 3, '4': 3, '5': 11, '6': '.pylons.IntWeightRange', '8': const {}, '10': 'WeightRanges'},
    const {'1': 'Program', '3': 4, '4': 1, '5': 9, '10': 'Program'},
  ],
};

const IntWeightRange$json = const {
  '1': 'IntWeightRange',
  '2': const [
    const {'1': 'Lower', '3': 1, '4': 1, '5': 3, '10': 'Lower'},
    const {'1': 'Upper', '3': 2, '4': 1, '5': 3, '10': 'Upper'},
    const {'1': 'Weight', '3': 3, '4': 1, '5': 3, '10': 'Weight'},
  ],
};

const StringInputParam$json = const {
  '1': 'StringInputParam',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 9, '10': 'Value'},
  ],
};

const FeeInputParam$json = const {
  '1': 'FeeInputParam',
  '2': const [
    const {'1': 'MinValue', '3': 1, '4': 1, '5': 3, '10': 'MinValue'},
    const {'1': 'MaxValue', '3': 2, '4': 1, '5': 3, '10': 'MaxValue'},
  ],
};

const LongInputParam$json = const {
  '1': 'LongInputParam',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'MinValue', '3': 2, '4': 1, '5': 3, '10': 'MinValue'},
    const {'1': 'MaxValue', '3': 3, '4': 1, '5': 3, '10': 'MaxValue'},
  ],
};

const ConditionList$json = const {
  '1': 'ConditionList',
  '2': const [
    const {'1': 'Doubles', '3': 1, '4': 3, '5': 11, '6': '.pylons.DoubleInputParam', '8': const {}, '10': 'Doubles'},
    const {'1': 'Longs', '3': 2, '4': 3, '5': 11, '6': '.pylons.LongInputParam', '8': const {}, '10': 'Longs'},
    const {'1': 'Strings', '3': 3, '4': 3, '5': 11, '6': '.pylons.StringInputParam', '8': const {}, '10': 'Strings'},
  ],
};

const ItemInput$json = const {
  '1': 'ItemInput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'Doubles', '3': 2, '4': 3, '5': 11, '6': '.pylons.DoubleInputParam', '8': const {}, '10': 'Doubles'},
    const {'1': 'Longs', '3': 3, '4': 3, '5': 11, '6': '.pylons.LongInputParam', '8': const {}, '10': 'Longs'},
    const {'1': 'Strings', '3': 4, '4': 3, '5': 11, '6': '.pylons.StringInputParam', '8': const {}, '10': 'Strings'},
    const {'1': 'TransferFee', '3': 5, '4': 1, '5': 11, '6': '.pylons.FeeInputParam', '8': const {}, '10': 'TransferFee'},
    const {'1': 'Conditions', '3': 6, '4': 1, '5': 11, '6': '.pylons.ConditionList', '8': const {}, '10': 'Conditions'},
  ],
};

const WeightedOutputs$json = const {
  '1': 'WeightedOutputs',
  '2': const [
    const {'1': 'EntryIDs', '3': 1, '4': 3, '5': 9, '10': 'EntryIDs'},
    const {'1': 'Weight', '3': 2, '4': 1, '5': 9, '10': 'Weight'},
  ],
};

const StringParam$json = const {
  '1': 'StringParam',
  '2': const [
    const {'1': 'Rate', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'Rate'},
    const {'1': 'Key', '3': 2, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 3, '4': 1, '5': 9, '10': 'Value'},
    const {'1': 'Program', '3': 4, '4': 1, '5': 9, '10': 'Program'},
  ],
};

const DoubleParam$json = const {
  '1': 'DoubleParam',
  '2': const [
    const {'1': 'Rate', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'Rate'},
    const {'1': 'Key', '3': 2, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'WeightRanges', '3': 3, '4': 3, '5': 11, '6': '.pylons.DoubleWeightRange', '8': const {}, '10': 'WeightRanges'},
    const {'1': 'Program', '3': 4, '4': 1, '5': 9, '10': 'Program'},
  ],
};

const ItemOutput$json = const {
  '1': 'ItemOutput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'Doubles', '3': 2, '4': 3, '5': 11, '6': '.pylons.DoubleParam', '8': const {}, '10': 'Doubles'},
    const {'1': 'Longs', '3': 3, '4': 3, '5': 11, '6': '.pylons.LongParam', '8': const {}, '10': 'Longs'},
    const {'1': 'Strings', '3': 4, '4': 3, '5': 11, '6': '.pylons.StringParam', '8': const {}, '10': 'Strings'},
    const {'1': 'TransferFee', '3': 5, '4': 1, '5': 3, '10': 'TransferFee'},
  ],
};

const ItemModifyOutput$json = const {
  '1': 'ItemModifyOutput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'ItemInputRef', '3': 2, '4': 1, '5': 9, '10': 'ItemInputRef'},
    const {'1': 'Doubles', '3': 3, '4': 3, '5': 11, '6': '.pylons.DoubleParam', '8': const {}, '10': 'Doubles'},
    const {'1': 'Longs', '3': 4, '4': 3, '5': 11, '6': '.pylons.LongParam', '8': const {}, '10': 'Longs'},
    const {'1': 'Strings', '3': 5, '4': 3, '5': 11, '6': '.pylons.StringParam', '8': const {}, '10': 'Strings'},
    const {'1': 'TransferFee', '3': 6, '4': 1, '5': 3, '10': 'TransferFee'},
  ],
};

const ItemModifyParams$json = const {
  '1': 'ItemModifyParams',
  '2': const [
    const {'1': 'Doubles', '3': 1, '4': 3, '5': 11, '6': '.pylons.DoubleParam', '8': const {}, '10': 'Doubles'},
    const {'1': 'Longs', '3': 2, '4': 3, '5': 11, '6': '.pylons.LongParam', '8': const {}, '10': 'Longs'},
    const {'1': 'Strings', '3': 3, '4': 3, '5': 11, '6': '.pylons.StringParam', '8': const {}, '10': 'Strings'},
    const {'1': 'TransferFee', '3': 4, '4': 1, '5': 3, '10': 'TransferFee'},
  ],
};

const Item$json = const {
  '1': 'Item',
  '2': const [
    const {'1': 'NodeVersion', '3': 1, '4': 1, '5': 9, '10': 'NodeVersion'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'Doubles', '3': 3, '4': 3, '5': 11, '6': '.pylons.DoubleKeyValue', '8': const {}, '10': 'Doubles'},
    const {'1': 'Longs', '3': 4, '4': 3, '5': 11, '6': '.pylons.LongKeyValue', '8': const {}, '10': 'Longs'},
    const {'1': 'Strings', '3': 5, '4': 3, '5': 11, '6': '.pylons.StringKeyValue', '8': const {}, '10': 'Strings'},
    const {'1': 'CookbookID', '3': 6, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'Sender', '3': 7, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'OwnerRecipeID', '3': 8, '4': 1, '5': 9, '10': 'OwnerRecipeID'},
    const {'1': 'OwnerTradeID', '3': 9, '4': 1, '5': 9, '10': 'OwnerTradeID'},
    const {'1': 'Tradable', '3': 10, '4': 1, '5': 8, '10': 'Tradable'},
    const {'1': 'LastUpdate', '3': 11, '4': 1, '5': 3, '10': 'LastUpdate'},
    const {'1': 'TransferFee', '3': 12, '4': 1, '5': 3, '10': 'TransferFee'},
  ],
};

const DoubleKeyValue$json = const {
  '1': 'DoubleKeyValue',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'Value'},
  ],
};

const LongKeyValue$json = const {
  '1': 'LongKeyValue',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 3, '10': 'Value'},
  ],
};

const StringKeyValue$json = const {
  '1': 'StringKeyValue',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 9, '10': 'Value'},
  ],
};

const TradeItemInput$json = const {
  '1': 'TradeItemInput',
  '2': const [
    const {'1': 'ItemInput', '3': 1, '4': 1, '5': 11, '6': '.pylons.ItemInput', '8': const {}, '10': 'ItemInput'},
    const {'1': 'CookbookID', '3': 2, '4': 1, '5': 9, '10': 'CookbookID'},
  ],
};

const LockedCoinDescribe$json = const {
  '1': 'LockedCoinDescribe',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'Amount', '3': 2, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'Amount'},
  ],
};

const ShortenRecipe$json = const {
  '1': 'ShortenRecipe',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'CookbookID', '3': 2, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'Name', '3': 3, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'Description', '3': 4, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'Sender', '3': 5, '4': 1, '5': 9, '10': 'Sender'},
  ],
};

const Execution$json = const {
  '1': 'Execution',
  '2': const [
    const {'1': 'NodeVersion', '3': 1, '4': 1, '5': 9, '10': 'NodeVersion'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'RecipeID', '3': 3, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'CookbookID', '3': 4, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'CoinInputs', '3': 5, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'CoinInputs'},
    const {'1': 'ItemInputs', '3': 6, '4': 3, '5': 11, '6': '.pylons.Item', '8': const {}, '10': 'ItemInputs'},
    const {'1': 'BlockHeight', '3': 7, '4': 1, '5': 3, '10': 'BlockHeight'},
    const {'1': 'Sender', '3': 8, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Completed', '3': 9, '4': 1, '5': 8, '10': 'Completed'},
  ],
};

const Cookbook$json = const {
  '1': 'Cookbook',
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

const Recipe$json = const {
  '1': 'Recipe',
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
    const {'1': 'ExtraInfo', '3': 13, '4': 1, '5': 9, '10': 'ExtraInfo'},
  ],
};

const Trade$json = const {
  '1': 'Trade',
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

