///
//  Generated code. Do not modify.
//  source: pylons/pylons/tx.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use msgAppleIapDescriptor instead')
const MsgAppleIap$json = const {
  '1': 'MsgAppleIap',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    const {'1': 'purchase_id', '3': 3, '4': 1, '5': 9, '10': 'purchaseId'},
    const {'1': 'receipt_data_base64', '3': 4, '4': 1, '5': 9, '10': 'receiptDataBase64'},
  ],
};

/// Descriptor for `MsgAppleIap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAppleIapDescriptor = $convert.base64Decode('CgtNc2dBcHBsZUlhcBIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEh0KCnByb2R1Y3RfaWQYAiABKAlSCXByb2R1Y3RJZBIfCgtwdXJjaGFzZV9pZBgDIAEoCVIKcHVyY2hhc2VJZBIuChNyZWNlaXB0X2RhdGFfYmFzZTY0GAQgASgJUhFyZWNlaXB0RGF0YUJhc2U2NA==');
@$core.Deprecated('Use msgAppleIapResponseDescriptor instead')
const MsgAppleIapResponse$json = const {
  '1': 'MsgAppleIapResponse',
};

/// Descriptor for `MsgAppleIapResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAppleIapResponseDescriptor = $convert.base64Decode('ChNNc2dBcHBsZUlhcFJlc3BvbnNl');
@$core.Deprecated('Use msgAddStripeRefundDescriptor instead')
const MsgAddStripeRefund$json = const {
  '1': 'MsgAddStripeRefund',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'payment', '3': 2, '4': 1, '5': 11, '6': '.pylons.pylons.PaymentInfo', '10': 'payment'},
  ],
};

/// Descriptor for `MsgAddStripeRefund`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAddStripeRefundDescriptor = $convert.base64Decode('ChJNc2dBZGRTdHJpcGVSZWZ1bmQSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchI0CgdwYXltZW50GAIgASgLMhoucHlsb25zLnB5bG9ucy5QYXltZW50SW5mb1IHcGF5bWVudA==');
@$core.Deprecated('Use msgAddStripeRefundResponseDescriptor instead')
const MsgAddStripeRefundResponse$json = const {
  '1': 'MsgAddStripeRefundResponse',
};

/// Descriptor for `MsgAddStripeRefundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAddStripeRefundResponseDescriptor = $convert.base64Decode('ChpNc2dBZGRTdHJpcGVSZWZ1bmRSZXNwb25zZQ==');
@$core.Deprecated('Use msgBurnDebtTokenDescriptor instead')
const MsgBurnDebtToken$json = const {
  '1': 'MsgBurnDebtToken',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'redeem_info', '3': 2, '4': 1, '5': 11, '6': '.pylons.pylons.RedeemInfo', '8': const {}, '10': 'redeemInfo'},
  ],
};

/// Descriptor for `MsgBurnDebtToken`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgBurnDebtTokenDescriptor = $convert.base64Decode('ChBNc2dCdXJuRGVidFRva2VuEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISQAoLcmVkZWVtX2luZm8YAiABKAsyGS5weWxvbnMucHlsb25zLlJlZGVlbUluZm9CBMjeHwBSCnJlZGVlbUluZm8=');
@$core.Deprecated('Use msgBurnDebtTokenResponseDescriptor instead')
const MsgBurnDebtTokenResponse$json = const {
  '1': 'MsgBurnDebtTokenResponse',
};

