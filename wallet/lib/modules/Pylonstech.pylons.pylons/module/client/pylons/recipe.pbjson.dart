///
import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use doubleInputParamDescriptor instead')
const DoubleInputParam$json = {
  '1': 'DoubleInputParam',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'min_value', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'minValue'},
    {'1': 'max_value', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'maxValue'},
  ],
};

/// Descriptor for `DoubleInputParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleInputParamDescriptor = $convert.base64Decode(
    'ChBEb3VibGVJbnB1dFBhcmFtEhAKA2tleRgBIAEoCVIDa2V5EksKCW1pbl92YWx1ZRgCIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IIbWluVmFsdWUSSwoJbWF4X3ZhbHVlGAMgASgJQi7I3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjUghtYXhWYWx1ZQ==');
@$core.Deprecated('Use longInputParamDescriptor instead')
const LongInputParam$json = {
  '1': 'LongInputParam',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'min_value', '3': 2, '4': 1, '5': 3, '10': 'minValue'},
    {'1': 'max_value', '3': 3, '4': 1, '5': 3, '10': 'maxValue'},
  ],
};

/// Descriptor for `LongInputParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List longInputParamDescriptor = $convert.base64Decode(
    'Cg5Mb25nSW5wdXRQYXJhbRIQCgNrZXkYASABKAlSA2tleRIbCgltaW5fdmFsdWUYAiABKANSCG1pblZhbHVlEhsKCW1heF92YWx1ZRgDIAEoA1IIbWF4VmFsdWU=');
@$core.Deprecated('Use stringInputParamDescriptor instead')
const StringInputParam$json = {
  '1': 'StringInputParam',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StringInputParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringInputParamDescriptor = $convert.base64Decode(
    'ChBTdHJpbmdJbnB1dFBhcmFtEhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZQ==');
@$core.Deprecated('Use itemInputDescriptor instead')
const ItemInput$json = {
  '1': 'ItemInput',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'doubles',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.DoubleInputParam',
      '8': {},
      '10': 'doubles'
    },
    {
      '1': 'longs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.LongInputParam',
      '8': {},
      '10': 'longs'
    },
    {
      '1': 'strings',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.StringInputParam',
      '8': {},
      '10': 'strings'
    },
  ],
};

/// Descriptor for `ItemInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemInputDescriptor = $convert.base64Decode(
    'CglJdGVtSW5wdXQSDgoCaWQYASABKAlSAmlkEj8KB2RvdWJsZXMYAiADKAsyHy5weWxvbnMucHlsb25zLkRvdWJsZUlucHV0UGFyYW1CBMjeHwBSB2RvdWJsZXMSOQoFbG9uZ3MYAyADKAsyHS5weWxvbnMucHlsb25zLkxvbmdJbnB1dFBhcmFtQgTI3h8AUgVsb25ncxI/CgdzdHJpbmdzGAQgAygLMh8ucHlsb25zLnB5bG9ucy5TdHJpbmdJbnB1dFBhcmFtQgTI3h8AUgdzdHJpbmdz');
@$core.Deprecated('Use doubleWeightRangeDescriptor instead')
const DoubleWeightRange$json = {
  '1': 'DoubleWeightRange',
  '2': [
    {'1': 'lower', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'lower'},
    {'1': 'upper', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'upper'},
    {'1': 'weight', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'weight'},
  ],
};

/// Descriptor for `DoubleWeightRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleWeightRangeDescriptor = $convert.base64Decode(
    'ChFEb3VibGVXZWlnaHRSYW5nZRJECgVsb3dlchgBIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IFbG93ZXISRAoFdXBwZXIYAiABKAlCLsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSBXVwcGVyEjMKBndlaWdodBgDIAEoBEIb6t4fF3dlaWdodCxvbWl0ZW1wdHksc3RyaW5nUgZ3ZWlnaHQ=');
