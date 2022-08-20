///
//  Generated code. Do not modify.
//  source: tendermint/abci/types.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../crypto/proof.pbjson.dart' as $3;
import '../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../types/params.pbjson.dart' as $1;
import '../../google/protobuf/duration.pbjson.dart' as $5;
import '../crypto/keys.pbjson.dart' as $4;
import '../types/types.pbjson.dart' as $2;
import '../version/types.pbjson.dart' as $6;

@$core.Deprecated('Use checkTxTypeDescriptor instead')
const CheckTxType$json = const {
  '1': 'CheckTxType',
  '2': const [
    const {'1': 'NEW', '2': 0, '3': const {}},
    const {'1': 'RECHECK', '2': 1, '3': const {}},
  ],
};

/// Descriptor for `CheckTxType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List checkTxTypeDescriptor = $convert.base64Decode(
    'CgtDaGVja1R4VHlwZRIQCgNORVcQABoHip0gA05ldxIYCgdSRUNIRUNLEAEaC4qdIAdSZWNoZWNr');
@$core.Deprecated('Use evidenceTypeDescriptor instead')
const EvidenceType$json = const {
  '1': 'EvidenceType',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'DUPLICATE_VOTE', '2': 1},
    const {'1': 'LIGHT_CLIENT_ATTACK', '2': 2},
  ],
};

/// Descriptor for `EvidenceType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List evidenceTypeDescriptor = $convert.base64Decode(
    'CgxFdmlkZW5jZVR5cGUSCwoHVU5LTk9XThAAEhIKDkRVUExJQ0FURV9WT1RFEAESFwoTTElHSFRfQ0xJRU5UX0FUVEFDSxAC');
@$core.Deprecated('Use requestDescriptor instead')
const Request$json = const {
  '1': 'Request',
  '2': const [
    const {
      '1': 'echo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestEcho',
      '9': 0,
      '10': 'echo'
    },
    const {
      '1': 'flush',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestFlush',
      '9': 0,
      '10': 'flush'
    },
    const {
      '1': 'info',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestInfo',
      '9': 0,
      '10': 'info'
    },
    const {
      '1': 'init_chain',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestInitChain',
      '9': 0,
      '10': 'initChain'
    },
    const {
      '1': 'query',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestQuery',
      '9': 0,
      '10': 'query'
    },
    const {
      '1': 'begin_block',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestBeginBlock',
      '9': 0,
      '10': 'beginBlock'
    },
    const {
      '1': 'check_tx',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestCheckTx',
      '9': 0,
      '10': 'checkTx'
    },
    const {
      '1': 'deliver_tx',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestDeliverTx',
      '9': 0,
      '10': 'deliverTx'
    },
    const {
      '1': 'end_block',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestEndBlock',
      '9': 0,
      '10': 'endBlock'
    },
    const {
      '1': 'commit',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestCommit',
      '9': 0,
      '10': 'commit'
    },
    const {
      '1': 'list_snapshots',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestListSnapshots',
      '9': 0,
      '10': 'listSnapshots'
    },
    const {
      '1': 'offer_snapshot',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestOfferSnapshot',
      '9': 0,
      '10': 'offerSnapshot'
    },
    const {
      '1': 'load_snapshot_chunk',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestLoadSnapshotChunk',
      '9': 0,
      '10': 'loadSnapshotChunk'
    },
    const {
      '1': 'apply_snapshot_chunk',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.RequestApplySnapshotChunk',
      '9': 0,
      '10': 'applySnapshotChunk'
    },
  ],
  '8': const [
    const {'1': 'value'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode(
    'CgdSZXF1ZXN0EjIKBGVjaG8YASABKAsyHC50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdEVjaG9IAFIEZWNobxI1CgVmbHVzaBgCIAEoCzIdLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0Rmx1c2hIAFIFZmx1c2gSMgoEaW5mbxgDIAEoCzIcLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0SW5mb0gAUgRpbmZvEkIKCmluaXRfY2hhaW4YBCABKAsyIS50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdEluaXRDaGFpbkgAUglpbml0Q2hhaW4SNQoFcXVlcnkYBSABKAsyHS50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdFF1ZXJ5SABSBXF1ZXJ5EkUKC2JlZ2luX2Jsb2NrGAYgASgLMiIudGVuZGVybWludC5hYmNpLlJlcXVlc3RCZWdpbkJsb2NrSABSCmJlZ2luQmxvY2sSPAoIY2hlY2tfdHgYByABKAsyHy50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdENoZWNrVHhIAFIHY2hlY2tUeBJCCgpkZWxpdmVyX3R4GAggASgLMiEudGVuZGVybWludC5hYmNpLlJlcXVlc3REZWxpdmVyVHhIAFIJZGVsaXZlclR4Ej8KCWVuZF9ibG9jaxgJIAEoCzIgLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0RW5kQmxvY2tIAFIIZW5kQmxvY2sSOAoGY29tbWl0GAogASgLMh4udGVuZGVybWludC5hYmNpLlJlcXVlc3RDb21taXRIAFIGY29tbWl0Ek4KDmxpc3Rfc25hcHNob3RzGAsgASgLMiUudGVuZGVybWludC5hYmNpLlJlcXVlc3RMaXN0U25hcHNob3RzSABSDWxpc3RTbmFwc2hvdHMSTgoOb2ZmZXJfc25hcHNob3QYDCABKAsyJS50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdE9mZmVyU25hcHNob3RIAFINb2ZmZXJTbmFwc2hvdBJbChNsb2FkX3NuYXBzaG90X2NodW5rGA0gASgLMikudGVuZGVybWludC5hYmNpLlJlcXVlc3RMb2FkU25hcHNob3RDaHVua0gAUhFsb2FkU25hcHNob3RDaHVuaxJeChRhcHBseV9zbmFwc2hvdF9jaHVuaxgOIAEoCzIqLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0QXBwbHlTbmFwc2hvdENodW5rSABSEmFwcGx5U25hcHNob3RDaHVua0IHCgV2YWx1ZQ==');
@$core.Deprecated('Use requestEchoDescriptor instead')
const RequestEcho$json = const {
  '1': 'RequestEcho',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RequestEcho`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestEchoDescriptor = $convert
    .base64Decode('CgtSZXF1ZXN0RWNobxIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use requestFlushDescriptor instead')
const RequestFlush$json = const {
  '1': 'RequestFlush',
};

/// Descriptor for `RequestFlush`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestFlushDescriptor =
    $convert.base64Decode('CgxSZXF1ZXN0Rmx1c2g=');
@$core.Deprecated('Use requestInfoDescriptor instead')
const RequestInfo$json = const {
  '1': 'RequestInfo',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'block_version', '3': 2, '4': 1, '5': 4, '10': 'blockVersion'},
    const {'1': 'p2p_version', '3': 3, '4': 1, '5': 4, '10': 'p2pVersion'},
    const {'1': 'abci_version', '3': 4, '4': 1, '5': 9, '10': 'abciVersion'},
  ],
};

/// Descriptor for `RequestInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestInfoDescriptor = $convert.base64Decode(
    'CgtSZXF1ZXN0SW5mbxIYCgd2ZXJzaW9uGAEgASgJUgd2ZXJzaW9uEiMKDWJsb2NrX3ZlcnNpb24YAiABKARSDGJsb2NrVmVyc2lvbhIfCgtwMnBfdmVyc2lvbhgDIAEoBFIKcDJwVmVyc2lvbhIhCgxhYmNpX3ZlcnNpb24YBCABKAlSC2FiY2lWZXJzaW9u');
@$core.Deprecated('Use requestInitChainDescriptor instead')
const RequestInitChain$json = const {
  '1': 'RequestInitChain',
  '2': const [
    const {
      '1': 'time',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': const {},
      '10': 'time'
    },
    const {'1': 'chain_id', '3': 2, '4': 1, '5': 9, '10': 'chainId'},
    const {
      '1': 'consensus_params',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.tendermint.types.ConsensusParams',
      '10': 'consensusParams'
    },
    const {
      '1': 'validators',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.ValidatorUpdate',
      '8': const {},
      '10': 'validators'
    },
    const {
      '1': 'app_state_bytes',
      '3': 5,
      '4': 1,
      '5': 12,
      '10': 'appStateBytes'
    },
    const {
      '1': 'initial_height',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'initialHeight'
    },
  ],
};

/// Descriptor for `RequestInitChain`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestInitChainDescriptor = $convert.base64Decode(
    'ChBSZXF1ZXN0SW5pdENoYWluEjgKBHRpbWUYASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wQgjI3h8AkN8fAVIEdGltZRIZCghjaGFpbl9pZBgCIAEoCVIHY2hhaW5JZBJMChBjb25zZW5zdXNfcGFyYW1zGAMgASgLMiEudGVuZGVybWludC50eXBlcy5Db25zZW5zdXNQYXJhbXNSD2NvbnNlbnN1c1BhcmFtcxJGCgp2YWxpZGF0b3JzGAQgAygLMiAudGVuZGVybWludC5hYmNpLlZhbGlkYXRvclVwZGF0ZUIEyN4fAFIKdmFsaWRhdG9ycxImCg9hcHBfc3RhdGVfYnl0ZXMYBSABKAxSDWFwcFN0YXRlQnl0ZXMSJQoOaW5pdGlhbF9oZWlnaHQYBiABKANSDWluaXRpYWxIZWlnaHQ=');
@$core.Deprecated('Use requestQueryDescriptor instead')
const RequestQuery$json = const {
  '1': 'RequestQuery',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'height', '3': 3, '4': 1, '5': 3, '10': 'height'},
    const {'1': 'prove', '3': 4, '4': 1, '5': 8, '10': 'prove'},
  ],
};

/// Descriptor for `RequestQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestQueryDescriptor = $convert.base64Decode(
    'CgxSZXF1ZXN0UXVlcnkSEgoEZGF0YRgBIAEoDFIEZGF0YRISCgRwYXRoGAIgASgJUgRwYXRoEhYKBmhlaWdodBgDIAEoA1IGaGVpZ2h0EhQKBXByb3ZlGAQgASgIUgVwcm92ZQ==');
