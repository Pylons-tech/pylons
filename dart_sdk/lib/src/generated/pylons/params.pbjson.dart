///
//  Generated code. Do not modify.
//  source: pylons/pylons/params.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use googleInAppPurchasePackageDescriptor instead')
const GoogleInAppPurchasePackage$json = const {
  '1': 'GoogleInAppPurchasePackage',
  '2': const [
    const {
      '1': 'package_name',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'packageName'
    },
    const {
      '1': 'product_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'productId'
    },
    const {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'amount'
    },
  ],
};

/// Descriptor for `GoogleInAppPurchasePackage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List googleInAppPurchasePackageDescriptor =
    $convert.base64Decode(
        'ChpHb29nbGVJbkFwcFB1cmNoYXNlUGFja2FnZRI6CgxwYWNrYWdlX25hbWUYASABKAlCF/LeHxN5YW1sOiJwYWNrYWdlX25hbWUiUgtwYWNrYWdlTmFtZRI0Cgpwcm9kdWN0X2lkGAIgASgJQhXy3h8ReWFtbDoicHJvZHVjdF9pZCJSCXByb2R1Y3RJZBJXCgZhbW91bnQYAyABKAlCP8jeHwDy3h8NeWFtbDoiYW1vdW50ItreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkludFIGYW1vdW50');
@$core.Deprecated('Use coinIssuerDescriptor instead')
const CoinIssuer$json = const {
  '1': 'CoinIssuer',
  '2': const [
    const {
      '1': 'coin_denom',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'coinDenom'
    },
    const {
      '1': 'packages',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.GoogleInAppPurchasePackage',
      '8': const {},
      '10': 'packages'
    },
    const {
      '1': 'google_in_app_purchase_pub_key',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'googleInAppPurchasePubKey'
    },
    const {'1': 'entity_name', '3': 4, '4': 1, '5': 9, '10': 'entityName'},
  ],
};

/// Descriptor for `CoinIssuer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinIssuerDescriptor = $convert.base64Decode(
    'CgpDb2luSXNzdWVyEjQKCmNvaW5fZGVub20YASABKAlCFfLeHxF5YW1sOiJjb2luX2Rlbm9tIlIJY29pbkRlbm9tEmkKCHBhY2thZ2VzGAIgAygLMikucHlsb25zLnB5bG9ucy5Hb29nbGVJbkFwcFB1cmNoYXNlUGFja2FnZUIi8t4fGnlhbWw6Imdvb2dsZV9pYXBfcGFja2FnZXMiyN4fAFIIcGFja2FnZXMSXwoeZ29vZ2xlX2luX2FwcF9wdXJjaGFzZV9wdWJfa2V5GAMgASgJQhzy3h8YeWFtbDoiZ29vZ2xlX2lhcF9wdWJrZXkiUhlnb29nbGVJbkFwcFB1cmNoYXNlUHViS2V5Eh8KC2VudGl0eV9uYW1lGAQgASgJUgplbnRpdHlOYW1l');
