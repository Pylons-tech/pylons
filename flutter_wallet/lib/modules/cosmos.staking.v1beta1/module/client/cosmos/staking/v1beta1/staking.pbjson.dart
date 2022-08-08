///
//  Generated code. Do not modify.
//  source: cosmos/staking/v1beta1/staking.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use bondStatusDescriptor instead')
const BondStatus$json = {
  '1': 'BondStatus',
  '2': [
    {'1': 'BOND_STATUS_UNSPECIFIED', '2': 0, '3': {}},
    {'1': 'BOND_STATUS_UNBONDED', '2': 1, '3': {}},
    {'1': 'BOND_STATUS_UNBONDING', '2': 2, '3': {}},
    {'1': 'BOND_STATUS_BONDED', '2': 3, '3': {}},
  ],
  '3': {},
};

/// Descriptor for `BondStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bondStatusDescriptor = $convert.base64Decode(
    'CgpCb25kU3RhdHVzEiwKF0JPTkRfU1RBVFVTX1VOU1BFQ0lGSUVEEAAaD4qdIAtVbnNwZWNpZmllZBImChRCT05EX1NUQVRVU19VTkJPTkRFRBABGgyKnSAIVW5ib25kZWQSKAoVQk9ORF9TVEFUVVNfVU5CT05ESU5HEAIaDYqdIAlVbmJvbmRpbmcSIgoSQk9ORF9TVEFUVVNfQk9OREVEEAMaCoqdIAZCb25kZWQaBIijHgA=');
@$core.Deprecated('Use historicalInfoDescriptor instead')
const HistoricalInfo$json = {
  '1': 'HistoricalInfo',
  '2': [
    {
      '1': 'header',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tendermint.types.Header',
      '8': {},
      '10': 'header'
    },
    {
      '1': 'valset',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.Validator',
      '8': {},
      '10': 'valset'
    },
  ],
};

/// Descriptor for `HistoricalInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historicalInfoDescriptor = $convert.base64Decode(
    'Cg5IaXN0b3JpY2FsSW5mbxI2CgZoZWFkZXIYASABKAsyGC50ZW5kZXJtaW50LnR5cGVzLkhlYWRlckIEyN4fAFIGaGVhZGVyEj8KBnZhbHNldBgCIAMoCzIhLmNvc21vcy5zdGFraW5nLnYxYmV0YTEuVmFsaWRhdG9yQgTI3h8AUgZ2YWxzZXQ=');
@$core.Deprecated('Use commissionRatesDescriptor instead')
const CommissionRates$json = {
  '1': 'CommissionRates',
  '2': [
    {'1': 'rate', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'rate'},
    {'1': 'max_rate', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'maxRate'},
    {
      '1': 'max_change_rate',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'maxChangeRate'
    },
  ],
  '7': {},
};

/// Descriptor for `CommissionRates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionRatesDescriptor = $convert.base64Decode(
    'Cg9Db21taXNzaW9uUmF0ZXMSQgoEcmF0ZRgBIAEoCUIu2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjyN4fAFIEcmF0ZRJcCghtYXhfcmF0ZRgCIAEoCUJB8t4fD3lhbWw6Im1heF9yYXRlItreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY8jeHwBSB21heFJhdGUScAoPbWF4X2NoYW5nZV9yYXRlGAMgASgJQkjy3h8WeWFtbDoibWF4X2NoYW5nZV9yYXRlItreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY8jeHwBSDW1heENoYW5nZVJhdGU6COigHwGYoB8A');
@$core.Deprecated('Use commissionDescriptor instead')
const Commission$json = {
  '1': 'Commission',
  '2': [
    {
      '1': 'commission_rates',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.CommissionRates',
      '8': {},
      '10': 'commissionRates'
    },
    {
      '1': 'update_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': {},
      '10': 'updateTime'
    },
  ],
  '7': {},
};