@$core.Deprecated('Use requestBeginBlockDescriptor instead')
const RequestBeginBlock$json = const {
  '1': 'RequestBeginBlock',
  '2': const [
    const {'1': 'hash', '3': 1, '4': 1, '5': 12, '10': 'hash'},
    const {
      '1': 'header',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.tendermint.types.Header',
      '8': const {},
      '10': 'header'
    },
    const {
      '1': 'last_commit_info',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.LastCommitInfo',
      '8': const {},
      '10': 'lastCommitInfo'
    },
    const {
      '1': 'byzantine_validators',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.Evidence',
      '8': const {},
      '10': 'byzantineValidators'
    },
  ],
};

/// Descriptor for `RequestBeginBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestBeginBlockDescriptor = $convert.base64Decode(
    'ChFSZXF1ZXN0QmVnaW5CbG9jaxISCgRoYXNoGAEgASgMUgRoYXNoEjYKBmhlYWRlchgCIAEoCzIYLnRlbmRlcm1pbnQudHlwZXMuSGVhZGVyQgTI3h8AUgZoZWFkZXISTwoQbGFzdF9jb21taXRfaW5mbxgDIAEoCzIfLnRlbmRlcm1pbnQuYWJjaS5MYXN0Q29tbWl0SW5mb0IEyN4fAFIObGFzdENvbW1pdEluZm8SUgoUYnl6YW50aW5lX3ZhbGlkYXRvcnMYBCADKAsyGS50ZW5kZXJtaW50LmFiY2kuRXZpZGVuY2VCBMjeHwBSE2J5emFudGluZVZhbGlkYXRvcnM=');
@$core.Deprecated('Use requestCheckTxDescriptor instead')
const RequestCheckTx$json = const {
  '1': 'RequestCheckTx',
  '2': const [
    const {'1': 'tx', '3': 1, '4': 1, '5': 12, '10': 'tx'},
    const {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.tendermint.abci.CheckTxType',
      '10': 'type'
    },
  ],
};

/// Descriptor for `RequestCheckTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestCheckTxDescriptor = $convert.base64Decode(
    'Cg5SZXF1ZXN0Q2hlY2tUeBIOCgJ0eBgBIAEoDFICdHgSMAoEdHlwZRgCIAEoDjIcLnRlbmRlcm1pbnQuYWJjaS5DaGVja1R4VHlwZVIEdHlwZQ==');
@$core.Deprecated('Use requestDeliverTxDescriptor instead')
const RequestDeliverTx$json = const {
  '1': 'RequestDeliverTx',
  '2': const [
    const {'1': 'tx', '3': 1, '4': 1, '5': 12, '10': 'tx'},
  ],
};

/// Descriptor for `RequestDeliverTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDeliverTxDescriptor =
    $convert.base64Decode('ChBSZXF1ZXN0RGVsaXZlclR4Eg4KAnR4GAEgASgMUgJ0eA==');
@$core.Deprecated('Use requestEndBlockDescriptor instead')
const RequestEndBlock$json = const {
  '1': 'RequestEndBlock',
  '2': const [
    const {'1': 'height', '3': 1, '4': 1, '5': 3, '10': 'height'},
  ],
};

/// Descriptor for `RequestEndBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestEndBlockDescriptor = $convert
    .base64Decode('Cg9SZXF1ZXN0RW5kQmxvY2sSFgoGaGVpZ2h0GAEgASgDUgZoZWlnaHQ=');
@$core.Deprecated('Use requestCommitDescriptor instead')
const RequestCommit$json = const {
  '1': 'RequestCommit',
};

