///
//  Generated code. Do not modify.
//  source: epochs/event.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use eventEndEpochDescriptor instead')
const EventEndEpoch$json = const {
  '1': 'EventEndEpoch',
  '2': const [
    const {'1': 'current_epoch', '3': 1, '4': 1, '5': 3, '10': 'currentEpoch'},
  ],
};

/// Descriptor for `EventEndEpoch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventEndEpochDescriptor = $convert.base64Decode('Cg1FdmVudEVuZEVwb2NoEiMKDWN1cnJlbnRfZXBvY2gYASABKANSDGN1cnJlbnRFcG9jaA==');
@$core.Deprecated('Use eventBeginEpochDescriptor instead')
const EventBeginEpoch$json = const {
  '1': 'EventBeginEpoch',
  '2': const [
    const {'1': 'current_epoch', '3': 1, '4': 1, '5': 3, '10': 'currentEpoch'},
    const {'1': 'start_time', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '8': const {}, '10': 'startTime'},
  ],
};

/// Descriptor for `EventBeginEpoch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventBeginEpochDescriptor = $convert.base64Decode('Cg9FdmVudEJlZ2luRXBvY2gSIwoNY3VycmVudF9lcG9jaBgBIAEoA1IMY3VycmVudEVwb2NoElgKCnN0YXJ0X3RpbWUYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wQh2Q3x8ByN4fAPLeHxF5YW1sOiJzdGFydF90aW1lIlIJc3RhcnRUaW1l');
