///
//  Generated code. Do not modify.
//  source: ibc/core/channel/v1/genesis.proto
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
    const {'1': 'channels', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.IdentifiedChannel', '8': const {}, '10': 'channels'},
    const {'1': 'acknowledgements', '3': 2, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketState', '8': const {}, '10': 'acknowledgements'},
    const {'1': 'commitments', '3': 3, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketState', '8': const {}, '10': 'commitments'},
    const {'1': 'receipts', '3': 4, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketState', '8': const {}, '10': 'receipts'},
    const {'1': 'send_sequences', '3': 5, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketSequence', '8': const {}, '10': 'sendSequences'},
    const {'1': 'recv_sequences', '3': 6, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketSequence', '8': const {}, '10': 'recvSequences'},
    const {'1': 'ack_sequences', '3': 7, '4': 3, '5': 11, '6': '.ibc.core.channel.v1.PacketSequence', '8': const {}, '10': 'ackSequences'},
    const {'1': 'next_channel_sequence', '3': 8, '4': 1, '5': 4, '8': const {}, '10': 'nextChannelSequence'},
  ],
};

/// Descriptor for `GenesisState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genesisStateDescriptor = $convert.base64Decode('CgxHZW5lc2lzU3RhdGUSXQoIY2hhbm5lbHMYASADKAsyJi5pYmMuY29yZS5jaGFubmVsLnYxLklkZW50aWZpZWRDaGFubmVsQhn63h8RSWRlbnRpZmllZENoYW5uZWzI3h8AUghjaGFubmVscxJSChBhY2tub3dsZWRnZW1lbnRzGAIgAygLMiAuaWJjLmNvcmUuY2hhbm5lbC52MS5QYWNrZXRTdGF0ZUIEyN4fAFIQYWNrbm93bGVkZ2VtZW50cxJICgtjb21taXRtZW50cxgDIAMoCzIgLmliYy5jb3JlLmNoYW5uZWwudjEuUGFja2V0U3RhdGVCBMjeHwBSC2NvbW1pdG1lbnRzEkIKCHJlY2VpcHRzGAQgAygLMiAuaWJjLmNvcmUuY2hhbm5lbC52MS5QYWNrZXRTdGF0ZUIEyN4fAFIIcmVjZWlwdHMSaQoOc2VuZF9zZXF1ZW5jZXMYBSADKAsyIy5pYmMuY29yZS5jaGFubmVsLnYxLlBhY2tldFNlcXVlbmNlQh3I3h8A8t4fFXlhbWw6InNlbmRfc2VxdWVuY2VzIlINc2VuZFNlcXVlbmNlcxJpCg5yZWN2X3NlcXVlbmNlcxgGIAMoCzIjLmliYy5jb3JlLmNoYW5uZWwudjEuUGFja2V0U2VxdWVuY2VCHcjeHwDy3h8VeWFtbDoicmVjdl9zZXF1ZW5jZXMiUg1yZWN2U2VxdWVuY2VzEmYKDWFja19zZXF1ZW5jZXMYByADKAsyIy5pYmMuY29yZS5jaGFubmVsLnYxLlBhY2tldFNlcXVlbmNlQhzI3h8A8t4fFHlhbWw6ImFja19zZXF1ZW5jZXMiUgxhY2tTZXF1ZW5jZXMSVAoVbmV4dF9jaGFubmVsX3NlcXVlbmNlGAggASgEQiDy3h8ceWFtbDoibmV4dF9jaGFubmVsX3NlcXVlbmNlIlITbmV4dENoYW5uZWxTZXF1ZW5jZQ==');
@$core.Deprecated('Use packetSequenceDescriptor instead')
const PacketSequence$json = const {
  '1': 'PacketSequence',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'channelId'},
    const {'1': 'sequence', '3': 3, '4': 1, '5': 4, '10': 'sequence'},
  ],
};

/// Descriptor for `PacketSequence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetSequenceDescriptor = $convert.base64Decode('Cg5QYWNrZXRTZXF1ZW5jZRIrCgdwb3J0X2lkGAEgASgJQhLy3h8OeWFtbDoicG9ydF9pZCJSBnBvcnRJZBI0CgpjaGFubmVsX2lkGAIgASgJQhXy3h8ReWFtbDoiY2hhbm5lbF9pZCJSCWNoYW5uZWxJZBIaCghzZXF1ZW5jZRgDIAEoBFIIc2VxdWVuY2U=');
