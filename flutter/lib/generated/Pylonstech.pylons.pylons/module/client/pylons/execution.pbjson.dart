///
//  Generated code. Do not modify.
//  source: pylons/execution.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const ItemRecord$json = const {
  '1': 'ItemRecord',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'doubles', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleKeyValue', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongKeyValue', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringKeyValue', '8': const {}, '10': 'strings'},
  ],
};

const Execution$json = const {
  '1': 'Execution',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'recipeID', '3': 3, '4': 1, '5': 9, '10': 'recipeID'},
    const {'1': 'cookbookID', '3': 4, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'recipeVersion', '3': 5, '4': 1, '5': 9, '10': 'recipeVersion'},
    const {'1': 'nodeVersion', '3': 6, '4': 1, '5': 9, '10': 'nodeVersion'},
    const {'1': 'blockHeight', '3': 7, '4': 1, '5': 3, '10': 'blockHeight'},
    const {'1': 'itemInputs', '3': 8, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRecord', '8': const {}, '10': 'itemInputs'},
    const {'1': 'coinInputs', '3': 9, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinInputs'},
    const {'1': 'coinOutputs', '3': 10, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'itemOutputIDs', '3': 11, '4': 3, '5': 9, '8': const {}, '10': 'itemOutputIDs'},
    const {'1': 'itemModifyOutputIDs', '3': 12, '4': 3, '5': 9, '8': const {}, '10': 'itemModifyOutputIDs'},
  ],
};