/// Descriptor for `RequestCommit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestCommitDescriptor =
    $convert.base64Decode('Cg1SZXF1ZXN0Q29tbWl0');
@$core.Deprecated('Use requestListSnapshotsDescriptor instead')
const RequestListSnapshots$json = const {
  '1': 'RequestListSnapshots',
};

/// Descriptor for `RequestListSnapshots`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestListSnapshotsDescriptor =
    $convert.base64Decode('ChRSZXF1ZXN0TGlzdFNuYXBzaG90cw==');
@$core.Deprecated('Use requestOfferSnapshotDescriptor instead')
const RequestOfferSnapshot$json = const {
  '1': 'RequestOfferSnapshot',
  '2': const [
    const {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.Snapshot',
      '10': 'snapshot'
    },
    const {'1': 'app_hash', '3': 2, '4': 1, '5': 12, '10': 'appHash'},
  ],
};

/// Descriptor for `RequestOfferSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestOfferSnapshotDescriptor = $convert.base64Decode(
    'ChRSZXF1ZXN0T2ZmZXJTbmFwc2hvdBI1CghzbmFwc2hvdBgBIAEoCzIZLnRlbmRlcm1pbnQuYWJjaS5TbmFwc2hvdFIIc25hcHNob3QSGQoIYXBwX2hhc2gYAiABKAxSB2FwcEhhc2g=');
@$core.Deprecated('Use requestLoadSnapshotChunkDescriptor instead')
const RequestLoadSnapshotChunk$json = const {
  '1': 'RequestLoadSnapshotChunk',
  '2': const [
    const {'1': 'height', '3': 1, '4': 1, '5': 4, '10': 'height'},
    const {'1': 'format', '3': 2, '4': 1, '5': 13, '10': 'format'},
    const {'1': 'chunk', '3': 3, '4': 1, '5': 13, '10': 'chunk'},
  ],
};

/// Descriptor for `RequestLoadSnapshotChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestLoadSnapshotChunkDescriptor =
    $convert.base64Decode(
        'ChhSZXF1ZXN0TG9hZFNuYXBzaG90Q2h1bmsSFgoGaGVpZ2h0GAEgASgEUgZoZWlnaHQSFgoGZm9ybWF0GAIgASgNUgZmb3JtYXQSFAoFY2h1bmsYAyABKA1SBWNodW5r');
@$core.Deprecated('Use requestApplySnapshotChunkDescriptor instead')
const RequestApplySnapshotChunk$json = const {
  '1': 'RequestApplySnapshotChunk',
  '2': const [
    const {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'chunk', '3': 2, '4': 1, '5': 12, '10': 'chunk'},
    const {'1': 'sender', '3': 3, '4': 1, '5': 9, '10': 'sender'},
  ],
};

/// Descriptor for `RequestApplySnapshotChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestApplySnapshotChunkDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0QXBwbHlTbmFwc2hvdENodW5rEhQKBWluZGV4GAEgASgNUgVpbmRleBIUCgVjaHVuaxgCIAEoDFIFY2h1bmsSFgoGc2VuZGVyGAMgASgJUgZzZW5kZXI=');
@$core.Deprecated('Use responseDescriptor instead')
const Response$json = const {
  '1': 'Response',
  '2': const [
    const {
      '1': 'exception',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseException',
      '9': 0,
      '10': 'exception'
    },
    const {
      '1': 'echo',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseEcho',
      '9': 0,
      '10': 'echo'
    },
    const {
      '1': 'flush',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseFlush',
      '9': 0,
      '10': 'flush'
    },
    const {
      '1': 'info',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseInfo',
      '9': 0,
      '10': 'info'
    },
    const {
      '1': 'init_chain',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseInitChain',
      '9': 0,
      '10': 'initChain'
    },
    const {
      '1': 'query',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseQuery',
      '9': 0,
      '10': 'query'
    },
    const {
      '1': 'begin_block',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseBeginBlock',
      '9': 0,
      '10': 'beginBlock'
    },
    const {
      '1': 'check_tx',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseCheckTx',
      '9': 0,
      '10': 'checkTx'
    },
    const {
      '1': 'deliver_tx',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseDeliverTx',
      '9': 0,
      '10': 'deliverTx'
    },
    const {
      '1': 'end_block',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseEndBlock',
      '9': 0,
      '10': 'endBlock'
    },
    const {
      '1': 'commit',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseCommit',
      '9': 0,
      '10': 'commit'
    },
    const {
      '1': 'list_snapshots',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseListSnapshots',
      '9': 0,
      '10': 'listSnapshots'
    },
    const {
      '1': 'offer_snapshot',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseOfferSnapshot',
      '9': 0,
      '10': 'offerSnapshot'
    },
    const {
      '1': 'load_snapshot_chunk',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseLoadSnapshotChunk',
      '9': 0,
      '10': 'loadSnapshotChunk'
    },
    const {
      '1': 'apply_snapshot_chunk',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseApplySnapshotChunk',
      '9': 0,
      '10': 'applySnapshotChunk'
    },
  ],
  '8': const [
    const {'1': 'value'},
  ],
};

/// Descriptor for `Response`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseDescriptor = $convert.base64Decode(
    'CghSZXNwb25zZRJCCglleGNlcHRpb24YASABKAsyIi50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VFeGNlcHRpb25IAFIJZXhjZXB0aW9uEjMKBGVjaG8YAiABKAsyHS50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VFY2hvSABSBGVjaG8SNgoFZmx1c2gYAyABKAsyHi50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VGbHVzaEgAUgVmbHVzaBIzCgRpbmZvGAQgASgLMh0udGVuZGVybWludC5hYmNpLlJlc3BvbnNlSW5mb0gAUgRpbmZvEkMKCmluaXRfY2hhaW4YBSABKAsyIi50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VJbml0Q2hhaW5IAFIJaW5pdENoYWluEjYKBXF1ZXJ5GAYgASgLMh4udGVuZGVybWludC5hYmNpLlJlc3BvbnNlUXVlcnlIAFIFcXVlcnkSRgoLYmVnaW5fYmxvY2sYByABKAsyIy50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VCZWdpbkJsb2NrSABSCmJlZ2luQmxvY2sSPQoIY2hlY2tfdHgYCCABKAsyIC50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VDaGVja1R4SABSB2NoZWNrVHgSQwoKZGVsaXZlcl90eBgJIAEoCzIiLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZURlbGl2ZXJUeEgAUglkZWxpdmVyVHgSQAoJZW5kX2Jsb2NrGAogASgLMiEudGVuZGVybWludC5hYmNpLlJlc3BvbnNlRW5kQmxvY2tIAFIIZW5kQmxvY2sSOQoGY29tbWl0GAsgASgLMh8udGVuZGVybWludC5hYmNpLlJlc3BvbnNlQ29tbWl0SABSBmNvbW1pdBJPCg5saXN0X3NuYXBzaG90cxgMIAEoCzImLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZUxpc3RTbmFwc2hvdHNIAFINbGlzdFNuYXBzaG90cxJPCg5vZmZlcl9zbmFwc2hvdBgNIAEoCzImLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZU9mZmVyU25hcHNob3RIAFINb2ZmZXJTbmFwc2hvdBJcChNsb2FkX3NuYXBzaG90X2NodW5rGA4gASgLMioudGVuZGVybWludC5hYmNpLlJlc3BvbnNlTG9hZFNuYXBzaG90Q2h1bmtIAFIRbG9hZFNuYXBzaG90Q2h1bmsSXwoUYXBwbHlfc25hcHNob3RfY2h1bmsYDyABKAsyKy50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VBcHBseVNuYXBzaG90Q2h1bmtIAFISYXBwbHlTbmFwc2hvdENodW5rQgcKBXZhbHVl');