/// Descriptor for `Commission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionDescriptor = $convert.base64Decode(
    'CgpDb21taXNzaW9uElwKEGNvbW1pc3Npb25fcmF0ZXMYASABKAsyJy5jb3Ntb3Muc3Rha2luZy52MWJldGExLkNvbW1pc3Npb25SYXRlc0II0N4fAcjeHwBSD2NvbW1pc3Npb25SYXRlcxJbCgt1cGRhdGVfdGltZRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBCHsjeHwCQ3x8B8t4fEnlhbWw6InVwZGF0ZV90aW1lIlIKdXBkYXRlVGltZToI6KAfAZigHwA=');
@$core.Deprecated('Use descriptionDescriptor instead')
const Description$json = {
  '1': 'Description',
  '2': [
    {'1': 'moniker', '3': 1, '4': 1, '5': 9, '10': 'moniker'},
    {'1': 'identity', '3': 2, '4': 1, '5': 9, '10': 'identity'},
    {'1': 'website', '3': 3, '4': 1, '5': 9, '10': 'website'},
    {
      '1': 'security_contact',
      '3': 4,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'securityContact'
    },
    {'1': 'details', '3': 5, '4': 1, '5': 9, '10': 'details'},
  ],
  '7': {},
};

/// Descriptor for `Description`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List descriptionDescriptor = $convert.base64Decode(
    'CgtEZXNjcmlwdGlvbhIYCgdtb25pa2VyGAEgASgJUgdtb25pa2VyEhoKCGlkZW50aXR5GAIgASgJUghpZGVudGl0eRIYCgd3ZWJzaXRlGAMgASgJUgd3ZWJzaXRlEkYKEHNlY3VyaXR5X2NvbnRhY3QYBCABKAlCG/LeHxd5YW1sOiJzZWN1cml0eV9jb250YWN0IlIPc2VjdXJpdHlDb250YWN0EhgKB2RldGFpbHMYBSABKAlSB2RldGFpbHM6COigHwGYoB8A');
@$core.Deprecated('Use validatorDescriptor instead')
const Validator$json = {
  '1': 'Validator',
  '2': [
    {
      '1': 'operator_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'operatorAddress'
    },
    {
      '1': 'consensus_pubkey',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '8': {},
      '10': 'consensusPubkey'
    },
    {'1': 'jailed', '3': 3, '4': 1, '5': 8, '10': 'jailed'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.cosmos.staking.v1beta1.BondStatus',
      '10': 'status'
    },
    {'1': 'tokens', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'tokens'},
    {
      '1': 'delegator_shares',
      '3': 6,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'delegatorShares'
    },
    {
      '1': 'description',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.Description',
      '8': {},
      '10': 'description'
    },
    {
      '1': 'unbonding_height',
      '3': 8,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'unbondingHeight'
    },
    {
      '1': 'unbonding_time',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': {},
      '10': 'unbondingTime'
    },
    {
      '1': 'commission',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.Commission',
      '8': {},
      '10': 'commission'
    },
    {
      '1': 'min_self_delegation',
      '3': 11,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'minSelfDelegation'
    },
  ],
  '7': {},
};

