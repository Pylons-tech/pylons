///
//  Generated code. Do not modify.
//  source: cosmos/tx/v1beta1/service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import 'tx.pbjson.dart' as $5;
import '../../../google/protobuf/any.pbjson.dart' as $0;
import '../../crypto/multisig/v1beta1/multisig.pbjson.dart' as $1;
import '../../base/v1beta1/coin.pbjson.dart' as $2;
import '../../base/abci/v1beta1/abci.pbjson.dart' as $6;
import '../../../tendermint/abci/types.pbjson.dart' as $7;
import '../../base/query/v1beta1/pagination.pbjson.dart' as $4;

@$core.Deprecated('Use orderByDescriptor instead')
const OrderBy$json = const {
  '1': 'OrderBy',
  '2': const [
    const {'1': 'ORDER_BY_UNSPECIFIED', '2': 0},
    const {'1': 'ORDER_BY_ASC', '2': 1},
    const {'1': 'ORDER_BY_DESC', '2': 2},
  ],
};

/// Descriptor for `OrderBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderByDescriptor = $convert.base64Decode(
    'CgdPcmRlckJ5EhgKFE9SREVSX0JZX1VOU1BFQ0lGSUVEEAASEAoMT1JERVJfQllfQVNDEAESEQoNT1JERVJfQllfREVTQxAC');
@$core.Deprecated('Use broadcastModeDescriptor instead')
const BroadcastMode$json = const {
  '1': 'BroadcastMode',
  '2': const [
    const {'1': 'BROADCAST_MODE_UNSPECIFIED', '2': 0},
    const {'1': 'BROADCAST_MODE_BLOCK', '2': 1},
    const {'1': 'BROADCAST_MODE_SYNC', '2': 2},
    const {'1': 'BROADCAST_MODE_ASYNC', '2': 3},
  ],
};

/// Descriptor for `BroadcastMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List broadcastModeDescriptor = $convert.base64Decode(
    'Cg1Ccm9hZGNhc3RNb2RlEh4KGkJST0FEQ0FTVF9NT0RFX1VOU1BFQ0lGSUVEEAASGAoUQlJPQURDQVNUX01PREVfQkxPQ0sQARIXChNCUk9BRENBU1RfTU9ERV9TWU5DEAISGAoUQlJPQURDQVNUX01PREVfQVNZTkMQAw==');
@$core.Deprecated('Use getTxsEventRequestDescriptor instead')
const GetTxsEventRequest$json = const {
  '1': 'GetTxsEventRequest',
  '2': const [
    const {'1': 'events', '3': 1, '4': 3, '5': 9, '10': 'events'},
    const {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
    const {
      '1': 'order_by',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.cosmos.tx.v1beta1.OrderBy',
      '10': 'orderBy'
    },
  ],
};

/// Descriptor for `GetTxsEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTxsEventRequestDescriptor = $convert.base64Decode(
    'ChJHZXRUeHNFdmVudFJlcXVlc3QSFgoGZXZlbnRzGAEgAygJUgZldmVudHMSRgoKcGFnaW5hdGlvbhgCIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24SNQoIb3JkZXJfYnkYAyABKA4yGi5jb3Ntb3MudHgudjFiZXRhMS5PcmRlckJ5UgdvcmRlckJ5');
