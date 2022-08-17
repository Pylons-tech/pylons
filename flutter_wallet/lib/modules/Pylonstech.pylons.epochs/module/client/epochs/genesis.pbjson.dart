///
//  Generated code. Do not modify.
//  source: epochs/genesis.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use epochInfoDescriptor instead')
const EpochInfo$json = const {
  '1': 'EpochInfo',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 1, '5': 9, '10': 'identifier'},
    const {'1': 'start_time', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '8': const {}, '10': 'startTime'},
    const {'1': 'duration', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '8': const {}, '10': 'duration'},
    const {'1': 'current_epoch', '3': 4, '4': 1, '5': 3, '10': 'currentEpoch'},
    const {'1': 'current_epoch_start_time', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '8': const {}, '10': 'currentEpochStartTime'},
    const {'1': 'epoch_counting_started', '3': 6, '4': 1, '5': 8, '10': 'epochCountingStarted'},
  ],
  '9': const [
    const {'1': 7, '2': 8},
  ],
};

/// Descriptor for `EpochInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List epochInfoDescriptor = $convert.base64Decode('CglFcG9jaEluZm8SHgoKaWRlbnRpZmllchgBIAEoCVIKaWRlbnRpZmllchJYCgpzdGFydF90aW1lGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEIdkN8fAcjeHwDy3h8ReWFtbDoic3RhcnRfdGltZSJSCXN0YXJ0VGltZRJoCghkdXJhdGlvbhgDIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvbkIxyN4fAJjfHwHq3h8SZHVyYXRpb24sb21pdGVtcHR58t4fD3lhbWw6ImR1cmF0aW9uIlIIZHVyYXRpb24SIwoNY3VycmVudF9lcG9jaBgEIAEoA1IMY3VycmVudEVwb2NoEoABChhjdXJyZW50X2Vwb2NoX3N0YXJ0X3RpbWUYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wQiuQ3x8ByN4fAPLeHx95YW1sOiJjdXJyZW50X2Vwb2NoX3N0YXJ0X3RpbWUiUhVjdXJyZW50RXBvY2hTdGFydFRpbWUSNAoWZXBvY2hfY291bnRpbmdfc3RhcnRlZBgGIAEoCFIUZXBvY2hDb3VudGluZ1N0YXJ0ZWRKBAgHEAg=');
@$core.Deprecated('Use genesisStateDescriptor instead')
const GenesisState$json = const {
  '1': 'GenesisState',
  '2': const [
    const {'1': 'epochs', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.epochs.EpochInfo', '8': const {}, '10': 'epochs'},
  ],
};

/// Descriptor for `GenesisState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genesisStateDescriptor = $convert.base64Decode('CgxHZW5lc2lzU3RhdGUSQQoGZXBvY2hzGAEgAygLMiMuUHlsb25zdGVjaC5weWxvbnMuZXBvY2hzLkVwb2NoSW5mb0IEyN4fAFIGZXBvY2hz');