@$core.Deprecated('Use responseExceptionDescriptor instead')
const ResponseException$json = const {
  '1': 'ResponseException',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `ResponseException`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseExceptionDescriptor = $convert
    .base64Decode('ChFSZXNwb25zZUV4Y2VwdGlvbhIUCgVlcnJvchgBIAEoCVIFZXJyb3I=');
@$core.Deprecated('Use responseEchoDescriptor instead')
const ResponseEcho$json = const {
  '1': 'ResponseEcho',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ResponseEcho`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseEchoDescriptor = $convert
    .base64Decode('CgxSZXNwb25zZUVjaG8SGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use responseFlushDescriptor instead')
const ResponseFlush$json = const {
  '1': 'ResponseFlush',
};

/// Descriptor for `ResponseFlush`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseFlushDescriptor =
    $convert.base64Decode('Cg1SZXNwb25zZUZsdXNo');
@$core.Deprecated('Use responseInfoDescriptor instead')
const ResponseInfo$json = const {
  '1': 'ResponseInfo',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 9, '10': 'data'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'app_version', '3': 3, '4': 1, '5': 4, '10': 'appVersion'},
    const {
      '1': 'last_block_height',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'lastBlockHeight'
    },
    const {
      '1': 'last_block_app_hash',
      '3': 5,
      '4': 1,
      '5': 12,
      '10': 'lastBlockAppHash'
    },
  ],
};

/// Descriptor for `ResponseInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseInfoDescriptor = $convert.base64Decode(
    'CgxSZXNwb25zZUluZm8SEgoEZGF0YRgBIAEoCVIEZGF0YRIYCgd2ZXJzaW9uGAIgASgJUgd2ZXJzaW9uEh8KC2FwcF92ZXJzaW9uGAMgASgEUgphcHBWZXJzaW9uEioKEWxhc3RfYmxvY2tfaGVpZ2h0GAQgASgDUg9sYXN0QmxvY2tIZWlnaHQSLQoTbGFzdF9ibG9ja19hcHBfaGFzaBgFIAEoDFIQbGFzdEJsb2NrQXBwSGFzaA==');
@$core.Deprecated('Use responseInitChainDescriptor instead')
const ResponseInitChain$json = const {
  '1': 'ResponseInitChain',
  '2': const [
    const {
      '1': 'consensus_params',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tendermint.types.ConsensusParams',
      '10': 'consensusParams'
    },
    const {
      '1': 'validators',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.ValidatorUpdate',
      '8': const {},
      '10': 'validators'
    },
    const {'1': 'app_hash', '3': 3, '4': 1, '5': 12, '10': 'appHash'},
  ],
};

/// Descriptor for `ResponseInitChain`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseInitChainDescriptor = $convert.base64Decode(
    'ChFSZXNwb25zZUluaXRDaGFpbhJMChBjb25zZW5zdXNfcGFyYW1zGAEgASgLMiEudGVuZGVybWludC50eXBlcy5Db25zZW5zdXNQYXJhbXNSD2NvbnNlbnN1c1BhcmFtcxJGCgp2YWxpZGF0b3JzGAIgAygLMiAudGVuZGVybWludC5hYmNpLlZhbGlkYXRvclVwZGF0ZUIEyN4fAFIKdmFsaWRhdG9ycxIZCghhcHBfaGFzaBgDIAEoDFIHYXBwSGFzaA==');
@$core.Deprecated('Use responseQueryDescriptor instead')
const ResponseQuery$json = const {
  '1': 'ResponseQuery',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    const {'1': 'log', '3': 3, '4': 1, '5': 9, '10': 'log'},
    const {'1': 'info', '3': 4, '4': 1, '5': 9, '10': 'info'},
    const {'1': 'index', '3': 5, '4': 1, '5': 3, '10': 'index'},
    const {'1': 'key', '3': 6, '4': 1, '5': 12, '10': 'key'},
    const {'1': 'value', '3': 7, '4': 1, '5': 12, '10': 'value'},
    const {
      '1': 'proof_ops',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.tendermint.crypto.ProofOps',
      '10': 'proofOps'
    },
    const {'1': 'height', '3': 9, '4': 1, '5': 3, '10': 'height'},
    const {'1': 'codespace', '3': 10, '4': 1, '5': 9, '10': 'codespace'},
  ],
};

/// Descriptor for `ResponseQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseQueryDescriptor = $convert.base64Decode(
    'Cg1SZXNwb25zZVF1ZXJ5EhIKBGNvZGUYASABKA1SBGNvZGUSEAoDbG9nGAMgASgJUgNsb2cSEgoEaW5mbxgEIAEoCVIEaW5mbxIUCgVpbmRleBgFIAEoA1IFaW5kZXgSEAoDa2V5GAYgASgMUgNrZXkSFAoFdmFsdWUYByABKAxSBXZhbHVlEjgKCXByb29mX29wcxgIIAEoCzIbLnRlbmRlcm1pbnQuY3J5cHRvLlByb29mT3BzUghwcm9vZk9wcxIWCgZoZWlnaHQYCSABKANSBmhlaWdodBIcCgljb2Rlc3BhY2UYCiABKAlSCWNvZGVzcGFjZQ==');
@$core.Deprecated('Use responseBeginBlockDescriptor instead')
const ResponseBeginBlock$json = const {
  '1': 'ResponseBeginBlock',
  '2': const [
    const {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.Event',
      '8': const {},
      '10': 'events'
    },
  ],
};

/// Descriptor for `ResponseBeginBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseBeginBlockDescriptor = $convert.base64Decode(
    'ChJSZXNwb25zZUJlZ2luQmxvY2sSSAoGZXZlbnRzGAEgAygLMhYudGVuZGVybWludC5hYmNpLkV2ZW50QhjI3h8A6t4fEGV2ZW50cyxvbWl0ZW1wdHlSBmV2ZW50cw==');