/// Descriptor for `Validator`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validatorDescriptor = $convert.base64Decode(
    'CglWYWxpZGF0b3ISRgoQb3BlcmF0b3JfYWRkcmVzcxgBIAEoCUIb8t4fF3lhbWw6Im9wZXJhdG9yX2FkZHJlc3MiUg9vcGVyYXRvckFkZHJlc3MSdAoQY29uc2Vuc3VzX3B1YmtleRgCIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlCM8q0LRRjb3Ntb3MuY3J5cHRvLlB1YktlefLeHxd5YW1sOiJjb25zZW5zdXNfcHVia2V5IlIPY29uc2Vuc3VzUHVia2V5EhYKBmphaWxlZBgDIAEoCFIGamFpbGVkEjoKBnN0YXR1cxgEIAEoDjIiLmNvc21vcy5zdGFraW5nLnYxYmV0YTEuQm9uZFN0YXR1c1IGc3RhdHVzEkYKBnRva2VucxgFIAEoCUIu2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuSW50yN4fAFIGdG9rZW5zEnQKEGRlbGVnYXRvcl9zaGFyZXMYBiABKAlCSfLeHxd5YW1sOiJkZWxlZ2F0b3Jfc2hhcmVzItreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY8jeHwBSD2RlbGVnYXRvclNoYXJlcxJLCgtkZXNjcmlwdGlvbhgHIAEoCzIjLmNvc21vcy5zdGFraW5nLnYxYmV0YTEuRGVzY3JpcHRpb25CBMjeHwBSC2Rlc2NyaXB0aW9uEkYKEHVuYm9uZGluZ19oZWlnaHQYCCABKANCG/LeHxd5YW1sOiJ1bmJvbmRpbmdfaGVpZ2h0IlIPdW5ib25kaW5nSGVpZ2h0EmQKDnVuYm9uZGluZ190aW1lGAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEIhyN4fAJDfHwHy3h8VeWFtbDoidW5ib25kaW5nX3RpbWUiUg11bmJvbmRpbmdUaW1lEkgKCmNvbW1pc3Npb24YCiABKAsyIi5jb3Ntb3Muc3Rha2luZy52MWJldGExLkNvbW1pc3Npb25CBMjeHwBSCmNvbW1pc3Npb24SfAoTbWluX3NlbGZfZGVsZWdhdGlvbhgLIAEoCUJM8t4fGnlhbWw6Im1pbl9zZWxmX2RlbGVnYXRpb24i2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuSW50yN4fAFIRbWluU2VsZkRlbGVnYXRpb246DOigHwCYoB8AiKAfAA==');
@$core.Deprecated('Use valAddressesDescriptor instead')
const ValAddresses$json = {
  '1': 'ValAddresses',
  '2': [
    {'1': 'addresses', '3': 1, '4': 3, '5': 9, '10': 'addresses'},
  ],
  '7': {},
};

/// Descriptor for `ValAddresses`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List valAddressesDescriptor = $convert.base64Decode(
    'CgxWYWxBZGRyZXNzZXMSHAoJYWRkcmVzc2VzGAEgAygJUglhZGRyZXNzZXM6CJigHwCA3CAB');
@$core.Deprecated('Use dVPairDescriptor instead')
const DVPair$json = {
  '1': 'DVPair',
  '2': [
    {
      '1': 'delegator_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'delegatorAddress'
    },
    {
      '1': 'validator_address',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'validatorAddress'
    },
  ],
  '7': {},
};

/// Descriptor for `DVPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dVPairDescriptor = $convert.base64Decode(
    'CgZEVlBhaXISSQoRZGVsZWdhdG9yX2FkZHJlc3MYASABKAlCHPLeHxh5YW1sOiJkZWxlZ2F0b3JfYWRkcmVzcyJSEGRlbGVnYXRvckFkZHJlc3MSSQoRdmFsaWRhdG9yX2FkZHJlc3MYAiABKAlCHPLeHxh5YW1sOiJ2YWxpZGF0b3JfYWRkcmVzcyJSEHZhbGlkYXRvckFkZHJlc3M6DOigHwCIoB8AmKAfAA==');
@$core.Deprecated('Use dVPairsDescriptor instead')
const DVPairs$json = {
  '1': 'DVPairs',
  '2': [
    {
      '1': 'pairs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.DVPair',
      '8': {},
      '10': 'pairs'
    },
  ],
};

/// Descriptor for `DVPairs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dVPairsDescriptor = $convert.base64Decode(
    'CgdEVlBhaXJzEjoKBXBhaXJzGAEgAygLMh4uY29zbW9zLnN0YWtpbmcudjFiZXRhMS5EVlBhaXJCBMjeHwBSBXBhaXJz');
