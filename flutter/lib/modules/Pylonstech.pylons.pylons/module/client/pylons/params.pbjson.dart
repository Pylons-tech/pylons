///
//  Generated code. Do not modify.
//  source: pylons/params.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const GoogleInAppPurchasePackage$json = const {
  '1': 'GoogleInAppPurchasePackage',
  '2': const [
    const {'1': 'PackageName', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'PackageName'},
    const {'1': 'ProductID', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'ProductID'},
    const {'1': 'Amount', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'Amount'},
  ],
};

const CoinIssuer$json = const {
  '1': 'CoinIssuer',
  '2': const [
    const {'1': 'CoinDenom', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'CoinDenom'},
    const {'1': 'Packages', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.GoogleInAppPurchasePackage', '8': const {}, '10': 'Packages'},
    const {'1': 'GoogleInAppPurchasePubKey', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'GoogleInAppPurchasePubKey'},
  ],
};

const Params$json = const {
  '1': 'Params',
  '2': const [
    const {'1': 'minNameFieldLength', '3': 1, '4': 1, '5': 4, '8': const {}, '10': 'minNameFieldLength'},
    const {'1': 'minDescriptionFieldLength', '3': 2, '4': 1, '5': 4, '8': const {}, '10': 'minDescriptionFieldLength'},
    const {'1': 'coinIssuers', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinIssuer', '8': const {}, '10': 'coinIssuers'},
    const {'1': 'recipeFeePercentage', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'recipeFeePercentage'},
    const {'1': 'itemTransferFeePercentage', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'itemTransferFeePercentage'},
    const {'1': 'UpdateItemStringFee', '3': 6, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'UpdateItemStringFee'},
    const {'1': 'minTransferFee', '3': 7, '4': 1, '5': 9, '8': const {}, '10': 'minTransferFee'},
    const {'1': 'maxTransferFee', '3': 8, '4': 1, '5': 9, '8': const {}, '10': 'maxTransferFee'},
    const {'1': 'UpdateUsernameFee', '3': 9, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'UpdateUsernameFee'},
  ],
  '7': const {},
};