@$core.Deprecated('Use responseCheckTxDescriptor instead')
const ResponseCheckTx$json = const {
  '1': 'ResponseCheckTx',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'log', '3': 3, '4': 1, '5': 9, '10': 'log'},
    const {'1': 'info', '3': 4, '4': 1, '5': 9, '10': 'info'},
    const {'1': 'gas_wanted', '3': 5, '4': 1, '5': 3, '10': 'gas_wanted'},
    const {'1': 'gas_used', '3': 6, '4': 1, '5': 3, '10': 'gas_used'},
    const {
      '1': 'events',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.Event',
      '8': const {},
      '10': 'events'
    },
    const {'1': 'codespace', '3': 8, '4': 1, '5': 9, '10': 'codespace'},
    const {'1': 'sender', '3': 9, '4': 1, '5': 9, '10': 'sender'},
    const {'1': 'priority', '3': 10, '4': 1, '5': 3, '10': 'priority'},
    const {'1': 'mempool_error', '3': 11, '4': 1, '5': 9, '10': 'mempoolError'},
  ],
};

/// Descriptor for `ResponseCheckTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseCheckTxDescriptor = $convert.base64Decode(
    'Cg9SZXNwb25zZUNoZWNrVHgSEgoEY29kZRgBIAEoDVIEY29kZRISCgRkYXRhGAIgASgMUgRkYXRhEhAKA2xvZxgDIAEoCVIDbG9nEhIKBGluZm8YBCABKAlSBGluZm8SHgoKZ2FzX3dhbnRlZBgFIAEoA1IKZ2FzX3dhbnRlZBIaCghnYXNfdXNlZBgGIAEoA1IIZ2FzX3VzZWQSSAoGZXZlbnRzGAcgAygLMhYudGVuZGVybWludC5hYmNpLkV2ZW50QhjI3h8A6t4fEGV2ZW50cyxvbWl0ZW1wdHlSBmV2ZW50cxIcCgljb2Rlc3BhY2UYCCABKAlSCWNvZGVzcGFjZRIWCgZzZW5kZXIYCSABKAlSBnNlbmRlchIaCghwcmlvcml0eRgKIAEoA1IIcHJpb3JpdHkSIwoNbWVtcG9vbF9lcnJvchgLIAEoCVIMbWVtcG9vbEVycm9y');
@$core.Deprecated('Use responseDeliverTxDescriptor instead')
const ResponseDeliverTx$json = const {
  '1': 'ResponseDeliverTx',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'log', '3': 3, '4': 1, '5': 9, '10': 'log'},
    const {'1': 'info', '3': 4, '4': 1, '5': 9, '10': 'info'},
    const {'1': 'gas_wanted', '3': 5, '4': 1, '5': 3, '10': 'gas_wanted'},
    const {'1': 'gas_used', '3': 6, '4': 1, '5': 3, '10': 'gas_used'},
    const {
      '1': 'events',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.Event',
      '8': const {},
      '10': 'events'
    },
    const {'1': 'codespace', '3': 8, '4': 1, '5': 9, '10': 'codespace'},
  ],
};

/// Descriptor for `ResponseDeliverTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseDeliverTxDescriptor = $convert.base64Decode(
    'ChFSZXNwb25zZURlbGl2ZXJUeBISCgRjb2RlGAEgASgNUgRjb2RlEhIKBGRhdGEYAiABKAxSBGRhdGESEAoDbG9nGAMgASgJUgNsb2cSEgoEaW5mbxgEIAEoCVIEaW5mbxIeCgpnYXNfd2FudGVkGAUgASgDUgpnYXNfd2FudGVkEhoKCGdhc191c2VkGAYgASgDUghnYXNfdXNlZBJICgZldmVudHMYByADKAsyFi50ZW5kZXJtaW50LmFiY2kuRXZlbnRCGMjeHwDq3h8QZXZlbnRzLG9taXRlbXB0eVIGZXZlbnRzEhwKCWNvZGVzcGFjZRgIIAEoCVIJY29kZXNwYWNl');
@$core.Deprecated('Use responseEndBlockDescriptor instead')
const ResponseEndBlock$json = const {
  '1': 'ResponseEndBlock',
  '2': const [
    const {
      '1': 'validator_updates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.ValidatorUpdate',
      '8': const {},
      '10': 'validatorUpdates'
    },
    const {
      '1': 'consensus_param_updates',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.tendermint.types.ConsensusParams',
      '10': 'consensusParamUpdates'
    },
    const {
      '1': 'events',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.Event',
      '8': const {},
      '10': 'events'
    },
  ],
};

/// Descriptor for `ResponseEndBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseEndBlockDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUVuZEJsb2NrElMKEXZhbGlkYXRvcl91cGRhdGVzGAEgAygLMiAudGVuZGVybWludC5hYmNpLlZhbGlkYXRvclVwZGF0ZUIEyN4fAFIQdmFsaWRhdG9yVXBkYXRlcxJZChdjb25zZW5zdXNfcGFyYW1fdXBkYXRlcxgCIAEoCzIhLnRlbmRlcm1pbnQudHlwZXMuQ29uc2Vuc3VzUGFyYW1zUhVjb25zZW5zdXNQYXJhbVVwZGF0ZXMSSAoGZXZlbnRzGAMgAygLMhYudGVuZGVybWludC5hYmNpLkV2ZW50QhjI3h8A6t4fEGV2ZW50cyxvbWl0ZW1wdHlSBmV2ZW50cw==');
@$core.Deprecated('Use responseCommitDescriptor instead')
const ResponseCommit$json = const {
  '1': 'ResponseCommit',
  '2': const [
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'retain_height', '3': 3, '4': 1, '5': 3, '10': 'retainHeight'},
  ],
};

/// Descriptor for `ResponseCommit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseCommitDescriptor = $convert.base64Decode(
    'Cg5SZXNwb25zZUNvbW1pdBISCgRkYXRhGAIgASgMUgRkYXRhEiMKDXJldGFpbl9oZWlnaHQYAyABKANSDHJldGFpbkhlaWdodA==');
@$core.Deprecated('Use responseListSnapshotsDescriptor instead')
const ResponseListSnapshots$json = const {
  '1': 'ResponseListSnapshots',
  '2': const [
    const {
      '1': 'snapshots',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.Snapshot',
      '10': 'snapshots'
    },
  ],
};

/// Descriptor for `ResponseListSnapshots`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseListSnapshotsDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZUxpc3RTbmFwc2hvdHMSNwoJc25hcHNob3RzGAEgAygLMhkudGVuZGVybWludC5hYmNpLlNuYXBzaG90UglzbmFwc2hvdHM=');
@$core.Deprecated('Use responseOfferSnapshotDescriptor instead')
const ResponseOfferSnapshot$json = const {
  '1': 'ResponseOfferSnapshot',
  '2': const [
    const {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.tendermint.abci.ResponseOfferSnapshot.Result',
      '10': 'result'
    },
  ],
  '4': const [ResponseOfferSnapshot_Result$json],
};

