///
//  Generated code. Do not modify.
//  source: pylons/pylons/event.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use eventBurnDebtTokenDescriptor instead')
const EventBurnDebtToken$json = {
  '1': 'EventBurnDebtToken',
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

/// Descriptor for `EventBurnDebtToken`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventBurnDebtTokenDescriptor = $convert.base64Decode(
    'ChJFdmVudEJ1cm5EZWJ0VG9rZW4SQAoLcmVkZWVtX2luZm8YASABKAsyGS5weWxvbnMucHlsb25zLlJlZGVlbUluZm9CBMjeHwBSCnJlZGVlbUluZm8=');
@$core.Deprecated('Use eventCreateAccountDescriptor instead')
const EventCreateAccount$json = {
  '1': 'EventCreateAccount',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `EventCreateAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateAccountDescriptor = $convert.base64Decode(
    'ChJFdmVudENyZWF0ZUFjY291bnQSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use eventUpdateAccountDescriptor instead')
const EventUpdateAccount$json = {
  '1': 'EventUpdateAccount',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `EventUpdateAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventUpdateAccountDescriptor = $convert.base64Decode(
    'ChJFdmVudFVwZGF0ZUFjY291bnQSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use eventCreateCookbookDescriptor instead')
const EventCreateCookbook$json = {
  '1': 'EventCreateCookbook',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `EventCreateCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateCookbookDescriptor = $convert.base64Decode(
    'ChNFdmVudENyZWF0ZUNvb2tib29rEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCaWQYAiABKAlSAmlk');
@$core.Deprecated('Use eventUpdateCookbookDescriptor instead')
const EventUpdateCookbook$json = {
  '1': 'EventUpdateCookbook',
  '2': [
    {
      '1': 'original_cookbook',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Cookbook',
      '8': {},
      '10': 'originalCookbook'
    },
  ],
};

/// Descriptor for `EventUpdateCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventUpdateCookbookDescriptor = $convert.base64Decode(
    'ChNFdmVudFVwZGF0ZUNvb2tib29rEkoKEW9yaWdpbmFsX2Nvb2tib29rGAEgASgLMhcucHlsb25zLnB5bG9ucy5Db29rYm9va0IEyN4fAFIQb3JpZ2luYWxDb29rYm9vaw==');
@$core.Deprecated('Use eventTransferCookbookDescriptor instead')
const EventTransferCookbook$json = {
  '1': 'EventTransferCookbook',
  '2': [
    {'1': 'sender', '3': 1, '4': 1, '5': 9, '10': 'sender'},
    {'1': 'receiver', '3': 2, '4': 1, '5': 9, '10': 'receiver'},
    {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `EventTransferCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventTransferCookbookDescriptor = $convert.base64Decode(
    'ChVFdmVudFRyYW5zZmVyQ29va2Jvb2sSFgoGc2VuZGVyGAEgASgJUgZzZW5kZXISGgoIcmVjZWl2ZXIYAiABKAlSCHJlY2VpdmVyEg4KAmlkGAMgASgJUgJpZA==');
@$core.Deprecated('Use eventCreateRecipeDescriptor instead')
const EventCreateRecipe$json = {
  '1': 'EventCreateRecipe',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `EventCreateRecipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateRecipeDescriptor = $convert.base64Decode(
    'ChFFdmVudENyZWF0ZVJlY2lwZRIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEh8KC2Nvb2tib29rX2lkGAIgASgJUgpjb29rYm9va0lkEg4KAmlkGAMgASgJUgJpZA==');
@$core.Deprecated('Use eventUpdateRecipeDescriptor instead')
const EventUpdateRecipe$json = {
  '1': 'EventUpdateRecipe',
  '2': [
    {
      '1': 'original_recipe',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.Recipe',
      '8': {},
      '10': 'originalRecipe'
    },
  ],
};

/// Descriptor for `EventUpdateRecipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventUpdateRecipeDescriptor = $convert.base64Decode(
    'ChFFdmVudFVwZGF0ZVJlY2lwZRJECg9vcmlnaW5hbF9yZWNpcGUYASABKAsyFS5weWxvbnMucHlsb25zLlJlY2lwZUIEyN4fAFIOb3JpZ2luYWxSZWNpcGU=');
@$core.Deprecated('Use eventCreateExecutionDescriptor instead')
const EventCreateExecution$json = {
  '1': 'EventCreateExecution',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'payment_infos',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.PaymentInfo',
      '8': {},
      '10': 'paymentInfos'
    },
  ],
};

/// Descriptor for `EventCreateExecution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateExecutionDescriptor = $convert.base64Decode(
    'ChRFdmVudENyZWF0ZUV4ZWN1dGlvbhIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAmlkGAIgASgJUgJpZBJFCg1wYXltZW50X2luZm9zGAMgAygLMhoucHlsb25zLnB5bG9ucy5QYXltZW50SW5mb0IEyN4fAFIMcGF5bWVudEluZm9z');
@$core.Deprecated('Use eventCompleteExecutionDescriptor instead')
const EventCompleteExecution$json = {
  '1': 'EventCompleteExecution',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'burn_coins',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'burnCoins'
    },
    {
      '1': 'pay_coins',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'payCoins'
    },
    {
      '1': 'transfer_coins',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'transferCoins'
    },
    {
      '1': 'fee_coins',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'feeCoins'
    },
    {
      '1': 'coin_outputs',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'coinOutputs'
    },
    {
      '1': 'mint_items',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Item',
      '8': {},
      '10': 'mintItems'
    },
    {
      '1': 'modify_items',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.Item',
      '8': {},
      '10': 'modifyItems'
    },
  ],
};

