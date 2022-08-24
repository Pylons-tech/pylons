///
//  Generated code. Do not modify.
//  source: cosmos/authz/v1beta1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../../base/query/v1beta1/pagination.pbjson.dart' as $2;
import 'authz.pbjson.dart' as $3;
import '../../../google/protobuf/any.pbjson.dart' as $0;
import '../../../google/protobuf/timestamp.pbjson.dart' as $1;

@$core.Deprecated('Use queryGrantsRequestDescriptor instead')
const QueryGrantsRequest$json = const {
  '1': 'QueryGrantsRequest',
  '2': const [
    const {'1': 'granter', '3': 1, '4': 1, '5': 9, '10': 'granter'},
    const {'1': 'grantee', '3': 2, '4': 1, '5': 9, '10': 'grantee'},
    const {'1': 'msg_type_url', '3': 3, '4': 1, '5': 9, '10': 'msgTypeUrl'},
    const {
      '1': 'pagination',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryGrantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGrantsRequestDescriptor = $convert.base64Decode(
    'ChJRdWVyeUdyYW50c1JlcXVlc3QSGAoHZ3JhbnRlchgBIAEoCVIHZ3JhbnRlchIYCgdncmFudGVlGAIgASgJUgdncmFudGVlEiAKDG1zZ190eXBlX3VybBgDIAEoCVIKbXNnVHlwZVVybBJGCgpwYWdpbmF0aW9uGAQgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryGrantsResponseDescriptor instead')
const QueryGrantsResponse$json = const {
  '1': 'QueryGrantsResponse',
  '2': const [
    const {
      '1': 'grants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cosmos.authz.v1beta1.Grant',
      '10': 'grants'
    },
    const {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryGrantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGrantsResponseDescriptor = $convert.base64Decode(
    'ChNRdWVyeUdyYW50c1Jlc3BvbnNlEjMKBmdyYW50cxgBIAMoCzIbLmNvc21vcy5hdXRoei52MWJldGExLkdyYW50UgZncmFudHMSRwoKcGFnaW5hdGlvbhgCIAEoCzInLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlc3BvbnNlUgpwYWdpbmF0aW9u');
const $core.Map<$core.String, $core.dynamic> QueryServiceBase$json = const {
  '1': 'Query',
  '2': const [
    const {
      '1': 'Grants',
      '2': '.cosmos.authz.v1beta1.QueryGrantsRequest',
      '3': '.cosmos.authz.v1beta1.QueryGrantsResponse',
      '4': const {}
    },
  ],
};

@$core.Deprecated('Use queryServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    QueryServiceBase$messageJson = const {
  '.cosmos.authz.v1beta1.QueryGrantsRequest': QueryGrantsRequest$json,
  '.cosmos.base.query.v1beta1.PageRequest': $2.PageRequest$json,
  '.cosmos.authz.v1beta1.QueryGrantsResponse': QueryGrantsResponse$json,
  '.cosmos.authz.v1beta1.Grant': $3.Grant$json,
  '.google.protobuf.Any': $0.Any$json,
  '.google.protobuf.Timestamp': $1.Timestamp$json,
  '.cosmos.base.query.v1beta1.PageResponse': $2.PageResponse$json,
};

/// Descriptor for `Query`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List queryServiceDescriptor = $convert.base64Decode(
    'CgVRdWVyeRKDAQoGR3JhbnRzEiguY29zbW9zLmF1dGh6LnYxYmV0YTEuUXVlcnlHcmFudHNSZXF1ZXN0GikuY29zbW9zLmF1dGh6LnYxYmV0YTEuUXVlcnlHcmFudHNSZXNwb25zZSIkgtPkkwIeEhwvY29zbW9zL2F1dGh6L3YxYmV0YTEvZ3JhbnRz');
