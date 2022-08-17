///
//  Generated code. Do not modify.
//  source: ibc/core/channel/v1/channel.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use stateDescriptor instead')
const State$json = const {
  '1': 'State',
  '2': const [
    const {'1': 'STATE_UNINITIALIZED_UNSPECIFIED', '2': 0, '3': const {}},
    const {'1': 'STATE_INIT', '2': 1, '3': const {}},
    const {'1': 'STATE_TRYOPEN', '2': 2, '3': const {}},
    const {'1': 'STATE_OPEN', '2': 3, '3': const {}},
    const {'1': 'STATE_CLOSED', '2': 4, '3': const {}},
  ],
  '3': const {},
};

/// Descriptor for `State`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stateDescriptor = $convert.base64Decode('CgVTdGF0ZRI2Ch9TVEFURV9VTklOSVRJQUxJWkVEX1VOU1BFQ0lGSUVEEAAaEYqdIA1VTklOSVRJQUxJWkVEEhgKClNUQVRFX0lOSVQQARoIip0gBElOSVQSHgoNU1RBVEVfVFJZT1BFThACGguKnSAHVFJZT1BFThIYCgpTVEFURV9PUEVOEAMaCIqdIARPUEVOEhwKDFNUQVRFX0NMT1NFRBAEGgqKnSAGQ0xPU0VEGgSIox4A');
@$core.Deprecated('Use orderDescriptor instead')
const Order$json = const {
  '1': 'Order',
  '2': const [
    const {'1': 'ORDER_NONE_UNSPECIFIED', '2': 0, '3': const {}},
    const {'1': 'ORDER_UNORDERED', '2': 1, '3': const {}},
    const {'1': 'ORDER_ORDERED', '2': 2, '3': const {}},
  ],
  '3': const {},
};

/// Descriptor for `Order`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode('CgVPcmRlchIkChZPUkRFUl9OT05FX1VOU1BFQ0lGSUVEEAAaCIqdIAROT05FEiIKD09SREVSX1VOT1JERVJFRBABGg2KnSAJVU5PUkRFUkVEEh4KDU9SREVSX09SREVSRUQQAhoLip0gB09SREVSRUQaBIijHgA=');
@$core.Deprecated('Use channelDescriptor instead')
const Channel$json = const {
  '1': 'Channel',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.ibc.core.channel.v1.State', '10': 'state'},
    const {'1': 'ordering', '3': 2, '4': 1, '5': 14, '6': '.ibc.core.channel.v1.Order', '10': 'ordering'},
    const {'1': 'counterparty', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.channel.v1.Counterparty', '8': const {}, '10': 'counterparty'},
    const {'1': 'connection_hops', '3': 4, '4': 3, '5': 9, '8': const {}, '10': 'connectionHops'},
    const {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
  ],
  '7': const {},
};

/// Descriptor for `Channel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDescriptor = $convert.base64Decode('CgdDaGFubmVsEjAKBXN0YXRlGAEgASgOMhouaWJjLmNvcmUuY2hhbm5lbC52MS5TdGF0ZVIFc3RhdGUSNgoIb3JkZXJpbmcYAiABKA4yGi5pYmMuY29yZS5jaGFubmVsLnYxLk9yZGVyUghvcmRlcmluZxJLCgxjb3VudGVycGFydHkYAyABKAsyIS5pYmMuY29yZS5jaGFubmVsLnYxLkNvdW50ZXJwYXJ0eUIEyN4fAFIMY291bnRlcnBhcnR5EkMKD2Nvbm5lY3Rpb25faG9wcxgEIAMoCUIa8t4fFnlhbWw6ImNvbm5lY3Rpb25faG9wcyJSDmNvbm5lY3Rpb25Ib3BzEhgKB3ZlcnNpb24YBSABKAlSB3ZlcnNpb246BIigHwA=');
@$core.Deprecated('Use identifiedChannelDescriptor instead')
const IdentifiedChannel$json = const {
  '1': 'IdentifiedChannel',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.ibc.core.channel.v1.State', '10': 'state'},
    const {'1': 'ordering', '3': 2, '4': 1, '5': 14, '6': '.ibc.core.channel.v1.Order', '10': 'ordering'},
    const {'1': 'counterparty', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.channel.v1.Counterparty', '8': const {}, '10': 'counterparty'},
    const {'1': 'connection_hops', '3': 4, '4': 3, '5': 9, '8': const {}, '10': 'connectionHops'},
    const {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'port_id', '3': 6, '4': 1, '5': 9, '10': 'portId'},
    const {'1': 'channel_id', '3': 7, '4': 1, '5': 9, '10': 'channelId'},
  ],
  '7': const {},
};

/// Descriptor for `IdentifiedChannel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifiedChannelDescriptor = $convert.base64Decode('ChFJZGVudGlmaWVkQ2hhbm5lbBIwCgVzdGF0ZRgBIAEoDjIaLmliYy5jb3JlLmNoYW5uZWwudjEuU3RhdGVSBXN0YXRlEjYKCG9yZGVyaW5nGAIgASgOMhouaWJjLmNvcmUuY2hhbm5lbC52MS5PcmRlclIIb3JkZXJpbmcSSwoMY291bnRlcnBhcnR5GAMgASgLMiEuaWJjLmNvcmUuY2hhbm5lbC52MS5Db3VudGVycGFydHlCBMjeHwBSDGNvdW50ZXJwYXJ0eRJDCg9jb25uZWN0aW9uX2hvcHMYBCADKAlCGvLeHxZ5YW1sOiJjb25uZWN0aW9uX2hvcHMiUg5jb25uZWN0aW9uSG9wcxIYCgd2ZXJzaW9uGAUgASgJUgd2ZXJzaW9uEhcKB3BvcnRfaWQYBiABKAlSBnBvcnRJZBIdCgpjaGFubmVsX2lkGAcgASgJUgljaGFubmVsSWQ6BIigHwA=');
@$core.Deprecated('Use counterpartyDescriptor instead')
const Counterparty$json = const {
  '1': 'Counterparty',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'channelId'},
  ],
  '7': const {},
};