@$core.Deprecated('Use responseOfferSnapshotDescriptor instead')
const ResponseOfferSnapshot_Result$json = const {
  '1': 'Result',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'ACCEPT', '2': 1},
    const {'1': 'ABORT', '2': 2},
    const {'1': 'REJECT', '2': 3},
    const {'1': 'REJECT_FORMAT', '2': 4},
    const {'1': 'REJECT_SENDER', '2': 5},
  ],
};

/// Descriptor for `ResponseOfferSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseOfferSnapshotDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZU9mZmVyU25hcHNob3QSRQoGcmVzdWx0GAEgASgOMi0udGVuZGVybWludC5hYmNpLlJlc3BvbnNlT2ZmZXJTbmFwc2hvdC5SZXN1bHRSBnJlc3VsdCJeCgZSZXN1bHQSCwoHVU5LTk9XThAAEgoKBkFDQ0VQVBABEgkKBUFCT1JUEAISCgoGUkVKRUNUEAMSEQoNUkVKRUNUX0ZPUk1BVBAEEhEKDVJFSkVDVF9TRU5ERVIQBQ==');
@$core.Deprecated('Use responseLoadSnapshotChunkDescriptor instead')
const ResponseLoadSnapshotChunk$json = const {
  '1': 'ResponseLoadSnapshotChunk',
  '2': const [
    const {'1': 'chunk', '3': 1, '4': 1, '5': 12, '10': 'chunk'},
  ],
};

/// Descriptor for `ResponseLoadSnapshotChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseLoadSnapshotChunkDescriptor =
    $convert.base64Decode(
        'ChlSZXNwb25zZUxvYWRTbmFwc2hvdENodW5rEhQKBWNodW5rGAEgASgMUgVjaHVuaw==');
@$core.Deprecated('Use responseApplySnapshotChunkDescriptor instead')
const ResponseApplySnapshotChunk$json = const {
  '1': 'ResponseApplySnapshotChunk',
  '2': const [
    const {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.tendermint.abci.ResponseApplySnapshotChunk.Result',
      '10': 'result'
    },
    const {
      '1': 'refetch_chunks',
      '3': 2,
      '4': 3,
      '5': 13,
      '10': 'refetchChunks'
    },
    const {
      '1': 'reject_senders',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'rejectSenders'
    },
  ],
  '4': const [ResponseApplySnapshotChunk_Result$json],
};

@$core.Deprecated('Use responseApplySnapshotChunkDescriptor instead')
const ResponseApplySnapshotChunk_Result$json = const {
  '1': 'Result',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'ACCEPT', '2': 1},
    const {'1': 'ABORT', '2': 2},
    const {'1': 'RETRY', '2': 3},
    const {'1': 'RETRY_SNAPSHOT', '2': 4},
    const {'1': 'REJECT_SNAPSHOT', '2': 5},
  ],
};

/// Descriptor for `ResponseApplySnapshotChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseApplySnapshotChunkDescriptor =
    $convert.base64Decode(
        'ChpSZXNwb25zZUFwcGx5U25hcHNob3RDaHVuaxJKCgZyZXN1bHQYASABKA4yMi50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VBcHBseVNuYXBzaG90Q2h1bmsuUmVzdWx0UgZyZXN1bHQSJQoOcmVmZXRjaF9jaHVua3MYAiADKA1SDXJlZmV0Y2hDaHVua3MSJQoOcmVqZWN0X3NlbmRlcnMYAyADKAlSDXJlamVjdFNlbmRlcnMiYAoGUmVzdWx0EgsKB1VOS05PV04QABIKCgZBQ0NFUFQQARIJCgVBQk9SVBACEgkKBVJFVFJZEAMSEgoOUkVUUllfU05BUFNIT1QQBBITCg9SRUpFQ1RfU05BUFNIT1QQBQ==');
@$core.Deprecated('Use lastCommitInfoDescriptor instead')
const LastCommitInfo$json = const {
  '1': 'LastCommitInfo',
  '2': const [
    const {'1': 'round', '3': 1, '4': 1, '5': 5, '10': 'round'},
    const {
      '1': 'votes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.VoteInfo',
      '8': const {},
      '10': 'votes'
    },
  ],
};

/// Descriptor for `LastCommitInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lastCommitInfoDescriptor = $convert.base64Decode(
    'Cg5MYXN0Q29tbWl0SW5mbxIUCgVyb3VuZBgBIAEoBVIFcm91bmQSNQoFdm90ZXMYAiADKAsyGS50ZW5kZXJtaW50LmFiY2kuVm90ZUluZm9CBMjeHwBSBXZvdGVz');
@$core.Deprecated('Use eventDescriptor instead')
const Event$json = const {
  '1': 'Event',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {
      '1': 'attributes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.tendermint.abci.EventAttribute',
      '8': const {},
      '10': 'attributes'
    },
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode(
    'CgVFdmVudBISCgR0eXBlGAEgASgJUgR0eXBlEl0KCmF0dHJpYnV0ZXMYAiADKAsyHy50ZW5kZXJtaW50LmFiY2kuRXZlbnRBdHRyaWJ1dGVCHMjeHwDq3h8UYXR0cmlidXRlcyxvbWl0ZW1wdHlSCmF0dHJpYnV0ZXM=');
@$core.Deprecated('Use eventAttributeDescriptor instead')
const EventAttribute$json = const {
  '1': 'EventAttribute',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    const {'1': 'index', '3': 3, '4': 1, '5': 8, '10': 'index'},
  ],
};

/// Descriptor for `EventAttribute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventAttributeDescriptor = $convert.base64Decode(
    'Cg5FdmVudEF0dHJpYnV0ZRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWUSFAoFaW5kZXgYAyABKAhSBWluZGV4');
@$core.Deprecated('Use txResultDescriptor instead')
const TxResult$json = const {
  '1': 'TxResult',
  '2': const [
    const {'1': 'height', '3': 1, '4': 1, '5': 3, '10': 'height'},
    const {'1': 'index', '3': 2, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'tx', '3': 3, '4': 1, '5': 12, '10': 'tx'},
    const {
      '1': 'result',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.ResponseDeliverTx',
      '8': const {},
      '10': 'result'
    },
  ],
};

/// Descriptor for `TxResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txResultDescriptor = $convert.base64Decode(
    'CghUeFJlc3VsdBIWCgZoZWlnaHQYASABKANSBmhlaWdodBIUCgVpbmRleBgCIAEoDVIFaW5kZXgSDgoCdHgYAyABKAxSAnR4EkAKBnJlc3VsdBgEIAEoCzIiLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZURlbGl2ZXJUeEIEyN4fAFIGcmVzdWx0');
@$core.Deprecated('Use validatorDescriptor instead')
const Validator$json = const {
  '1': 'Validator',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 12, '10': 'address'},
    const {'1': 'power', '3': 3, '4': 1, '5': 3, '10': 'power'},
  ],
};