@$core.Deprecated('Use doubleParamDescriptor instead')
const DoubleParam$json = {
  '1': 'DoubleParam',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'weightRanges',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.DoubleWeightRange',
      '8': {},
      '10': 'weightRanges'
    },
    {'1': 'program', '3': 3, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `DoubleParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleParamDescriptor = $convert.base64Decode(
    'CgtEb3VibGVQYXJhbRIQCgNrZXkYASABKAlSA2tleRJKCgx3ZWlnaHRSYW5nZXMYAiADKAsyIC5weWxvbnMucHlsb25zLkRvdWJsZVdlaWdodFJhbmdlQgTI3h8AUgx3ZWlnaHRSYW5nZXMSGAoHcHJvZ3JhbRgDIAEoCVIHcHJvZ3JhbQ==');
@$core.Deprecated('Use intWeightRangeDescriptor instead')
const IntWeightRange$json = {
  '1': 'IntWeightRange',
  '2': [
    {'1': 'lower', '3': 1, '4': 1, '5': 3, '8': {}, '10': 'lower'},
    {'1': 'upper', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'upper'},
    {'1': 'weight', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'weight'},
  ],
};

/// Descriptor for `IntWeightRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List intWeightRangeDescriptor = $convert.base64Decode(
    'Cg5JbnRXZWlnaHRSYW5nZRIwCgVsb3dlchgBIAEoA0Ia6t4fFmxvd2VyLG9taXRlbXB0eSxzdHJpbmdSBWxvd2VyEjAKBXVwcGVyGAIgASgDQhrq3h8WdXBwZXIsb21pdGVtcHR5LHN0cmluZ1IFdXBwZXISMwoGd2VpZ2h0GAMgASgEQhvq3h8Xd2VpZ2h0LG9taXRlbXB0eSxzdHJpbmdSBndlaWdodA==');
@$core.Deprecated('Use longParamDescriptor instead')
const LongParam$json = {
  '1': 'LongParam',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'weightRanges',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.IntWeightRange',
      '8': {},
      '10': 'weightRanges'
    },
    {'1': 'program', '3': 3, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `LongParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List longParamDescriptor = $convert.base64Decode(
    'CglMb25nUGFyYW0SEAoDa2V5GAEgASgJUgNrZXkSRwoMd2VpZ2h0UmFuZ2VzGAIgAygLMh0ucHlsb25zLnB5bG9ucy5JbnRXZWlnaHRSYW5nZUIEyN4fAFIMd2VpZ2h0UmFuZ2VzEhgKB3Byb2dyYW0YAyABKAlSB3Byb2dyYW0=');
@$core.Deprecated('Use stringParamDescriptor instead')
const StringParam$json = {
  '1': 'StringParam',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'program', '3': 3, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `StringParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringParamDescriptor = $convert.base64Decode(
    'CgtTdHJpbmdQYXJhbRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWUSGAoHcHJvZ3JhbRgDIAEoCVIHcHJvZ3JhbQ==');
@$core.Deprecated('Use coinOutputDescriptor instead')
const CoinOutput$json = {
  '1': 'CoinOutput',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'coin',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'coin'
    },
    {'1': 'program', '3': 3, '4': 1, '5': 9, '10': 'program'},
  ],
};

/// Descriptor for `CoinOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinOutputDescriptor = $convert.base64Decode(
    'CgpDb2luT3V0cHV0Eg4KAmlkGAEgASgJUgJpZBIzCgRjb2luGAIgASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQgTI3h8AUgRjb2luEhgKB3Byb2dyYW0YAyABKAlSB3Byb2dyYW0=');
@$core.Deprecated('Use itemOutputDescriptor instead')
const ItemOutput$json = {
  '1': 'ItemOutput',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'doubles',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.DoubleParam',
      '8': {},
      '10': 'doubles'
    },
    {
      '1': 'longs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.LongParam',
      '8': {},
      '10': 'longs'
    },
    {
      '1': 'strings',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.StringParam',
      '8': {},
      '10': 'strings'
    },
    {
      '1': 'mutable_strings',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.StringKeyValue',
      '8': {},
      '10': 'mutableStrings'
    },
    {
      '1': 'transfer_fee',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'transferFee'
    },
    {
      '1': 'trade_percentage',
      '3': 7,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'tradePercentage'
    },
    {'1': 'quantity', '3': 8, '4': 1, '5': 4, '8': {}, '10': 'quantity'},
    {
      '1': 'amount_minted',
      '3': 9,
      '4': 1,
      '5': 4,
      '8': {},
      '10': 'amountMinted'
    },
    {'1': 'tradeable', '3': 10, '4': 1, '5': 8, '10': 'tradeable'},
  ],
};

/// Descriptor for `ItemOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemOutputDescriptor = $convert.base64Decode(
    'CgpJdGVtT3V0cHV0Eg4KAmlkGAEgASgJUgJpZBI6Cgdkb3VibGVzGAIgAygLMhoucHlsb25zLnB5bG9ucy5Eb3VibGVQYXJhbUIEyN4fAFIHZG91YmxlcxI0CgVsb25ncxgDIAMoCzIYLnB5bG9ucy5weWxvbnMuTG9uZ1BhcmFtQgTI3h8AUgVsb25ncxI6CgdzdHJpbmdzGAQgAygLMhoucHlsb25zLnB5bG9ucy5TdHJpbmdQYXJhbUIEyN4fAFIHc3RyaW5ncxJMCg9tdXRhYmxlX3N0cmluZ3MYBSADKAsyHS5weWxvbnMucHlsb25zLlN0cmluZ0tleVZhbHVlQgTI3h8AUg5tdXRhYmxlU3RyaW5ncxJCCgx0cmFuc2Zlcl9mZWUYBiADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CBMjeHwBSC3RyYW5zZmVyRmVlElkKEHRyYWRlX3BlcmNlbnRhZ2UYByABKAlCLsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSD3RyYWRlUGVyY2VudGFnZRI5CghxdWFudGl0eRgIIAEoBEId6t4fGXF1YW50aXR5LG9taXRlbXB0eSxzdHJpbmdSCHF1YW50aXR5EkcKDWFtb3VudF9taW50ZWQYCSABKARCIureHx5hbW91bnRfbWludGVkLG9taXRlbXB0eSxzdHJpbmdSDGFtb3VudE1pbnRlZBIcCgl0cmFkZWFibGUYCiABKAhSCXRyYWRlYWJsZQ==');