/// Descriptor for `MsgBurnDebtTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgBurnDebtTokenResponseDescriptor = $convert.base64Decode('ChhNc2dCdXJuRGVidFRva2VuUmVzcG9uc2U=');
@$core.Deprecated('Use msgUpdateAccountDescriptor instead')
const MsgUpdateAccount$json = const {
  '1': 'MsgUpdateAccount',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `MsgUpdateAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateAccountDescriptor = $convert.base64Decode('ChBNc2dVcGRhdGVBY2NvdW50EhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISGgoIdXNlcm5hbWUYAiABKAlSCHVzZXJuYW1l');
@$core.Deprecated('Use msgUpdateAccountResponseDescriptor instead')
const MsgUpdateAccountResponse$json = const {
  '1': 'MsgUpdateAccountResponse',
};

/// Descriptor for `MsgUpdateAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateAccountResponseDescriptor = $convert.base64Decode('ChhNc2dVcGRhdGVBY2NvdW50UmVzcG9uc2U=');
@$core.Deprecated('Use msgCreateAccountDescriptor instead')
const MsgCreateAccount$json = const {
  '1': 'MsgCreateAccount',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'referral_address', '3': 4, '4': 1, '5': 9, '10': 'referralAddress'},
  ],
};

/// Descriptor for `MsgCreateAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateAccountDescriptor = $convert.base64Decode('ChBNc2dDcmVhdGVBY2NvdW50EhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISGgoIdXNlcm5hbWUYAiABKAlSCHVzZXJuYW1lEhQKBXRva2VuGAMgASgJUgV0b2tlbhIpChByZWZlcnJhbF9hZGRyZXNzGAQgASgJUg9yZWZlcnJhbEFkZHJlc3M=');
@$core.Deprecated('Use msgCreateAccountResponseDescriptor instead')
const MsgCreateAccountResponse$json = const {
  '1': 'MsgCreateAccountResponse',
};

/// Descriptor for `MsgCreateAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateAccountResponseDescriptor = $convert.base64Decode('ChhNc2dDcmVhdGVBY2NvdW50UmVzcG9uc2U=');
@$core.Deprecated('Use msgFulfillTradeDescriptor instead')
const MsgFulfillTrade$json = const {
  '1': 'MsgFulfillTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 4, '10': 'id'},
    const {'1': 'coin_inputs_index', '3': 3, '4': 1, '5': 4, '10': 'coinInputsIndex'},
    const {'1': 'items', '3': 4, '4': 3, '5': 11, '6': '.pylons.pylons.ItemRef', '8': const {}, '10': 'items'},
    const {'1': 'payment_infos', '3': 5, '4': 3, '5': 11, '6': '.pylons.pylons.PaymentInfo', '8': const {}, '10': 'paymentInfos'},
  ],
};

/// Descriptor for `MsgFulfillTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgFulfillTradeDescriptor = $convert.base64Decode('Cg9Nc2dGdWxmaWxsVHJhZGUSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIOCgJpZBgCIAEoBFICaWQSKgoRY29pbl9pbnB1dHNfaW5kZXgYAyABKARSD2NvaW5JbnB1dHNJbmRleBIyCgVpdGVtcxgEIAMoCzIWLnB5bG9ucy5weWxvbnMuSXRlbVJlZkIEyN4fAFIFaXRlbXMSRQoNcGF5bWVudF9pbmZvcxgFIAMoCzIaLnB5bG9ucy5weWxvbnMuUGF5bWVudEluZm9CBMjeHwBSDHBheW1lbnRJbmZvcw==');
@$core.Deprecated('Use msgFulfillTradeResponseDescriptor instead')
const MsgFulfillTradeResponse$json = const {
  '1': 'MsgFulfillTradeResponse',
};

/// Descriptor for `MsgFulfillTradeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgFulfillTradeResponseDescriptor = $convert.base64Decode('ChdNc2dGdWxmaWxsVHJhZGVSZXNwb25zZQ==');
@$core.Deprecated('Use msgCreateTradeDescriptor instead')
const MsgCreateTrade$json = const {
  '1': 'MsgCreateTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'coin_inputs', '3': 2, '4': 3, '5': 11, '6': '.pylons.pylons.CoinInput', '8': const {}, '10': 'coinInputs'},
    const {'1': 'item_inputs', '3': 3, '4': 3, '5': 11, '6': '.pylons.pylons.ItemInput', '8': const {}, '10': 'itemInputs'},
    const {'1': 'coin_outputs', '3': 4, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'item_outputs', '3': 5, '4': 3, '5': 11, '6': '.pylons.pylons.ItemRef', '8': const {}, '10': 'itemOutputs'},
    const {'1': 'extra_info', '3': 6, '4': 1, '5': 9, '10': 'extraInfo'},
  ],
};

