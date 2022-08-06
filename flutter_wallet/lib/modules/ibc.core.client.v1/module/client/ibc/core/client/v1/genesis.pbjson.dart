///
//  Generated code. Do not modify.
//  source: ibc/core/client/v1/genesis.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use genesisStateDescriptor instead')
const GenesisState$json = const {
  '1': 'GenesisState',
  '2': const [
    const {'1': 'clients', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.client.v1.IdentifiedClientState', '8': const {}, '10': 'clients'},
    const {'1': 'clients_consensus', '3': 2, '4': 3, '5': 11, '6': '.ibc.core.client.v1.ClientConsensusStates', '8': const {}, '10': 'clientsConsensus'},
    const {'1': 'clients_metadata', '3': 3, '4': 3, '5': 11, '6': '.ibc.core.client.v1.IdentifiedGenesisMetadata', '8': const {}, '10': 'clientsMetadata'},
    const {'1': 'params', '3': 4, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Params', '8': const {}, '10': 'params'},
    const {'1': 'create_localhost', '3': 5, '4': 1, '5': 8, '8': const {}, '10': 'createLocalhost'},
    const {'1': 'next_client_sequence', '3': 6, '4': 1, '5': 4, '8': const {}, '10': 'nextClientSequence'},
  ],
};

/// Descriptor for `GenesisState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genesisStateDescriptor = $convert.base64Decode('CgxHZW5lc2lzU3RhdGUSYwoHY2xpZW50cxgBIAMoCzIpLmliYy5jb3JlLmNsaWVudC52MS5JZGVudGlmaWVkQ2xpZW50U3RhdGVCHsjeHwCq3x8WSWRlbnRpZmllZENsaWVudFN0YXRlc1IHY2xpZW50cxKSAQoRY2xpZW50c19jb25zZW5zdXMYAiADKAsyKS5pYmMuY29yZS5jbGllbnQudjEuQ2xpZW50Q29uc2Vuc3VzU3RhdGVzQjrI3h8Aqt8fFkNsaWVudHNDb25zZW5zdXNTdGF0ZXPy3h8YeWFtbDoiY2xpZW50c19jb25zZW5zdXMiUhBjbGllbnRzQ29uc2Vuc3VzEnkKEGNsaWVudHNfbWV0YWRhdGEYAyADKAsyLS5pYmMuY29yZS5jbGllbnQudjEuSWRlbnRpZmllZEdlbmVzaXNNZXRhZGF0YUIfyN4fAPLeHxd5YW1sOiJjbGllbnRzX21ldGFkYXRhIlIPY2xpZW50c01ldGFkYXRhEjgKBnBhcmFtcxgEIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5QYXJhbXNCBMjeHwBSBnBhcmFtcxJGChBjcmVhdGVfbG9jYWxob3N0GAUgASgIQhvy3h8XeWFtbDoiY3JlYXRlX2xvY2FsaG9zdCJSD2NyZWF0ZUxvY2FsaG9zdBJRChRuZXh0X2NsaWVudF9zZXF1ZW5jZRgGIAEoBEIf8t4fG3lhbWw6Im5leHRfY2xpZW50X3NlcXVlbmNlIlISbmV4dENsaWVudFNlcXVlbmNl');
@$core.Deprecated('Use genesisMetadataDescriptor instead')
const GenesisMetadata$json = const {
  '1': 'GenesisMetadata',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 12, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
  '7': const {},
};

/// Descriptor for `GenesisMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genesisMetadataDescriptor = $convert.base64Decode('Cg9HZW5lc2lzTWV0YWRhdGESEAoDa2V5GAEgASgMUgNrZXkSFAoFdmFsdWUYAiABKAxSBXZhbHVlOgSIoB8A');
@$core.Deprecated('Use identifiedGenesisMetadataDescriptor instead')
const IdentifiedGenesisMetadata$json = const {
  '1': 'IdentifiedGenesisMetadata',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'client_metadata', '3': 2, '4': 3, '5': 11, '6': '.ibc.core.client.v1.GenesisMetadata', '8': const {}, '10': 'clientMetadata'},
  ],
};

/// Descriptor for `IdentifiedGenesisMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifiedGenesisMetadataDescriptor = $convert.base64Decode('ChlJZGVudGlmaWVkR2VuZXNpc01ldGFkYXRhEjEKCWNsaWVudF9pZBgBIAEoCUIU8t4fEHlhbWw6ImNsaWVudF9pZCJSCGNsaWVudElkEmwKD2NsaWVudF9tZXRhZGF0YRgCIAMoCzIjLmliYy5jb3JlLmNsaWVudC52MS5HZW5lc2lzTWV0YWRhdGFCHsjeHwDy3h8WeWFtbDoiY2xpZW50X21ldGFkYXRhIlIOY2xpZW50TWV0YWRhdGE=');