@$core.Deprecated('Use itemModifyOutputDescriptor instead')
const ItemModifyOutput$json = {
  '1': 'ItemModifyOutput',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'item_input_ref', '3': 2, '4': 1, '5': 9, '10': 'itemInputRef'},
    {
      '1': 'doubles',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.DoubleParam',
      '8': {},
      '10': 'doubles'
    },
    {
      '1': 'longs',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.LongParam',
      '8': {},
      '10': 'longs'
    },
    {
      '1': 'strings',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.StringParam',
      '8': {},
      '10': 'strings'
    },
    {
      '1': 'mutable_strings',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.StringKeyValue',
      '8': {},
      '10': 'mutableStrings'
    },
    {
      '1': 'transfer_fee',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'transferFee'
    },
    {
      '1': 'trade_percentage',
      '3': 8,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'tradePercentage'
    },
    {'1': 'quantity', '3': 9, '4': 1, '5': 4, '8': {}, '10': 'quantity'},
    {
      '1': 'amount_minted',
      '3': 10,
      '4': 1,
      '5': 4,
      '8': {},
      '10': 'amountMinted'
    },
    {'1': 'tradeable', '3': 11, '4': 1, '5': 8, '10': 'tradeable'},
  ],
};

/// Descriptor for `ItemModifyOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemModifyOutputDescriptor = $convert.base64Decode(
    'ChBJdGVtTW9kaWZ5T3V0cHV0Eg4KAmlkGAEgASgJUgJpZBIkCg5pdGVtX2lucHV0X3JlZhgCIAEoCVIMaXRlbUlucHV0UmVmEjoKB2RvdWJsZXMYAyADKAsyGi5weWxvbnMucHlsb25zLkRvdWJsZVBhcmFtQgTI3h8AUgdkb3VibGVzEjQKBWxvbmdzGAQgAygLMhgucHlsb25zLnB5bG9ucy5Mb25nUGFyYW1CBMjeHwBSBWxvbmdzEjoKB3N0cmluZ3MYBSADKAsyGi5weWxvbnMucHlsb25zLlN0cmluZ1BhcmFtQgTI3h8AUgdzdHJpbmdzEkwKD211dGFibGVfc3RyaW5ncxgGIAMoCzIdLnB5bG9ucy5weWxvbnMuU3RyaW5nS2V5VmFsdWVCBMjeHwBSDm11dGFibGVTdHJpbmdzEkIKDHRyYW5zZmVyX2ZlZRgHIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIEyN4fAFILdHJhbnNmZXJGZWUSWQoQdHJhZGVfcGVyY2VudGFnZRgIIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1IPdHJhZGVQZXJjZW50YWdlEjkKCHF1YW50aXR5GAkgASgEQh3q3h8ZcXVhbnRpdHksb21pdGVtcHR5LHN0cmluZ1IIcXVhbnRpdHkSRwoNYW1vdW50X21pbnRlZBgKIAEoBEIi6t4fHmFtb3VudF9taW50ZWQsb21pdGVtcHR5LHN0cmluZ1IMYW1vdW50TWludGVkEhwKCXRyYWRlYWJsZRgLIAEoCFIJdHJhZGVhYmxl');
@$core.Deprecated('Use entriesListDescriptor instead')
const EntriesList$json = {
  '1': 'EntriesList',
  '2': [
    {
      '1': 'coin_outputs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.CoinOutput',
      '8': {},
      '10': 'coinOutputs'
    },
    {
      '1': 'item_outputs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemOutput',
      '8': {},
      '10': 'itemOutputs'
    },
    {
      '1': 'item_modify_outputs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemModifyOutput',
      '8': {},
      '10': 'itemModifyOutputs'
    },
  ],
};