@$core.Deprecated('Use dVVTripletDescriptor instead')
const DVVTriplet$json = {
  '1': 'DVVTriplet',
  '2': [
    {
      '1': 'delegator_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'delegatorAddress'
    },
    {
      '1': 'validator_src_address',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'validatorSrcAddress'
    },
    {
      '1': 'validator_dst_address',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'validatorDstAddress'
    },
  ],
  '7': {},
};

/// Descriptor for `DVVTriplet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dVVTripletDescriptor = $convert.base64Decode(
    'CgpEVlZUcmlwbGV0EkkKEWRlbGVnYXRvcl9hZGRyZXNzGAEgASgJQhzy3h8YeWFtbDoiZGVsZWdhdG9yX2FkZHJlc3MiUhBkZWxlZ2F0b3JBZGRyZXNzElQKFXZhbGlkYXRvcl9zcmNfYWRkcmVzcxgCIAEoCUIg8t4fHHlhbWw6InZhbGlkYXRvcl9zcmNfYWRkcmVzcyJSE3ZhbGlkYXRvclNyY0FkZHJlc3MSVAoVdmFsaWRhdG9yX2RzdF9hZGRyZXNzGAMgASgJQiDy3h8ceWFtbDoidmFsaWRhdG9yX2RzdF9hZGRyZXNzIlITdmFsaWRhdG9yRHN0QWRkcmVzczoM6KAfAIigHwCYoB8A');
@$core.Deprecated('Use dVVTripletsDescriptor instead')
const DVVTriplets$json = {
  '1': 'DVVTriplets',
  '2': [
    {
      '1': 'triplets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.DVVTriplet',
      '8': {},
      '10': 'triplets'
    },
  ],
};

/// Descriptor for `DVVTriplets`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dVVTripletsDescriptor = $convert.base64Decode(
    'CgtEVlZUcmlwbGV0cxJECgh0cmlwbGV0cxgBIAMoCzIiLmNvc21vcy5zdGFraW5nLnYxYmV0YTEuRFZWVHJpcGxldEIEyN4fAFIIdHJpcGxldHM=');
@$core.Deprecated('Use delegationDescriptor instead')
const Delegation$json = {
  '1': 'Delegation',
  '2': [
    {
      '1': 'delegator_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'delegatorAddress'
    },
    {
      '1': 'validator_address',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'validatorAddress'
    },
    {'1': 'shares', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'shares'},
  ],
  '7': {},
};

/// Descriptor for `Delegation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delegationDescriptor = $convert.base64Decode(
    'CgpEZWxlZ2F0aW9uEkkKEWRlbGVnYXRvcl9hZGRyZXNzGAEgASgJQhzy3h8YeWFtbDoiZGVsZWdhdG9yX2FkZHJlc3MiUhBkZWxlZ2F0b3JBZGRyZXNzEkkKEXZhbGlkYXRvcl9hZGRyZXNzGAIgASgJQhzy3h8YeWFtbDoidmFsaWRhdG9yX2FkZHJlc3MiUhB2YWxpZGF0b3JBZGRyZXNzEkYKBnNoYXJlcxgDIAEoCUIu2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjyN4fAFIGc2hhcmVzOgzooB8AiKAfAJigHwA=');
@$core.Deprecated('Use unbondingDelegationDescriptor instead')
const UnbondingDelegation$json = {
  '1': 'UnbondingDelegation',
  '2': [
    {
      '1': 'delegator_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'delegatorAddress'
    },
    {
      '1': 'validator_address',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'validatorAddress'
    },
    {
      '1': 'entries',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.UnbondingDelegationEntry',
      '8': {},
      '10': 'entries'
    },
  ],
  '7': {},
};

