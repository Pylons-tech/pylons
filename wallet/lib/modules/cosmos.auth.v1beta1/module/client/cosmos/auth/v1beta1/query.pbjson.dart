///
//  Generated code. Do not modify.
//  source: cosmos/auth/v1beta1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use queryAccountsRequestDescriptor instead')
const QueryAccountsRequest$json = {
  '1': 'QueryAccountsRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryAccountsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAccountsRequestDescriptor = $convert.base64Decode(
    'ChRRdWVyeUFjY291bnRzUmVxdWVzdBJGCgpwYWdpbmF0aW9uGAEgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryAccountsResponseDescriptor instead')
const QueryAccountsResponse$json = {
  '1': 'QueryAccountsResponse',
  '2': [
    {
      '1': 'accounts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.Any',
      '8': {},
      '10': 'accounts'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryAccountsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAccountsResponseDescriptor = $convert.base64Decode(
    'ChVRdWVyeUFjY291bnRzUmVzcG9uc2USPgoIYWNjb3VudHMYASADKAsyFC5nb29nbGUucHJvdG9idWYuQW55QgzKtC0IQWNjb3VudElSCGFjY291bnRzEkcKCnBhZ2luYXRpb24YAiABKAsyJy5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXNwb25zZVIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryAccountRequestDescriptor instead')
const QueryAccountRequest$json = {
  '1': 'QueryAccountRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
  '7': {},
};

/// Descriptor for `QueryAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAccountRequestDescriptor = $convert.base64Decode(
    'ChNRdWVyeUFjY291bnRSZXF1ZXN0EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3M6COigHwCIoB8A');
@$core.Deprecated('Use queryAccountResponseDescriptor instead')
const QueryAccountResponse$json = {
  '1': 'QueryAccountResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '8': {},
      '10': 'account'
    },
  ],
};

/// Descriptor for `QueryAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAccountResponseDescriptor = $convert.base64Decode(
    'ChRRdWVyeUFjY291bnRSZXNwb25zZRI8CgdhY2NvdW50GAEgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueUIMyrQtCEFjY291bnRJUgdhY2NvdW50');
@$core.Deprecated('Use queryParamsRequestDescriptor instead')
const QueryParamsRequest$json = {
  '1': 'QueryParamsRequest',
};

/// Descriptor for `QueryParamsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryParamsRequestDescriptor =
    $convert.base64Decode('ChJRdWVyeVBhcmFtc1JlcXVlc3Q=');
@$core.Deprecated('Use queryParamsResponseDescriptor instead')
const QueryParamsResponse$json = {
  '1': 'QueryParamsResponse',
  '2': [
    {
      '1': 'params',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.auth.v1beta1.Params',
      '8': {},
      '10': 'params'
    },
  ],
};

/// Descriptor for `QueryParamsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryParamsResponseDescriptor = $convert.base64Decode(
    'ChNRdWVyeVBhcmFtc1Jlc3BvbnNlEjkKBnBhcmFtcxgBIAEoCzIbLmNvc21vcy5hdXRoLnYxYmV0YTEuUGFyYW1zQgTI3h8AUgZwYXJhbXM=');
