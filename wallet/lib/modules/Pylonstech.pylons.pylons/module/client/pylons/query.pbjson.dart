///
//  Generated code. Do not modify.
//  source: pylons/pylons/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use queryListSignUpByRefereeDescriptor instead')
const QueryListSignUpByReferee$json = {
  '1': 'QueryListSignUpByReferee',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
  ],
};

/// Descriptor for `QueryListSignUpByReferee`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListSignUpByRefereeDescriptor =
    $convert.base64Decode(
        'ChhRdWVyeUxpc3RTaWduVXBCeVJlZmVyZWUSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvcg==');
@$core.Deprecated('Use queryListSignUpByRefereeResponseDescriptor instead')
const QueryListSignUpByRefereeResponse$json = {
  '1': 'QueryListSignUpByRefereeResponse',
  '2': [
    {
      '1': 'signup',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.ReferralKV',
      '10': 'signup'
    },
  ],
};

/// Descriptor for `QueryListSignUpByRefereeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListSignUpByRefereeResponseDescriptor =
    $convert.base64Decode(
        'CiBRdWVyeUxpc3RTaWduVXBCeVJlZmVyZWVSZXNwb25zZRIxCgZzaWdudXAYASABKAsyGS5weWxvbnMucHlsb25zLlJlZmVycmFsS1ZSBnNpZ251cA==');