/// Descriptor for `Validator`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validatorDescriptor = $convert.base64Decode(
    'CglWYWxpZGF0b3ISGAoHYWRkcmVzcxgBIAEoDFIHYWRkcmVzcxIUCgVwb3dlchgDIAEoA1IFcG93ZXI=');
@$core.Deprecated('Use validatorUpdateDescriptor instead')
const ValidatorUpdate$json = const {
  '1': 'ValidatorUpdate',
  '2': const [
    const {
      '1': 'pub_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tendermint.crypto.PublicKey',
      '8': const {},
      '10': 'pubKey'
    },
    const {'1': 'power', '3': 2, '4': 1, '5': 3, '10': 'power'},
  ],
};

/// Descriptor for `ValidatorUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validatorUpdateDescriptor = $convert.base64Decode(
    'Cg9WYWxpZGF0b3JVcGRhdGUSOwoHcHViX2tleRgBIAEoCzIcLnRlbmRlcm1pbnQuY3J5cHRvLlB1YmxpY0tleUIEyN4fAFIGcHViS2V5EhQKBXBvd2VyGAIgASgDUgVwb3dlcg==');
@$core.Deprecated('Use voteInfoDescriptor instead')
const VoteInfo$json = const {
  '1': 'VoteInfo',
  '2': const [
    const {
      '1': 'validator',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.Validator',
      '8': const {},
      '10': 'validator'
    },
    const {
      '1': 'signed_last_block',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'signedLastBlock'
    },
  ],
};

/// Descriptor for `VoteInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voteInfoDescriptor = $convert.base64Decode(
    'CghWb3RlSW5mbxI+Cgl2YWxpZGF0b3IYASABKAsyGi50ZW5kZXJtaW50LmFiY2kuVmFsaWRhdG9yQgTI3h8AUgl2YWxpZGF0b3ISKgoRc2lnbmVkX2xhc3RfYmxvY2sYAiABKAhSD3NpZ25lZExhc3RCbG9jaw==');
@$core.Deprecated('Use evidenceDescriptor instead')
const Evidence$json = const {
  '1': 'Evidence',
  '2': const [
    const {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.tendermint.abci.EvidenceType',
      '10': 'type'
    },
    const {
      '1': 'validator',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.tendermint.abci.Validator',
      '8': const {},
      '10': 'validator'
    },
    const {'1': 'height', '3': 3, '4': 1, '5': 3, '10': 'height'},
    const {
      '1': 'time',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': const {},
      '10': 'time'
    },
    const {
      '1': 'total_voting_power',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'totalVotingPower'
    },
  ],
};

/// Descriptor for `Evidence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evidenceDescriptor = $convert.base64Decode(
    'CghFdmlkZW5jZRIxCgR0eXBlGAEgASgOMh0udGVuZGVybWludC5hYmNpLkV2aWRlbmNlVHlwZVIEdHlwZRI+Cgl2YWxpZGF0b3IYAiABKAsyGi50ZW5kZXJtaW50LmFiY2kuVmFsaWRhdG9yQgTI3h8AUgl2YWxpZGF0b3ISFgoGaGVpZ2h0GAMgASgDUgZoZWlnaHQSOAoEdGltZRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBCCMjeHwCQ3x8BUgR0aW1lEiwKEnRvdGFsX3ZvdGluZ19wb3dlchgFIAEoA1IQdG90YWxWb3RpbmdQb3dlcg==');
