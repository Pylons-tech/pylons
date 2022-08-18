///
//  Generated code. Do not modify.
//  source: ibc/core/channel/v1/tx.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use msgChannelOpenInitDescriptor instead')
const MsgChannelOpenInit$json = {
  '1': 'MsgChannelOpenInit',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'portId'},
    {
      '1': 'channel',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.channel.v1.Channel',
      '8': {},
      '10': 'channel'
    },
    {'1': 'signer', '3': 3, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgChannelOpenInit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenInitDescriptor = $convert.base64Decode(
    'ChJNc2dDaGFubmVsT3BlbkluaXQSKwoHcG9ydF9pZBgBIAEoCUIS8t4fDnlhbWw6InBvcnRfaWQiUgZwb3J0SWQSPAoHY2hhbm5lbBgCIAEoCzIcLmliYy5jb3JlLmNoYW5uZWwudjEuQ2hhbm5lbEIEyN4fAFIHY2hhbm5lbBIWCgZzaWduZXIYAyABKAlSBnNpZ25lcjoI6KAfAIigHwA=');
@$core.Deprecated('Use msgChannelOpenInitResponseDescriptor instead')
const MsgChannelOpenInitResponse$json = {
  '1': 'MsgChannelOpenInitResponse',
};

/// Descriptor for `MsgChannelOpenInitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenInitResponseDescriptor =
    $convert.base64Decode('ChpNc2dDaGFubmVsT3BlbkluaXRSZXNwb25zZQ==');
@$core.Deprecated('Use msgChannelOpenTryDescriptor instead')
const MsgChannelOpenTry$json = {
  '1': 'MsgChannelOpenTry',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'portId'},
    {
      '1': 'previous_channel_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'previousChannelId'
    },
    {
      '1': 'channel',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.channel.v1.Channel',
      '8': {},
      '10': 'channel'
    },
    {
      '1': 'counterparty_version',
      '3': 4,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'counterpartyVersion'
    },
    {'1': 'proof_init', '3': 5, '4': 1, '5': 12, '8': {}, '10': 'proofInit'},
    {
      '1': 'proof_height',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {'1': 'signer', '3': 7, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgChannelOpenTry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenTryDescriptor = $convert.base64Decode(
    'ChFNc2dDaGFubmVsT3BlblRyeRIrCgdwb3J0X2lkGAEgASgJQhLy3h8OeWFtbDoicG9ydF9pZCJSBnBvcnRJZBJOChNwcmV2aW91c19jaGFubmVsX2lkGAIgASgJQh7y3h8aeWFtbDoicHJldmlvdXNfY2hhbm5lbF9pZCJSEXByZXZpb3VzQ2hhbm5lbElkEjwKB2NoYW5uZWwYAyABKAsyHC5pYmMuY29yZS5jaGFubmVsLnYxLkNoYW5uZWxCBMjeHwBSB2NoYW5uZWwSUgoUY291bnRlcnBhcnR5X3ZlcnNpb24YBCABKAlCH/LeHxt5YW1sOiJjb3VudGVycGFydHlfdmVyc2lvbiJSE2NvdW50ZXJwYXJ0eVZlcnNpb24SNAoKcHJvb2ZfaW5pdBgFIAEoDEIV8t4fEXlhbWw6InByb29mX2luaXQiUglwcm9vZkluaXQSWgoMcHJvb2ZfaGVpZ2h0GAYgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIb8t4fE3lhbWw6InByb29mX2hlaWdodCLI3h8AUgtwcm9vZkhlaWdodBIWCgZzaWduZXIYByABKAlSBnNpZ25lcjoI6KAfAIigHwA=');
@$core.Deprecated('Use msgChannelOpenTryResponseDescriptor instead')
const MsgChannelOpenTryResponse$json = {
  '1': 'MsgChannelOpenTryResponse',
};

/// Descriptor for `MsgChannelOpenTryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenTryResponseDescriptor =
    $convert.base64Decode('ChlNc2dDaGFubmVsT3BlblRyeVJlc3BvbnNl');
@$core.Deprecated('Use msgChannelOpenAckDescriptor instead')
const MsgChannelOpenAck$json = {
  '1': 'MsgChannelOpenAck',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'portId'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'channelId'},
    {
      '1': 'counterparty_channel_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'counterpartyChannelId'
    },
    {
      '1': 'counterparty_version',
      '3': 4,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'counterpartyVersion'
    },
    {'1': 'proof_try', '3': 5, '4': 1, '5': 12, '8': {}, '10': 'proofTry'},
    {
      '1': 'proof_height',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {'1': 'signer', '3': 7, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgChannelOpenAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenAckDescriptor = $convert.base64Decode(
    'ChFNc2dDaGFubmVsT3BlbkFjaxIrCgdwb3J0X2lkGAEgASgJQhLy3h8OeWFtbDoicG9ydF9pZCJSBnBvcnRJZBI0CgpjaGFubmVsX2lkGAIgASgJQhXy3h8ReWFtbDoiY2hhbm5lbF9pZCJSCWNoYW5uZWxJZBJaChdjb3VudGVycGFydHlfY2hhbm5lbF9pZBgDIAEoCUIi8t4fHnlhbWw6ImNvdW50ZXJwYXJ0eV9jaGFubmVsX2lkIlIVY291bnRlcnBhcnR5Q2hhbm5lbElkElIKFGNvdW50ZXJwYXJ0eV92ZXJzaW9uGAQgASgJQh/y3h8beWFtbDoiY291bnRlcnBhcnR5X3ZlcnNpb24iUhNjb3VudGVycGFydHlWZXJzaW9uEjEKCXByb29mX3RyeRgFIAEoDEIU8t4fEHlhbWw6InByb29mX3RyeSJSCHByb29mVHJ5EloKDHByb29mX2hlaWdodBgGIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCG/LeHxN5YW1sOiJwcm9vZl9oZWlnaHQiyN4fAFILcHJvb2ZIZWlnaHQSFgoGc2lnbmVyGAcgASgJUgZzaWduZXI6COigHwCIoB8A');
@$core.Deprecated('Use msgChannelOpenAckResponseDescriptor instead')
const MsgChannelOpenAckResponse$json = {
  '1': 'MsgChannelOpenAckResponse',
};

/// Descriptor for `MsgChannelOpenAckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenAckResponseDescriptor =
    $convert.base64Decode('ChlNc2dDaGFubmVsT3BlbkFja1Jlc3BvbnNl');
@$core.Deprecated('Use msgChannelOpenConfirmDescriptor instead')
const MsgChannelOpenConfirm$json = {
  '1': 'MsgChannelOpenConfirm',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'portId'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'channelId'},
    {'1': 'proof_ack', '3': 3, '4': 1, '5': 12, '8': {}, '10': 'proofAck'},
    {
      '1': 'proof_height',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {'1': 'signer', '3': 5, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgChannelOpenConfirm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenConfirmDescriptor = $convert.base64Decode(
    'ChVNc2dDaGFubmVsT3BlbkNvbmZpcm0SKwoHcG9ydF9pZBgBIAEoCUIS8t4fDnlhbWw6InBvcnRfaWQiUgZwb3J0SWQSNAoKY2hhbm5lbF9pZBgCIAEoCUIV8t4fEXlhbWw6ImNoYW5uZWxfaWQiUgljaGFubmVsSWQSMQoJcHJvb2ZfYWNrGAMgASgMQhTy3h8QeWFtbDoicHJvb2ZfYWNrIlIIcHJvb2ZBY2sSWgoMcHJvb2ZfaGVpZ2h0GAQgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIb8t4fE3lhbWw6InByb29mX2hlaWdodCLI3h8AUgtwcm9vZkhlaWdodBIWCgZzaWduZXIYBSABKAlSBnNpZ25lcjoI6KAfAIigHwA=');
@$core.Deprecated('Use msgChannelOpenConfirmResponseDescriptor instead')
const MsgChannelOpenConfirmResponse$json = {
  '1': 'MsgChannelOpenConfirmResponse',
};

/// Descriptor for `MsgChannelOpenConfirmResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelOpenConfirmResponseDescriptor =
    $convert.base64Decode('Ch1Nc2dDaGFubmVsT3BlbkNvbmZpcm1SZXNwb25zZQ==');
@$core.Deprecated('Use msgChannelCloseInitDescriptor instead')
const MsgChannelCloseInit$json = {
  '1': 'MsgChannelCloseInit',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'portId'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'channelId'},
    {'1': 'signer', '3': 3, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgChannelCloseInit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelCloseInitDescriptor = $convert.base64Decode(
    'ChNNc2dDaGFubmVsQ2xvc2VJbml0EisKB3BvcnRfaWQYASABKAlCEvLeHw55YW1sOiJwb3J0X2lkIlIGcG9ydElkEjQKCmNoYW5uZWxfaWQYAiABKAlCFfLeHxF5YW1sOiJjaGFubmVsX2lkIlIJY2hhbm5lbElkEhYKBnNpZ25lchgDIAEoCVIGc2lnbmVyOgjooB8AiKAfAA==');
@$core.Deprecated('Use msgChannelCloseInitResponseDescriptor instead')
const MsgChannelCloseInitResponse$json = {
  '1': 'MsgChannelCloseInitResponse',
};

/// Descriptor for `MsgChannelCloseInitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelCloseInitResponseDescriptor =
    $convert.base64Decode('ChtNc2dDaGFubmVsQ2xvc2VJbml0UmVzcG9uc2U=');
@$core.Deprecated('Use msgChannelCloseConfirmDescriptor instead')
const MsgChannelCloseConfirm$json = {
  '1': 'MsgChannelCloseConfirm',
  '2': [
    {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'portId'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'channelId'},
    {'1': 'proof_init', '3': 3, '4': 1, '5': 12, '8': {}, '10': 'proofInit'},
    {
      '1': 'proof_height',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {'1': 'signer', '3': 5, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgChannelCloseConfirm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelCloseConfirmDescriptor =
    $convert.base64Decode(
        'ChZNc2dDaGFubmVsQ2xvc2VDb25maXJtEisKB3BvcnRfaWQYASABKAlCEvLeHw55YW1sOiJwb3J0X2lkIlIGcG9ydElkEjQKCmNoYW5uZWxfaWQYAiABKAlCFfLeHxF5YW1sOiJjaGFubmVsX2lkIlIJY2hhbm5lbElkEjQKCnByb29mX2luaXQYAyABKAxCFfLeHxF5YW1sOiJwcm9vZl9pbml0IlIJcHJvb2ZJbml0EloKDHByb29mX2hlaWdodBgEIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCG/LeHxN5YW1sOiJwcm9vZl9oZWlnaHQiyN4fAFILcHJvb2ZIZWlnaHQSFgoGc2lnbmVyGAUgASgJUgZzaWduZXI6COigHwCIoB8A');
@$core.Deprecated('Use msgChannelCloseConfirmResponseDescriptor instead')
const MsgChannelCloseConfirmResponse$json = {
  '1': 'MsgChannelCloseConfirmResponse',
};

/// Descriptor for `MsgChannelCloseConfirmResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgChannelCloseConfirmResponseDescriptor =
    $convert.base64Decode('Ch5Nc2dDaGFubmVsQ2xvc2VDb25maXJtUmVzcG9uc2U=');
@$core.Deprecated('Use msgRecvPacketDescriptor instead')
const MsgRecvPacket$json = {
  '1': 'MsgRecvPacket',
  '2': [
    {
      '1': 'packet',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.channel.v1.Packet',
      '8': {},
      '10': 'packet'
    },
    {
      '1': 'proof_commitment',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'proofCommitment'
    },
    {
      '1': 'proof_height',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {'1': 'signer', '3': 4, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgRecvPacket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgRecvPacketDescriptor = $convert.base64Decode(
    'Cg1Nc2dSZWN2UGFja2V0EjkKBnBhY2tldBgBIAEoCzIbLmliYy5jb3JlLmNoYW5uZWwudjEuUGFja2V0QgTI3h8AUgZwYWNrZXQSRgoQcHJvb2ZfY29tbWl0bWVudBgCIAEoDEIb8t4fF3lhbWw6InByb29mX2NvbW1pdG1lbnQiUg9wcm9vZkNvbW1pdG1lbnQSWgoMcHJvb2ZfaGVpZ2h0GAMgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIb8t4fE3lhbWw6InByb29mX2hlaWdodCLI3h8AUgtwcm9vZkhlaWdodBIWCgZzaWduZXIYBCABKAlSBnNpZ25lcjoI6KAfAIigHwA=');
@$core.Deprecated('Use msgRecvPacketResponseDescriptor instead')
const MsgRecvPacketResponse$json = {
  '1': 'MsgRecvPacketResponse',
};

/// Descriptor for `MsgRecvPacketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgRecvPacketResponseDescriptor =
    $convert.base64Decode('ChVNc2dSZWN2UGFja2V0UmVzcG9uc2U=');
@$core.Deprecated('Use msgTimeoutDescriptor instead')
const MsgTimeout$json = {
  '1': 'MsgTimeout',
  '2': [
    {
      '1': 'packet',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.channel.v1.Packet',
      '8': {},
      '10': 'packet'
    },
    {
      '1': 'proof_unreceived',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'proofUnreceived'
    },
    {
      '1': 'proof_height',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {
      '1': 'next_sequence_recv',
      '3': 4,
      '4': 1,
      '5': 4,
      '8': {},
      '10': 'nextSequenceRecv'
    },
    {'1': 'signer', '3': 5, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgTimeout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgTimeoutDescriptor = $convert.base64Decode(
    'CgpNc2dUaW1lb3V0EjkKBnBhY2tldBgBIAEoCzIbLmliYy5jb3JlLmNoYW5uZWwudjEuUGFja2V0QgTI3h8AUgZwYWNrZXQSRgoQcHJvb2ZfdW5yZWNlaXZlZBgCIAEoDEIb8t4fF3lhbWw6InByb29mX3VucmVjZWl2ZWQiUg9wcm9vZlVucmVjZWl2ZWQSWgoMcHJvb2ZfaGVpZ2h0GAMgASgLMhouaWJjLmNvcmUuY2xpZW50LnYxLkhlaWdodEIb8t4fE3lhbWw6InByb29mX2hlaWdodCLI3h8AUgtwcm9vZkhlaWdodBJLChJuZXh0X3NlcXVlbmNlX3JlY3YYBCABKARCHfLeHxl5YW1sOiJuZXh0X3NlcXVlbmNlX3JlY3YiUhBuZXh0U2VxdWVuY2VSZWN2EhYKBnNpZ25lchgFIAEoCVIGc2lnbmVyOgjooB8AiKAfAA==');
@$core.Deprecated('Use msgTimeoutResponseDescriptor instead')
const MsgTimeoutResponse$json = {
  '1': 'MsgTimeoutResponse',
};

/// Descriptor for `MsgTimeoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgTimeoutResponseDescriptor =
    $convert.base64Decode('ChJNc2dUaW1lb3V0UmVzcG9uc2U=');
@$core.Deprecated('Use msgTimeoutOnCloseDescriptor instead')
const MsgTimeoutOnClose$json = {
  '1': 'MsgTimeoutOnClose',
  '2': [
    {
      '1': 'packet',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.channel.v1.Packet',
      '8': {},
      '10': 'packet'
    },
    {
      '1': 'proof_unreceived',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'proofUnreceived'
    },
    {'1': 'proof_close', '3': 3, '4': 1, '5': 12, '8': {}, '10': 'proofClose'},
    {
      '1': 'proof_height',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {
      '1': 'next_sequence_recv',
      '3': 5,
      '4': 1,
      '5': 4,
      '8': {},
      '10': 'nextSequenceRecv'
    },
    {'1': 'signer', '3': 6, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgTimeoutOnClose`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgTimeoutOnCloseDescriptor = $convert.base64Decode(
    'ChFNc2dUaW1lb3V0T25DbG9zZRI5CgZwYWNrZXQYASABKAsyGy5pYmMuY29yZS5jaGFubmVsLnYxLlBhY2tldEIEyN4fAFIGcGFja2V0EkYKEHByb29mX3VucmVjZWl2ZWQYAiABKAxCG/LeHxd5YW1sOiJwcm9vZl91bnJlY2VpdmVkIlIPcHJvb2ZVbnJlY2VpdmVkEjcKC3Byb29mX2Nsb3NlGAMgASgMQhby3h8SeWFtbDoicHJvb2ZfY2xvc2UiUgpwcm9vZkNsb3NlEloKDHByb29mX2hlaWdodBgEIAEoCzIaLmliYy5jb3JlLmNsaWVudC52MS5IZWlnaHRCG/LeHxN5YW1sOiJwcm9vZl9oZWlnaHQiyN4fAFILcHJvb2ZIZWlnaHQSSwoSbmV4dF9zZXF1ZW5jZV9yZWN2GAUgASgEQh3y3h8ZeWFtbDoibmV4dF9zZXF1ZW5jZV9yZWN2IlIQbmV4dFNlcXVlbmNlUmVjdhIWCgZzaWduZXIYBiABKAlSBnNpZ25lcjoI6KAfAIigHwA=');
@$core.Deprecated('Use msgTimeoutOnCloseResponseDescriptor instead')
const MsgTimeoutOnCloseResponse$json = {
  '1': 'MsgTimeoutOnCloseResponse',
};

/// Descriptor for `MsgTimeoutOnCloseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgTimeoutOnCloseResponseDescriptor =
    $convert.base64Decode('ChlNc2dUaW1lb3V0T25DbG9zZVJlc3BvbnNl');
@$core.Deprecated('Use msgAcknowledgementDescriptor instead')
const MsgAcknowledgement$json = {
  '1': 'MsgAcknowledgement',
  '2': [
    {
      '1': 'packet',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.channel.v1.Packet',
      '8': {},
      '10': 'packet'
    },
    {'1': 'acknowledgement', '3': 2, '4': 1, '5': 12, '10': 'acknowledgement'},
    {'1': 'proof_acked', '3': 3, '4': 1, '5': 12, '8': {}, '10': 'proofAcked'},
    {
      '1': 'proof_height',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ibc.core.client.v1.Height',
      '8': {},
      '10': 'proofHeight'
    },
    {'1': 'signer', '3': 5, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': {},
};

/// Descriptor for `MsgAcknowledgement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAcknowledgementDescriptor = $convert.base64Decode(
    'ChJNc2dBY2tub3dsZWRnZW1lbnQSOQoGcGFja2V0GAEgASgLMhsuaWJjLmNvcmUuY2hhbm5lbC52MS5QYWNrZXRCBMjeHwBSBnBhY2tldBIoCg9hY2tub3dsZWRnZW1lbnQYAiABKAxSD2Fja25vd2xlZGdlbWVudBI3Cgtwcm9vZl9hY2tlZBgDIAEoDEIW8t4fEnlhbWw6InByb29mX2Fja2VkIlIKcHJvb2ZBY2tlZBJaCgxwcm9vZl9oZWlnaHQYBCABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0Qhvy3h8TeWFtbDoicHJvb2ZfaGVpZ2h0IsjeHwBSC3Byb29mSGVpZ2h0EhYKBnNpZ25lchgFIAEoCVIGc2lnbmVyOgjooB8AiKAfAA==');
@$core.Deprecated('Use msgAcknowledgementResponseDescriptor instead')
const MsgAcknowledgementResponse$json = {
  '1': 'MsgAcknowledgementResponse',
};

/// Descriptor for `MsgAcknowledgementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAcknowledgementResponseDescriptor =
    $convert.base64Decode('ChpNc2dBY2tub3dsZWRnZW1lbnRSZXNwb25zZQ==');
