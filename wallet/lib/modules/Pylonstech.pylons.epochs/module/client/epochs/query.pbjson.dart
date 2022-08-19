///
//  Generated code. Do not modify.
//  source: epochs/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use queryEpochsInfoRequestDescriptor instead')
const QueryEpochsInfoRequest$json = {
  '1': 'QueryEpochsInfoRequest',
};

/// Descriptor for `QueryEpochsInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryEpochsInfoRequestDescriptor =
    $convert.base64Decode('ChZRdWVyeUVwb2Noc0luZm9SZXF1ZXN0');
@$core.Deprecated('Use queryEpochsInfoResponseDescriptor instead')
const QueryEpochsInfoResponse$json = {
  '1': 'QueryEpochsInfoResponse',
  '2': [
    {
      '1': 'epochs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.Pylonstech.pylons.epochs.EpochInfo',
      '8': {},
      '10': 'epochs'
    },
  ],
};

/// Descriptor for `QueryEpochsInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryEpochsInfoResponseDescriptor =
    $convert.base64Decode(
        'ChdRdWVyeUVwb2Noc0luZm9SZXNwb25zZRJBCgZlcG9jaHMYASADKAsyIy5QeWxvbnN0ZWNoLnB5bG9ucy5lcG9jaHMuRXBvY2hJbmZvQgTI3h8AUgZlcG9jaHM=');
@$core.Deprecated('Use queryCurrentEpochRequestDescriptor instead')
const QueryCurrentEpochRequest$json = {
  '1': 'QueryCurrentEpochRequest',
  '2': [
    {'1': 'identifier', '3': 1, '4': 1, '5': 9, '10': 'identifier'},
  ],
};

/// Descriptor for `QueryCurrentEpochRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCurrentEpochRequestDescriptor =
    $convert.base64Decode(
        'ChhRdWVyeUN1cnJlbnRFcG9jaFJlcXVlc3QSHgoKaWRlbnRpZmllchgBIAEoCVIKaWRlbnRpZmllcg==');
@$core.Deprecated('Use queryCurrentEpochResponseDescriptor instead')
const QueryCurrentEpochResponse$json = {
  '1': 'QueryCurrentEpochResponse',
  '2': [
    {'1': 'current_epoch', '3': 1, '4': 1, '5': 3, '10': 'currentEpoch'},
  ],
};

/// Descriptor for `QueryCurrentEpochResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCurrentEpochResponseDescriptor =
    $convert.base64Decode(
        'ChlRdWVyeUN1cnJlbnRFcG9jaFJlc3BvbnNlEiMKDWN1cnJlbnRfZXBvY2gYASABKANSDGN1cnJlbnRFcG9jaA==');
