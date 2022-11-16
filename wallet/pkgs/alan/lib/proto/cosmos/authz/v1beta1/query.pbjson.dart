///
//  Generated code. Do not modify.
//  source: cosmos/authz/v1beta1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use queryGrantsRequestDescriptor instead')
const QueryGrantsRequest$json = const {
  '1': 'QueryGrantsRequest',
  '2': const [
    const {'1': 'granter', '3': 1, '4': 1, '5': 9, '10': 'granter'},
    const {'1': 'grantee', '3': 2, '4': 1, '5': 9, '10': 'grantee'},
    const {'1': 'msg_type_url', '3': 3, '4': 1, '5': 9, '10': 'msgTypeUrl'},
    const {'1': 'pagination', '3': 4, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryGrantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGrantsRequestDescriptor = $convert.base64Decode('ChJRdWVyeUdyYW50c1JlcXVlc3QSGAoHZ3JhbnRlchgBIAEoCVIHZ3JhbnRlchIYCgdncmFudGVlGAIgASgJUgdncmFudGVlEiAKDG1zZ190eXBlX3VybBgDIAEoCVIKbXNnVHlwZVVybBJGCgpwYWdpbmF0aW9uGAQgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryGrantsResponseDescriptor instead')
const QueryGrantsResponse$json = const {
  '1': 'QueryGrantsResponse',
  '2': const [
    const {'1': 'grants', '3': 1, '4': 3, '5': 11, '6': '.cosmos.authz.v1beta1.Grant', '10': 'grants'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryGrantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGrantsResponseDescriptor = $convert.base64Decode('ChNRdWVyeUdyYW50c1Jlc3BvbnNlEjMKBmdyYW50cxgBIAMoCzIbLmNvc21vcy5hdXRoei52MWJldGExLkdyYW50UgZncmFudHMSRwoKcGFnaW5hdGlvbhgCIAEoCzInLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlc3BvbnNlUgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryGranterGrantsRequestDescriptor instead')
const QueryGranterGrantsRequest$json = const {
  '1': 'QueryGranterGrantsRequest',
  '2': const [
    const {'1': 'granter', '3': 1, '4': 1, '5': 9, '10': 'granter'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryGranterGrantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGranterGrantsRequestDescriptor = $convert.base64Decode('ChlRdWVyeUdyYW50ZXJHcmFudHNSZXF1ZXN0EhgKB2dyYW50ZXIYASABKAlSB2dyYW50ZXISRgoKcGFnaW5hdGlvbhgCIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryGranterGrantsResponseDescriptor instead')
const QueryGranterGrantsResponse$json = const {
  '1': 'QueryGranterGrantsResponse',
  '2': const [
    const {'1': 'grants', '3': 1, '4': 3, '5': 11, '6': '.cosmos.authz.v1beta1.GrantAuthorization', '10': 'grants'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryGranterGrantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGranterGrantsResponseDescriptor = $convert.base64Decode('ChpRdWVyeUdyYW50ZXJHcmFudHNSZXNwb25zZRJACgZncmFudHMYASADKAsyKC5jb3Ntb3MuYXV0aHoudjFiZXRhMS5HcmFudEF1dGhvcml6YXRpb25SBmdyYW50cxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryGranteeGrantsRequestDescriptor instead')
const QueryGranteeGrantsRequest$json = const {
  '1': 'QueryGranteeGrantsRequest',
  '2': const [
    const {'1': 'grantee', '3': 1, '4': 1, '5': 9, '10': 'grantee'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryGranteeGrantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGranteeGrantsRequestDescriptor = $convert.base64Decode('ChlRdWVyeUdyYW50ZWVHcmFudHNSZXF1ZXN0EhgKB2dyYW50ZWUYASABKAlSB2dyYW50ZWUSRgoKcGFnaW5hdGlvbhgCIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryGranteeGrantsResponseDescriptor instead')
const QueryGranteeGrantsResponse$json = const {
  '1': 'QueryGranteeGrantsResponse',
  '2': const [
    const {'1': 'grants', '3': 1, '4': 3, '5': 11, '6': '.cosmos.authz.v1beta1.GrantAuthorization', '10': 'grants'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryGranteeGrantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGranteeGrantsResponseDescriptor = $convert.base64Decode('ChpRdWVyeUdyYW50ZWVHcmFudHNSZXNwb25zZRJACgZncmFudHMYASADKAsyKC5jb3Ntb3MuYXV0aHoudjFiZXRhMS5HcmFudEF1dGhvcml6YXRpb25SBmdyYW50cxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24=');