@$core.Deprecated('Use snapshotDescriptor instead')
const Snapshot$json = const {
  '1': 'Snapshot',
  '2': const [
    const {'1': 'height', '3': 1, '4': 1, '5': 4, '10': 'height'},
    const {'1': 'format', '3': 2, '4': 1, '5': 13, '10': 'format'},
    const {'1': 'chunks', '3': 3, '4': 1, '5': 13, '10': 'chunks'},
    const {'1': 'hash', '3': 4, '4': 1, '5': 12, '10': 'hash'},
    const {'1': 'metadata', '3': 5, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `Snapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List snapshotDescriptor = $convert.base64Decode(
    'CghTbmFwc2hvdBIWCgZoZWlnaHQYASABKARSBmhlaWdodBIWCgZmb3JtYXQYAiABKA1SBmZvcm1hdBIWCgZjaHVua3MYAyABKA1SBmNodW5rcxISCgRoYXNoGAQgASgMUgRoYXNoEhoKCG1ldGFkYXRhGAUgASgMUghtZXRhZGF0YQ==');
const $core.Map<$core.String, $core.dynamic> ABCIApplicationServiceBase$json =
    const {
  '1': 'ABCIApplication',
  '2': const [
    const {
      '1': 'Echo',
      '2': '.tendermint.abci.RequestEcho',
      '3': '.tendermint.abci.ResponseEcho'
    },
    const {
      '1': 'Flush',
      '2': '.tendermint.abci.RequestFlush',
      '3': '.tendermint.abci.ResponseFlush'
    },
    const {
      '1': 'Info',
      '2': '.tendermint.abci.RequestInfo',
      '3': '.tendermint.abci.ResponseInfo'
    },
    const {
      '1': 'DeliverTx',
      '2': '.tendermint.abci.RequestDeliverTx',
      '3': '.tendermint.abci.ResponseDeliverTx'
    },
    const {
      '1': 'CheckTx',
      '2': '.tendermint.abci.RequestCheckTx',
      '3': '.tendermint.abci.ResponseCheckTx'
    },
    const {
      '1': 'Query',
      '2': '.tendermint.abci.RequestQuery',
      '3': '.tendermint.abci.ResponseQuery'
    },
    const {
      '1': 'Commit',
      '2': '.tendermint.abci.RequestCommit',
      '3': '.tendermint.abci.ResponseCommit'
    },
    const {
      '1': 'InitChain',
      '2': '.tendermint.abci.RequestInitChain',
      '3': '.tendermint.abci.ResponseInitChain'
    },
    const {
      '1': 'BeginBlock',
      '2': '.tendermint.abci.RequestBeginBlock',
      '3': '.tendermint.abci.ResponseBeginBlock'
    },
    const {
      '1': 'EndBlock',
      '2': '.tendermint.abci.RequestEndBlock',
      '3': '.tendermint.abci.ResponseEndBlock'
    },
    const {
      '1': 'ListSnapshots',
      '2': '.tendermint.abci.RequestListSnapshots',
      '3': '.tendermint.abci.ResponseListSnapshots'
    },
    const {
      '1': 'OfferSnapshot',
      '2': '.tendermint.abci.RequestOfferSnapshot',
      '3': '.tendermint.abci.ResponseOfferSnapshot'
    },
    const {
      '1': 'LoadSnapshotChunk',
      '2': '.tendermint.abci.RequestLoadSnapshotChunk',
      '3': '.tendermint.abci.ResponseLoadSnapshotChunk'
    },
    const {
      '1': 'ApplySnapshotChunk',
      '2': '.tendermint.abci.RequestApplySnapshotChunk',
      '3': '.tendermint.abci.ResponseApplySnapshotChunk'
    },
  ],
};

@$core.Deprecated('Use aBCIApplicationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ABCIApplicationServiceBase$messageJson = const {
  '.tendermint.abci.RequestEcho': RequestEcho$json,
  '.tendermint.abci.ResponseEcho': ResponseEcho$json,
  '.tendermint.abci.RequestFlush': RequestFlush$json,
  '.tendermint.abci.ResponseFlush': ResponseFlush$json,
  '.tendermint.abci.RequestInfo': RequestInfo$json,
  '.tendermint.abci.ResponseInfo': ResponseInfo$json,
  '.tendermint.abci.RequestDeliverTx': RequestDeliverTx$json,
  '.tendermint.abci.ResponseDeliverTx': ResponseDeliverTx$json,
  '.tendermint.abci.Event': Event$json,
  '.tendermint.abci.EventAttribute': EventAttribute$json,
  '.tendermint.abci.RequestCheckTx': RequestCheckTx$json,
  '.tendermint.abci.ResponseCheckTx': ResponseCheckTx$json,
  '.tendermint.abci.RequestQuery': RequestQuery$json,
  '.tendermint.abci.ResponseQuery': ResponseQuery$json,
  '.tendermint.crypto.ProofOps': $3.ProofOps$json,
  '.tendermint.crypto.ProofOp': $3.ProofOp$json,
  '.tendermint.abci.RequestCommit': RequestCommit$json,
  '.tendermint.abci.ResponseCommit': ResponseCommit$json,
  '.tendermint.abci.RequestInitChain': RequestInitChain$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.tendermint.types.ConsensusParams': $1.ConsensusParams$json,
  '.tendermint.types.BlockParams': $1.BlockParams$json,
  '.tendermint.types.EvidenceParams': $1.EvidenceParams$json,
  '.google.protobuf.Duration': $5.Duration$json,
  '.tendermint.types.ValidatorParams': $1.ValidatorParams$json,
  '.tendermint.types.VersionParams': $1.VersionParams$json,
  '.tendermint.abci.ValidatorUpdate': ValidatorUpdate$json,
  '.tendermint.crypto.PublicKey': $4.PublicKey$json,
  '.tendermint.abci.ResponseInitChain': ResponseInitChain$json,
  '.tendermint.abci.RequestBeginBlock': RequestBeginBlock$json,
  '.tendermint.types.Header': $2.Header$json,
  '.tendermint.version.Consensus': $6.Consensus$json,
  '.tendermint.types.BlockID': $2.BlockID$json,
  '.tendermint.types.PartSetHeader': $2.PartSetHeader$json,
  '.tendermint.abci.LastCommitInfo': LastCommitInfo$json,
  '.tendermint.abci.VoteInfo': VoteInfo$json,
  '.tendermint.abci.Validator': Validator$json,
  '.tendermint.abci.Evidence': Evidence$json,
  '.tendermint.abci.ResponseBeginBlock': ResponseBeginBlock$json,
  '.tendermint.abci.RequestEndBlock': RequestEndBlock$json,
  '.tendermint.abci.ResponseEndBlock': ResponseEndBlock$json,
  '.tendermint.abci.RequestListSnapshots': RequestListSnapshots$json,
  '.tendermint.abci.ResponseListSnapshots': ResponseListSnapshots$json,
  '.tendermint.abci.Snapshot': Snapshot$json,
  '.tendermint.abci.RequestOfferSnapshot': RequestOfferSnapshot$json,
  '.tendermint.abci.ResponseOfferSnapshot': ResponseOfferSnapshot$json,
  '.tendermint.abci.RequestLoadSnapshotChunk': RequestLoadSnapshotChunk$json,
  '.tendermint.abci.ResponseLoadSnapshotChunk': ResponseLoadSnapshotChunk$json,
  '.tendermint.abci.RequestApplySnapshotChunk': RequestApplySnapshotChunk$json,
  '.tendermint.abci.ResponseApplySnapshotChunk':
      ResponseApplySnapshotChunk$json,
};

/// Descriptor for `ABCIApplication`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List aBCIApplicationServiceDescriptor =
    $convert.base64Decode(
        'Cg9BQkNJQXBwbGljYXRpb24SQwoERWNobxIcLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0RWNobxodLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZUVjaG8SRgoFRmx1c2gSHS50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdEZsdXNoGh4udGVuZGVybWludC5hYmNpLlJlc3BvbnNlRmx1c2gSQwoESW5mbxIcLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0SW5mbxodLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZUluZm8SUgoJRGVsaXZlclR4EiEudGVuZGVybWludC5hYmNpLlJlcXVlc3REZWxpdmVyVHgaIi50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VEZWxpdmVyVHgSTAoHQ2hlY2tUeBIfLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0Q2hlY2tUeBogLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZUNoZWNrVHgSRgoFUXVlcnkSHS50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdFF1ZXJ5Gh4udGVuZGVybWludC5hYmNpLlJlc3BvbnNlUXVlcnkSSQoGQ29tbWl0Eh4udGVuZGVybWludC5hYmNpLlJlcXVlc3RDb21taXQaHy50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VDb21taXQSUgoJSW5pdENoYWluEiEudGVuZGVybWludC5hYmNpLlJlcXVlc3RJbml0Q2hhaW4aIi50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VJbml0Q2hhaW4SVQoKQmVnaW5CbG9jaxIiLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0QmVnaW5CbG9jaxojLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZUJlZ2luQmxvY2sSTwoIRW5kQmxvY2sSIC50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdEVuZEJsb2NrGiEudGVuZGVybWludC5hYmNpLlJlc3BvbnNlRW5kQmxvY2sSXgoNTGlzdFNuYXBzaG90cxIlLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0TGlzdFNuYXBzaG90cxomLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZUxpc3RTbmFwc2hvdHMSXgoNT2ZmZXJTbmFwc2hvdBIlLnRlbmRlcm1pbnQuYWJjaS5SZXF1ZXN0T2ZmZXJTbmFwc2hvdBomLnRlbmRlcm1pbnQuYWJjaS5SZXNwb25zZU9mZmVyU25hcHNob3QSagoRTG9hZFNuYXBzaG90Q2h1bmsSKS50ZW5kZXJtaW50LmFiY2kuUmVxdWVzdExvYWRTbmFwc2hvdENodW5rGioudGVuZGVybWludC5hYmNpLlJlc3BvbnNlTG9hZFNuYXBzaG90Q2h1bmsSbQoSQXBwbHlTbmFwc2hvdENodW5rEioudGVuZGVybWludC5hYmNpLlJlcXVlc3RBcHBseVNuYXBzaG90Q2h1bmsaKy50ZW5kZXJtaW50LmFiY2kuUmVzcG9uc2VBcHBseVNuYXBzaG90Q2h1bms=');
