///
//  Generated code. Do not modify.
//  source: pylons/pylons/item.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use doubleKeyValueDescriptor instead')
const DoubleKeyValue$json = const {
  '1': 'DoubleKeyValue',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'value'},
  ],
};

/// Descriptor for `DoubleKeyValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleKeyValueDescriptor = $convert.base64Decode('Cg5Eb3VibGVLZXlWYWx1ZRIQCgNrZXkYASABKAlSA2tleRJECgV2YWx1ZRgCIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IFdmFsdWU=');
@$core.Deprecated('Use longKeyValueDescriptor instead')
const LongKeyValue$json = const {
  '1': 'LongKeyValue',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
};

/// Descriptor for `LongKeyValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List longKeyValueDescriptor = $convert.base64Decode('CgxMb25nS2V5VmFsdWUSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKANSBXZhbHVl');
@$core.Deprecated('Use stringKeyValueDescriptor instead')
const StringKeyValue$json = const {
  '1': 'StringKeyValue',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StringKeyValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringKeyValueDescriptor = $convert.base64Decode('Cg5TdHJpbmdLZXlWYWx1ZRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU=');
@$core.Deprecated('Use itemDescriptor instead')
const Item$json = const {
  '1': 'Item',
  '2': const [
    const {'1': 'owner', '3': 1, '4': 1, '5': 9, '10': 'owner'},
    const {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'node_version', '3': 4, '4': 1, '5': 4, '10': 'nodeVersion'},
    const {'1': 'doubles', '3': 5, '4': 3, '5': 11, '6': '.pylons.pylons.DoubleKeyValue', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 6, '4': 3, '5': 11, '6': '.pylons.pylons.LongKeyValue', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 7, '4': 3, '5': 11, '6': '.pylons.pylons.StringKeyValue', '8': const {}, '10': 'strings'},
    const {'1': 'mutable_strings', '3': 8, '4': 3, '5': 11, '6': '.pylons.pylons.StringKeyValue', '8': const {}, '10': 'mutableStrings'},
    const {'1': 'tradeable', '3': 9, '4': 1, '5': 8, '10': 'tradeable'},
    const {'1': 'last_update', '3': 10, '4': 1, '5': 3, '10': 'lastUpdate'},
    const {'1': 'transfer_fee', '3': 11, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'transferFee'},
    const {'1': 'trade_percentage', '3': 12, '4': 1, '5': 9, '8': const {}, '10': 'tradePercentage'},
    const {'1': 'created_at', '3': 13, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 14, '4': 1, '5': 3, '10': 'updatedAt'},
    const {'1': 'recipe_id', '3': 15, '4': 1, '5': 9, '10': 'recipeId'},
  ],
};

/// Descriptor for `Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemDescriptor = $convert.base64Decode('CgRJdGVtEhQKBW93bmVyGAEgASgJUgVvd25lchIfCgtjb29rYm9va19pZBgCIAEoCVIKY29va2Jvb2tJZBIOCgJpZBgDIAEoCVICaWQSIQoMbm9kZV92ZXJzaW9uGAQgASgEUgtub2RlVmVyc2lvbhI9Cgdkb3VibGVzGAUgAygLMh0ucHlsb25zLnB5bG9ucy5Eb3VibGVLZXlWYWx1ZUIEyN4fAFIHZG91YmxlcxI3CgVsb25ncxgGIAMoCzIbLnB5bG9ucy5weWxvbnMuTG9uZ0tleVZhbHVlQgTI3h8AUgVsb25ncxI9CgdzdHJpbmdzGAcgAygLMh0ucHlsb25zLnB5bG9ucy5TdHJpbmdLZXlWYWx1ZUIEyN4fAFIHc3RyaW5ncxJMCg9tdXRhYmxlX3N0cmluZ3MYCCADKAsyHS5weWxvbnMucHlsb25zLlN0cmluZ0tleVZhbHVlQgTI3h8AUg5tdXRhYmxlU3RyaW5ncxIcCgl0cmFkZWFibGUYCSABKAhSCXRyYWRlYWJsZRIfCgtsYXN0X3VwZGF0ZRgKIAEoA1IKbGFzdFVwZGF0ZRJCCgx0cmFuc2Zlcl9mZWUYCyADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CBMjeHwBSC3RyYW5zZmVyRmVlElkKEHRyYWRlX3BlcmNlbnRhZ2UYDCABKAlCLsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSD3RyYWRlUGVyY2VudGFnZRIdCgpjcmVhdGVkX2F0GA0gASgDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgOIAEoA1IJdXBkYXRlZEF0EhsKCXJlY2lwZV9pZBgPIAEoCVIIcmVjaXBlSWQ=');
@$core.Deprecated('Use itemHistoryDescriptor instead')
const ItemHistory$json = const {
  '1': 'ItemHistory',
  '2': const [
    const {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'from', '3': 4, '4': 1, '5': 9, '10': 'from'},
    const {'1': 'to', '3': 5, '4': 1, '5': 9, '10': 'to'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `ItemHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemHistoryDescriptor = $convert.base64Decode('CgtJdGVtSGlzdG9yeRIfCgtjb29rYm9va19pZBgCIAEoCVIKY29va2Jvb2tJZBIOCgJpZBgDIAEoCVICaWQSEgoEZnJvbRgEIAEoCVIEZnJvbRIOCgJ0bxgFIAEoCVICdG8SHQoKY3JlYXRlZF9hdBgGIAEoA1IJY3JlYXRlZEF0');