/// Descriptor for `UnbondingDelegation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbondingDelegationDescriptor = $convert.base64Decode(
    'ChNVbmJvbmRpbmdEZWxlZ2F0aW9uEkkKEWRlbGVnYXRvcl9hZGRyZXNzGAEgASgJQhzy3h8YeWFtbDoiZGVsZWdhdG9yX2FkZHJlc3MiUhBkZWxlZ2F0b3JBZGRyZXNzEkkKEXZhbGlkYXRvcl9hZGRyZXNzGAIgASgJQhzy3h8YeWFtbDoidmFsaWRhdG9yX2FkZHJlc3MiUhB2YWxpZGF0b3JBZGRyZXNzElAKB2VudHJpZXMYAyADKAsyMC5jb3Ntb3Muc3Rha2luZy52MWJldGExLlVuYm9uZGluZ0RlbGVnYXRpb25FbnRyeUIEyN4fAFIHZW50cmllczoM6KAfAIigHwCYoB8A');
@$core.Deprecated('Use unbondingDelegationEntryDescriptor instead')
const UnbondingDelegationEntry$json = {
  '1': 'UnbondingDelegationEntry',
  '2': [
    {
      '1': 'creation_height',
      '3': 1,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'creationHeight'
    },
    {
      '1': 'completion_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': {},
      '10': 'completionTime'
    },
    {
      '1': 'initial_balance',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'initialBalance'
    },
    {'1': 'balance', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'balance'},
  ],
  '7': {},
};

/// Descriptor for `UnbondingDelegationEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbondingDelegationEntryDescriptor =
    $convert.base64Decode(
        'ChhVbmJvbmRpbmdEZWxlZ2F0aW9uRW50cnkSQwoPY3JlYXRpb25faGVpZ2h0GAEgASgDQhry3h8WeWFtbDoiY3JlYXRpb25faGVpZ2h0IlIOY3JlYXRpb25IZWlnaHQSZwoPY29tcGxldGlvbl90aW1lGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEIiyN4fAJDfHwHy3h8WeWFtbDoiY29tcGxldGlvbl90aW1lIlIOY29tcGxldGlvblRpbWUScQoPaW5pdGlhbF9iYWxhbmNlGAMgASgJQkja3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5JbnTI3h8A8t4fFnlhbWw6ImluaXRpYWxfYmFsYW5jZSJSDmluaXRpYWxCYWxhbmNlEkgKB2JhbGFuY2UYBCABKAlCLtreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkludMjeHwBSB2JhbGFuY2U6COigHwGYoB8A');
@$core.Deprecated('Use redelegationEntryDescriptor instead')
const RedelegationEntry$json = {
  '1': 'RedelegationEntry',
  '2': [
    {
      '1': 'creation_height',
      '3': 1,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'creationHeight'
    },
    {
      '1': 'completion_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': {},
      '10': 'completionTime'
    },
    {
      '1': 'initial_balance',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'initialBalance'
    },
    {'1': 'shares_dst', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sharesDst'},
  ],
  '7': {},
};

/// Descriptor for `RedelegationEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redelegationEntryDescriptor = $convert.base64Decode(
    'ChFSZWRlbGVnYXRpb25FbnRyeRJDCg9jcmVhdGlvbl9oZWlnaHQYASABKANCGvLeHxZ5YW1sOiJjcmVhdGlvbl9oZWlnaHQiUg5jcmVhdGlvbkhlaWdodBJnCg9jb21wbGV0aW9uX3RpbWUYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wQiLI3h8AkN8fAfLeHxZ5YW1sOiJjb21wbGV0aW9uX3RpbWUiUg5jb21wbGV0aW9uVGltZRJxCg9pbml0aWFsX2JhbGFuY2UYAyABKAlCSNreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkludMjeHwDy3h8WeWFtbDoiaW5pdGlhbF9iYWxhbmNlIlIOaW5pdGlhbEJhbGFuY2USTQoKc2hhcmVzX2RzdBgEIAEoCUIu2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjyN4fAFIJc2hhcmVzRHN0OgjooB8BmKAfAA==');
