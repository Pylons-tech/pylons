///
//  Generated code. Do not modify.
//  source: pylons/genesis.proto
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
    const {'1': 'accountList', '3': 14, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.UserMap', '8': const {}, '10': 'accountList'},
    const {'1': 'tradeList', '3': 13, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Trade', '8': const {}, '10': 'tradeList'},
    const {'1': 'tradeCount', '3': 12, '4': 1, '5': 4, '10': 'tradeCount'},
    const {'1': 'entityCount', '3': 11, '4': 1, '5': 4, '10': 'entityCount'},
    const {'1': 'params', '3': 10, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Params', '8': const {}, '10': 'params'},
    const {'1': 'googleInAppPurchaseOrderList', '3': 8, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.GoogleInAppPurchaseOrder', '8': const {}, '10': 'googleInAppPurchaseOrderList'},
    const {'1': 'googleIAPOrderCount', '3': 9, '4': 1, '5': 4, '10': 'googleIAPOrderCount'},
    const {'1': 'executionList', '3': 7, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'executionList'},
    const {'1': 'executionCount', '3': 6, '4': 1, '5': 4, '10': 'executionCount'},
    const {'1': 'pendingExecutionList', '3': 5, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'pendingExecutionList'},
    const {'1': 'pendingExecutionCount', '3': 4, '4': 1, '5': 4, '10': 'pendingExecutionCount'},
    const {'1': 'itemList', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Item', '8': const {}, '10': 'itemList'},
    const {'1': 'recipeList', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Recipe', '8': const {}, '10': 'recipeList'},
    const {'1': 'cookbookList', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Cookbook', '8': const {}, '10': 'cookbookList'},
  ],
};

/// Descriptor for `GenesisState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genesisStateDescriptor = $convert.base64Decode('CgxHZW5lc2lzU3RhdGUSSQoLYWNjb3VudExpc3QYDiADKAsyIS5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuVXNlck1hcEIEyN4fAFILYWNjb3VudExpc3QSQwoJdHJhZGVMaXN0GA0gAygLMh8uUHlsb25zdGVjaC5weWxvbnMucHlsb25zLlRyYWRlQgTI3h8AUgl0cmFkZUxpc3QSHgoKdHJhZGVDb3VudBgMIAEoBFIKdHJhZGVDb3VudBIgCgtlbnRpdHlDb3VudBgLIAEoBFILZW50aXR5Q291bnQSPgoGcGFyYW1zGAogASgLMiAuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLlBhcmFtc0IEyN4fAFIGcGFyYW1zEnwKHGdvb2dsZUluQXBwUHVyY2hhc2VPcmRlckxpc3QYCCADKAsyMi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuR29vZ2xlSW5BcHBQdXJjaGFzZU9yZGVyQgTI3h8AUhxnb29nbGVJbkFwcFB1cmNoYXNlT3JkZXJMaXN0EjAKE2dvb2dsZUlBUE9yZGVyQ291bnQYCSABKARSE2dvb2dsZUlBUE9yZGVyQ291bnQSTwoNZXhlY3V0aW9uTGlzdBgHIAMoCzIjLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5FeGVjdXRpb25CBMjeHwBSDWV4ZWN1dGlvbkxpc3QSJgoOZXhlY3V0aW9uQ291bnQYBiABKARSDmV4ZWN1dGlvbkNvdW50El0KFHBlbmRpbmdFeGVjdXRpb25MaXN0GAUgAygLMiMuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkV4ZWN1dGlvbkIEyN4fAFIUcGVuZGluZ0V4ZWN1dGlvbkxpc3QSNAoVcGVuZGluZ0V4ZWN1dGlvbkNvdW50GAQgASgEUhVwZW5kaW5nRXhlY3V0aW9uQ291bnQSQAoIaXRlbUxpc3QYAyADKAsyHi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuSXRlbUIEyN4fAFIIaXRlbUxpc3QSRgoKcmVjaXBlTGlzdBgCIAMoCzIgLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5SZWNpcGVCBMjeHwBSCnJlY2lwZUxpc3QSTAoMY29va2Jvb2tMaXN0GAEgAygLMiIuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkNvb2tib29rQgTI3h8AUgxjb29rYm9va0xpc3Q=');