@$core.Deprecated('Use queryListTradesByCreatorRequestDescriptor instead')
const QueryListTradesByCreatorRequest$json = {
  '1': 'QueryListTradesByCreatorRequest',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListTradesByCreatorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListTradesByCreatorRequestDescriptor =
    $convert.base64Decode(
        'Ch9RdWVyeUxpc3RUcmFkZXNCeUNyZWF0b3JSZXF1ZXN0EhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISRgoKcGFnaW5hdGlvbhgCIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryListTradesByCreatorResponseDescriptor instead')
const QueryListTradesByCreatorResponse$json = {
  '1': 'QueryListTradesByCreatorResponse',
  '2': [
    {
      '1': 'trades',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Trade',
      '8': {},
      '10': 'trades'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
  '7': {},
};

/// Descriptor for `QueryListTradesByCreatorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListTradesByCreatorResponseDescriptor =
    $convert.base64Decode(
        'CiBRdWVyeUxpc3RUcmFkZXNCeUNyZWF0b3JSZXNwb25zZRIyCgZ0cmFkZXMYASADKAsyFC5weWxvbnMucHlsb25zLlRyYWRlQgTI3h8AUgZ0cmFkZXMSRwoKcGFnaW5hdGlvbhgCIAEoCzInLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlc3BvbnNlUgpwYWdpbmF0aW9uOgiIoB8A6KAfAA==');
@$core.Deprecated('Use queryGetRecipeHistoryRequestDescriptor instead')
const QueryGetRecipeHistoryRequest$json = {
  '1': 'QueryGetRecipeHistoryRequest',
  '2': [
    {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'recipe_id', '3': 2, '4': 1, '5': 9, '10': 'recipeId'},
  ],
};

/// Descriptor for `QueryGetRecipeHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRecipeHistoryRequestDescriptor =
    $convert.base64Decode(
        'ChxRdWVyeUdldFJlY2lwZUhpc3RvcnlSZXF1ZXN0Eh8KC2Nvb2tib29rX2lkGAEgASgJUgpjb29rYm9va0lkEhsKCXJlY2lwZV9pZBgCIAEoCVIIcmVjaXBlSWQ=');
@$core.Deprecated('Use queryGetRecipeHistoryResponseDescriptor instead')
const QueryGetRecipeHistoryResponse$json = {
  '1': 'QueryGetRecipeHistoryResponse',
  '2': [
    {
      '1': 'history',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.RecipeHistory',
      '10': 'history'
    },
  ],
};

/// Descriptor for `QueryGetRecipeHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRecipeHistoryResponseDescriptor =
    $convert.base64Decode(
        'Ch1RdWVyeUdldFJlY2lwZUhpc3RvcnlSZXNwb25zZRI2CgdoaXN0b3J5GAEgAygLMhwucHlsb25zLnB5bG9ucy5SZWNpcGVIaXN0b3J5UgdoaXN0b3J5');
@$core.Deprecated('Use recipeHistoryDescriptor instead')
const RecipeHistory$json = {
  '1': 'RecipeHistory',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'recipe_id', '3': 3, '4': 1, '5': 9, '10': 'recipeId'},
    {'1': 'sender', '3': 4, '4': 1, '5': 9, '10': 'sender'},
    {'1': 'sender_name', '3': 5, '4': 1, '5': 9, '10': 'senderName'},
    {'1': 'receiver', '3': 6, '4': 1, '5': 9, '10': 'receiver'},
    {'1': 'amount', '3': 7, '4': 1, '5': 9, '10': 'amount'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `RecipeHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeHistoryDescriptor = $convert.base64Decode(
    'Cg1SZWNpcGVIaXN0b3J5EhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIfCgtjb29rYm9va19pZBgCIAEoCVIKY29va2Jvb2tJZBIbCglyZWNpcGVfaWQYAyABKAlSCHJlY2lwZUlkEhYKBnNlbmRlchgEIAEoCVIGc2VuZGVyEh8KC3NlbmRlcl9uYW1lGAUgASgJUgpzZW5kZXJOYW1lEhoKCHJlY2VpdmVyGAYgASgJUghyZWNlaXZlchIWCgZhbW91bnQYByABKAlSBmFtb3VudBIdCgpjcmVhdGVkX2F0GAggASgDUgljcmVhdGVkQXQ=');
@$core.Deprecated('Use queryGetStripeRefundRequestDescriptor instead')
const QueryGetStripeRefundRequest$json = {
  '1': 'QueryGetStripeRefundRequest',
};

/// Descriptor for `QueryGetStripeRefundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetStripeRefundRequestDescriptor =
    $convert.base64Decode('ChtRdWVyeUdldFN0cmlwZVJlZnVuZFJlcXVlc3Q=');
@$core.Deprecated('Use queryGetStripeRefundResponseDescriptor instead')
const QueryGetStripeRefundResponse$json = {
  '1': 'QueryGetStripeRefundResponse',
  '2': [
    {
      '1': 'refunds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.StripeRefund',
      '10': 'refunds'
    },
  ],
};

/// Descriptor for `QueryGetStripeRefundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetStripeRefundResponseDescriptor =
    $convert.base64Decode(
        'ChxRdWVyeUdldFN0cmlwZVJlZnVuZFJlc3BvbnNlEjUKB3JlZnVuZHMYASADKAsyGy5weWxvbnMucHlsb25zLlN0cmlwZVJlZnVuZFIHcmVmdW5kcw==');
@$core.Deprecated('Use queryGetRedeemInfoRequestDescriptor instead')
const QueryGetRedeemInfoRequest$json = {
  '1': 'QueryGetRedeemInfoRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `QueryGetRedeemInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRedeemInfoRequestDescriptor =
    $convert.base64Decode(
        'ChlRdWVyeUdldFJlZGVlbUluZm9SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');
@$core.Deprecated('Use queryGetRedeemInfoResponseDescriptor instead')
const QueryGetRedeemInfoResponse$json = {
  '1': 'QueryGetRedeemInfoResponse',
  '2': [
    {
      '1': 'redeem_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.RedeemInfo',
      '8': {},
      '10': 'redeemInfo'
    },
  ],
};

/// Descriptor for `QueryGetRedeemInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRedeemInfoResponseDescriptor =
    $convert.base64Decode(
        'ChpRdWVyeUdldFJlZGVlbUluZm9SZXNwb25zZRJACgtyZWRlZW1faW5mbxgBIAEoCzIZLnB5bG9ucy5weWxvbnMuUmVkZWVtSW5mb0IEyN4fAFIKcmVkZWVtSW5mbw==');
@$core.Deprecated('Use queryAllRedeemInfoRequestDescriptor instead')
const QueryAllRedeemInfoRequest$json = {
  '1': 'QueryAllRedeemInfoRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryAllRedeemInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAllRedeemInfoRequestDescriptor =
    $convert.base64Decode(
        'ChlRdWVyeUFsbFJlZGVlbUluZm9SZXF1ZXN0EkYKCnBhZ2luYXRpb24YASABKAsyJi5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXF1ZXN0UgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryAllRedeemInfoResponseDescriptor instead')
const QueryAllRedeemInfoResponse$json = {
  '1': 'QueryAllRedeemInfoResponse',
  '2': [
    {
      '1': 'redeem_info',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.RedeemInfo',
      '8': {},
      '10': 'redeemInfo'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryAllRedeemInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAllRedeemInfoResponseDescriptor =
    $convert.base64Decode(
        'ChpRdWVyeUFsbFJlZGVlbUluZm9SZXNwb25zZRJACgtyZWRlZW1faW5mbxgBIAMoCzIZLnB5bG9ucy5weWxvbnMuUmVkZWVtSW5mb0IEyN4fAFIKcmVkZWVtSW5mbxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryGetPaymentInfoRequestDescriptor instead')
const QueryGetPaymentInfoRequest$json = {
  '1': 'QueryGetPaymentInfoRequest',
  '2': [
    {'1': 'purchase_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseId'},
  ],
};

/// Descriptor for `QueryGetPaymentInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetPaymentInfoRequestDescriptor =
    $convert.base64Decode(
        'ChpRdWVyeUdldFBheW1lbnRJbmZvUmVxdWVzdBIfCgtwdXJjaGFzZV9pZBgBIAEoCVIKcHVyY2hhc2VJZA==');
@$core.Deprecated('Use queryGetPaymentInfoResponseDescriptor instead')
const QueryGetPaymentInfoResponse$json = {
  '1': 'QueryGetPaymentInfoResponse',
  '2': [
    {
      '1': 'payment_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.PaymentInfo',
      '8': {},
      '10': 'paymentInfo'
    },
  ],
};

/// Descriptor for `QueryGetPaymentInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetPaymentInfoResponseDescriptor =
    $convert.base64Decode(
        'ChtRdWVyeUdldFBheW1lbnRJbmZvUmVzcG9uc2USQwoMcGF5bWVudF9pbmZvGAEgASgLMhoucHlsb25zLnB5bG9ucy5QYXltZW50SW5mb0IEyN4fAFILcGF5bWVudEluZm8=');
@$core.Deprecated('Use queryAllPaymentInfoRequestDescriptor instead')
const QueryAllPaymentInfoRequest$json = {
  '1': 'QueryAllPaymentInfoRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryAllPaymentInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAllPaymentInfoRequestDescriptor =
    $convert.base64Decode(
        'ChpRdWVyeUFsbFBheW1lbnRJbmZvUmVxdWVzdBJGCgpwYWdpbmF0aW9uGAEgASgLMiYuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVxdWVzdFIKcGFnaW5hdGlvbg==');
@$core.Deprecated('Use queryAllPaymentInfoResponseDescriptor instead')
const QueryAllPaymentInfoResponse$json = {
  '1': 'QueryAllPaymentInfoResponse',
  '2': [
    {
      '1': 'payment_info',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.PaymentInfo',
      '8': {},
      '10': 'paymentInfo'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryAllPaymentInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryAllPaymentInfoResponseDescriptor =
    $convert.base64Decode(
        'ChtRdWVyeUFsbFBheW1lbnRJbmZvUmVzcG9uc2USQwoMcGF5bWVudF9pbmZvGAEgAygLMhoucHlsb25zLnB5bG9ucy5QYXltZW50SW5mb0IEyN4fAFILcGF5bWVudEluZm8SRwoKcGFnaW5hdGlvbhgCIAEoCzInLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlc3BvbnNlUgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryGetUsernameByAddressRequestDescriptor instead')
const QueryGetUsernameByAddressRequest$json = {
  '1': 'QueryGetUsernameByAddressRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `QueryGetUsernameByAddressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetUsernameByAddressRequestDescriptor =
    $convert.base64Decode(
        'CiBRdWVyeUdldFVzZXJuYW1lQnlBZGRyZXNzUmVxdWVzdBIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNz');
@$core.Deprecated('Use queryGetAddressByUsernameRequestDescriptor instead')
const QueryGetAddressByUsernameRequest$json = {
  '1': 'QueryGetAddressByUsernameRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `QueryGetAddressByUsernameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetAddressByUsernameRequestDescriptor =
    $convert.base64Decode(
        'CiBRdWVyeUdldEFkZHJlc3NCeVVzZXJuYW1lUmVxdWVzdBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use queryGetUsernameByAddressResponseDescriptor instead')
const QueryGetUsernameByAddressResponse$json = {
  '1': 'QueryGetUsernameByAddressResponse',
  '2': [
    {
      '1': 'username',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Username',
      '8': {},
      '10': 'username'
    },
  ],
};

/// Descriptor for `QueryGetUsernameByAddressResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetUsernameByAddressResponseDescriptor =
    $convert.base64Decode(
        'CiFRdWVyeUdldFVzZXJuYW1lQnlBZGRyZXNzUmVzcG9uc2USOQoIdXNlcm5hbWUYASABKAsyFy5weWxvbnMucHlsb25zLlVzZXJuYW1lQgTI3h8AUgh1c2VybmFtZQ==');
@$core.Deprecated('Use queryGetAddressByUsernameResponseDescriptor instead')
const QueryGetAddressByUsernameResponse$json = {
  '1': 'QueryGetAddressByUsernameResponse',
  '2': [
    {
      '1': 'address',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.AccountAddr',
      '8': {},
      '10': 'address'
    },
  ],
};

/// Descriptor for `QueryGetAddressByUsernameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetAddressByUsernameResponseDescriptor =
    $convert.base64Decode(
        'CiFRdWVyeUdldEFkZHJlc3NCeVVzZXJuYW1lUmVzcG9uc2USOgoHYWRkcmVzcxgBIAEoCzIaLnB5bG9ucy5weWxvbnMuQWNjb3VudEFkZHJCBMjeHwBSB2FkZHJlc3M=');
@$core.Deprecated('Use queryGetTradeRequestDescriptor instead')
const QueryGetTradeRequest$json = {
  '1': 'QueryGetTradeRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `QueryGetTradeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetTradeRequestDescriptor = $convert
    .base64Decode('ChRRdWVyeUdldFRyYWRlUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQ=');
@$core.Deprecated('Use queryGetTradeResponseDescriptor instead')
const QueryGetTradeResponse$json = {
  '1': 'QueryGetTradeResponse',
  '2': [
    {
      '1': 'trade',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Trade',
      '8': {},
      '10': 'trade'
    },
  ],
};

/// Descriptor for `QueryGetTradeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetTradeResponseDescriptor = $convert.base64Decode(
    'ChVRdWVyeUdldFRyYWRlUmVzcG9uc2USMAoFdHJhZGUYASABKAsyFC5weWxvbnMucHlsb25zLlRyYWRlQgTI3h8AUgV0cmFkZQ==');
@$core.Deprecated('Use queryListItemByOwnerRequestDescriptor instead')
const QueryListItemByOwnerRequest$json = {
  '1': 'QueryListItemByOwnerRequest',
  '2': [
    {'1': 'owner', '3': 1, '4': 1, '5': 9, '10': 'owner'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListItemByOwnerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListItemByOwnerRequestDescriptor =
    $convert.base64Decode(
        'ChtRdWVyeUxpc3RJdGVtQnlPd25lclJlcXVlc3QSFAoFb3duZXIYASABKAlSBW93bmVyEkYKCnBhZ2luYXRpb24YAyABKAsyJi5jb3Ntb3MuYmFzZS5xdWVyeS52MWJldGExLlBhZ2VSZXF1ZXN0UgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryListItemByOwnerResponseDescriptor instead')
const QueryListItemByOwnerResponse$json = {
  '1': 'QueryListItemByOwnerResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Item',
      '8': {},
      '10': 'items'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
  '7': {},
};

/// Descriptor for `QueryListItemByOwnerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListItemByOwnerResponseDescriptor =
    $convert.base64Decode(
        'ChxRdWVyeUxpc3RJdGVtQnlPd25lclJlc3BvbnNlEi8KBWl0ZW1zGAEgAygLMhMucHlsb25zLnB5bG9ucy5JdGVtQgTI3h8AUgVpdGVtcxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb246CIigHwDooB8A');
@$core
    .Deprecated('Use queryGetGoogleInAppPurchaseOrderRequestDescriptor instead')
const QueryGetGoogleInAppPurchaseOrderRequest$json = {
  '1': 'QueryGetGoogleInAppPurchaseOrderRequest',
  '2': [
    {'1': 'purchase_token', '3': 1, '4': 1, '5': 9, '10': 'purchaseToken'},
  ],
};

/// Descriptor for `QueryGetGoogleInAppPurchaseOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetGoogleInAppPurchaseOrderRequestDescriptor =
    $convert.base64Decode(
        'CidRdWVyeUdldEdvb2dsZUluQXBwUHVyY2hhc2VPcmRlclJlcXVlc3QSJQoOcHVyY2hhc2VfdG9rZW4YASABKAlSDXB1cmNoYXNlVG9rZW4=');
@$core.Deprecated(
    'Use queryGetGoogleInAppPurchaseOrderResponseDescriptor instead')
const QueryGetGoogleInAppPurchaseOrderResponse$json = {
  '1': 'QueryGetGoogleInAppPurchaseOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.GoogleInAppPurchaseOrder',
      '8': {},
      '10': 'order'
    },
  ],
};

/// Descriptor for `QueryGetGoogleInAppPurchaseOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetGoogleInAppPurchaseOrderResponseDescriptor =
    $convert.base64Decode(
        'CihRdWVyeUdldEdvb2dsZUluQXBwUHVyY2hhc2VPcmRlclJlc3BvbnNlEkMKBW9yZGVyGAEgASgLMicucHlsb25zLnB5bG9ucy5Hb29nbGVJbkFwcFB1cmNoYXNlT3JkZXJCBMjeHwBSBW9yZGVy');
@$core.Deprecated('Use queryListExecutionsByItemRequestDescriptor instead')
const QueryListExecutionsByItemRequest$json = {
  '1': 'QueryListExecutionsByItemRequest',
  '2': [
    {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
  '7': {},
};

/// Descriptor for `QueryListExecutionsByItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByItemRequestDescriptor =
    $convert.base64Decode(
        'CiBRdWVyeUxpc3RFeGVjdXRpb25zQnlJdGVtUmVxdWVzdBIfCgtjb29rYm9va19pZBgBIAEoCVIKY29va2Jvb2tJZBIXCgdpdGVtX2lkGAIgASgJUgZpdGVtSWQSRgoKcGFnaW5hdGlvbhgDIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb246CIigHwDooB8A');
@$core.Deprecated('Use queryListExecutionsByItemResponseDescriptor instead')
const QueryListExecutionsByItemResponse$json = {
  '1': 'QueryListExecutionsByItemResponse',
  '2': [
    {
      '1': 'completed_executions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Execution',
      '8': {},
      '10': 'completedExecutions'
    },
    {
      '1': 'pending_executions',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Execution',
      '8': {},
      '10': 'pendingExecutions'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListExecutionsByItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByItemResponseDescriptor =
    $convert.base64Decode(
        'CiFRdWVyeUxpc3RFeGVjdXRpb25zQnlJdGVtUmVzcG9uc2USUQoUY29tcGxldGVkX2V4ZWN1dGlvbnMYASADKAsyGC5weWxvbnMucHlsb25zLkV4ZWN1dGlvbkIEyN4fAFITY29tcGxldGVkRXhlY3V0aW9ucxJNChJwZW5kaW5nX2V4ZWN1dGlvbnMYAiADKAsyGC5weWxvbnMucHlsb25zLkV4ZWN1dGlvbkIEyN4fAFIRcGVuZGluZ0V4ZWN1dGlvbnMSRwoKcGFnaW5hdGlvbhgDIAEoCzInLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlc3BvbnNlUgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryListExecutionsByRecipeRequestDescriptor instead')
const QueryListExecutionsByRecipeRequest$json = {
  '1': 'QueryListExecutionsByRecipeRequest',
  '2': [
    {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'recipe_id', '3': 2, '4': 1, '5': 9, '10': 'recipeId'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
  '7': {},
};

/// Descriptor for `QueryListExecutionsByRecipeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByRecipeRequestDescriptor =
    $convert.base64Decode(
        'CiJRdWVyeUxpc3RFeGVjdXRpb25zQnlSZWNpcGVSZXF1ZXN0Eh8KC2Nvb2tib29rX2lkGAEgASgJUgpjb29rYm9va0lkEhsKCXJlY2lwZV9pZBgCIAEoCVIIcmVjaXBlSWQSRgoKcGFnaW5hdGlvbhgDIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb246CIigHwDooB8A');
@$core.Deprecated('Use queryListExecutionsByRecipeResponseDescriptor instead')
const QueryListExecutionsByRecipeResponse$json = {
  '1': 'QueryListExecutionsByRecipeResponse',
  '2': [
    {
      '1': 'completed_executions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Execution',
      '8': {},
      '10': 'completedExecutions'
    },
    {
      '1': 'pending_executions',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Execution',
      '8': {},
      '10': 'pendingExecutions'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListExecutionsByRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListExecutionsByRecipeResponseDescriptor =
    $convert.base64Decode(
        'CiNRdWVyeUxpc3RFeGVjdXRpb25zQnlSZWNpcGVSZXNwb25zZRJRChRjb21wbGV0ZWRfZXhlY3V0aW9ucxgBIAMoCzIYLnB5bG9ucy5weWxvbnMuRXhlY3V0aW9uQgTI3h8AUhNjb21wbGV0ZWRFeGVjdXRpb25zEk0KEnBlbmRpbmdfZXhlY3V0aW9ucxgCIAMoCzIYLnB5bG9ucy5weWxvbnMuRXhlY3V0aW9uQgTI3h8AUhFwZW5kaW5nRXhlY3V0aW9ucxJHCgpwYWdpbmF0aW9uGAMgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryGetExecutionRequestDescriptor instead')
const QueryGetExecutionRequest$json = {
  '1': 'QueryGetExecutionRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `QueryGetExecutionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetExecutionRequestDescriptor = $convert
    .base64Decode('ChhRdWVyeUdldEV4ZWN1dGlvblJlcXVlc3QSDgoCaWQYASABKAlSAmlk');
@$core.Deprecated('Use queryGetExecutionResponseDescriptor instead')
const QueryGetExecutionResponse$json = {
  '1': 'QueryGetExecutionResponse',
  '2': [
    {
      '1': 'execution',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Execution',
      '8': {},
      '10': 'execution'
    },
    {'1': 'completed', '3': 2, '4': 1, '5': 8, '10': 'completed'},
  ],
};

/// Descriptor for `QueryGetExecutionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetExecutionResponseDescriptor =
    $convert.base64Decode(
        'ChlRdWVyeUdldEV4ZWN1dGlvblJlc3BvbnNlEjwKCWV4ZWN1dGlvbhgBIAEoCzIYLnB5bG9ucy5weWxvbnMuRXhlY3V0aW9uQgTI3h8AUglleGVjdXRpb24SHAoJY29tcGxldGVkGAIgASgIUgljb21wbGV0ZWQ=');
@$core.Deprecated('Use queryListRecipesByCookbookRequestDescriptor instead')
const QueryListRecipesByCookbookRequest$json = {
  '1': 'QueryListRecipesByCookbookRequest',
  '2': [
    {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListRecipesByCookbookRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListRecipesByCookbookRequestDescriptor =
    $convert.base64Decode(
        'CiFRdWVyeUxpc3RSZWNpcGVzQnlDb29rYm9va1JlcXVlc3QSHwoLY29va2Jvb2tfaWQYASABKAlSCmNvb2tib29rSWQSRgoKcGFnaW5hdGlvbhgCIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryListRecipesByCookbookResponseDescriptor instead')
const QueryListRecipesByCookbookResponse$json = {
  '1': 'QueryListRecipesByCookbookResponse',
  '2': [
    {
      '1': 'recipes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Recipe',
      '8': {},
      '10': 'recipes'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListRecipesByCookbookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListRecipesByCookbookResponseDescriptor =
    $convert.base64Decode(
        'CiJRdWVyeUxpc3RSZWNpcGVzQnlDb29rYm9va1Jlc3BvbnNlEjUKB3JlY2lwZXMYASADKAsyFS5weWxvbnMucHlsb25zLlJlY2lwZUIEyN4fAFIHcmVjaXBlcxJHCgpwYWdpbmF0aW9uGAIgASgLMicuY29zbW9zLmJhc2UucXVlcnkudjFiZXRhMS5QYWdlUmVzcG9uc2VSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryGetItemRequestDescriptor instead')
const QueryGetItemRequest$json = {
  '1': 'QueryGetItemRequest',
  '2': [
    {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `QueryGetItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetItemRequestDescriptor = $convert.base64Decode(
    'ChNRdWVyeUdldEl0ZW1SZXF1ZXN0Eh8KC2Nvb2tib29rX2lkGAEgASgJUgpjb29rYm9va0lkEg4KAmlkGAMgASgJUgJpZA==');
@$core.Deprecated('Use queryGetItemResponseDescriptor instead')
const QueryGetItemResponse$json = {
  '1': 'QueryGetItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Item',
      '8': {},
      '10': 'item'
    },
  ],
};

/// Descriptor for `QueryGetItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetItemResponseDescriptor = $convert.base64Decode(
    'ChRRdWVyeUdldEl0ZW1SZXNwb25zZRItCgRpdGVtGAEgASgLMhMucHlsb25zLnB5bG9ucy5JdGVtQgTI3h8AUgRpdGVt');
@$core.Deprecated('Use queryGetRecipeRequestDescriptor instead')
const QueryGetRecipeRequest$json = {
  '1': 'QueryGetRecipeRequest',
  '2': [
    {'1': 'cookbook_id', '3': 1, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `QueryGetRecipeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRecipeRequestDescriptor = $convert.base64Decode(
    'ChVRdWVyeUdldFJlY2lwZVJlcXVlc3QSHwoLY29va2Jvb2tfaWQYASABKAlSCmNvb2tib29rSWQSDgoCaWQYAiABKAlSAmlk');
@$core.Deprecated('Use queryGetRecipeResponseDescriptor instead')
const QueryGetRecipeResponse$json = {
  '1': 'QueryGetRecipeResponse',
  '2': [
    {
      '1': 'recipe',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Recipe',
      '8': {},
      '10': 'recipe'
    },
  ],
};

/// Descriptor for `QueryGetRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetRecipeResponseDescriptor =
    $convert.base64Decode(
        'ChZRdWVyeUdldFJlY2lwZVJlc3BvbnNlEjMKBnJlY2lwZRgBIAEoCzIVLnB5bG9ucy5weWxvbnMuUmVjaXBlQgTI3h8AUgZyZWNpcGU=');
@$core.Deprecated('Use queryListCookbooksByCreatorRequestDescriptor instead')
const QueryListCookbooksByCreatorRequest$json = {
  '1': 'QueryListCookbooksByCreatorRequest',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListCookbooksByCreatorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListCookbooksByCreatorRequestDescriptor =
    $convert.base64Decode(
        'CiJRdWVyeUxpc3RDb29rYm9va3NCeUNyZWF0b3JSZXF1ZXN0EhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISRgoKcGFnaW5hdGlvbhgDIAEoCzImLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use queryListCookbooksByCreatorResponseDescriptor instead')
const QueryListCookbooksByCreatorResponse$json = {
  '1': 'QueryListCookbooksByCreatorResponse',
  '2': [
    {
      '1': 'cookbooks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Cookbook',
      '8': {},
      '10': 'cookbooks'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cosmos.base.query.v1beta1.PageResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `QueryListCookbooksByCreatorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryListCookbooksByCreatorResponseDescriptor =
    $convert.base64Decode(
        'CiNRdWVyeUxpc3RDb29rYm9va3NCeUNyZWF0b3JSZXNwb25zZRI7Cgljb29rYm9va3MYASADKAsyFy5weWxvbnMucHlsb25zLkNvb2tib29rQgTI3h8AUgljb29rYm9va3MSRwoKcGFnaW5hdGlvbhgDIAEoCzInLmNvc21vcy5iYXNlLnF1ZXJ5LnYxYmV0YTEuUGFnZVJlc3BvbnNlUgpwYWdpbmF0aW9u');
@$core.Deprecated('Use queryGetCookbookRequestDescriptor instead')
const QueryGetCookbookRequest$json = {
  '1': 'QueryGetCookbookRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `QueryGetCookbookRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetCookbookRequestDescriptor = $convert
    .base64Decode('ChdRdWVyeUdldENvb2tib29rUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');
@$core.Deprecated('Use queryGetCookbookResponseDescriptor instead')
const QueryGetCookbookResponse$json = {
  '1': 'QueryGetCookbookResponse',
  '2': [
    {
      '1': 'cookbook',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Cookbook',
      '8': {},
      '10': 'cookbook'
    },
  ],
};

/// Descriptor for `QueryGetCookbookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryGetCookbookResponseDescriptor =
    $convert.base64Decode(
        'ChhRdWVyeUdldENvb2tib29rUmVzcG9uc2USOQoIY29va2Jvb2sYASABKAsyFy5weWxvbnMucHlsb25zLkNvb2tib29rQgTI3h8AUghjb29rYm9vaw==');
