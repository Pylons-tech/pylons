///
//  Generated code. Do not modify.
//  source: ibc/core/connection/v1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use queryConnectionRequestDescriptor instead')
const QueryConnectionRequest$json = const {
  '1': 'QueryConnectionRequest',
  '2': const [
    const {'1': 'connection_id', '3': 1, '4': 1, '5': 9, '10': 'connectionId'},
  ],
};

/// Descriptor for `QueryConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionRequestDescriptor = $convert.base64Decode('ChZRdWVyeUNvbm5lY3Rpb25SZXF1ZXN0EiMKDWNvbm5lY3Rpb25faWQYASABKAlSDGNvbm5lY3Rpb25JZA==');
@$core.Deprecated('Use queryConnectionResponseDescriptor instead')
const QueryConnectionResponse$json = const {
  '1': 'QueryConnectionResponse',
  '2': const [
    const {'1': 'connection', '3': 1, '4': 1, '5': 11, '6': '.ibc.core.connection.v1.ConnectionEnd', '10': 'connection'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryConnectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionResponseDescriptor = $convert.base64Decode('ChdRdWVyeUNvbm5lY3Rpb25SZXNwb25zZRJFCgpjb25uZWN0aW9uGAEgASgLMiUuaWJjLmNvcmUuY29ubmVjdGlvbi52MS5Db25uZWN0aW9uRW5kUgpjb25uZWN0aW9uEhQKBXByb29mGAIgASgMUgVwcm9vZhJDCgxwcm9vZl9oZWlnaHQYAyABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0QgTI3h8AUgtwcm9vZkhlaWdodA==');
@$core.Deprecated('Use queryConnectionsRequestDescriptor instead')
const QueryConnectionsRequest$json = const {
  '1': 'QueryConnectionsRequest',
  '2': const [
    const {'1': 'pagination', '3': 1, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryConnectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionsRequestDescriptor = $convert.base64Decode('ChdRdWVyeUNvbm5lY3Rpb25zUmVxdWVzdBJGCgpwYWdpbmF0aW9uGAEgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryConnectionsResponseDescriptor instead')
const QueryConnectionsResponse$json = const {
  '1': 'QueryConnectionsResponse',
  '2': const [
    const {'1': 'connections', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.connection.v1.IdentifiedConnection', '10': 'connections'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
    const {'1': 'height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'height'},
  ],
};

/// Descriptor for `QueryConnectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionsResponseDescriptor = $convert.base64Decode('ChhRdWVyeUNvbm5lY3Rpb25zUmVzcG9uc2USTgoLY29ubmVjdGlvbnMYASADKAsyLC5pYmMuY29yZS5jb25uZWN0aW9uLnYxLklkZW50aWZpZWRDb25uZWN0aW9uUgtjb25uZWN0aW9ucxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24SOAoGaGVpZ2h0GAMgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIEyN4fAFIGaGVpZ2h0');
@$core.Deprecated('Use queryClientConnectionsRequestDescriptor instead')
const QueryClientConnectionsRequest$json = const {
  '1': 'QueryClientConnectionsRequest',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
  ],
};

/// Descriptor for `QueryClientConnectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryClientConnectionsRequestDescriptor = $convert.base64Decode('Ch1RdWVyeUNsaWVudENvbm5lY3Rpb25zUmVxdWVzdBIbCgljbGllbnRfaWQYASABKAlSCGNsaWVudElk');
@$core.Deprecated('Use queryClientConnectionsResponseDescriptor instead')
const QueryClientConnectionsResponse$json = const {
  '1': 'QueryClientConnectionsResponse',
  '2': const [
    const {'1': 'connection_paths', '3': 1, '4': 3, '5': 9, '10': 'connectionPaths'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryClientConnectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryClientConnectionsResponseDescriptor = $convert.base64Decode('Ch5RdWVyeUNsaWVudENvbm5lY3Rpb25zUmVzcG9uc2USKQoQY29ubmVjdGlvbl9wYXRocxgBIAMoCVIPY29ubmVjdGlvblBhdGhzEhQKBXByb29mGAIgASgMUgVwcm9vZhJDCgxwcm9vZl9oZWlnaHQYAyABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0QgTI3h8AUgtwcm9vZkhlaWdodA==');
@$core.Deprecated('Use queryConnectionClientStateRequestDescriptor instead')
const QueryConnectionClientStateRequest$json = const {
  '1': 'QueryConnectionClientStateRequest',
  '2': const [
    const {'1': 'connection_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'connectionId'},
  ],
};

/// Descriptor for `QueryConnectionClientStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionClientStateRequestDescriptor = $convert.base64Decode('CiFRdWVyeUNvbm5lY3Rpb25DbGllbnRTdGF0ZVJlcXVlc3QSPQoNY29ubmVjdGlvbl9pZBgBIAEoCUIY8t4fFHlhbWw6ImNvbm5lY3Rpb25faWQiUgxjb25uZWN0aW9uSWQ=');
@$core.Deprecated('Use queryConnectionClientStateResponseDescriptor instead')
const QueryConnectionClientStateResponse$json = const {
  '1': 'QueryConnectionClientStateResponse',
  '2': const [
    const {'1': 'identified_client_state', '3': 1, '4': 1, '5': 11, '6': '.ibc.core.client.v1.IdentifiedClientState', '10': 'identifiedClientState'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryConnectionClientStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionClientStateResponseDescriptor = $convert.base64Decode('CiJRdWVyeUNvbm5lY3Rpb25DbGllbnRTdGF0ZVJlc3BvbnNlEmEKF2lkZW50aWZpZWRfY2xpZW50X3N0YXRlGAEgASgLMikuaWJjLmNvcmUuY2xpZW50LnYxLklkZW50aWZpZWRDbGllbnRTdGF0ZVIVaWRlbnRpZmllZENsaWVudFN0YXRlEhQKBXByb29mGAIgASgMUgVwcm9vZhJDCgxwcm9vZl9oZWlnaHQYAyABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0QgTI3h8AUgtwcm9vZkhlaWdodA==');
@$core.Deprecated('Use queryConnectionConsensusStateRequestDescriptor instead')
const QueryConnectionConsensusStateRequest$json = const {
  '1': 'QueryConnectionConsensusStateRequest',
  '2': const [
    const {'1': 'connection_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'connectionId'},
    const {'1': 'revision_number', '3': 2, '4': 1, '5': 4, '10': 'revisionNumber'},
    const {'1': 'revision_height', '3': 3, '4': 1, '5': 4, '10': 'revisionHeight'},
  ],
};

/// Descriptor for `QueryConnectionConsensusStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionConsensusStateRequestDescriptor = $convert.base64Decode('CiRRdWVyeUNvbm5lY3Rpb25Db25zZW5zdXNTdGF0ZVJlcXVlc3QSPQoNY29ubmVjdGlvbl9pZBgBIAEoCUIY8t4fFHlhbWw6ImNvbm5lY3Rpb25faWQiUgxjb25uZWN0aW9uSWQSJwoPcmV2aXNpb25fbnVtYmVyGAIgASgEUg5yZXZpc2lvbk51bWJlchInCg9yZXZpc2lvbl9oZWlnaHQYAyABKARSDnJldmlzaW9uSGVpZ2h0');
@$core.Deprecated('Use queryConnectionConsensusStateResponseDescriptor instead')
const QueryConnectionConsensusStateResponse$json = const {
  '1': 'QueryConnectionConsensusStateResponse',
  '2': const [
    const {'1': 'consensus_state', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Any', '10': 'consensusState'},
    const {'1': 'client_id', '3': 2, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'proof', '3': 3, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 4, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryConnectionConsensusStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionConsensusStateResponseDescriptor = $convert.base64Decode('CiVRdWVyeUNvbm5lY3Rpb25Db25zZW5zdXNTdGF0ZVJlc3BvbnNlEj0KD2NvbnNlbnN1c19zdGF0ZRgBIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSDmNvbnNlbnN1c1N0YXRlEhsKCWNsaWVudF9pZBgCIAEoCVIIY2xpZW50SWQSFAoFcHJvb2YYAyABKAxSBXByb29mEkMKDHByb29mX2hlaWdodBgEIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCBMjeHwBSC3Byb29mSGVpZ2h0');