/// Descriptor for `MsgCreateTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateTradeDescriptor = $convert.base64Decode('Cg5Nc2dDcmVhdGVUcmFkZRIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEj8KC2NvaW5faW5wdXRzGAIgAygLMhgucHlsb25zLnB5bG9ucy5Db2luSW5wdXRCBMjeHwBSCmNvaW5JbnB1dHMSPwoLaXRlbV9pbnB1dHMYAyADKAsyGC5weWxvbnMucHlsb25zLkl0ZW1JbnB1dEIEyN4fAFIKaXRlbUlucHV0cxJuCgxjb2luX291dHB1dHMYBCADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1ILY29pbk91dHB1dHMSPwoMaXRlbV9vdXRwdXRzGAUgAygLMhYucHlsb25zLnB5bG9ucy5JdGVtUmVmQgTI3h8AUgtpdGVtT3V0cHV0cxIdCgpleHRyYV9pbmZvGAYgASgJUglleHRyYUluZm8=');
@$core.Deprecated('Use msgCreateTradeResponseDescriptor instead')
const MsgCreateTradeResponse$json = const {
  '1': 'MsgCreateTradeResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `MsgCreateTradeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateTradeResponseDescriptor = $convert.base64Decode('ChZNc2dDcmVhdGVUcmFkZVJlc3BvbnNlEg4KAmlkGAEgASgEUgJpZA==');
@$core.Deprecated('Use msgCancelTradeDescriptor instead')
const MsgCancelTrade$json = const {
  '1': 'MsgCancelTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `MsgCancelTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCancelTradeDescriptor = $convert.base64Decode('Cg5Nc2dDYW5jZWxUcmFkZRIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAmlkGAIgASgEUgJpZA==');
@$core.Deprecated('Use msgCancelTradeResponseDescriptor instead')
const MsgCancelTradeResponse$json = const {
  '1': 'MsgCancelTradeResponse',
};

/// Descriptor for `MsgCancelTradeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCancelTradeResponseDescriptor = $convert.base64Decode('ChZNc2dDYW5jZWxUcmFkZVJlc3BvbnNl');
@$core.Deprecated('Use msgCompleteExecutionEarlyDescriptor instead')
const MsgCompleteExecutionEarly$json = const {
  '1': 'MsgCompleteExecutionEarly',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `MsgCompleteExecutionEarly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCompleteExecutionEarlyDescriptor = $convert.base64Decode('ChlNc2dDb21wbGV0ZUV4ZWN1dGlvbkVhcmx5EhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCaWQYAiABKAlSAmlk');
@$core.Deprecated('Use msgCompleteExecutionEarlyResponseDescriptor instead')
const MsgCompleteExecutionEarlyResponse$json = const {
  '1': 'MsgCompleteExecutionEarlyResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `MsgCompleteExecutionEarlyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCompleteExecutionEarlyResponseDescriptor = $convert.base64Decode('CiFNc2dDb21wbGV0ZUV4ZWN1dGlvbkVhcmx5UmVzcG9uc2USDgoCaWQYASABKAlSAmlk');
@$core.Deprecated('Use msgTransferCookbookDescriptor instead')
const MsgTransferCookbook$json = const {
  '1': 'MsgTransferCookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'recipient', '3': 3, '4': 1, '5': 9, '10': 'recipient'},
  ],
};

/// Descriptor for `MsgTransferCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgTransferCookbookDescriptor = $convert.base64Decode('ChNNc2dUcmFuc2ZlckNvb2tib29rEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCaWQYAiABKAlSAmlkEhwKCXJlY2lwaWVudBgDIAEoCVIJcmVjaXBpZW50');
@$core.Deprecated('Use msgTransferCookbookResponseDescriptor instead')
const MsgTransferCookbookResponse$json = const {
  '1': 'MsgTransferCookbookResponse',
};

/// Descriptor for `MsgTransferCookbookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgTransferCookbookResponseDescriptor = $convert.base64Decode('ChtNc2dUcmFuc2ZlckNvb2tib29rUmVzcG9uc2U=');
@$core.Deprecated('Use msgGoogleInAppPurchaseGetCoinsDescriptor instead')
const MsgGoogleInAppPurchaseGetCoins$json = const {
  '1': 'MsgGoogleInAppPurchaseGetCoins',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    const {'1': 'purchase_token', '3': 3, '4': 1, '5': 9, '10': 'purchaseToken'},
    const {'1': 'receipt_data_base64', '3': 4, '4': 1, '5': 9, '10': 'receiptDataBase64'},
    const {'1': 'signature', '3': 5, '4': 1, '5': 9, '10': 'signature'},
  ],
};

/// Descriptor for `MsgGoogleInAppPurchaseGetCoins`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgGoogleInAppPurchaseGetCoinsDescriptor = $convert.base64Decode('Ch5Nc2dHb29nbGVJbkFwcFB1cmNoYXNlR2V0Q29pbnMSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIdCgpwcm9kdWN0X2lkGAIgASgJUglwcm9kdWN0SWQSJQoOcHVyY2hhc2VfdG9rZW4YAyABKAlSDXB1cmNoYXNlVG9rZW4SLgoTcmVjZWlwdF9kYXRhX2Jhc2U2NBgEIAEoCVIRcmVjZWlwdERhdGFCYXNlNjQSHAoJc2lnbmF0dXJlGAUgASgJUglzaWduYXR1cmU=');
@$core.Deprecated('Use msgGoogleInAppPurchaseGetCoinsResponseDescriptor instead')
const MsgGoogleInAppPurchaseGetCoinsResponse$json = const {
  '1': 'MsgGoogleInAppPurchaseGetCoinsResponse',
};

/// Descriptor for `MsgGoogleInAppPurchaseGetCoinsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgGoogleInAppPurchaseGetCoinsResponseDescriptor = $convert.base64Decode('CiZNc2dHb29nbGVJbkFwcFB1cmNoYXNlR2V0Q29pbnNSZXNwb25zZQ==');
@$core.Deprecated('Use msgSendItemsDescriptor instead')
const MsgSendItems$json = const {
  '1': 'MsgSendItems',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'receiver', '3': 2, '4': 1, '5': 9, '10': 'receiver'},
    const {'1': 'items', '3': 3, '4': 3, '5': 11, '6': '.pylons.pylons.ItemRef', '8': const {}, '10': 'items'},
  ],
};

