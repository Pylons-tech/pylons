///
//  Generated code. Do not modify.
//  source: ibc/core/port/v1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use queryAppVersionRequestDescriptor instead')
const QueryAppVersionRequest$json = {
  '1': 'QueryAppVersionRequest',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    {'1': 'connection_id', '3': 2, '4': 1, '5': 9, '10': 'connectionId'},
    {
      '1': 'ordering',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.ibc.core.channel.v1.Order',
      '10': 'ordering'
    },
    {
      '1': 'counterparty',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.channel.v1.Counterparty',
      '10': 'counterparty'
    },
    {'1': 'proposed_version', '3': 5, '4': 1, '5': 9, '10': 'proposedVersion'},
  ],
};

/// Descriptor for `QueryAppVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAppVersionRequestDescriptor =
    $convert.base64Decode(
        'ChZRdWVyeUFwcFZlcnNpb25SZXF1ZXN0EhcKB3BvcnRfaWQYASABKAlSBnBvcnRJZBIjCg1jb25uZWN0aW9uX2lkGAIgASgJUgxjb25uZWN0aW9uSWQSNgoIb3JkZXJpbmcYAyABKA4yGi5pYmMuY29yZS5jaGFubmVsLnYxLk9yZGVyUghvcmRlcmluZxJFCgxjb3VudGVycGFydHkYBCABKAsyIS5pYmMuY29yZS5jaGFubmVsLnYxLkNvdW50ZXJwYXJ0eVIMY291bnRlcnBhcnR5EikKEHByb3Bvc2VkX3ZlcnNpb24YBSABKAlSD3Byb3Bvc2VkVmVyc2lvbg==');
@$core.Deprecated('Use queryAppVersionResponseDescriptor instead')
const QueryAppVersionResponse$json = {
  '1': 'QueryAppVersionResponse',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `QueryAppVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAppVersionResponseDescriptor =
    $convert.base64Decode(
        'ChdRdWVyeUFwcFZlcnNpb25SZXNwb25zZRIXCgdwb3J0X2lkGAEgASgJUgZwb3J0SWQSGAoHdmVyc2lvbhgCIAEoCVIHdmVyc2lvbg==');
