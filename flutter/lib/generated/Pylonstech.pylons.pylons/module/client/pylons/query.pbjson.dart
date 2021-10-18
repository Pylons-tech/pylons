///
//  Generated code. Do not modify.
//  source: pylons/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use queryGetUsernameByAddressRequestDescriptor instead')
const QueryGetUsernameByAddressRequest$json = const {
  '1': 'QueryGetUsernameByAddressRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `QueryGetUsernameByAddressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetUsernameByAddressRequestDescriptor = $convert.base64Decode('CiBRdWVyeUdldFVzZXJuYW1lQnlBZGRyZXNzUmVxdWVzdBIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNz');
@$core.Deprecated('Use queryGetAddressByUsernameRequestDescriptor instead')
const QueryGetAddressByUsernameRequest$json = const {
  '1': 'QueryGetAddressByUsernameRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `QueryGetAddressByUsernameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetAddressByUsernameRequestDescriptor = $convert.base64Decode('CiBRdWVyeUdldEFkZHJlc3NCeVVzZXJuYW1lUmVxdWVzdBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use queryGetUsernameByAddressResponseDescriptor instead')
const QueryGetUsernameByAddressResponse$json = const {
  '1': 'QueryGetUsernameByAddressResponse',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Username', '8': const {}, '10': 'username'},
  ],
};

/// Descriptor for `QueryGetUsernameByAddressResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetUsernameByAddressResponseDescriptor = $convert.base64Decode('CiFRdWVyeUdldFVzZXJuYW1lQnlBZGRyZXNzUmVzcG9uc2USRAoIdXNlcm5hbWUYASABKAsyIi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuVXNlcm5hbWVCBMjeHwBSCHVzZXJuYW1l');
@$core.Deprecated('Use queryGetAddressByUsernameResponseDescriptor instead')
const QueryGetAddressByUsernameResponse$json = const {
  '1': 'QueryGetAddressByUsernameResponse',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.AccountAddr', '8': const {}, '10': 'address'},
  ],
};

/// Descriptor for `QueryGetAddressByUsernameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetAddressByUsernameResponseDescriptor = $convert.base64Decode('CiFRdWVyeUdldEFkZHJlc3NCeVVzZXJuYW1lUmVzcG9uc2USRQoHYWRkcmVzcxgBIAEoCzIlLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5BY2NvdW50QWRkckIEyN4fAFIHYWRkcmVzcw==');
@$core.Deprecated('Use queryGetTradeRequestDescriptor instead')
const QueryGetTradeRequest$json = const {
  '1': 'QueryGetTradeRequest',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 4, '10': 'ID'},
  ],
};