/// Descriptor for `MsgSendItems`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgSendItemsDescriptor = $convert.base64Decode('CgxNc2dTZW5kSXRlbXMSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIaCghyZWNlaXZlchgCIAEoCVIIcmVjZWl2ZXISMgoFaXRlbXMYAyADKAsyFi5weWxvbnMucHlsb25zLkl0ZW1SZWZCBMjeHwBSBWl0ZW1z');
@$core.Deprecated('Use msgSendItemsResponseDescriptor instead')
const MsgSendItemsResponse$json = const {
  '1': 'MsgSendItemsResponse',
};

/// Descriptor for `MsgSendItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgSendItemsResponseDescriptor = $convert.base64Decode('ChRNc2dTZW5kSXRlbXNSZXNwb25zZQ==');
@$core.Deprecated('Use msgExecuteRecipeDescriptor instead')
const MsgExecuteRecipe$json = const {
  '1': 'MsgExecuteRecipe',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'recipe_id', '3': 3, '4': 1, '5': 9, '10': 'recipeId'},
    const {'1': 'coin_inputs_index', '3': 4, '4': 1, '5': 4, '10': 'coinInputsIndex'},
    const {'1': 'item_ids', '3': 5, '4': 3, '5': 9, '8': const {}, '10': 'itemIds'},
    const {'1': 'payment_infos', '3': 6, '4': 3, '5': 11, '6': '.pylons.pylons.PaymentInfo', '8': const {}, '10': 'paymentInfos'},
  ],
};

