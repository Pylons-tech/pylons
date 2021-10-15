///
//  Generated code. Do not modify.
//  source: pylons/item.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use doubleKeyValueDescriptor instead')
const DoubleKeyValue$json = const {
  '1': 'DoubleKeyValue',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'Value'},
  ],
};

/// Descriptor for `DoubleKeyValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleKeyValueDescriptor = $convert.base64Decode('Cg5Eb3VibGVLZXlWYWx1ZRIQCgNLZXkYASABKAlSA0tleRJECgVWYWx1ZRgCIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IFVmFsdWU=');
@$core.Deprecated('Use longKeyValueDescriptor instead')
const LongKeyValue$json = const {
  '1': 'LongKeyValue',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 3, '10': 'Value'},
  ],
};

/// Descriptor for `LongKeyValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List longKeyValueDescriptor = $convert.base64Decode('CgxMb25nS2V5VmFsdWUSEAoDS2V5GAEgASgJUgNLZXkSFAoFVmFsdWUYAiABKANSBVZhbHVl');
@$core.Deprecated('Use stringKeyValueDescriptor instead')
const StringKeyValue$json = const {
  '1': 'StringKeyValue',
  '2': const [
    const {'1': 'Key', '3': 1, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 9, '10': 'Value'},
  ],
};

/// Descriptor for `StringKeyValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringKeyValueDescriptor = $convert.base64Decode('Cg5TdHJpbmdLZXlWYWx1ZRIQCgNLZXkYASABKAlSA0tleRIUCgVWYWx1ZRgCIAEoCVIFVmFsdWU=');
@$core.Deprecated('Use itemDescriptor instead')
const Item$json = const {
  '1': 'Item',
  '2': const [
    const {'1': 'owner', '3': 1, '4': 1, '5': 9, '10': 'owner'},
    const {'1': 'cookbookID', '3': 2, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'nodeVersion', '3': 4, '4': 1, '5': 9, '10': 'nodeVersion'},
    const {'1': 'doubles', '3': 5, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleKeyValue', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 6, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongKeyValue', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 7, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringKeyValue', '8': const {}, '10': 'strings'},
    const {'1': 'mutableStrings', '3': 8, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringKeyValue', '8': const {}, '10': 'mutableStrings'},
    const {'1': 'tradeable', '3': 9, '4': 1, '5': 8, '10': 'tradeable'},
    const {'1': 'lastUpdate', '3': 10, '4': 1, '5': 3, '10': 'lastUpdate'},
    const {'1': 'transferFee', '3': 11, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'transferFee'},
    const {'1': 'tradePercentage', '3': 12, '4': 1, '5': 9, '8': const {}, '10': 'tradePercentage'},
  ],
};

/// Descriptor for `Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemDescriptor = $convert.base64Decode('CgRJdGVtEhQKBW93bmVyGAEgASgJUgVvd25lchIeCgpjb29rYm9va0lEGAIgASgJUgpjb29rYm9va0lEEg4KAklEGAMgASgJUgJJRBIgCgtub2RlVmVyc2lvbhgEIAEoCVILbm9kZVZlcnNpb24SSAoHZG91YmxlcxgFIAMoCzIoLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Eb3VibGVLZXlWYWx1ZUIEyN4fAFIHZG91YmxlcxJCCgVsb25ncxgGIAMoCzImLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Mb25nS2V5VmFsdWVCBMjeHwBSBWxvbmdzEkgKB3N0cmluZ3MYByADKAsyKC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuU3RyaW5nS2V5VmFsdWVCBMjeHwBSB3N0cmluZ3MSVgoObXV0YWJsZVN0cmluZ3MYCCADKAsyKC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuU3RyaW5nS2V5VmFsdWVCBMjeHwBSDm11dGFibGVTdHJpbmdzEhwKCXRyYWRlYWJsZRgJIAEoCFIJdHJhZGVhYmxlEh4KCmxhc3RVcGRhdGUYCiABKANSCmxhc3RVcGRhdGUSQQoLdHJhbnNmZXJGZWUYCyADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CBMjeHwBSC3RyYW5zZmVyRmVlElgKD3RyYWRlUGVyY2VudGFnZRgMIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IPdHJhZGVQZXJjZW50YWdl');