/// Descriptor for `EntriesList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entriesListDescriptor = $convert.base64Decode(
    'CgtFbnRyaWVzTGlzdBJCCgxjb2luX291dHB1dHMYASADKAsyGS5weWxvbnMucHlsb25zLkNvaW5PdXRwdXRCBMjeHwBSC2NvaW5PdXRwdXRzEkIKDGl0ZW1fb3V0cHV0cxgCIAMoCzIZLnB5bG9ucy5weWxvbnMuSXRlbU91dHB1dEIEyN4fAFILaXRlbU91dHB1dHMSVQoTaXRlbV9tb2RpZnlfb3V0cHV0cxgDIAMoCzIfLnB5bG9ucy5weWxvbnMuSXRlbU1vZGlmeU91dHB1dEIEyN4fAFIRaXRlbU1vZGlmeU91dHB1dHM=');
@$core.Deprecated('Use weightedOutputsDescriptor instead')
const WeightedOutputs$json = {
  '1': 'WeightedOutputs',
  '2': [
    {'1': 'entry_ids', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'entryIds'},
    {'1': 'weight', '3': 2, '4': 1, '5': 4, '8': {}, '10': 'weight'},
  ],
};

/// Descriptor for `WeightedOutputs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weightedOutputsDescriptor = $convert.base64Decode(
    'Cg9XZWlnaHRlZE91dHB1dHMSIQoJZW50cnlfaWRzGAEgAygJQgTI3h8AUghlbnRyeUlkcxIzCgZ3ZWlnaHQYAiABKARCG+reHxd3ZWlnaHQsb21pdGVtcHR5LHN0cmluZ1IGd2VpZ2h0');
@$core.Deprecated('Use coinInputDescriptor instead')
const CoinInput$json = {
  '1': 'CoinInput',
  '2': [
    {
      '1': 'coins',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'coins'
    },
  ],
};

/// Descriptor for `CoinInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinInputDescriptor = $convert.base64Decode(
    'CglDb2luSW5wdXQSYQoFY29pbnMYASADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1IFY29pbnM=');
@$core.Deprecated('Use recipeDescriptor instead')
const Recipe$json = {
  '1': 'Recipe',
  '2': [
    {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'node_version', '3': 3, '4': 1, '5': 4, '10': 'nodeVersion'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'coin_inputs',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.CoinInput',
      '8': {},
      '10': 'coinInputs'
    },
    {
      '1': 'item_inputs',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemInput',
      '8': {},
      '10': 'itemInputs'
    },
    {
      '1': 'entries',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.EntriesList',
      '8': {},
      '10': 'entries'
    },
    {
      '1': 'outputs',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.WeightedOutputs',
      '8': {},
      '10': 'outputs'
    },
    {'1': 'block_interval', '3': 11, '4': 1, '5': 3, '10': 'blockInterval'},
    {
      '1': 'cost_per_block',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'costPerBlock'
    },
    {'1': 'enabled', '3': 13, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'extra_info', '3': 14, '4': 1, '5': 9, '10': 'extraInfo'},
    {'1': 'created_at', '3': 15, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 16, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Recipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeDescriptor = $convert.base64Decode(
    'CgZSZWNpcGUSHwoLY29va2Jvb2tfaWQYASABKAlSCmNvb2tib29rSWQSDgoCaWQYAiABKAlSAmlkEiEKDG5vZGVfdmVyc2lvbhgDIAEoBFILbm9kZVZlcnNpb24SEgoEbmFtZRgEIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SGAoHdmVyc2lvbhgGIAEoCVIHdmVyc2lvbhI/Cgtjb2luX2lucHV0cxgHIAMoCzIYLnB5bG9ucy5weWxvbnMuQ29pbklucHV0QgTI3h8AUgpjb2luSW5wdXRzEj8KC2l0ZW1faW5wdXRzGAggAygLMhgucHlsb25zLnB5bG9ucy5JdGVtSW5wdXRCBMjeHwBSCml0ZW1JbnB1dHMSOgoHZW50cmllcxgJIAEoCzIaLnB5bG9ucy5weWxvbnMuRW50cmllc0xpc3RCBMjeHwBSB2VudHJpZXMSPgoHb3V0cHV0cxgKIAMoCzIeLnB5bG9ucy5weWxvbnMuV2VpZ2h0ZWRPdXRwdXRzQgTI3h8AUgdvdXRwdXRzEiUKDmJsb2NrX2ludGVydmFsGAsgASgDUg1ibG9ja0ludGVydmFsEkUKDmNvc3RfcGVyX2Jsb2NrGAwgASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQgTI3h8AUgxjb3N0UGVyQmxvY2sSGAoHZW5hYmxlZBgNIAEoCFIHZW5hYmxlZBIdCgpleHRyYV9pbmZvGA4gASgJUglleHRyYUluZm8SHQoKY3JlYXRlZF9hdBgPIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYECABKANSCXVwZGF0ZWRBdA==');
