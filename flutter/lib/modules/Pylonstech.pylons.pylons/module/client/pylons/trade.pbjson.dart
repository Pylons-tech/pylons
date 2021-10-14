///
//  Generated code. Do not modify.
//  source: pylons/trade.proto
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
    const {'1': 'cookbookID', '3': 1, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'itemID', '3': 2, '4': 1, '5': 9, '10': 'itemID'},
  ],
};

/// Descriptor for `ItemRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemRefDescriptor = $convert.base64Decode('CgdJdGVtUmVmEh4KCmNvb2tib29rSUQYASABKAlSCmNvb2tib29rSUQSFgoGaXRlbUlEGAIgASgJUgZpdGVtSUQ=');
@$core.Deprecated('Use tradeDescriptor instead')
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

/// Descriptor for `Trade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tradeDescriptor = $convert.base64Decode('CgVUcmFkZRIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAklEGAIgASgEUgJJRBJJCgpjb2luSW5wdXRzGAMgAygLMiMuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkNvaW5JbnB1dEIEyN4fAFIKY29pbklucHV0cxJJCgppdGVtSW5wdXRzGAQgAygLMiMuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkl0ZW1JbnB1dEIEyN4fAFIKaXRlbUlucHV0cxJtCgtjb2luT3V0cHV0cxgFIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUgtjb2luT3V0cHV0cxJJCgtpdGVtT3V0cHV0cxgGIAMoCzIhLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5JdGVtUmVmQgTI3h8AUgtpdGVtT3V0cHV0cxIcCglleHRyYUluZm8YByABKAlSCWV4dHJhSW5mbxIaCghyZWNlaXZlchgIIAEoCVIIcmVjZWl2ZXISUwoQdHJhZGVkSXRlbUlucHV0cxgJIAMoCzIhLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5JdGVtUmVmQgTI3h8AUhB0cmFkZWRJdGVtSW5wdXRz');
