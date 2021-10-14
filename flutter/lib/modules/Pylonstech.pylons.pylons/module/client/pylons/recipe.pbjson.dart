///
//  Generated code. Do not modify.
//  source: pylons/recipe.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use doubleInputParamDescriptor instead')
const DoubleInputParam$json = const {
  '1': 'DoubleInputParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'minValue', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'minValue'},
    const {'1': 'maxValue', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'maxValue'},
  ],
};

/// Descriptor for `DoubleInputParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleInputParamDescriptor = $convert.base64Decode('ChBEb3VibGVJbnB1dFBhcmFtEhAKA2tleRgBIAEoCVIDa2V5EkoKCG1pblZhbHVlGAIgASgJQi7I3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjUghtaW5WYWx1ZRJKCghtYXhWYWx1ZRgDIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IIbWF4VmFsdWU=');
@$core.Deprecated('Use longInputParamDescriptor instead')
const LongInputParam$json = const {
  '1': 'LongInputParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'minValue', '3': 2, '4': 1, '5': 3, '10': 'minValue'},
    const {'1': 'maxValue', '3': 3, '4': 1, '5': 3, '10': 'maxValue'},
  ],
};

/// Descriptor for `LongInputParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List longInputParamDescriptor = $convert.base64Decode('Cg5Mb25nSW5wdXRQYXJhbRIQCgNrZXkYASABKAlSA2tleRIaCghtaW5WYWx1ZRgCIAEoA1IIbWluVmFsdWUSGgoIbWF4VmFsdWUYAyABKANSCG1heFZhbHVl');
@$core.Deprecated('Use stringInputParamDescriptor instead')
const StringInputParam$json = const {
  '1': 'StringInputParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StringInputParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringInputParamDescriptor = $convert.base64Decode('ChBTdHJpbmdJbnB1dFBhcmFtEhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZQ==');
@$core.Deprecated('Use conditionListDescriptor instead')
const ConditionList$json = const {
  '1': 'ConditionList',
  '2': const [
    const {'1': 'doubles', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleInputParam', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongInputParam', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringInputParam', '8': const {}, '10': 'strings'},
  ],
};

/// Descriptor for `ConditionList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conditionListDescriptor = $convert.base64Decode('Cg1Db25kaXRpb25MaXN0EkoKB2RvdWJsZXMYASADKAsyKi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuRG91YmxlSW5wdXRQYXJhbUIEyN4fAFIHZG91YmxlcxJECgVsb25ncxgCIAMoCzIoLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Mb25nSW5wdXRQYXJhbUIEyN4fAFIFbG9uZ3MSSgoHc3RyaW5ncxgDIAMoCzIqLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5TdHJpbmdJbnB1dFBhcmFtQgTI3h8AUgdzdHJpbmdz');
@$core.Deprecated('Use itemInputDescriptor instead')
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

/// Descriptor for `ItemInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemInputDescriptor = $convert.base64Decode('CglJdGVtSW5wdXQSDgoCSUQYASABKAlSAklEEkoKB2RvdWJsZXMYAiADKAsyKi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuRG91YmxlSW5wdXRQYXJhbUIEyN4fAFIHZG91YmxlcxJECgVsb25ncxgDIAMoCzIoLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Mb25nSW5wdXRQYXJhbUIEyN4fAFIFbG9uZ3MSSgoHc3RyaW5ncxgEIAMoCzIqLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5TdHJpbmdJbnB1dFBhcmFtQgTI3h8AUgdzdHJpbmdzEk0KCmNvbmRpdGlvbnMYBSABKAsyJy5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuQ29uZGl0aW9uTGlzdEIEyN4fAFIKY29uZGl0aW9ucw==');
@$core.Deprecated('Use doubleWeightRangeDescriptor instead')
const DoubleWeightRange$json = const {
  '1': 'DoubleWeightRange',
  '2': const [
    const {'1': 'lower', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'lower'},
    const {'1': 'upper', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'upper'},
    const {'1': 'weight', '3': 3, '4': 1, '5': 4, '10': 'weight'},
  ],
};

/// Descriptor for `DoubleWeightRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleWeightRangeDescriptor = $convert.base64Decode('ChFEb3VibGVXZWlnaHRSYW5nZRJECgVsb3dlchgBIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IFbG93ZXISRAoFdXBwZXIYAiABKAlCLsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSBXVwcGVyEhYKBndlaWdodBgDIAEoBFIGd2VpZ2h0');
@$core.Deprecated('Use doubleParamDescriptor instead')
const DoubleParam$json = const {
  '1': 'DoubleParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'rate', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'rate'},
    const {'1': 'weightRanges', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleWeightRange', '8': const {}, '10': 'weightRanges'},
    const {'1': 'program', '3': 4, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `DoubleParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleParamDescriptor = $convert.base64Decode('CgtEb3VibGVQYXJhbRIQCgNrZXkYASABKAlSA2tleRJCCgRyYXRlGAIgASgJQi7I3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjUgRyYXRlElUKDHdlaWdodFJhbmdlcxgDIAMoCzIrLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Eb3VibGVXZWlnaHRSYW5nZUIEyN4fAFIMd2VpZ2h0UmFuZ2VzEhgKB3Byb2dyYW0YBCABKAlSB3Byb2dyYW0=');
@$core.Deprecated('Use intWeightRangeDescriptor instead')
const IntWeightRange$json = const {
  '1': 'IntWeightRange',
  '2': const [
    const {'1': 'lower', '3': 1, '4': 1, '5': 3, '10': 'lower'},
    const {'1': 'upper', '3': 2, '4': 1, '5': 3, '10': 'upper'},
    const {'1': 'weight', '3': 3, '4': 1, '5': 4, '10': 'weight'},
  ],
};

/// Descriptor for `IntWeightRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List intWeightRangeDescriptor = $convert.base64Decode('Cg5JbnRXZWlnaHRSYW5nZRIUCgVsb3dlchgBIAEoA1IFbG93ZXISFAoFdXBwZXIYAiABKANSBXVwcGVyEhYKBndlaWdodBgDIAEoBFIGd2VpZ2h0');
@$core.Deprecated('Use longParamDescriptor instead')
const LongParam$json = const {
  '1': 'LongParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'rate', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'rate'},
    const {'1': 'weightRanges', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.IntWeightRange', '8': const {}, '10': 'weightRanges'},
    const {'1': 'program', '3': 4, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `LongParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List longParamDescriptor = $convert.base64Decode('CglMb25nUGFyYW0SEAoDa2V5GAEgASgJUgNrZXkSQgoEcmF0ZRgCIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IEcmF0ZRJSCgx3ZWlnaHRSYW5nZXMYAyADKAsyKC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuSW50V2VpZ2h0UmFuZ2VCBMjeHwBSDHdlaWdodFJhbmdlcxIYCgdwcm9ncmFtGAQgASgJUgdwcm9ncmFt');
@$core.Deprecated('Use stringParamDescriptor instead')
const StringParam$json = const {
  '1': 'StringParam',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'rate', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'rate'},
    const {'1': 'value', '3': 3, '4': 1, '5': 9, '10': 'value'},
    const {'1': 'program', '3': 4, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `StringParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringParamDescriptor = $convert.base64Decode('CgtTdHJpbmdQYXJhbRIQCgNrZXkYASABKAlSA2tleRJCCgRyYXRlGAIgASgJQi7I3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjUgRyYXRlEhQKBXZhbHVlGAMgASgJUgV2YWx1ZRIYCgdwcm9ncmFtGAQgASgJUgdwcm9ncmFt');
@$core.Deprecated('Use coinOutputDescriptor instead')
const CoinOutput$json = const {
  '1': 'CoinOutput',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'coin', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coin'},
    const {'1': 'program', '3': 3, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `CoinOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinOutputDescriptor = $convert.base64Decode('CgpDb2luT3V0cHV0Eg4KAklEGAEgASgJUgJJRBIzCgRjb2luGAIgASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQgTI3h8AUgRjb2luEhgKB3Byb2dyYW0YAyABKAlSB3Byb2dyYW0=');
@$core.Deprecated('Use itemOutputDescriptor instead')
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

/// Descriptor for `ItemOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemOutputDescriptor = $convert.base64Decode('CgpJdGVtT3V0cHV0Eg4KAklEGAEgASgJUgJJRBJFCgdkb3VibGVzGAIgAygLMiUuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkRvdWJsZVBhcmFtQgTI3h8AUgdkb3VibGVzEj8KBWxvbmdzGAMgAygLMiMuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkxvbmdQYXJhbUIEyN4fAFIFbG9uZ3MSRQoHc3RyaW5ncxgEIAMoCzIlLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5TdHJpbmdQYXJhbUIEyN4fAFIHc3RyaW5ncxJWCg5tdXRhYmxlU3RyaW5ncxgFIAMoCzIoLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5TdHJpbmdLZXlWYWx1ZUIEyN4fAFIObXV0YWJsZVN0cmluZ3MSQQoLdHJhbnNmZXJGZWUYBiADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CBMjeHwBSC3RyYW5zZmVyRmVlElgKD3RyYWRlUGVyY2VudGFnZRgHIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IPdHJhZGVQZXJjZW50YWdlEhoKCHF1YW50aXR5GAggASgEUghxdWFudGl0eRIiCgxhbW91bnRNaW50ZWQYCSABKARSDGFtb3VudE1pbnRlZBIcCgl0cmFkZWFibGUYCiABKAhSCXRyYWRlYWJsZQ==');
@$core.Deprecated('Use itemModifyOutputDescriptor instead')
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

/// Descriptor for `ItemModifyOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemModifyOutputDescriptor = $convert.base64Decode('ChBJdGVtTW9kaWZ5T3V0cHV0Eg4KAklEGAEgASgJUgJJRBIiCgxpdGVtSW5wdXRSZWYYAiABKAlSDGl0ZW1JbnB1dFJlZhJFCgdkb3VibGVzGAMgAygLMiUuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkRvdWJsZVBhcmFtQgTI3h8AUgdkb3VibGVzEj8KBWxvbmdzGAQgAygLMiMuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkxvbmdQYXJhbUIEyN4fAFIFbG9uZ3MSRQoHc3RyaW5ncxgFIAMoCzIlLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5TdHJpbmdQYXJhbUIEyN4fAFIHc3RyaW5ncxJWCg5tdXRhYmxlU3RyaW5ncxgGIAMoCzIoLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5TdHJpbmdLZXlWYWx1ZUIEyN4fAFIObXV0YWJsZVN0cmluZ3MSQQoLdHJhbnNmZXJGZWUYByADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CBMjeHwBSC3RyYW5zZmVyRmVlElgKD3RyYWRlUGVyY2VudGFnZRgIIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IPdHJhZGVQZXJjZW50YWdlEhoKCHF1YW50aXR5GAkgASgEUghxdWFudGl0eRIiCgxhbW91bnRNaW50ZWQYCiABKARSDGFtb3VudE1pbnRlZBIcCgl0cmFkZWFibGUYCyABKAhSCXRyYWRlYWJsZQ==');
@$core.Deprecated('Use entriesListDescriptor instead')
const EntriesList$json = const {
  '1': 'EntriesList',
  '2': const [
    const {'1': 'coinOutputs', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinOutput', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'itemOutputs', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemOutput', '8': const {}, '10': 'itemOutputs'},
    const {'1': 'itemModifyOutputs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemModifyOutput', '8': const {}, '10': 'itemModifyOutputs'},
  ],
};

/// Descriptor for `EntriesList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entriesListDescriptor = $convert.base64Decode('CgtFbnRyaWVzTGlzdBJMCgtjb2luT3V0cHV0cxgBIAMoCzIkLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Db2luT3V0cHV0QgTI3h8AUgtjb2luT3V0cHV0cxJMCgtpdGVtT3V0cHV0cxgCIAMoCzIkLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5JdGVtT3V0cHV0QgTI3h8AUgtpdGVtT3V0cHV0cxJeChFpdGVtTW9kaWZ5T3V0cHV0cxgDIAMoCzIqLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5JdGVtTW9kaWZ5T3V0cHV0QgTI3h8AUhFpdGVtTW9kaWZ5T3V0cHV0cw==');
@$core.Deprecated('Use weightedOutputsDescriptor instead')
const WeightedOutputs$json = const {
  '1': 'WeightedOutputs',
  '2': const [
    const {'1': 'entryIDs', '3': 1, '4': 3, '5': 9, '8': const {}, '10': 'entryIDs'},
    const {'1': 'weight', '3': 2, '4': 1, '5': 4, '10': 'weight'},
  ],
};

/// Descriptor for `WeightedOutputs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weightedOutputsDescriptor = $convert.base64Decode('Cg9XZWlnaHRlZE91dHB1dHMSIAoIZW50cnlJRHMYASADKAlCBMjeHwBSCGVudHJ5SURzEhYKBndlaWdodBgCIAEoBFIGd2VpZ2h0');
@$core.Deprecated('Use coinInputDescriptor instead')
const CoinInput$json = const {
  '1': 'CoinInput',
  '2': const [
    const {'1': 'coins', '3': 1, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coins'},
  ],
};

/// Descriptor for `CoinInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinInputDescriptor = $convert.base64Decode('CglDb2luSW5wdXQSYQoFY29pbnMYASADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1IFY29pbnM=');
@$core.Deprecated('Use recipeDescriptor instead')
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

/// Descriptor for `Recipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeDescriptor = $convert.base64Decode('CgZSZWNpcGUSHgoKY29va2Jvb2tJRBgBIAEoCVIKY29va2Jvb2tJRBIOCgJJRBgCIAEoCVICSUQSIAoLbm9kZVZlcnNpb24YAyABKAlSC25vZGVWZXJzaW9uEhIKBG5hbWUYBCABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEhgKB3ZlcnNpb24YBiABKAlSB3ZlcnNpb24SSQoKY29pbklucHV0cxgHIAMoCzIjLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Db2luSW5wdXRCBMjeHwBSCmNvaW5JbnB1dHMSSQoKaXRlbUlucHV0cxgIIAMoCzIjLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5JdGVtSW5wdXRCBMjeHwBSCml0ZW1JbnB1dHMSRQoHZW50cmllcxgJIAEoCzIlLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5FbnRyaWVzTGlzdEIEyN4fAFIHZW50cmllcxJJCgdvdXRwdXRzGAogAygLMikuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLldlaWdodGVkT3V0cHV0c0IEyN4fAFIHb3V0cHV0cxIkCg1ibG9ja0ludGVydmFsGAsgASgDUg1ibG9ja0ludGVydmFsEhgKB2VuYWJsZWQYDCABKAhSB2VuYWJsZWQSHAoJZXh0cmFJbmZvGA0gASgJUglleHRyYUluZm8=');
