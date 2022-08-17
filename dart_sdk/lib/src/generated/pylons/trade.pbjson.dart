///
//  Generated code. Do not modify.
//  source: pylons/pylons/trade.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use itemRefDescriptor instead')
const ItemRef$json = const {
  '1': 'ItemRef',
  '2': const [
    const {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `ItemRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemRefDescriptor = $convert.base64Decode(
    'CgdJdGVtUmVmEh8KC2Nvb2tib29rX2lkGAEgASgJUgpjb29rYm9va0lkEhcKB2l0ZW1faWQYAiABKAlSBml0ZW1JZA==');
@$core.Deprecated('Use tradeDescriptor instead')
const Trade$json = const {
  '1': 'Trade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 4, '10': 'id'},
    const {
      '1': 'coin_inputs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.CoinInput',
      '8': const {},
      '10': 'coinInputs'
    },
    const {
      '1': 'item_inputs',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemInput',
      '8': const {},
      '10': 'itemInputs'
    },
    const {
      '1': 'coin_outputs',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': const {},
      '10': 'coinOutputs'
    },
    const {
      '1': 'item_outputs',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemRef',
      '8': const {},
      '10': 'itemOutputs'
    },
    const {'1': 'extra_info', '3': 7, '4': 1, '5': 9, '10': 'extraInfo'},
    const {'1': 'receiver', '3': 8, '4': 1, '5': 9, '10': 'receiver'},
    const {
      '1': 'traded_item_inputs',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemRef',
      '8': const {},
      '10': 'tradedItemInputs'
    },
  ],
};

/// Descriptor for `Trade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tradeDescriptor = $convert.base64Decode(
    'CgVUcmFkZRIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAmlkGAIgASgEUgJpZBI/Cgtjb2luX2lucHV0cxgDIAMoCzIYLnB5bG9ucy5weWxvbnMuQ29pbklucHV0QgTI3h8AUgpjb2luSW5wdXRzEj8KC2l0ZW1faW5wdXRzGAQgAygLMhgucHlsb25zLnB5bG9ucy5JdGVtSW5wdXRCBMjeHwBSCml0ZW1JbnB1dHMSbgoMY29pbl9vdXRwdXRzGAUgAygLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQjDI3h8Aqt8fKGdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuQ29pbnNSC2NvaW5PdXRwdXRzEj8KDGl0ZW1fb3V0cHV0cxgGIAMoCzIWLnB5bG9ucy5weWxvbnMuSXRlbVJlZkIEyN4fAFILaXRlbU91dHB1dHMSHQoKZXh0cmFfaW5mbxgHIAEoCVIJZXh0cmFJbmZvEhoKCHJlY2VpdmVyGAggASgJUghyZWNlaXZlchJKChJ0cmFkZWRfaXRlbV9pbnB1dHMYCSADKAsyFi5weWxvbnMucHlsb25zLkl0ZW1SZWZCBMjeHwBSEHRyYWRlZEl0ZW1JbnB1dHM=');