/// Descriptor for `MsgExecuteRecipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgExecuteRecipeDescriptor = $convert.base64Decode('ChBNc2dFeGVjdXRlUmVjaXBlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISHwoLY29va2Jvb2tfaWQYAiABKAlSCmNvb2tib29rSWQSGwoJcmVjaXBlX2lkGAMgASgJUghyZWNpcGVJZBIqChFjb2luX2lucHV0c19pbmRleBgEIAEoBFIPY29pbklucHV0c0luZGV4Eh8KCGl0ZW1faWRzGAUgAygJQgTI3h8AUgdpdGVtSWRzEkUKDXBheW1lbnRfaW5mb3MYBiADKAsyGi5weWxvbnMucHlsb25zLlBheW1lbnRJbmZvQgTI3h8AUgxwYXltZW50SW5mb3M=');
@$core.Deprecated('Use msgExecuteRecipeResponseDescriptor instead')
const MsgExecuteRecipeResponse$json = const {
  '1': 'MsgExecuteRecipeResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `MsgExecuteRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgExecuteRecipeResponseDescriptor = $convert.base64Decode('ChhNc2dFeGVjdXRlUmVjaXBlUmVzcG9uc2USDgoCaWQYASABKAlSAmlk');
@$core.Deprecated('Use msgSetItemStringDescriptor instead')
const MsgSetItemString$json = const {
  '1': 'MsgSetItemString',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'id', '3': 4, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'field', '3': 5, '4': 1, '5': 9, '10': 'field'},
    const {'1': 'value', '3': 6, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `MsgSetItemString`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgSetItemStringDescriptor = $convert.base64Decode('ChBNc2dTZXRJdGVtU3RyaW5nEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISHwoLY29va2Jvb2tfaWQYAiABKAlSCmNvb2tib29rSWQSDgoCaWQYBCABKAlSAmlkEhQKBWZpZWxkGAUgASgJUgVmaWVsZBIUCgV2YWx1ZRgGIAEoCVIFdmFsdWU=');
@$core.Deprecated('Use msgSetItemStringResponseDescriptor instead')
const MsgSetItemStringResponse$json = const {
  '1': 'MsgSetItemStringResponse',
};

/// Descriptor for `MsgSetItemStringResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgSetItemStringResponseDescriptor = $convert.base64Decode('ChhNc2dTZXRJdGVtU3RyaW5nUmVzcG9uc2U=');
@$core.Deprecated('Use msgCreateRecipeDescriptor instead')
const MsgCreateRecipe$json = const {
  '1': 'MsgCreateRecipe',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'coin_inputs', '3': 7, '4': 3, '5': 11, '6': '.pylons.pylons.CoinInput', '8': const {}, '10': 'coinInputs'},
    const {'1': 'item_inputs', '3': 8, '4': 3, '5': 11, '6': '.pylons.pylons.ItemInput', '8': const {}, '10': 'itemInputs'},
    const {'1': 'entries', '3': 9, '4': 1, '5': 11, '6': '.pylons.pylons.EntriesList', '8': const {}, '10': 'entries'},
    const {'1': 'outputs', '3': 10, '4': 3, '5': 11, '6': '.pylons.pylons.WeightedOutputs', '8': const {}, '10': 'outputs'},
    const {'1': 'block_interval', '3': 11, '4': 1, '5': 3, '10': 'blockInterval'},
    const {'1': 'cost_per_block', '3': 12, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'costPerBlock'},
    const {'1': 'enabled', '3': 13, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'extra_info', '3': 14, '4': 1, '5': 9, '10': 'extraInfo'},
  ],
};

