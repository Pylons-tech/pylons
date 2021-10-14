///
//  Generated code. Do not modify.
//  source: pylons/trade.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const ItemRef$json = const {
  '1': 'ItemRef',
  '2': const [
    const {'1': 'cookbookID', '3': 1, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'itemID', '3': 2, '4': 1, '5': 9, '10': 'itemID'},
  ],
};

const Trade$json = const {
  '1': 'Trade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 4, '10': 'ID'},
    const {'1': 'coinInputs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinInput', '8': const {}, '10': 'coinInputs'},
    const {'1': 'itemInputs', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemInput', '8': const {}, '10': 'itemInputs'},
    const {'1': 'coinOutputs', '3': 5, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'itemOutputs', '3': 6, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'itemOutputs'},
    const {'1': 'extraInfo', '3': 7, '4': 1, '5': 9, '10': 'extraInfo'},
    const {'1': 'receiver', '3': 8, '4': 1, '5': 9, '10': 'receiver'},
    const {'1': 'tradedItemInputs', '3': 9, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'tradedItemInputs'},
  ],
};