@$core.Deprecated('Use redelegationDescriptor instead')
const Redelegation$json = {
  '1': 'Redelegation',
  '2': [
    {
      '1': 'delegator_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'delegatorAddress'
    },
    {
      '1': 'validator_src_address',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'validatorSrcAddress'
    },
    {
      '1': 'validator_dst_address',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'validatorDstAddress'
    },
    {
      '1': 'entries',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.RedelegationEntry',
      '8': {},
      '10': 'entries'
    },
  ],
  '7': {},
};

/// Descriptor for `Redelegation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redelegationDescriptor = $convert.base64Decode(
    'CgxSZWRlbGVnYXRpb24SSQoRZGVsZWdhdG9yX2FkZHJlc3MYASABKAlCHPLeHxh5YW1sOiJkZWxlZ2F0b3JfYWRkcmVzcyJSEGRlbGVnYXRvckFkZHJlc3MSVAoVdmFsaWRhdG9yX3NyY19hZGRyZXNzGAIgASgJQiDy3h8ceWFtbDoidmFsaWRhdG9yX3NyY19hZGRyZXNzIlITdmFsaWRhdG9yU3JjQWRkcmVzcxJUChV2YWxpZGF0b3JfZHN0X2FkZHJlc3MYAyABKAlCIPLeHxx5YW1sOiJ2YWxpZGF0b3JfZHN0X2FkZHJlc3MiUhN2YWxpZGF0b3JEc3RBZGRyZXNzEkkKB2VudHJpZXMYBCADKAsyKS5jb3Ntb3Muc3Rha2luZy52MWJldGExLlJlZGVsZWdhdGlvbkVudHJ5QgTI3h8AUgdlbnRyaWVzOgzooB8AiKAfAJigHwA=');
@$core.Deprecated('Use paramsDescriptor instead')
const Params$json = {
  '1': 'Params',
  '2': [
    {
      '1': 'unbonding_time',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '8': {},
      '10': 'unbondingTime'
    },
    {
      '1': 'max_validators',
      '3': 2,
      '4': 1,
      '5': 13,
      '8': {},
      '10': 'maxValidators'
    },
    {'1': 'max_entries', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'maxEntries'},
    {
      '1': 'historical_entries',
      '3': 4,
      '4': 1,
      '5': 13,
      '8': {},
      '10': 'historicalEntries'
    },
    {'1': 'bond_denom', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'bondDenom'},
  ],
  '7': {},
};

/// Descriptor for `Params`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paramsDescriptor = $convert.base64Decode(
    'CgZQYXJhbXMSYwoOdW5ib25kaW5nX3RpbWUYASABKAsyGS5nb29nbGUucHJvdG9idWYuRHVyYXRpb25CIcjeHwCY3x8B8t4fFXlhbWw6InVuYm9uZGluZ190aW1lIlINdW5ib25kaW5nVGltZRJACg5tYXhfdmFsaWRhdG9ycxgCIAEoDUIZ8t4fFXlhbWw6Im1heF92YWxpZGF0b3JzIlINbWF4VmFsaWRhdG9ycxI3CgttYXhfZW50cmllcxgDIAEoDUIW8t4fEnlhbWw6Im1heF9lbnRyaWVzIlIKbWF4RW50cmllcxJMChJoaXN0b3JpY2FsX2VudHJpZXMYBCABKA1CHfLeHxl5YW1sOiJoaXN0b3JpY2FsX2VudHJpZXMiUhFoaXN0b3JpY2FsRW50cmllcxI0Cgpib25kX2Rlbm9tGAUgASgJQhXy3h8ReWFtbDoiYm9uZF9kZW5vbSJSCWJvbmREZW5vbToI6KAfAZigHwA=');