/// Descriptor for `EventCompleteExecution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCompleteExecutionDescriptor =
    $convert.base64Decode(
        'ChZFdmVudENvbXBsZXRlRXhlY3V0aW9uEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCaWQYAiABKAlSAmlkEmoKCmJ1cm5fY29pbnMYAyADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1IJYnVybkNvaW5zEmgKCXBheV9jb2lucxgEIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUghwYXlDb2lucxJyCg50cmFuc2Zlcl9jb2lucxgFIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUg10cmFuc2ZlckNvaW5zEmgKCWZlZV9jb2lucxgGIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUghmZWVDb2lucxJuCgxjb2luX291dHB1dHMYByADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1ILY29pbk91dHB1dHMSOAoKbWludF9pdGVtcxgIIAMoCzITLnB5bG9ucy5weWxvbnMuSXRlbUIEyN4fAFIJbWludEl0ZW1zEjwKDG1vZGlmeV9pdGVtcxgJIAMoCzITLnB5bG9ucy5weWxvbnMuSXRlbUIEyN4fAFILbW9kaWZ5SXRlbXM=');
@$core.Deprecated('Use eventDropExecutionDescriptor instead')
const EventDropExecution$json = {
  '1': 'EventDropExecution',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `EventDropExecution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDropExecutionDescriptor = $convert.base64Decode(
    'ChJFdmVudERyb3BFeGVjdXRpb24SGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIOCgJpZBgCIAEoCVICaWQ=');
@$core.Deprecated('Use eventCompleteExecutionEarlyDescriptor instead')
const EventCompleteExecutionEarly$json = {
  '1': 'EventCompleteExecutionEarly',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `EventCompleteExecutionEarly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCompleteExecutionEarlyDescriptor =
    $convert.base64Decode(
        'ChtFdmVudENvbXBsZXRlRXhlY3V0aW9uRWFybHkSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIOCgJpZBgCIAEoCVICaWQ=');
@$core.Deprecated('Use eventSendItemsDescriptor instead')
const EventSendItems$json = {
  '1': 'EventSendItems',
  '2': [
    {'1': 'sender', '3': 1, '4': 1, '5': 9, '10': 'sender'},
    {'1': 'receiver', '3': 2, '4': 1, '5': 9, '10': 'receiver'},
    {
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemRef',
      '8': {},
      '10': 'items'
    },
  ],
};

/// Descriptor for `EventSendItems`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventSendItemsDescriptor = $convert.base64Decode(
    'Cg5FdmVudFNlbmRJdGVtcxIWCgZzZW5kZXIYASABKAlSBnNlbmRlchIaCghyZWNlaXZlchgCIAEoCVIIcmVjZWl2ZXISMgoFaXRlbXMYAyADKAsyFi5weWxvbnMucHlsb25zLkl0ZW1SZWZCBMjeHwBSBWl0ZW1z');
@$core.Deprecated('Use eventSetItemStringDescriptor instead')
const EventSetItemString$json = {
  '1': 'EventSetItemString',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'cookbook_id', '3': 2, '4': 1, '5': 9, '10': 'cookbookId'},
    {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'original_mutable_strings',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.StringKeyValue',
      '8': {},
      '10': 'originalMutableStrings'
    },
  ],
};

/// Descriptor for `EventSetItemString`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventSetItemStringDescriptor = $convert.base64Decode(
    'ChJFdmVudFNldEl0ZW1TdHJpbmcSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIfCgtjb29rYm9va19pZBgCIAEoCVIKY29va2Jvb2tJZBIOCgJpZBgDIAEoCVICaWQSXQoYb3JpZ2luYWxfbXV0YWJsZV9zdHJpbmdzGAQgAygLMh0ucHlsb25zLnB5bG9ucy5TdHJpbmdLZXlWYWx1ZUIEyN4fAFIWb3JpZ2luYWxNdXRhYmxlU3RyaW5ncw==');