/// Descriptor for `MsgCreateRecipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateRecipeDescriptor = $convert.base64Decode('Cg9Nc2dDcmVhdGVSZWNpcGUSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIfCgtjb29rYm9va19pZBgCIAEoCVIKY29va2Jvb2tJZBIOCgJpZBgDIAEoCVICaWQSEgoEbmFtZRgEIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SGAoHdmVyc2lvbhgGIAEoCVIHdmVyc2lvbhI/Cgtjb2luX2lucHV0cxgHIAMoCzIYLnB5bG9ucy5weWxvbnMuQ29pbklucHV0QgTI3h8AUgpjb2luSW5wdXRzEj8KC2l0ZW1faW5wdXRzGAggAygLMhgucHlsb25zLnB5bG9ucy5JdGVtSW5wdXRCBMjeHwBSCml0ZW1JbnB1dHMSOgoHZW50cmllcxgJIAEoCzIaLnB5bG9ucy5weWxvbnMuRW50cmllc0xpc3RCBMjeHwBSB2VudHJpZXMSPgoHb3V0cHV0cxgKIAMoCzIeLnB5bG9ucy5weWxvbnMuV2VpZ2h0ZWRPdXRwdXRzQgTI3h8AUgdvdXRwdXRzEiUKDmJsb2NrX2ludGVydmFsGAsgASgDUg1ibG9ja0ludGVydmFsEkUKDmNvc3RfcGVyX2Jsb2NrGAwgASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQgTI3h8AUgxjb3N0UGVyQmxvY2sSGAoHZW5hYmxlZBgNIAEoCFIHZW5hYmxlZBIdCgpleHRyYV9pbmZvGA4gASgJUglleHRyYUluZm8=');
@$core.Deprecated('Use msgCreateRecipeResponseDescriptor instead')
const MsgCreateRecipeResponse$json = const {
  '1': 'MsgCreateRecipeResponse',
};

/// Descriptor for `MsgCreateRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateRecipeResponseDescriptor = $convert.base64Decode('ChdNc2dDcmVhdGVSZWNpcGVSZXNwb25zZQ==');
@$core.Deprecated('Use msgUpdateRecipeDescriptor instead')
const MsgUpdateRecipe$json = const {
  '1': 'MsgUpdateRecipe',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'coin_inputs', '3': 7, '4': 3, '5': 11, '6': '.pylons.pylons.CoinInput', '8': const {}, '10': 'coinInputs'},
    const {'1': 'item_inputs', '3': 8, '4': 3, '5': 11, '6': '.pylons.pylons.ItemInput', '8': const {}, '10': 'itemInputs'},
    const {'1': 'entries', '3': 9, '4': 1, '5': 11, '6': '.pylons.pylons.EntriesList', '8': const {}, '10': 'entries'},
    const {'1': 'outputs', '3': 10, '4': 3, '5': 11, '6': '.pylons.pylons.WeightedOutputs', '8': const {}, '10': 'outputs'},
    const {'1': 'block_interval', '3': 11, '4': 1, '5': 3, '10': 'blockInterval'},
    const {'1': 'cost_per_block', '3': 12, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'costPerBlock'},
    const {'1': 'enabled', '3': 13, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'extra_info', '3': 14, '4': 1, '5': 9, '10': 'extraInfo'},
  ],
};