/// Descriptor for `QueryGetTradeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetTradeRequestDescriptor = $convert.base64Decode('ChRRdWVyeUdldFRyYWRlUmVxdWVzdBIOCgJJRBgBIAEoBFICSUQ=');
@$core.Deprecated('Use queryGetTradeResponseDescriptor instead')
const QueryGetTradeResponse$json = const {
  '1': 'QueryGetTradeResponse',
  '2': const [
    const {'1': 'Trade', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Trade', '8': const {}, '10': 'Trade'},
  ],
};

/// Descriptor for `QueryGetTradeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetTradeResponseDescriptor = $convert.base64Decode('ChVRdWVyeUdldFRyYWRlUmVzcG9uc2USOwoFVHJhZGUYASABKAsyHy5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuVHJhZGVCBMjeHwBSBVRyYWRl');
@$core.Deprecated('Use queryListItemByOwnerRequestDescriptor instead')
const QueryListItemByOwnerRequest$json = const {
  '1': 'QueryListItemByOwnerRequest',
  '2': const [
    const {'1': 'owner', '3': 1, '4': 1, '5': 9, '10': 'owner'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryListItemByOwnerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListItemByOwnerRequestDescriptor = $convert.base64Decode('ChtRdWVyeUxpc3RJdGVtQnlPd25lclJlcXVlc3QSFAoFb3duZXIYASABKAlSBW93bmVyEkYKCnBhZ2luYXRpb24YAyABKAsyJi5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXF1ZXN0UgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryListItemByOwnerResponseDescriptor instead')
const QueryListItemByOwnerResponse$json = const {
  '1': 'QueryListItemByOwnerResponse',
  '2': const [
    const {'1': 'Items', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Item', '8': const {}, '10': 'Items'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
  '7': const {},
};

/// Descriptor for `QueryListItemByOwnerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListItemByOwnerResponseDescriptor = $convert.base64Decode('ChxRdWVyeUxpc3RJdGVtQnlPd25lclJlc3BvbnNlEjoKBUl0ZW1zGAEgAygLMh4uUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkl0ZW1CBMjeHwBSBUl0ZW1zEkcKCnBhZ2luYXRpb24YAiABKAsyJy5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXNwb25zZVIKcGFnaW5hdGlvbjoI6KAfAIigHwA=');
@$core.Deprecated('Use queryGetGoogleInAppPurchaseOrderRequestDescriptor instead')
const QueryGetGoogleInAppPurchaseOrderRequest$json = const {
  '1': 'QueryGetGoogleInAppPurchaseOrderRequest',
  '2': const [
    const {'1': 'PurchaseToken', '3': 1, '4': 1, '5': 9, '10': 'PurchaseToken'},
  ],
};

/// Descriptor for `QueryGetGoogleInAppPurchaseOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetGoogleInAppPurchaseOrderRequestDescriptor = $convert.base64Decode('CidRdWVyeUdldEdvb2dsZUluQXBwUHVyY2hhc2VPcmRlclJlcXVlc3QSJAoNUHVyY2hhc2VUb2tlbhgBIAEoCVINUHVyY2hhc2VUb2tlbg==');
@$core.Deprecated('Use queryGetGoogleInAppPurchaseOrderResponseDescriptor instead')
const QueryGetGoogleInAppPurchaseOrderResponse$json = const {
  '1': 'QueryGetGoogleInAppPurchaseOrderResponse',
  '2': const [
    const {'1': 'Order', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.GoogleInAppPurchaseOrder', '8': const {}, '10': 'Order'},
  ],
};

/// Descriptor for `QueryGetGoogleInAppPurchaseOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetGoogleInAppPurchaseOrderResponseDescriptor = $convert.base64Decode('CihRdWVyeUdldEdvb2dsZUluQXBwUHVyY2hhc2VPcmRlclJlc3BvbnNlEk4KBU9yZGVyGAEgASgLMjIuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkdvb2dsZUluQXBwUHVyY2hhc2VPcmRlckIEyN4fAFIFT3JkZXI=');
@$core.Deprecated('Use queryListExecutionsByItemRequestDescriptor instead')
const QueryListExecutionsByItemRequest$json = const {
  '1': 'QueryListExecutionsByItemRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ItemID', '3': 2, '4': 1, '5': 9, '10': 'ItemID'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
  '7': const {},
};

/// Descriptor for `QueryListExecutionsByItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByItemRequestDescriptor = $convert.base64Decode('CiBRdWVyeUxpc3RFeGVjdXRpb25zQnlJdGVtUmVxdWVzdBIeCgpDb29rYm9va0lEGAEgASgJUgpDb29rYm9va0lEEhYKBkl0ZW1JRBgCIAEoCVIGSXRlbUlEEkYKCnBhZ2luYXRpb24YAyABKAsyJi5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXF1ZXN0UgpwYWdpbmF0aW9uOgjooB8AiKAfAA==');
@$core.Deprecated('Use queryListExecutionsByItemResponseDescriptor instead')
const QueryListExecutionsByItemResponse$json = const {
  '1': 'QueryListExecutionsByItemResponse',
  '2': const [
    const {'1': 'CompletedExecutions', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'CompletedExecutions'},
    const {'1': 'PendingExecutions', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'PendingExecutions'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryListExecutionsByItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByItemResponseDescriptor = $convert.base64Decode('CiFRdWVyeUxpc3RFeGVjdXRpb25zQnlJdGVtUmVzcG9uc2USWwoTQ29tcGxldGVkRXhlY3V0aW9ucxgBIAMoCzIjLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5FeGVjdXRpb25CBMjeHwBSE0NvbXBsZXRlZEV4ZWN1dGlvbnMSVwoRUGVuZGluZ0V4ZWN1dGlvbnMYAiADKAsyIy5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuRXhlY3V0aW9uQgTI3h8AUhFQZW5kaW5nRXhlY3V0aW9ucxJHCgpwYWdpbmF0aW9uGAMgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryListExecutionsByRecipeRequestDescriptor instead')
const QueryListExecutionsByRecipeRequest$json = const {
  '1': 'QueryListExecutionsByRecipeRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'RecipeID', '3': 2, '4': 1, '5': 9, '10': 'RecipeID'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
  '7': const {},
};

/// Descriptor for `QueryListExecutionsByRecipeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByRecipeRequestDescriptor = $convert.base64Decode('CiJRdWVyeUxpc3RFeGVjdXRpb25zQnlSZWNpcGVSZXF1ZXN0Eh4KCkNvb2tib29rSUQYASABKAlSCkNvb2tib29rSUQSGgoIUmVjaXBlSUQYAiABKAlSCFJlY2lwZUlEEkYKCnBhZ2luYXRpb24YAyABKAsyJi5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXF1ZXN0UgpwYWdpbmF0aW9uOgjooB8AiKAfAA==');
@$core.Deprecated('Use queryListExecutionsByRecipeResponseDescriptor instead')
const QueryListExecutionsByRecipeResponse$json = const {
  '1': 'QueryListExecutionsByRecipeResponse',
  '2': const [
    const {'1': 'CompletedExecutions', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'CompletedExecutions'},
    const {'1': 'PendingExecutions', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'PendingExecutions'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryListExecutionsByRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByRecipeResponseDescriptor = $convert.base64Decode('CiNRdWVyeUxpc3RFeGVjdXRpb25zQnlSZWNpcGVSZXNwb25zZRJbChNDb21wbGV0ZWRFeGVjdXRpb25zGAEgAygLMiMuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkV4ZWN1dGlvbkIEyN4fAFITQ29tcGxldGVkRXhlY3V0aW9ucxJXChFQZW5kaW5nRXhlY3V0aW9ucxgCIAMoCzIjLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5FeGVjdXRpb25CBMjeHwBSEVBlbmRpbmdFeGVjdXRpb25zEkcKCnBhZ2luYXRpb24YAyABKAsyJy5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXNwb25zZVIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryGetExecutionRequestDescriptor instead')
const QueryGetExecutionRequest$json = const {
  '1': 'QueryGetExecutionRequest',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `QueryGetExecutionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetExecutionRequestDescriptor = $convert.base64Decode('ChhRdWVyeUdldEV4ZWN1dGlvblJlcXVlc3QSDgoCSUQYASABKAlSAklE');
@$core.Deprecated('Use queryGetExecutionResponseDescriptor instead')
const QueryGetExecutionResponse$json = const {
  '1': 'QueryGetExecutionResponse',
  '2': const [
    const {'1': 'Execution', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Execution', '8': const {}, '10': 'Execution'},
    const {'1': 'Completed', '3': 2, '4': 1, '5': 8, '10': 'Completed'},
  ],
};

/// Descriptor for `QueryGetExecutionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetExecutionResponseDescriptor = $convert.base64Decode('ChlRdWVyeUdldEV4ZWN1dGlvblJlc3BvbnNlEkcKCUV4ZWN1dGlvbhgBIAEoCzIjLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5FeGVjdXRpb25CBMjeHwBSCUV4ZWN1dGlvbhIcCglDb21wbGV0ZWQYAiABKAhSCUNvbXBsZXRlZA==');
@$core.Deprecated('Use queryListRecipesByCookbookRequestDescriptor instead')
const QueryListRecipesByCookbookRequest$json = const {
  '1': 'QueryListRecipesByCookbookRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryListRecipesByCookbookRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListRecipesByCookbookRequestDescriptor = $convert.base64Decode('CiFRdWVyeUxpc3RSZWNpcGVzQnlDb29rYm9va1JlcXVlc3QSHgoKQ29va2Jvb2tJRBgBIAEoCVIKQ29va2Jvb2tJRBJGCgpwYWdpbmF0aW9uGAIgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryListRecipesByCookbookResponseDescriptor instead')
const QueryListRecipesByCookbookResponse$json = const {
  '1': 'QueryListRecipesByCookbookResponse',
  '2': const [
    const {'1': 'Recipes', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Recipe', '8': const {}, '10': 'Recipes'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryListRecipesByCookbookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListRecipesByCookbookResponseDescriptor = $convert.base64Decode('CiJRdWVyeUxpc3RSZWNpcGVzQnlDb29rYm9va1Jlc3BvbnNlEkAKB1JlY2lwZXMYASADKAsyIC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuUmVjaXBlQgTI3h8AUgdSZWNpcGVzEkcKCnBhZ2luYXRpb24YAiABKAsyJy5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXNwb25zZVIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryGetItemRequestDescriptor instead')
const QueryGetItemRequest$json = const {
  '1': 'QueryGetItemRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `QueryGetItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetItemRequestDescriptor = $convert.base64Decode('ChNRdWVyeUdldEl0ZW1SZXF1ZXN0Eh4KCkNvb2tib29rSUQYASABKAlSCkNvb2tib29rSUQSDgoCSUQYAyABKAlSAklE');
@$core.Deprecated('Use queryGetItemResponseDescriptor instead')
const QueryGetItemResponse$json = const {
  '1': 'QueryGetItemResponse',
  '2': const [
    const {'1': 'Item', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Item', '8': const {}, '10': 'Item'},
  ],
};

/// Descriptor for `QueryGetItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetItemResponseDescriptor = $convert.base64Decode('ChRRdWVyeUdldEl0ZW1SZXNwb25zZRI4CgRJdGVtGAEgASgLMh4uUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkl0ZW1CBMjeHwBSBEl0ZW0=');
@$core.Deprecated('Use queryGetRecipeRequestDescriptor instead')
const QueryGetRecipeRequest$json = const {
  '1': 'QueryGetRecipeRequest',
  '2': const [
    const {'1': 'CookbookID', '3': 1, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `QueryGetRecipeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRecipeRequestDescriptor = $convert.base64Decode('ChVRdWVyeUdldFJlY2lwZVJlcXVlc3QSHgoKQ29va2Jvb2tJRBgBIAEoCVIKQ29va2Jvb2tJRBIOCgJJRBgCIAEoCVICSUQ=');
@$core.Deprecated('Use queryGetRecipeResponseDescriptor instead')
const QueryGetRecipeResponse$json = const {
  '1': 'QueryGetRecipeResponse',
  '2': const [
    const {'1': 'Recipe', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Recipe', '8': const {}, '10': 'Recipe'},
  ],
};

/// Descriptor for `QueryGetRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRecipeResponseDescriptor = $convert.base64Decode('ChZRdWVyeUdldFJlY2lwZVJlc3BvbnNlEj4KBlJlY2lwZRgBIAEoCzIgLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5SZWNpcGVCBMjeHwBSBlJlY2lwZQ==');
@$core.Deprecated('Use queryListCookbooksByCreatorRequestDescriptor instead')
const QueryListCookbooksByCreatorRequest$json = const {
  '1': 'QueryListCookbooksByCreatorRequest',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryListCookbooksByCreatorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListCookbooksByCreatorRequestDescriptor = $convert.base64Decode('CiJRdWVyeUxpc3RDb29rYm9va3NCeUNyZWF0b3JSZXF1ZXN0EhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISRgoKcGFnaW5hdGlvbhgDIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryListCookbooksByCreatorResponseDescriptor instead')
const QueryListCookbooksByCreatorResponse$json = const {
  '1': 'QueryListCookbooksByCreatorResponse',
  '2': const [
    const {'1': 'Cookbooks', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Cookbook', '8': const {}, '10': 'Cookbooks'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.cosmos.base.query.v1beta1.PageResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `QueryListCookbooksByCreatorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListCookbooksByCreatorResponseDescriptor = $convert.base64Decode('CiNRdWVyeUxpc3RDb29rYm9va3NCeUNyZWF0b3JSZXNwb25zZRJGCglDb29rYm9va3MYASADKAsyIi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuQ29va2Jvb2tCBMjeHwBSCUNvb2tib29rcxJHCgpwYWdpbmF0aW9uGAMgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryGetCookbookRequestDescriptor instead')
const QueryGetCookbookRequest$json = const {
  '1': 'QueryGetCookbookRequest',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `QueryGetCookbookRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetCookbookRequestDescriptor = $convert.base64Decode('ChdRdWVyeUdldENvb2tib29rUmVxdWVzdBIOCgJJRBgBIAEoCVICSUQ=');
@$core.Deprecated('Use queryGetCookbookResponseDescriptor instead')
const QueryGetCookbookResponse$json = const {
  '1': 'QueryGetCookbookResponse',
  '2': const [
    const {'1': 'Cookbook', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Cookbook', '8': const {}, '10': 'Cookbook'},
  ],
};

/// Descriptor for `QueryGetCookbookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetCookbookResponseDescriptor = $convert.base64Decode('ChhRdWVyeUdldENvb2tib29rUmVzcG9uc2USRAoIQ29va2Jvb2sYASABKAsyIi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuQ29va2Jvb2tCBMjeHwBSCENvb2tib29r');