@$core.Deprecated('Use paymentProcessorDescriptor instead')
const PaymentProcessor$json = const {
  '1': 'PaymentProcessor',
  '2': const [
    const {
      '1': 'coin_denom',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'coinDenom'
    },
    const {
      '1': 'pub_key',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'pubKey'
    },
    const {
      '1': 'processor_percentage',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'processorPercentage'
    },
    const {
      '1': 'validators_percentage',
      '3': 4,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'validatorsPercentage'
    },
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `PaymentProcessor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentProcessorDescriptor = $convert.base64Decode(
    'ChBQYXltZW50UHJvY2Vzc29yEjQKCmNvaW5fZGVub20YASABKAlCFfLeHxF5YW1sOiJjb2luX2Rlbm9tIlIJY29pbkRlbm9tEisKB3B1Yl9rZXkYAiABKAlCEvLeHw55YW1sOiJwdWJfa2V5IlIGcHViS2V5EoABChRwcm9jZXNzb3JfcGVyY2VudGFnZRgDIAEoCUJN8t4fG3lhbWw6InByb2Nlc3Nvcl9wZXJjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSE3Byb2Nlc3NvclBlcmNlbnRhZ2USggEKFXZhbGlkYXRvcnNfcGVyY2VudGFnZRgEIAEoCUJN8t4fG3lhbWw6InZhbGlkYXRvcnNfcGVjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSFHZhbGlkYXRvcnNQZXJjZW50YWdlEhIKBG5hbWUYBSABKAlSBG5hbWU=');
@$core.Deprecated('Use paramsDescriptor instead')
const Params$json = const {
  '1': 'Params',
  '2': const [
    const {
      '1': 'coin_issuers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.CoinIssuer',
      '8': const {},
      '10': 'coinIssuers'
    },
    const {
      '1': 'payment_processors',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.PaymentProcessor',
      '8': const {},
      '10': 'paymentProcessors'
    },
    const {
      '1': 'recipe_fee_percentage',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'recipeFeePercentage'
    },
    const {
      '1': 'item_transfer_fee_percentage',
      '3': 4,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'itemTransferFeePercentage'
    },
    const {
      '1': 'update_item_string_fee',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': const {},
      '10': 'updateItemStringFee'
    },
    const {
      '1': 'min_transfer_fee',
      '3': 6,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'minTransferFee'
    },
    const {
      '1': 'max_transfer_fee',
      '3': 7,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'maxTransferFee'
    },
    const {
      '1': 'update_username_fee',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': const {},
      '10': 'updateUsernameFee'
    },
    const {
      '1': 'distr_epoch_identifier',
      '3': 9,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'distrEpochIdentifier'
    },
    const {
      '1': 'engine_version',
      '3': 10,
      '4': 1,
      '5': 4,
      '8': const {},
      '10': 'engineVersion'
    },
    const {
      '1': 'max_txs_in_block',
      '3': 11,
      '4': 1,
      '5': 4,
      '8': const {},
      '10': 'maxTxsInBlock'
    },
  ],
  '7': const {},
};

/// Descriptor for `Params`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paramsDescriptor = $convert.base64Decode(
    'CgZQYXJhbXMSWQoMY29pbl9pc3N1ZXJzGAEgAygLMhkucHlsb25zLnB5bG9ucy5Db2luSXNzdWVyQhvy3h8TeWFtbDoiY29pbl9pc3N1ZXJzIsjeHwBSC2NvaW5Jc3N1ZXJzEnEKEnBheW1lbnRfcHJvY2Vzc29ycxgCIAMoCzIfLnB5bG9ucy5weWxvbnMuUGF5bWVudFByb2Nlc3NvckIh8t4fGXlhbWw6InBheW1lbnRfcHJvY2Vzc29ycyLI3h8AUhFwYXltZW50UHJvY2Vzc29ycxKCAQoVcmVjaXBlX2ZlZV9wZXJjZW50YWdlGAMgASgJQk7y3h8ceWFtbDoicmVjaXBlX2ZlZV9wZXJjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSE3JlY2lwZUZlZVBlcmNlbnRhZ2USlgEKHGl0ZW1fdHJhbnNmZXJfZmVlX3BlcmNlbnRhZ2UYBCABKAlCVfLeHyN5YW1sOiJpdGVtX3RyYW5zZmVyX2ZlZV9wZXJjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSGWl0ZW1UcmFuc2ZlckZlZVBlcmNlbnRhZ2USdQoWdXBkYXRlX2l0ZW1fc3RyaW5nX2ZlZRgFIAEoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIl8t4fHXlhbWw6InVwZGF0ZV9pdGVtX3N0cmluZ19mZWUiyN4fAFITdXBkYXRlSXRlbVN0cmluZ0ZlZRJzChBtaW5fdHJhbnNmZXJfZmVlGAYgASgJQkny3h8XeWFtbDoibWluX3RyYW5zZmVyX2ZlZSLI3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuSW50Ug5taW5UcmFuc2ZlckZlZRJzChBtYXhfdHJhbnNmZXJfZmVlGAcgASgJQkny3h8XeWFtbDoibWF4X3RyYW5zZmVyX2ZlZSLI3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuSW50Ug5tYXhUcmFuc2ZlckZlZRJtChN1cGRhdGVfdXNlcm5hbWVfZmVlGAggASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQiLy3h8aeWFtbDoidXBkYXRlX3VzZXJuYW1lX2ZlZSLI3h8AUhF1cGRhdGVVc2VybmFtZUZlZRJXChZkaXN0cl9lcG9jaF9pZGVudGlmaWVyGAkgASgJQiHy3h8deWFtbDoiZGlzdHJfZXBvY2hfaWRlbnRpZmllciJSFGRpc3RyRXBvY2hJZGVudGlmaWVyEkAKDmVuZ2luZV92ZXJzaW9uGAogASgEQhny3h8VeWFtbDoiZW5naW5lX3ZlcnNpb24iUg1lbmdpbmVWZXJzaW9uEkQKEG1heF90eHNfaW5fYmxvY2sYCyABKARCG/LeHxd5YW1sOiJtYXhfdHhzX2luX2Jsb2NrIlINbWF4VHhzSW5CbG9jazoEmKAfAA==');
