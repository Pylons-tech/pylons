///
//  Generated code. Do not modify.
//  source: pylons/pylons/genesis.proto
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
    const {
      '1': 'redeem_info_list',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.RedeemInfo',
      '8': const {},
      '10': 'redeemInfoList'
    },
    const {
      '1': 'payment_info_list',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.PaymentInfo',
      '8': const {},
      '10': 'paymentInfoList'
    },
    const {
      '1': 'account_list',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.UserMap',
      '8': const {},
      '10': 'accountList'
    },
    const {
      '1': 'trade_list',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Trade',
      '8': const {},
      '10': 'tradeList'
    },
    const {'1': 'trade_count', '3': 12, '4': 1, '5': 4, '10': 'tradeCount'},
    const {'1': 'entity_count', '3': 11, '4': 1, '5': 4, '10': 'entityCount'},
    const {
      '1': 'params',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Params',
      '8': const {},
      '10': 'params'
    },
    const {
      '1': 'google_in_app_purchase_order_list',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.GoogleInAppPurchaseOrder',
      '8': const {},
      '10': 'googleInAppPurchaseOrderList'
    },
    const {
      '1': 'google_iap_order_count',
      '3': 9,
      '4': 1,
      '5': 4,
      '10': 'googleIapOrderCount'
    },
    const {
      '1': 'execution_list',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Execution',
      '8': const {},
      '10': 'executionList'
    },
    const {
      '1': 'execution_count',
      '3': 6,
      '4': 1,
      '5': 4,
      '10': 'executionCount'
    },
    const {
      '1': 'pending_execution_list',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Execution',
      '8': const {},
      '10': 'pendingExecutionList'
    },
    const {
      '1': 'pending_execution_count',
      '3': 4,
      '4': 1,
      '5': 4,
      '10': 'pendingExecutionCount'
    },
    const {
      '1': 'item_list',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Item',
      '8': const {},
      '10': 'itemList'
    },
    const {
      '1': 'recipe_list',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Recipe',
      '8': const {},
      '10': 'recipeList'
    },
    const {
      '1': 'cookbook_list',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Cookbook',
      '8': const {},
      '10': 'cookbookList'
    },
  ],
};

/// Descriptor for `GenesisState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genesisStateDescriptor = $convert.base64Decode(
    'CgxHZW5lc2lzU3RhdGUSSQoQcmVkZWVtX2luZm9fbGlzdBgQIAMoCzIZLnB5bG9ucy5weWxvbnMuUmVkZWVtSW5mb0IEyN4fAFIOcmVkZWVtSW5mb0xpc3QSTAoRcGF5bWVudF9pbmZvX2xpc3QYDyADKAsyGi5weWxvbnMucHlsb25zLlBheW1lbnRJbmZvQgTI3h8AUg9wYXltZW50SW5mb0xpc3QSPwoMYWNjb3VudF9saXN0GA4gAygLMhYucHlsb25zLnB5bG9ucy5Vc2VyTWFwQgTI3h8AUgthY2NvdW50TGlzdBI5Cgp0cmFkZV9saXN0GA0gAygLMhQucHlsb25zLnB5bG9ucy5UcmFkZUIEyN4fAFIJdHJhZGVMaXN0Eh8KC3RyYWRlX2NvdW50GAwgASgEUgp0cmFkZUNvdW50EiEKDGVudGl0eV9jb3VudBgLIAEoBFILZW50aXR5Q291bnQSMwoGcGFyYW1zGAogASgLMhUucHlsb25zLnB5bG9ucy5QYXJhbXNCBMjeHwBSBnBhcmFtcxJ2CiFnb29nbGVfaW5fYXBwX3B1cmNoYXNlX29yZGVyX2xpc3QYCCADKAsyJy5weWxvbnMucHlsb25zLkdvb2dsZUluQXBwUHVyY2hhc2VPcmRlckIEyN4fAFIcZ29vZ2xlSW5BcHBQdXJjaGFzZU9yZGVyTGlzdBIzChZnb29nbGVfaWFwX29yZGVyX2NvdW50GAkgASgEUhNnb29nbGVJYXBPcmRlckNvdW50EkUKDmV4ZWN1dGlvbl9saXN0GAcgAygLMhgucHlsb25zLnB5bG9ucy5FeGVjdXRpb25CBMjeHwBSDWV4ZWN1dGlvbkxpc3QSJwoPZXhlY3V0aW9uX2NvdW50GAYgASgEUg5leGVjdXRpb25Db3VudBJUChZwZW5kaW5nX2V4ZWN1dGlvbl9saXN0GAUgAygLMhgucHlsb25zLnB5bG9ucy5FeGVjdXRpb25CBMjeHwBSFHBlbmRpbmdFeGVjdXRpb25MaXN0EjYKF3BlbmRpbmdfZXhlY3V0aW9uX2NvdW50GAQgASgEUhVwZW5kaW5nRXhlY3V0aW9uQ291bnQSNgoJaXRlbV9saXN0GAMgAygLMhMucHlsb25zLnB5bG9ucy5JdGVtQgTI3h8AUghpdGVtTGlzdBI8CgtyZWNpcGVfbGlzdBgCIAMoCzIVLnB5bG9ucy5weWxvbnMuUmVjaXBlQgTI3h8AUgpyZWNpcGVMaXN0EkIKDWNvb2tib29rX2xpc3QYASADKAsyFy5weWxvbnMucHlsb25zLkNvb2tib29rQgTI3h8AUgxjb29rYm9va0xpc3Q=');
