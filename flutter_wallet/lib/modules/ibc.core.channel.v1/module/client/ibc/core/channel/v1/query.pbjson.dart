///
//  Generated code. Do not modify.
//  source: ibc/core/channel/v1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use queryChannelRequestDescriptor instead')
const QueryChannelRequest$json = const {
  '1': 'QueryChannelRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `QueryChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelRequestDescriptor = $convert.base64Decode('ChNRdWVyeUNoYW5uZWxSZXF1ZXN0EhcKB3BvcnRfaWQYASABKAlSBnBvcnRJZBIdCgpjaGFubmVsX2lkGAIgASgJUgljaGFubmVsSWQ=');
@$core.Deprecated('Use queryChannelResponseDescriptor instead')
const QueryChannelResponse$json = const {
  '1': 'QueryChannelResponse',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 11, '6': '.ibc.core.channel.v1.Channel', '10': 'channel'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelResponseDescriptor = $convert.base64Decode('ChRRdWVyeUNoYW5uZWxSZXNwb25zZRI2CgdjaGFubmVsGAEgASgLMhwuaWJjLmNvcmUuY2hhbm5lbC52MS5DaGFubmVsUgdjaGFubmVsEhQKBXByb29mGAIgASgMUgVwcm9vZhJDCgxwcm9vZl9oZWlnaHQYAyABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0QgTI3h8AUgtwcm9vZkhlaWdodA==');
@$core.Deprecated('Use queryChannelsRequestDescriptor instead')
const QueryChannelsRequest$json = const {
  '1': 'QueryChannelsRequest',
  '2': const [
    const {'1': 'pagination', '3': 1, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelsRequestDescriptor = $convert.base64Decode('ChRRdWVyeUNoYW5uZWxzUmVxdWVzdBJGCgpwYWdpbmF0aW9uGAEgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryChannelsResponseDescriptor instead')
const QueryChannelsResponse$json = const {
  '1': 'QueryChannelsResponse',
  '2': const [
    const {'1': 'channels', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.IdentifiedChannel', '10': 'channels'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
    const {'1': 'height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'height'},
  ],
};

/// Descriptor for `QueryChannelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelsResponseDescriptor = $convert.base64Decode('ChVRdWVyeUNoYW5uZWxzUmVzcG9uc2USQgoIY2hhbm5lbHMYASADKAsyJi5pYmMuY29yZS5jaGFubmVsLnYxLklkZW50aWZpZWRDaGFubmVsUghjaGFubmVscxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24SOAoGaGVpZ2h0GAMgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIEyN4fAFIGaGVpZ2h0');
@$core.Deprecated('Use queryConnectionChannelsRequestDescriptor instead')
const QueryConnectionChannelsRequest$json = const {
  '1': 'QueryConnectionChannelsRequest',
  '2': const [
    const {'1': 'connection', '3': 1, '4': 1, '5': 9, '10': 'connection'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryConnectionChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionChannelsRequestDescriptor = $convert.base64Decode('Ch5RdWVyeUNvbm5lY3Rpb25DaGFubmVsc1JlcXVlc3QSHgoKY29ubmVjdGlvbhgBIAEoCVIKY29ubmVjdGlvbhJGCgpwYWdpbmF0aW9uGAIgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryConnectionChannelsResponseDescriptor instead')
const QueryConnectionChannelsResponse$json = const {
  '1': 'QueryConnectionChannelsResponse',
  '2': const [
    const {'1': 'channels', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.IdentifiedChannel', '10': 'channels'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
    const {'1': 'height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'height'},
  ],
};

/// Descriptor for `QueryConnectionChannelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryConnectionChannelsResponseDescriptor = $convert.base64Decode('Ch9RdWVyeUNvbm5lY3Rpb25DaGFubmVsc1Jlc3BvbnNlEkIKCGNoYW5uZWxzGAEgAygLMiYuaWJjLmNvcmUuY2hhbm5lbC52MS5JZGVudGlmaWVkQ2hhbm5lbFIIY2hhbm5lbHMSRwoKcGFnaW5hdGlvbhgCIAEoCzInLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlc3BvbnNlUgpwYWdpbmF0aW9uEjgKBmhlaWdodBgDIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCBMjeHwBSBmhlaWdodA==');
@$core.Deprecated('Use queryChannelClientStateRequestDescriptor instead')
const QueryChannelClientStateRequest$json = const {
  '1': 'QueryChannelClientStateRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `QueryChannelClientStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelClientStateRequestDescriptor = $convert.base64Decode('Ch5RdWVyeUNoYW5uZWxDbGllbnRTdGF0ZVJlcXVlc3QSFwoHcG9ydF9pZBgBIAEoCVIGcG9ydElkEh0KCmNoYW5uZWxfaWQYAiABKAlSCWNoYW5uZWxJZA==');
@$core.Deprecated('Use queryChannelClientStateResponseDescriptor instead')
const QueryChannelClientStateResponse$json = const {
  '1': 'QueryChannelClientStateResponse',
  '2': const [
    const {'1': 'identified_client_state', '3': 1, '4': 1, '5': 11, '6': '.ibc.core.client.v1.IdentifiedClientState', '10': 'identifiedClientState'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryChannelClientStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelClientStateResponseDescriptor = $convert.base64Decode('Ch9RdWVyeUNoYW5uZWxDbGllbnRTdGF0ZVJlc3BvbnNlEmEKF2lkZW50aWZpZWRfY2xpZW50X3N0YXRlGAEgASgLMikuaWJjLmNvcmUuY2xpZW50LnYxLklkZW50aWZpZWRDbGllbnRTdGF0ZVIVaWRlbnRpZmllZENsaWVudFN0YXRlEhQKBXByb29mGAIgASgMUgVwcm9vZhJDCgxwcm9vZl9oZWlnaHQYAyABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0QgTI3h8AUgtwcm9vZkhlaWdodA==');
@$core.Deprecated('Use queryChannelConsensusStateRequestDescriptor instead')
const QueryChannelConsensusStateRequest$json = const {
  '1': 'QueryChannelConsensusStateRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'revision_number', '3': 3, '4': 1, '5': 4, '10': 'revisionNumber'},
    const {'1': 'revision_height', '3': 4, '4': 1, '5': 4, '10': 'revisionHeight'},
  ],
};

/// Descriptor for `QueryChannelConsensusStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelConsensusStateRequestDescriptor = $convert.base64Decode('CiFRdWVyeUNoYW5uZWxDb25zZW5zdXNTdGF0ZVJlcXVlc3QSFwoHcG9ydF9pZBgBIAEoCVIGcG9ydElkEh0KCmNoYW5uZWxfaWQYAiABKAlSCWNoYW5uZWxJZBInCg9yZXZpc2lvbl9udW1iZXIYAyABKARSDnJldmlzaW9uTnVtYmVyEicKD3JldmlzaW9uX2hlaWdodBgEIAEoBFIOcmV2aXNpb25IZWlnaHQ=');
@$core.Deprecated('Use queryChannelConsensusStateResponseDescriptor instead')
const QueryChannelConsensusStateResponse$json = const {
  '1': 'QueryChannelConsensusStateResponse',
  '2': const [
    const {'1': 'consensus_state', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Any', '10': 'consensusState'},
    const {'1': 'client_id', '3': 2, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'proof', '3': 3, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 4, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryChannelConsensusStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryChannelConsensusStateResponseDescriptor = $convert.base64Decode('CiJRdWVyeUNoYW5uZWxDb25zZW5zdXNTdGF0ZVJlc3BvbnNlEj0KD2NvbnNlbnN1c19zdGF0ZRgBIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSDmNvbnNlbnN1c1N0YXRlEhsKCWNsaWVudF9pZBgCIAEoCVIIY2xpZW50SWQSFAoFcHJvb2YYAyABKAxSBXByb29mEkMKDHByb29mX2hlaWdodBgEIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCBMjeHwBSC3Byb29mSGVpZ2h0');
@$core.Deprecated('Use queryPacketCommitmentRequestDescriptor instead')
const QueryPacketCommitmentRequest$json = const {
  '1': 'QueryPacketCommitmentRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'sequence', '3': 3, '4': 1, '5': 4, '10': 'sequence'},
  ],
};

/// Descriptor for `QueryPacketCommitmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketCommitmentRequestDescriptor = $convert.base64Decode('ChxRdWVyeVBhY2tldENvbW1pdG1lbnRSZXF1ZXN0EhcKB3BvcnRfaWQYASABKAlSBnBvcnRJZBIdCgpjaGFubmVsX2lkGAIgASgJUgljaGFubmVsSWQSGgoIc2VxdWVuY2UYAyABKARSCHNlcXVlbmNl');
@$core.Deprecated('Use queryPacketCommitmentResponseDescriptor instead')
const QueryPacketCommitmentResponse$json = const {
  '1': 'QueryPacketCommitmentResponse',
  '2': const [
    const {'1': 'commitment', '3': 1, '4': 1, '5': 12, '10': 'commitment'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryPacketCommitmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketCommitmentResponseDescriptor = $convert.base64Decode('Ch1RdWVyeVBhY2tldENvbW1pdG1lbnRSZXNwb25zZRIeCgpjb21taXRtZW50GAEgASgMUgpjb21taXRtZW50EhQKBXByb29mGAIgASgMUgVwcm9vZhJDCgxwcm9vZl9oZWlnaHQYAyABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0QgTI3h8AUgtwcm9vZkhlaWdodA==');
@$core.Deprecated('Use queryPacketCommitmentsRequestDescriptor instead')
const QueryPacketCommitmentsRequest$json = const {
  '1': 'QueryPacketCommitmentsRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryPacketCommitmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketCommitmentsRequestDescriptor = $convert.base64Decode('Ch1RdWVyeVBhY2tldENvbW1pdG1lbnRzUmVxdWVzdBIXCgdwb3J0X2lkGAEgASgJUgZwb3J0SWQSHQoKY2hhbm5lbF9pZBgCIAEoCVIJY2hhbm5lbElkEkYKCnBhZ2luYXRpb24YAyABKAsyJi5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXF1ZXN0UgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryPacketCommitmentsResponseDescriptor instead')
const QueryPacketCommitmentsResponse$json = const {
  '1': 'QueryPacketCommitmentsResponse',
  '2': const [
    const {'1': 'commitments', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketState', '10': 'commitments'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
    const {'1': 'height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'height'},
  ],
};

/// Descriptor for `QueryPacketCommitmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketCommitmentsResponseDescriptor = $convert.base64Decode('Ch5RdWVyeVBhY2tldENvbW1pdG1lbnRzUmVzcG9uc2USQgoLY29tbWl0bWVudHMYASADKAsyIC5pYmMuY29yZS5jaGFubmVsLnYxLlBhY2tldFN0YXRlUgtjb21taXRtZW50cxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24SOAoGaGVpZ2h0GAMgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIEyN4fAFIGaGVpZ2h0');
@$core.Deprecated('Use queryPacketReceiptRequestDescriptor instead')
const QueryPacketReceiptRequest$json = const {
  '1': 'QueryPacketReceiptRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'sequence', '3': 3, '4': 1, '5': 4, '10': 'sequence'},
  ],
};

/// Descriptor for `QueryPacketReceiptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketReceiptRequestDescriptor = $convert.base64Decode('ChlRdWVyeVBhY2tldFJlY2VpcHRSZXF1ZXN0EhcKB3BvcnRfaWQYASABKAlSBnBvcnRJZBIdCgpjaGFubmVsX2lkGAIgASgJUgljaGFubmVsSWQSGgoIc2VxdWVuY2UYAyABKARSCHNlcXVlbmNl');
@$core.Deprecated('Use queryPacketReceiptResponseDescriptor instead')
const QueryPacketReceiptResponse$json = const {
  '1': 'QueryPacketReceiptResponse',
  '2': const [
    const {'1': 'received', '3': 2, '4': 1, '5': 8, '10': 'received'},
    const {'1': 'proof', '3': 3, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 4, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryPacketReceiptResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketReceiptResponseDescriptor = $convert.base64Decode('ChpRdWVyeVBhY2tldFJlY2VpcHRSZXNwb25zZRIaCghyZWNlaXZlZBgCIAEoCFIIcmVjZWl2ZWQSFAoFcHJvb2YYAyABKAxSBXByb29mEkMKDHByb29mX2hlaWdodBgEIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCBMjeHwBSC3Byb29mSGVpZ2h0');
@$core.Deprecated('Use queryPacketAcknowledgementRequestDescriptor instead')
const QueryPacketAcknowledgementRequest$json = const {
  '1': 'QueryPacketAcknowledgementRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'sequence', '3': 3, '4': 1, '5': 4, '10': 'sequence'},
  ],
};

/// Descriptor for `QueryPacketAcknowledgementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketAcknowledgementRequestDescriptor = $convert.base64Decode('CiFRdWVyeVBhY2tldEFja25vd2xlZGdlbWVudFJlcXVlc3QSFwoHcG9ydF9pZBgBIAEoCVIGcG9ydElkEh0KCmNoYW5uZWxfaWQYAiABKAlSCWNoYW5uZWxJZBIaCghzZXF1ZW5jZRgDIAEoBFIIc2VxdWVuY2U=');
@$core.Deprecated('Use queryPacketAcknowledgementResponseDescriptor instead')
const QueryPacketAcknowledgementResponse$json = const {
  '1': 'QueryPacketAcknowledgementResponse',
  '2': const [
    const {'1': 'acknowledgement', '3': 1, '4': 1, '5': 12, '10': 'acknowledgement'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryPacketAcknowledgementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketAcknowledgementResponseDescriptor = $convert.base64Decode('CiJRdWVyeVBhY2tldEFja25vd2xlZGdlbWVudFJlc3BvbnNlEigKD2Fja25vd2xlZGdlbWVudBgBIAEoDFIPYWNrbm93bGVkZ2VtZW50EhQKBXByb29mGAIgASgMUgVwcm9vZhJDCgxwcm9vZl9oZWlnaHQYAyABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0QgTI3h8AUgtwcm9vZkhlaWdodA==');
@$core.Deprecated('Use queryPacketAcknowledgementsRequestDescriptor instead')
const QueryPacketAcknowledgementsRequest$json = const {
  '1': 'QueryPacketAcknowledgementsRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
    const {'1': 'packet_commitment_sequences', '3': 4, '4': 3, '5': 4, '10': 'packetCommitmentSequences'},
  ],
};

/// Descriptor for `QueryPacketAcknowledgementsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketAcknowledgementsRequestDescriptor = $convert.base64Decode('CiJRdWVyeVBhY2tldEFja25vd2xlZGdlbWVudHNSZXF1ZXN0EhcKB3BvcnRfaWQYASABKAlSBnBvcnRJZBIdCgpjaGFubmVsX2lkGAIgASgJUgljaGFubmVsSWQSRgoKcGFnaW5hdGlvbhgDIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24SPgobcGFja2V0X2NvbW1pdG1lbnRfc2VxdWVuY2VzGAQgAygEUhlwYWNrZXRDb21taXRtZW50U2VxdWVuY2Vz');
@$core.Deprecated('Use queryPacketAcknowledgementsResponseDescriptor instead')
const QueryPacketAcknowledgementsResponse$json = const {
  '1': 'QueryPacketAcknowledgementsResponse',
  '2': const [
    const {'1': 'acknowledgements', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketState', '10': 'acknowledgements'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
    const {'1': 'height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'height'},
  ],
};

/// Descriptor for `QueryPacketAcknowledgementsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryPacketAcknowledgementsResponseDescriptor = $convert.base64Decode('CiNRdWVyeVBhY2tldEFja25vd2xlZGdlbWVudHNSZXNwb25zZRJMChBhY2tub3dsZWRnZW1lbnRzGAEgAygLMiAuaWJjLmNvcmUuY2hhbm5lbC52MS5QYWNrZXRTdGF0ZVIQYWNrbm93bGVkZ2VtZW50cxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24SOAoGaGVpZ2h0GAMgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIEyN4fAFIGaGVpZ2h0');
@$core.Deprecated('Use queryUnreceivedPacketsRequestDescriptor instead')
const QueryUnreceivedPacketsRequest$json = const {
  '1': 'QueryUnreceivedPacketsRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'packet_commitment_sequences', '3': 3, '4': 3, '5': 4, '10': 'packetCommitmentSequences'},
  ],
};

/// Descriptor for `QueryUnreceivedPacketsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryUnreceivedPacketsRequestDescriptor = $convert.base64Decode('Ch1RdWVyeVVucmVjZWl2ZWRQYWNrZXRzUmVxdWVzdBIXCgdwb3J0X2lkGAEgASgJUgZwb3J0SWQSHQoKY2hhbm5lbF9pZBgCIAEoCVIJY2hhbm5lbElkEj4KG3BhY2tldF9jb21taXRtZW50X3NlcXVlbmNlcxgDIAMoBFIZcGFja2V0Q29tbWl0bWVudFNlcXVlbmNlcw==');
@$core.Deprecated('Use queryUnreceivedPacketsResponseDescriptor instead')
const QueryUnreceivedPacketsResponse$json = const {
  '1': 'QueryUnreceivedPacketsResponse',
  '2': const [
    const {'1': 'sequences', '3': 1, '4': 3, '5': 4, '10': 'sequences'},
    const {'1': 'height', '3': 2, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'height'},
  ],
};

/// Descriptor for `QueryUnreceivedPacketsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryUnreceivedPacketsResponseDescriptor = $convert.base64Decode('Ch5RdWVyeVVucmVjZWl2ZWRQYWNrZXRzUmVzcG9uc2USHAoJc2VxdWVuY2VzGAEgAygEUglzZXF1ZW5jZXMSOAoGaGVpZ2h0GAIgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIEyN4fAFIGaGVpZ2h0');
@$core.Deprecated('Use queryUnreceivedAcksRequestDescriptor instead')
const QueryUnreceivedAcksRequest$json = const {
  '1': 'QueryUnreceivedAcksRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'packet_ack_sequences', '3': 3, '4': 3, '5': 4, '10': 'packetAckSequences'},
  ],
};

/// Descriptor for `QueryUnreceivedAcksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryUnreceivedAcksRequestDescriptor = $convert.base64Decode('ChpRdWVyeVVucmVjZWl2ZWRBY2tzUmVxdWVzdBIXCgdwb3J0X2lkGAEgASgJUgZwb3J0SWQSHQoKY2hhbm5lbF9pZBgCIAEoCVIJY2hhbm5lbElkEjAKFHBhY2tldF9hY2tfc2VxdWVuY2VzGAMgAygEUhJwYWNrZXRBY2tTZXF1ZW5jZXM=');
@$core.Deprecated('Use queryUnreceivedAcksResponseDescriptor instead')
const QueryUnreceivedAcksResponse$json = const {
  '1': 'QueryUnreceivedAcksResponse',
  '2': const [
    const {'1': 'sequences', '3': 1, '4': 3, '5': 4, '10': 'sequences'},
    const {'1': 'height', '3': 2, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'height'},
  ],
};

/// Descriptor for `QueryUnreceivedAcksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryUnreceivedAcksResponseDescriptor = $convert.base64Decode('ChtRdWVyeVVucmVjZWl2ZWRBY2tzUmVzcG9uc2USHAoJc2VxdWVuY2VzGAEgAygEUglzZXF1ZW5jZXMSOAoGaGVpZ2h0GAIgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIEyN4fAFIGaGVpZ2h0');
@$core.Deprecated('Use queryNextSequenceReceiveRequestDescriptor instead')
const QueryNextSequenceReceiveRequest$json = const {
  '1': 'QueryNextSequenceReceiveRequest',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `QueryNextSequenceReceiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryNextSequenceReceiveRequestDescriptor = $convert.base64Decode('Ch9RdWVyeU5leHRTZXF1ZW5jZVJlY2VpdmVSZXF1ZXN0EhcKB3BvcnRfaWQYASABKAlSBnBvcnRJZBIdCgpjaGFubmVsX2lkGAIgASgJUgljaGFubmVsSWQ=');
@$core.Deprecated('Use queryNextSequenceReceiveResponseDescriptor instead')
const QueryNextSequenceReceiveResponse$json = const {
  '1': 'QueryNextSequenceReceiveResponse',
  '2': const [
    const {'1': 'next_sequence_receive', '3': 1, '4': 1, '5': 4, '10': 'nextSequenceReceive'},
    const {'1': 'proof', '3': 2, '4': 1, '5': 12, '10': 'proof'},
    const {'1': 'proof_height', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'proofHeight'},
  ],
};

/// Descriptor for `QueryNextSequenceReceiveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryNextSequenceReceiveResponseDescriptor = $convert.base64Decode('CiBRdWVyeU5leHRTZXF1ZW5jZVJlY2VpdmVSZXNwb25zZRIyChVuZXh0X3NlcXVlbmNlX3JlY2VpdmUYASABKARSE25leHRTZXF1ZW5jZVJlY2VpdmUSFAoFcHJvb2YYAiABKAxSBXByb29mEkMKDHByb29mX2hlaWdodBgDIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCBMjeHwBSC3Byb29mSGVpZ2h0');