@$core.Deprecated('Use getTxsEventResponseDescriptor instead')
const GetTxsEventResponse$json = const {
  '1': 'GetTxsEventResponse',
  '2': const [
    const {
      '1': 'txs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cosmos.tx.v1beta1.Tx',
      '10': 'txs'
    },
    const {
      '1': 'tx_responses',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.abci.v1beta1.TxResponse',
      '10': 'txResponses'
    },
    const {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `GetTxsEventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTxsEventResponseDescriptor = $convert.base64Decode(
    'ChNHZXRUeHNFdmVudFJlc3BvbnNlEicKA3R4cxgBIAMoCzIVLmNvc21vcy50eC52MWJldGExLlR4UgN0eHMSRwoMdHhfcmVzcG9uc2VzGAIgAygLMiQuY29zbW9zLmJhc2UuYWJjaS52MWJldGExLlR4UmVzcG9uc2VSC3R4UmVzcG9uc2VzEkcKCnBhZ2luYXRpb24YAyABKAsyJy5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXNwb25zZVIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use broadcastTxRequestDescriptor instead')
const BroadcastTxRequest$json = const {
  '1': 'BroadcastTxRequest',
  '2': const [
    const {'1': 'tx_bytes', '3': 1, '4': 1, '5': 12, '10': 'txBytes'},
    const {
      '1': 'mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.cosmos.tx.v1beta1.BroadcastMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `BroadcastTxRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastTxRequestDescriptor = $convert.base64Decode(
    'ChJCcm9hZGNhc3RUeFJlcXVlc3QSGQoIdHhfYnl0ZXMYASABKAxSB3R4Qnl0ZXMSNAoEbW9kZRgCIAEoDjIgLmNvc21vcy50eC52MWJldGExLkJyb2FkY2FzdE1vZGVSBG1vZGU=');
@$core.Deprecated('Use broadcastTxResponseDescriptor instead')
const BroadcastTxResponse$json = const {
  '1': 'BroadcastTxResponse',
  '2': const [
    const {
      '1': 'tx_response',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.abci.v1beta1.TxResponse',
      '10': 'txResponse'
    },
  ],
};

/// Descriptor for `BroadcastTxResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastTxResponseDescriptor = $convert.base64Decode(
    'ChNCcm9hZGNhc3RUeFJlc3BvbnNlEkUKC3R4X3Jlc3BvbnNlGAEgASgLMiQuY29zbW9zLmJhc2UuYWJjaS52MWJldGExLlR4UmVzcG9uc2VSCnR4UmVzcG9uc2U=');
@$core.Deprecated('Use simulateRequestDescriptor instead')
const SimulateRequest$json = const {
  '1': 'SimulateRequest',
  '2': const [
    const {
      '1': 'tx',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.tx.v1beta1.Tx',
      '8': const {'3': true},
      '10': 'tx',
    },
    const {'1': 'tx_bytes', '3': 2, '4': 1, '5': 12, '10': 'txBytes'},
  ],
};

/// Descriptor for `SimulateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simulateRequestDescriptor = $convert.base64Decode(
    'Cg9TaW11bGF0ZVJlcXVlc3QSKQoCdHgYASABKAsyFS5jb3Ntb3MudHgudjFiZXRhMS5UeEICGAFSAnR4EhkKCHR4X2J5dGVzGAIgASgMUgd0eEJ5dGVz');
@$core.Deprecated('Use simulateResponseDescriptor instead')
const SimulateResponse$json = const {
  '1': 'SimulateResponse',
  '2': const [
    const {
      '1': 'gas_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.abci.v1beta1.GasInfo',
      '10': 'gasInfo'
    },
    const {
      '1': 'result',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.abci.v1beta1.Result',
      '10': 'result'
    },
  ],
};

/// Descriptor for `SimulateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simulateResponseDescriptor = $convert.base64Decode(
    'ChBTaW11bGF0ZVJlc3BvbnNlEjwKCGdhc19pbmZvGAEgASgLMiEuY29zbW9zLmJhc2UuYWJjaS52MWJldGExLkdhc0luZm9SB2dhc0luZm8SOAoGcmVzdWx0GAIgASgLMiAuY29zbW9zLmJhc2UuYWJjaS52MWJldGExLlJlc3VsdFIGcmVzdWx0');
@$core.Deprecated('Use getTxRequestDescriptor instead')
const GetTxRequest$json = const {
  '1': 'GetTxRequest',
  '2': const [
    const {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
  ],
};

/// Descriptor for `GetTxRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTxRequestDescriptor =
    $convert.base64Decode('CgxHZXRUeFJlcXVlc3QSEgoEaGFzaBgBIAEoCVIEaGFzaA==');
@$core.Deprecated('Use getTxResponseDescriptor instead')
const GetTxResponse$json = const {
  '1': 'GetTxResponse',
  '2': const [
    const {
      '1': 'tx',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.tx.v1beta1.Tx',
      '10': 'tx'
    },
    const {
      '1': 'tx_response',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.abci.v1beta1.TxResponse',
      '10': 'txResponse'
    },
  ],
};

/// Descriptor for `GetTxResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTxResponseDescriptor = $convert.base64Decode(
    'Cg1HZXRUeFJlc3BvbnNlEiUKAnR4GAEgASgLMhUuY29zbW9zLnR4LnYxYmV0YTEuVHhSAnR4EkUKC3R4X3Jlc3BvbnNlGAIgASgLMiQuY29zbW9zLmJhc2UuYWJjaS52MWJldGExLlR4UmVzcG9uc2VSCnR4UmVzcG9uc2U=');
const $core.Map<$core.String, $core.dynamic> ServiceBase$json = const {
  '1': 'Service',
  '2': const [
    const {
      '1': 'Simulate',
      '2': '.cosmos.tx.v1beta1.SimulateRequest',
      '3': '.cosmos.tx.v1beta1.SimulateResponse',
      '4': const {}
    },
    const {
      '1': 'GetTx',
      '2': '.cosmos.tx.v1beta1.GetTxRequest',
      '3': '.cosmos.tx.v1beta1.GetTxResponse',
      '4': const {}
    },
    const {
      '1': 'BroadcastTx',
      '2': '.cosmos.tx.v1beta1.BroadcastTxRequest',
      '3': '.cosmos.tx.v1beta1.BroadcastTxResponse',
      '4': const {}
    },
    const {
      '1': 'GetTxsEvent',
      '2': '.cosmos.tx.v1beta1.GetTxsEventRequest',
      '3': '.cosmos.tx.v1beta1.GetTxsEventResponse',
      '4': const {}
    },
  ],
};