@$core.Deprecated('Use eventCreateTradeDescriptor instead')
const EventCreateTrade$json = {
  '1': 'EventCreateTrade',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `EventCreateTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateTradeDescriptor = $convert.base64Decode(
    'ChBFdmVudENyZWF0ZVRyYWRlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCaWQYAiABKARSAmlk');
@$core.Deprecated('Use eventCancelTradeDescriptor instead')
const EventCancelTrade$json = {
  '1': 'EventCancelTrade',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `EventCancelTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCancelTradeDescriptor = $convert.base64Decode(
    'ChBFdmVudENhbmNlbFRyYWRlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCaWQYAiABKARSAmlk');
@$core.Deprecated('Use eventFulfillTradeDescriptor instead')
const EventFulfillTrade$json = {
  '1': 'EventFulfillTrade',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'creator', '3': 2, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'fulfiller', '3': 3, '4': 1, '5': 9, '10': 'fulfiller'},
    {
      '1': 'item_inputs',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemRef',
      '8': {},
      '10': 'itemInputs'
    },
    {
      '1': 'coin_inputs',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'coinInputs'
    },
    {
      '1': 'item_outputs',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.ItemRef',
      '8': {},
      '10': 'itemOutputs'
    },
    {
      '1': 'coin_outputs',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.cosmos.base.v1beta1.Coin',
      '8': {},
      '10': 'coinOutputs'
    },
    {
      '1': 'payment_infos',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.PaymentInfo',
      '8': {},
      '10': 'paymentInfos'
    },
  ],
};

/// Descriptor for `EventFulfillTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventFulfillTradeDescriptor = $convert.base64Decode(
    'ChFFdmVudEZ1bGZpbGxUcmFkZRIOCgJpZBgBIAEoBFICaWQSGAoHY3JlYXRvchgCIAEoCVIHY3JlYXRvchIcCglmdWxmaWxsZXIYAyABKAlSCWZ1bGZpbGxlchI9CgtpdGVtX2lucHV0cxgEIAMoCzIWLnB5bG9ucy5weWxvbnMuSXRlbVJlZkIEyN4fAFIKaXRlbUlucHV0cxJsCgtjb2luX2lucHV0cxgFIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUgpjb2luSW5wdXRzEj8KDGl0ZW1fb3V0cHV0cxgGIAMoCzIWLnB5bG9ucy5weWxvbnMuSXRlbVJlZkIEyN4fAFILaXRlbU91dHB1dHMSbgoMY29pbl9vdXRwdXRzGAcgAygLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQjDI3h8Aqt8fKGdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuQ29pbnNSC2NvaW5PdXRwdXRzEkUKDXBheW1lbnRfaW5mb3MYCCADKAsyGi5weWxvbnMucHlsb25zLlBheW1lbnRJbmZvQgTI3h8AUgxwYXltZW50SW5mb3M=');
@$core.Deprecated('Use eventGooglePurchaseDescriptor instead')
const EventGooglePurchase$json = {
  '1': 'EventGooglePurchase',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'purchase_token', '3': 3, '4': 1, '5': 9, '10': 'purchaseToken'},
    {
      '1': 'receipt_data_base64',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'receiptDataBase64'
    },
    {'1': 'signature', '3': 5, '4': 1, '5': 9, '10': 'signature'},
  ],
};

/// Descriptor for `EventGooglePurchase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventGooglePurchaseDescriptor = $convert.base64Decode(
    'ChNFdmVudEdvb2dsZVB1cmNoYXNlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISHQoKcHJvZHVjdF9pZBgCIAEoCVIJcHJvZHVjdElkEiUKDnB1cmNoYXNlX3Rva2VuGAMgASgJUg1wdXJjaGFzZVRva2VuEi4KE3JlY2VpcHRfZGF0YV9iYXNlNjQYBCABKAlSEXJlY2VpcHREYXRhQmFzZTY0EhwKCXNpZ25hdHVyZRgFIAEoCVIJc2lnbmF0dXJl');
@$core.Deprecated('Use eventStripePurchaseDescriptor instead')
const EventStripePurchase$json = {
  '1': 'EventStripePurchase',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `EventStripePurchase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventStripePurchaseDescriptor = $convert.base64Decode(
    'ChNFdmVudFN0cmlwZVB1cmNoYXNlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCaWQYAiABKAlSAmlk');
@$core.Deprecated('Use eventApplePurchaseDescriptor instead')
const EventApplePurchase$json = {
  '1': 'EventApplePurchase',
  '2': [
    {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'transaction_id', '3': 3, '4': 1, '5': 9, '10': 'transactionId'},
    {
      '1': 'receipt_data_base64',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'receiptDataBase64'
    },
  ],
};

/// Descriptor for `EventApplePurchase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventApplePurchaseDescriptor = $convert.base64Decode(
    'ChJFdmVudEFwcGxlUHVyY2hhc2USGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIdCgpwcm9kdWN0X2lkGAIgASgJUglwcm9kdWN0SWQSJQoOdHJhbnNhY3Rpb25faWQYAyABKAlSDXRyYW5zYWN0aW9uSWQSLgoTcmVjZWlwdF9kYXRhX2Jhc2U2NBgEIAEoCVIRcmVjZWlwdERhdGFCYXNlNjQ=');