/// Descriptor for `MsgUpdateRecipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateRecipeDescriptor = $convert.base64Decode('Cg9Nc2dVcGRhdGVSZWNpcGUSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIfCgtjb29rYm9va19pZBgCIAEoCVIKY29va2Jvb2tJZBIOCgJpZBgDIAEoCVICaWQSEgoEbmFtZRgEIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SGAoHdmVyc2lvbhgGIAEoCVIHdmVyc2lvbhI/Cgtjb2luX2lucHV0cxgHIAMoCzIYLnB5bG9ucy5weWxvbnMuQ29pbklucHV0QgTI3h8AUgpjb2luSW5wdXRzEj8KC2l0ZW1faW5wdXRzGAggAygLMhgucHlsb25zLnB5bG9ucy5JdGVtSW5wdXRCBMjeHwBSCml0ZW1JbnB1dHMSOgoHZW50cmllcxgJIAEoCzIaLnB5bG9ucy5weWxvbnMuRW50cmllc0xpc3RCBMjeHwBSB2VudHJpZXMSPgoHb3V0cHV0cxgKIAMoCzIeLnB5bG9ucy5weWxvbnMuV2VpZ2h0ZWRPdXRwdXRzQgTI3h8AUgdvdXRwdXRzEiUKDmJsb2NrX2ludGVydmFsGAsgASgDUg1ibG9ja0ludGVydmFsEkUKDmNvc3RfcGVyX2Jsb2NrGAwgASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQgTI3h8AUgxjb3N0UGVyQmxvY2sSGAoHZW5hYmxlZBgNIAEoCFIHZW5hYmxlZBIdCgpleHRyYV9pbmZvGA4gASgJUglleHRyYUluZm8=');
@$core.Deprecated('Use msgUpdateRecipeResponseDescriptor instead')
const MsgUpdateRecipeResponse$json = const {
  '1': 'MsgUpdateRecipeResponse',
};

/// Descriptor for `MsgUpdateRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateRecipeResponseDescriptor = $convert.base64Decode('ChdNc2dVcGRhdGVSZWNpcGVSZXNwb25zZQ==');
@$core.Deprecated('Use msgCreateCookbookDescriptor instead')
const MsgCreateCookbook$json = const {
  '1': 'MsgCreateCookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'developer', '3': 5, '4': 1, '5': 9, '10': 'developer'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'support_email', '3': 7, '4': 1, '5': 9, '10': 'supportEmail'},
    const {'1': 'enabled', '3': 8, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `MsgCreateCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateCookbookDescriptor = $convert.base64Decode('ChFNc2dDcmVhdGVDb29rYm9vaxIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAmlkGAIgASgJUgJpZBISCgRuYW1lGAMgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIcCglkZXZlbG9wZXIYBSABKAlSCWRldmVsb3BlchIYCgd2ZXJzaW9uGAYgASgJUgd2ZXJzaW9uEiMKDXN1cHBvcnRfZW1haWwYByABKAlSDHN1cHBvcnRFbWFpbBIYCgdlbmFibGVkGAggASgIUgdlbmFibGVk');
@$core.Deprecated('Use msgCreateCookbookResponseDescriptor instead')
const MsgCreateCookbookResponse$json = const {
  '1': 'MsgCreateCookbookResponse',
};

/// Descriptor for `MsgCreateCookbookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgCreateCookbookResponseDescriptor = $convert.base64Decode('ChlNc2dDcmVhdGVDb29rYm9va1Jlc3BvbnNl');
@$core.Deprecated('Use msgUpdateCookbookDescriptor instead')
const MsgUpdateCookbook$json = const {
  '1': 'MsgUpdateCookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'developer', '3': 5, '4': 1, '5': 9, '10': 'developer'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'support_email', '3': 7, '4': 1, '5': 9, '10': 'supportEmail'},
    const {'1': 'enabled', '3': 8, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `MsgUpdateCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateCookbookDescriptor = $convert.base64Decode('ChFNc2dVcGRhdGVDb29rYm9vaxIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAmlkGAIgASgJUgJpZBISCgRuYW1lGAMgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIcCglkZXZlbG9wZXIYBSABKAlSCWRldmVsb3BlchIYCgd2ZXJzaW9uGAYgASgJUgd2ZXJzaW9uEiMKDXN1cHBvcnRfZW1haWwYByABKAlSDHN1cHBvcnRFbWFpbBIYCgdlbmFibGVkGAggASgIUgdlbmFibGVk');
@$core.Deprecated('Use msgUpdateCookbookResponseDescriptor instead')
const MsgUpdateCookbookResponse$json = const {
  '1': 'MsgUpdateCookbookResponse',
};

/// Descriptor for `MsgUpdateCookbookResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgUpdateCookbookResponseDescriptor = $convert.base64Decode('ChlNc2dVcGRhdGVDb29rYm9va1Jlc3BvbnNl');