/// Descriptor for `Counterparty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List counterpartyDescriptor = $convert.base64Decode('CgxDb3VudGVycGFydHkSKwoHcG9ydF9pZBgBIAEoCUIS8t4fDnlhbWw6InBvcnRfaWQiUgZwb3J0SWQSNAoKY2hhbm5lbF9pZBgCIAEoCUIV8t4fEXlhbWw6ImNoYW5uZWxfaWQiUgljaGFubmVsSWQ6BIigHwA=');
@$core.Deprecated('Use packetDescriptor instead')
const Packet$json = const {
  '1': 'Packet',
  '2': const [
    const {'1': 'sequence', '3': 1, '4': 1, '5': 4, '10': 'sequence'},
    const {'1': 'source_port', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'sourcePort'},
    const {'1': 'source_channel', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'sourceChannel'},
    const {'1': 'destination_port', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'destinationPort'},
    const {'1': 'destination_channel', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'destinationChannel'},
    const {'1': 'data', '3': 6, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'timeout_height', '3': 7, '4': 1, '5': 11, '6': '.ibc.core.client.v1.Height', '8': const {}, '10': 'timeoutHeight'},
    const {'1': 'timeout_timestamp', '3': 8, '4': 1, '5': 4, '8': const {}, '10': 'timeoutTimestamp'},
  ],
  '7': const {},
};

/// Descriptor for `Packet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetDescriptor = $convert.base64Decode('CgZQYWNrZXQSGgoIc2VxdWVuY2UYASABKARSCHNlcXVlbmNlEjcKC3NvdXJjZV9wb3J0GAIgASgJQhby3h8SeWFtbDoic291cmNlX3BvcnQiUgpzb3VyY2VQb3J0EkAKDnNvdXJjZV9jaGFubmVsGAMgASgJQhny3h8VeWFtbDoic291cmNlX2NoYW5uZWwiUg1zb3VyY2VDaGFubmVsEkYKEGRlc3RpbmF0aW9uX3BvcnQYBCABKAlCG/LeHxd5YW1sOiJkZXN0aW5hdGlvbl9wb3J0IlIPZGVzdGluYXRpb25Qb3J0Ek8KE2Rlc3RpbmF0aW9uX2NoYW5uZWwYBSABKAlCHvLeHxp5YW1sOiJkZXN0aW5hdGlvbl9jaGFubmVsIlISZGVzdGluYXRpb25DaGFubmVsEhIKBGRhdGEYBiABKAxSBGRhdGESYAoOdGltZW91dF9oZWlnaHQYByABKAsyGi5pYmMuY29yZS5jbGllbnQudjEuSGVpZ2h0Qh3y3h8VeWFtbDoidGltZW91dF9oZWlnaHQiyN4fAFINdGltZW91dEhlaWdodBJJChF0aW1lb3V0X3RpbWVzdGFtcBgIIAEoBEIc8t4fGHlhbWw6InRpbWVvdXRfdGltZXN0YW1wIlIQdGltZW91dFRpbWVzdGFtcDoEiKAfAA==');
@$core.Deprecated('Use packetStateDescriptor instead')
const PacketState$json = const {
  '1': 'PacketState',
  '2': const [
    const {'1': 'port_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'portId'},
    const {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'channelId'},
    const {'1': 'sequence', '3': 3, '4': 1, '5': 4, '10': 'sequence'},
    const {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
  '7': const {},
};

/// Descriptor for `PacketState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetStateDescriptor = $convert.base64Decode('CgtQYWNrZXRTdGF0ZRIrCgdwb3J0X2lkGAEgASgJQhLy3h8OeWFtbDoicG9ydF9pZCJSBnBvcnRJZBI0CgpjaGFubmVsX2lkGAIgASgJQhXy3h8ReWFtbDoiY2hhbm5lbF9pZCJSCWNoYW5uZWxJZBIaCghzZXF1ZW5jZRgDIAEoBFIIc2VxdWVuY2USEgoEZGF0YRgEIAEoDFIEZGF0YToEiKAfAA==');
@$core.Deprecated('Use acknowledgementDescriptor instead')
const Acknowledgement$json = const {
  '1': 'Acknowledgement',
  '2': const [
    const {'1': 'result', '3': 21, '4': 1, '5': 12, '9': 0, '10': 'result'},
    const {'1': 'error', '3': 22, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '8': const [
    const {'1': 'response'},
  ],
};

/// Descriptor for `Acknowledgement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgementDescriptor = $convert.base64Decode('Cg9BY2tub3dsZWRnZW1lbnQSGAoGcmVzdWx0GBUgASgMSABSBnJlc3VsdBIWCgVlcnJvchgWIAEoCUgAUgVlcnJvckIKCghyZXNwb25zZQ==');
