///
//  Generated code. Do not modify.
//  source: pylons/recipe.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const DoubleInputParam$json = const {
  '1': 'DoubleInputParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'minValue', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'minValue'},
    const {'1': 'maxValue', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'maxValue'},
  ],
};

const LongInputParam$json = const {
  '1': 'LongInputParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'minValue', '3': 2, '4': 1, '5': 3, '10': 'minValue'},
    const {'1': 'maxValue', '3': 3, '4': 1, '5': 3, '10': 'maxValue'},
  ],
};

const StringInputParam$json = const {
  '1': 'StringInputParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

const ConditionList$json = const {
  '1': 'ConditionList',
  '2': const [
    const {'1': 'doubles', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleInputParam', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongInputParam', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringInputParam', '8': const {}, '10': 'strings'},
  ],
};

const ItemInput$json = const {
  '1': 'ItemInput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'doubles', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleInputParam', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongInputParam', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringInputParam', '8': const {}, '10': 'strings'},
    const {'1': 'conditions', '3': 5, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.ConditionList', '8': const {}, '10': 'conditions'},
  ],
};

const DoubleWeightRange$json = const {
  '1': 'DoubleWeightRange',
  '2': const [
    const {'1': 'lower', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'lower'},
    const {'1': 'upper', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'upper'},
    const {'1': 'weight', '3': 3, '4': 1, '5': 4, '10': 'weight'},
  ],
};

const DoubleParam$json = const {
  '1': 'DoubleParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'rate', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'rate'},
    const {'1': 'weightRanges', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleWeightRange', '8': const {}, '10': 'weightRanges'},
    const {'1': 'program', '3': 4, '4': 1, '5': 9, '10': 'program'},
  ],
};

const IntWeightRange$json = const {
  '1': 'IntWeightRange',
  '2': const [
    const {'1': 'lower', '3': 1, '4': 1, '5': 3, '10': 'lower'},
    const {'1': 'upper', '3': 2, '4': 1, '5': 3, '10': 'upper'},
    const {'1': 'weight', '3': 3, '4': 1, '5': 4, '10': 'weight'},
  ],
};

const LongParam$json = const {
  '1': 'LongParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'rate', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'rate'},
    const {'1': 'weightRanges', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.IntWeightRange', '8': const {}, '10': 'weightRanges'},
    const {'1': 'program', '3': 4, '4': 1, '5': 9, '10': 'program'},
  ],
};

const StringParam$json = const {
  '1': 'StringParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'rate', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'rate'},
    const {'1': 'value', '3': 3, '4': 1, '5': 9, '10': 'value'},
    const {'1': 'program', '3': 4, '4': 1, '5': 9, '10': 'program'},
  ],
};

const CoinOutput$json = const {
  '1': 'CoinOutput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'coin', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coin'},
    const {'1': 'program', '3': 3, '4': 1, '5': 9, '10': 'program'},
  ],
};

const ItemOutput$json = const {
  '1': 'ItemOutput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'doubles', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleParam', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongParam', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringParam', '8': const {}, '10': 'strings'},
    const {'1': 'mutableStrings', '3': 5, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringKeyValue', '8': const {}, '10': 'mutableStrings'},
    const {'1': 'transferFee', '3': 6, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'transferFee'},
    const {'1': 'tradePercentage', '3': 7, '4': 1, '5': 9, '8': const {}, '10': 'tradePercentage'},
    const {'1': 'quantity', '3': 8, '4': 1, '5': 4, '10': 'quantity'},
    const {'1': 'amountMinted', '3': 9, '4': 1, '5': 4, '10': 'amountMinted'},
    const {'1': 'tradeable', '3': 10, '4': 1, '5': 8, '10': 'tradeable'},
  ],
};

const ItemModifyOutput$json = const {
  '1': 'ItemModifyOutput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'itemInputRef', '3': 2, '4': 1, '5': 9, '10': 'itemInputRef'},
    const {'1': 'doubles', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleParam', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongParam', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 5, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringParam', '8': const {}, '10': 'strings'},
    const {'1': 'mutableStrings', '3': 6, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringKeyValue', '8': const {}, '10': 'mutableStrings'},
    const {'1': 'transferFee', '3': 7, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'transferFee'},
    const {'1': 'tradePercentage', '3': 8, '4': 1, '5': 9, '8': const {}, '10': 'tradePercentage'},
    const {'1': 'quantity', '3': 9, '4': 1, '5': 4, '10': 'quantity'},
    const {'1': 'amountMinted', '3': 10, '4': 1, '5': 4, '10': 'amountMinted'},
    const {'1': 'tradeable', '3': 11, '4': 1, '5': 8, '10': 'tradeable'},
  ],
};

const EntriesList$json = const {
  '1': 'EntriesList',
  '2': const [
    const {'1': 'coinOutputs', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinOutput', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'itemOutputs', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemOutput', '8': const {}, '10': 'itemOutputs'},
    const {'1': 'itemModifyOutputs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemModifyOutput', '8': const {}, '10': 'itemModifyOutputs'},
  ],
};

const WeightedOutputs$json = const {
  '1': 'WeightedOutputs',
  '2': const [
    const {'1': 'entryIDs', '3': 1, '4': 3, '5': 9, '8': const {}, '10': 'entryIDs'},
    const {'1': 'weight', '3': 2, '4': 1, '5': 4, '10': 'weight'},
  ],
};

const CoinInput$json = const {
  '1': 'CoinInput',
  '2': const [
    const {'1': 'coins', '3': 1, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coins'},
  ],
};

const Recipe$json = const {
  '1': 'Recipe',
  '2': const [
    const {'1': 'cookbookID', '3': 1, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'nodeVersion', '3': 3, '4': 1, '5': 9, '10': 'nodeVersion'},
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