@$core.Deprecated('Use delegationResponseDescriptor instead')
const DelegationResponse$json = {
  '1': 'DelegationResponse',
  '2': [
    {
      '1': 'delegation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.Delegation',
      '8': {},
      '10': 'delegation'
    },
    {
      '1': 'balance',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'balance'
    },
  ],
  '7': {},
};

/// Descriptor for `DelegationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delegationResponseDescriptor = $convert.base64Decode(
    'ChJEZWxlZ2F0aW9uUmVzcG9uc2USSAoKZGVsZWdhdGlvbhgBIAEoCzIiLmNvc21vcy5zdGFraW5nLnYxYmV0YTEuRGVsZWdhdGlvbkIEyN4fAFIKZGVsZWdhdGlvbhI5CgdiYWxhbmNlGAIgASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQgTI3h8AUgdiYWxhbmNlOgjooB8AmKAfAA==');
@$core.Deprecated('Use redelegationEntryResponseDescriptor instead')
const RedelegationEntryResponse$json = {
  '1': 'RedelegationEntryResponse',
  '2': [
    {
      '1': 'redelegation_entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.RedelegationEntry',
      '8': {},
      '10': 'redelegationEntry'
    },
    {'1': 'balance', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'balance'},
  ],
  '7': {},
};

/// Descriptor for `RedelegationEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redelegationEntryResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWRlbGVnYXRpb25FbnRyeVJlc3BvbnNlEl4KEnJlZGVsZWdhdGlvbl9lbnRyeRgBIAEoCzIpLmNvc21vcy5zdGFraW5nLnYxYmV0YTEuUmVkZWxlZ2F0aW9uRW50cnlCBMjeHwBSEXJlZGVsZWdhdGlvbkVudHJ5EkgKB2JhbGFuY2UYBCABKAlCLtreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkludMjeHwBSB2JhbGFuY2U6BOigHwE=');
@$core.Deprecated('Use redelegationResponseDescriptor instead')
const RedelegationResponse$json = {
  '1': 'RedelegationResponse',
  '2': [
    {
      '1': 'redelegation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.Redelegation',
      '8': {},
      '10': 'redelegation'
    },
    {
      '1': 'entries',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.cosmos.staking.v1beta1.RedelegationEntryResponse',
      '8': {},
      '10': 'entries'
    },
  ],
  '7': {},
};

/// Descriptor for `RedelegationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redelegationResponseDescriptor = $convert.base64Decode(
    'ChRSZWRlbGVnYXRpb25SZXNwb25zZRJOCgxyZWRlbGVnYXRpb24YASABKAsyJC5jb3Ntb3Muc3Rha2luZy52MWJldGExLlJlZGVsZWdhdGlvbkIEyN4fAFIMcmVkZWxlZ2F0aW9uElEKB2VudHJpZXMYAiADKAsyMS5jb3Ntb3Muc3Rha2luZy52MWJldGExLlJlZGVsZWdhdGlvbkVudHJ5UmVzcG9uc2VCBMjeHwBSB2VudHJpZXM6BOigHwA=');
@$core.Deprecated('Use poolDescriptor instead')
const Pool$json = {
  '1': 'Pool',
  '2': [
    {
      '1': 'not_bonded_tokens',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'notBondedTokens'
    },
    {
      '1': 'bonded_tokens',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'bondedTokens'
    },
  ],
  '7': {},
};

/// Descriptor for `Pool`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List poolDescriptor = $convert.base64Decode(
    'CgRQb29sEm8KEW5vdF9ib25kZWRfdG9rZW5zGAEgASgJQkPa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5JbnTq3h8Rbm90X2JvbmRlZF90b2tlbnPI3h8AUg9ub3RCb25kZWRUb2tlbnMSfAoNYm9uZGVkX3Rva2VucxgCIAEoCUJX6t4fDWJvbmRlZF90b2tlbnPa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5JbnTI3h8A8t4fFHlhbWw6ImJvbmRlZF90b2tlbnMiUgxib25kZWRUb2tlbnM6CPCgHwHooB8B');