@$core.Deprecated('Use serviceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ServiceBase$messageJson = const {
  '.cosmos.tx.v1beta1.SimulateRequest': SimulateRequest$json,
  '.cosmos.tx.v1beta1.Tx': $5.Tx$json,
  '.cosmos.tx.v1beta1.TxBody': $5.TxBody$json,
  '.google.protobuf.Any': $0.Any$json,
  '.cosmos.tx.v1beta1.AuthInfo': $5.AuthInfo$json,
  '.cosmos.tx.v1beta1.SignerInfo': $5.SignerInfo$json,
  '.cosmos.tx.v1beta1.ModeInfo': $5.ModeInfo$json,
  '.cosmos.tx.v1beta1.ModeInfo.Single': $5.ModeInfo_Single$json,
  '.cosmos.tx.v1beta1.ModeInfo.Multi': $5.ModeInfo_Multi$json,
  '.cosmos.crypto.multisig.v1beta1.CompactBitArray': $1.CompactBitArray$json,
  '.cosmos.tx.v1beta1.Fee': $5.Fee$json,
  '.cosmos.base.v1beta1.Coin': $2.Coin$json,
  '.cosmos.tx.v1beta1.SimulateResponse': SimulateResponse$json,
  '.cosmos.base.abci.v1beta1.GasInfo': $6.GasInfo$json,
  '.cosmos.base.abci.v1beta1.Result': $6.Result$json,
  '.tendermint.abci.Event': $7.Event$json,
  '.tendermint.abci.EventAttribute': $7.EventAttribute$json,
  '.cosmos.tx.v1beta1.GetTxRequest': GetTxRequest$json,
  '.cosmos.tx.v1beta1.GetTxResponse': GetTxResponse$json,
  '.cosmos.base.abci.v1beta1.TxResponse': $6.TxResponse$json,
  '.cosmos.base.abci.v1beta1.ABCIMessageLog': $6.ABCIMessageLog$json,
  '.cosmos.base.abci.v1beta1.StringEvent': $6.StringEvent$json,
  '.cosmos.base.abci.v1beta1.Attribute': $6.Attribute$json,
  '.cosmos.tx.v1beta1.BroadcastTxRequest': BroadcastTxRequest$json,
  '.cosmos.tx.v1beta1.BroadcastTxResponse': BroadcastTxResponse$json,
  '.cosmos.tx.v1beta1.GetTxsEventRequest': GetTxsEventRequest$json,
  '.cosmos.base.query.v1beta1.PageRequest': $4.PageRequest$json,
  '.cosmos.tx.v1beta1.GetTxsEventResponse': GetTxsEventResponse$json,
  '.cosmos.base.query.v1beta1.PageResponse': $4.PageResponse$json,
};

/// Descriptor for `Service`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List serviceDescriptor = $convert.base64Decode(
    'CgdTZXJ2aWNlEnsKCFNpbXVsYXRlEiIuY29zbW9zLnR4LnYxYmV0YTEuU2ltdWxhdGVSZXF1ZXN0GiMuY29zbW9zLnR4LnYxYmV0YTEuU2ltdWxhdGVSZXNwb25zZSImgtPkkwIgIhsvY29zbW9zL3R4L3YxYmV0YTEvc2ltdWxhdGU6ASoScQoFR2V0VHgSHy5jb3Ntb3MudHgudjFiZXRhMS5HZXRUeFJlcXVlc3QaIC5jb3Ntb3MudHgudjFiZXRhMS5HZXRUeFJlc3BvbnNlIiWC0+STAh8SHS9jb3Ntb3MvdHgvdjFiZXRhMS90eHMve2hhc2h9En8KC0Jyb2FkY2FzdFR4EiUuY29zbW9zLnR4LnYxYmV0YTEuQnJvYWRjYXN0VHhSZXF1ZXN0GiYuY29zbW9zLnR4LnYxYmV0YTEuQnJvYWRjYXN0VHhSZXNwb25zZSIhgtPkkwIbIhYvY29zbW9zL3R4L3YxYmV0YTEvdHhzOgEqEnwKC0dldFR4c0V2ZW50EiUuY29zbW9zLnR4LnYxYmV0YTEuR2V0VHhzRXZlbnRSZXF1ZXN0GiYuY29zbW9zLnR4LnYxYmV0YTEuR2V0VHhzRXZlbnRSZXNwb25zZSIegtPkkwIYEhYvY29zbW9zL3R4L3YxYmV0YTEvdHhz');
