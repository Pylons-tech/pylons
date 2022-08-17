///
//  Generated code. Do not modify.
//  source: ibc/core/client/v1/tx.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use msgCreateClientDescriptor instead')
const MsgCreateClient$json = const {
  '1': 'MsgCreateClient',
  '2': const [
    const {'1': 'client_state', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Any', '8': const {}, '10': 'clientState'},
    const {'1': 'consensus_state', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Any', '8': const {}, '10': 'consensusState'},
    const {'1': 'signer', '3': 3, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': const {},
};

/// Descriptor for `MsgCreateClient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateClientDescriptor = $convert.base64Decode('Cg9Nc2dDcmVhdGVDbGllbnQSUAoMY2xpZW50X3N0YXRlGAEgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueUIX8t4fE3lhbWw6ImNsaWVudF9zdGF0ZSJSC2NsaWVudFN0YXRlElkKD2NvbnNlbnN1c19zdGF0ZRgCIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlCGvLeHxZ5YW1sOiJjb25zZW5zdXNfc3RhdGUiUg5jb25zZW5zdXNTdGF0ZRIWCgZzaWduZXIYAyABKAlSBnNpZ25lcjoI6KAfAIigHwA=');
@$core.Deprecated('Use msgCreateClientResponseDescriptor instead')
const MsgCreateClientResponse$json = const {
  '1': 'MsgCreateClientResponse',
};

/// Descriptor for `MsgCreateClientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateClientResponseDescriptor = $convert.base64Decode('ChdNc2dDcmVhdGVDbGllbnRSZXNwb25zZQ==');
@$core.Deprecated('Use msgUpdateClientDescriptor instead')
const MsgUpdateClient$json = const {
  '1': 'MsgUpdateClient',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'header', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Any', '10': 'header'},
    const {'1': 'signer', '3': 3, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': const {},
};

/// Descriptor for `MsgUpdateClient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateClientDescriptor = $convert.base64Decode('Cg9Nc2dVcGRhdGVDbGllbnQSMQoJY2xpZW50X2lkGAEgASgJQhTy3h8QeWFtbDoiY2xpZW50X2lkIlIIY2xpZW50SWQSLAoGaGVhZGVyGAIgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueVIGaGVhZGVyEhYKBnNpZ25lchgDIAEoCVIGc2lnbmVyOgjooB8AiKAfAA==');
@$core.Deprecated('Use msgUpdateClientResponseDescriptor instead')
const MsgUpdateClientResponse$json = const {
  '1': 'MsgUpdateClientResponse',
};

/// Descriptor for `MsgUpdateClientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateClientResponseDescriptor = $convert.base64Decode('ChdNc2dVcGRhdGVDbGllbnRSZXNwb25zZQ==');
@$core.Deprecated('Use msgUpgradeClientDescriptor instead')
const MsgUpgradeClient$json = const {
  '1': 'MsgUpgradeClient',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'client_state', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Any', '8': const {}, '10': 'clientState'},
    const {'1': 'consensus_state', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Any', '8': const {}, '10': 'consensusState'},
    const {'1': 'proof_upgrade_client', '3': 4, '4': 1, '5': 12, '8': const {}, '10': 'proofUpgradeClient'},
    const {'1': 'proof_upgrade_consensus_state', '3': 5, '4': 1, '5': 12, '8': const {}, '10': 'proofUpgradeConsensusState'},
    const {'1': 'signer', '3': 6, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': const {},
};

/// Descriptor for `MsgUpgradeClient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpgradeClientDescriptor = $convert.base64Decode('ChBNc2dVcGdyYWRlQ2xpZW50EjEKCWNsaWVudF9pZBgBIAEoCUIU8t4fEHlhbWw6ImNsaWVudF9pZCJSCGNsaWVudElkElAKDGNsaWVudF9zdGF0ZRgCIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlCF/LeHxN5YW1sOiJjbGllbnRfc3RhdGUiUgtjbGllbnRTdGF0ZRJZCg9jb25zZW5zdXNfc3RhdGUYAyABKAsyFC5nb29nbGUucHJvdG9idWYuQW55Qhry3h8WeWFtbDoiY29uc2Vuc3VzX3N0YXRlIlIOY29uc2Vuc3VzU3RhdGUSUQoUcHJvb2ZfdXBncmFkZV9jbGllbnQYBCABKAxCH/LeHxt5YW1sOiJwcm9vZl91cGdyYWRlX2NsaWVudCJSEnByb29mVXBncmFkZUNsaWVudBJrCh1wcm9vZl91cGdyYWRlX2NvbnNlbnN1c19zdGF0ZRgFIAEoDEIo8t4fJHlhbWw6InByb29mX3VwZ3JhZGVfY29uc2Vuc3VzX3N0YXRlIlIacHJvb2ZVcGdyYWRlQ29uc2Vuc3VzU3RhdGUSFgoGc2lnbmVyGAYgASgJUgZzaWduZXI6COigHwCIoB8A');
@$core.Deprecated('Use msgUpgradeClientResponseDescriptor instead')
const MsgUpgradeClientResponse$json = const {
  '1': 'MsgUpgradeClientResponse',
};

/// Descriptor for `MsgUpgradeClientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpgradeClientResponseDescriptor = $convert.base64Decode('ChhNc2dVcGdyYWRlQ2xpZW50UmVzcG9uc2U=');
@$core.Deprecated('Use msgSubmitMisbehaviourDescriptor instead')
const MsgSubmitMisbehaviour$json = const {
  '1': 'MsgSubmitMisbehaviour',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'misbehaviour', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Any', '10': 'misbehaviour'},
    const {'1': 'signer', '3': 3, '4': 1, '5': 9, '10': 'signer'},
  ],
  '7': const {},
};

/// Descriptor for `MsgSubmitMisbehaviour`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgSubmitMisbehaviourDescriptor = $convert.base64Decode('ChVNc2dTdWJtaXRNaXNiZWhhdmlvdXISMQoJY2xpZW50X2lkGAEgASgJQhTy3h8QeWFtbDoiY2xpZW50X2lkIlIIY2xpZW50SWQSOAoMbWlzYmVoYXZpb3VyGAIgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueVIMbWlzYmVoYXZpb3VyEhYKBnNpZ25lchgDIAEoCVIGc2lnbmVyOgjooB8AiKAfAA==');
@$core.Deprecated('Use msgSubmitMisbehaviourResponseDescriptor instead')
const MsgSubmitMisbehaviourResponse$json = const {
  '1': 'MsgSubmitMisbehaviourResponse',
};

/// Descriptor for `MsgSubmitMisbehaviourResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgSubmitMisbehaviourResponseDescriptor = $convert.base64Decode('Ch1Nc2dTdWJtaXRNaXNiZWhhdmlvdXJSZXNwb25zZQ==');
