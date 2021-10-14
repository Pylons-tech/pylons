///
//  Generated code. Do not modify.
//  source: pylons/event.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use eventCreateAccountDescriptor instead')
const EventCreateAccount$json = const {
  '1': 'EventCreateAccount',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `EventCreateAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateAccountDescriptor = $convert.base64Decode('ChJFdmVudENyZWF0ZUFjY291bnQSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use eventUpdateAccountDescriptor instead')
const EventUpdateAccount$json = const {
  '1': 'EventUpdateAccount',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `EventUpdateAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventUpdateAccountDescriptor = $convert.base64Decode('ChJFdmVudFVwZGF0ZUFjY291bnQSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use eventCreateCookbookDescriptor instead')
const EventCreateCookbook$json = const {
  '1': 'EventCreateCookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `EventCreateCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateCookbookDescriptor = $convert.base64Decode('ChNFdmVudENyZWF0ZUNvb2tib29rEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCSUQYAiABKAlSAklE');
@$core.Deprecated('Use eventUpdateCookbookDescriptor instead')
const EventUpdateCookbook$json = const {
  '1': 'EventUpdateCookbook',
  '2': const [
    const {'1': 'originalCookbook', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Cookbook', '8': const {}, '10': 'originalCookbook'},
  ],
};

/// Descriptor for `EventUpdateCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventUpdateCookbookDescriptor = $convert.base64Decode('ChNFdmVudFVwZGF0ZUNvb2tib29rElQKEG9yaWdpbmFsQ29va2Jvb2sYASABKAsyIi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuQ29va2Jvb2tCBMjeHwBSEG9yaWdpbmFsQ29va2Jvb2s=');
@$core.Deprecated('Use eventTransferCookbookDescriptor instead')
const EventTransferCookbook$json = const {
  '1': 'EventTransferCookbook',
  '2': const [
    const {'1': 'sender', '3': 1, '4': 1, '5': 9, '10': 'sender'},
    const {'1': 'receiver', '3': 2, '4': 1, '5': 9, '10': 'receiver'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `EventTransferCookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventTransferCookbookDescriptor = $convert.base64Decode('ChVFdmVudFRyYW5zZmVyQ29va2Jvb2sSFgoGc2VuZGVyGAEgASgJUgZzZW5kZXISGgoIcmVjZWl2ZXIYAiABKAlSCHJlY2VpdmVyEg4KAklEGAMgASgJUgJJRA==');
@$core.Deprecated('Use eventCreateRecipeDescriptor instead')
const EventCreateRecipe$json = const {
  '1': 'EventCreateRecipe',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'CookbookID', '3': 2, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `EventCreateRecipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateRecipeDescriptor = $convert.base64Decode('ChFFdmVudENyZWF0ZVJlY2lwZRIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEh4KCkNvb2tib29rSUQYAiABKAlSCkNvb2tib29rSUQSDgoCSUQYAyABKAlSAklE');
@$core.Deprecated('Use eventUpdateRecipeDescriptor instead')
const EventUpdateRecipe$json = const {
  '1': 'EventUpdateRecipe',
  '2': const [
    const {'1': 'originalRecipe', '3': 1, '4': 1, '5': 11, '6': '.Pylonstech.pylons.pylons.Recipe', '8': const {}, '10': 'originalRecipe'},
  ],
};

/// Descriptor for `EventUpdateRecipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventUpdateRecipeDescriptor = $convert.base64Decode('ChFFdmVudFVwZGF0ZVJlY2lwZRJOCg5vcmlnaW5hbFJlY2lwZRgBIAEoCzIgLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5SZWNpcGVCBMjeHwBSDm9yaWdpbmFsUmVjaXBl');
@$core.Deprecated('Use eventCreateExecutionDescriptor instead')
const EventCreateExecution$json = const {
  '1': 'EventCreateExecution',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `EventCreateExecution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateExecutionDescriptor = $convert.base64Decode('ChRFdmVudENyZWF0ZUV4ZWN1dGlvbhIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAklEGAIgASgJUgJJRA==');
@$core.Deprecated('Use eventCompleteExecutionDescriptor instead')
const EventCompleteExecution$json = const {
  '1': 'EventCompleteExecution',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'burnCoins', '3': 3, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'burnCoins'},
    const {'1': 'payCoins', '3': 4, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'payCoins'},
    const {'1': 'transferCoins', '3': 5, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'transferCoins'},
    const {'1': 'feeCoins', '3': 6, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'feeCoins'},
    const {'1': 'coinOutputs', '3': 7, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'mintItems', '3': 8, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Item', '8': const {}, '10': 'mintItems'},
    const {'1': 'modifyItems', '3': 9, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.Item', '8': const {}, '10': 'modifyItems'},
  ],
};

/// Descriptor for `EventCompleteExecution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCompleteExecutionDescriptor = $convert.base64Decode('ChZFdmVudENvbXBsZXRlRXhlY3V0aW9uEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCSUQYAiABKAlSAklEEmkKCWJ1cm5Db2lucxgDIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUglidXJuQ29pbnMSZwoIcGF5Q29pbnMYBCADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1IIcGF5Q29pbnMScQoNdHJhbnNmZXJDb2lucxgFIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUg10cmFuc2ZlckNvaW5zEmcKCGZlZUNvaW5zGAYgAygLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQjDI3h8Aqt8fKGdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuQ29pbnNSCGZlZUNvaW5zEm0KC2NvaW5PdXRwdXRzGAcgAygLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQjDI3h8Aqt8fKGdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuQ29pbnNSC2NvaW5PdXRwdXRzEkIKCW1pbnRJdGVtcxgIIAMoCzIeLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5JdGVtQgTI3h8AUgltaW50SXRlbXMSRgoLbW9kaWZ5SXRlbXMYCSADKAsyHi5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuSXRlbUIEyN4fAFILbW9kaWZ5SXRlbXM=');
@$core.Deprecated('Use eventDropExecutionDescriptor instead')
const EventDropExecution$json = const {
  '1': 'EventDropExecution',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `EventDropExecution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDropExecutionDescriptor = $convert.base64Decode('ChJFdmVudERyb3BFeGVjdXRpb24SGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIOCgJJRBgCIAEoCVICSUQ=');
@$core.Deprecated('Use eventCompleteExecutionEarlyDescriptor instead')
const EventCompleteExecutionEarly$json = const {
  '1': 'EventCompleteExecutionEarly',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `EventCompleteExecutionEarly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCompleteExecutionEarlyDescriptor = $convert.base64Decode('ChtFdmVudENvbXBsZXRlRXhlY3V0aW9uRWFybHkSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIOCgJJRBgCIAEoCVICSUQ=');
@$core.Deprecated('Use eventSendItemsDescriptor instead')
const EventSendItems$json = const {
  '1': 'EventSendItems',
  '2': const [
    const {'1': 'sender', '3': 1, '4': 1, '5': 9, '10': 'sender'},
    const {'1': 'receiver', '3': 2, '4': 1, '5': 9, '10': 'receiver'},
    const {'1': 'items', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'items'},
  ],
};

/// Descriptor for `EventSendItems`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventSendItemsDescriptor = $convert.base64Decode('Cg5FdmVudFNlbmRJdGVtcxIWCgZzZW5kZXIYASABKAlSBnNlbmRlchIaCghyZWNlaXZlchgCIAEoCVIIcmVjZWl2ZXISPQoFaXRlbXMYAyADKAsyIS5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuSXRlbVJlZkIEyN4fAFIFaXRlbXM=');
@$core.Deprecated('Use eventSetItemStringDescriptor instead')
const EventSetItemString$json = const {
  '1': 'EventSetItemString',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'CookbookID', '3': 2, '4': 1, '5': 9, '10': 'CookbookID'},
    const {'1': 'ID', '3': 3, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'originalMutableStrings', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringKeyValue', '8': const {}, '10': 'originalMutableStrings'},
  ],
};

/// Descriptor for `EventSetItemString`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventSetItemStringDescriptor = $convert.base64Decode('ChJFdmVudFNldEl0ZW1TdHJpbmcSGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIeCgpDb29rYm9va0lEGAIgASgJUgpDb29rYm9va0lEEg4KAklEGAMgASgJUgJJRBJmChZvcmlnaW5hbE11dGFibGVTdHJpbmdzGAQgAygLMiguUHlsb25zdGVjaC5weWxvbnMucHlsb25zLlN0cmluZ0tleVZhbHVlQgTI3h8AUhZvcmlnaW5hbE11dGFibGVTdHJpbmdz');
@$core.Deprecated('Use eventCreateTradeDescriptor instead')
const EventCreateTrade$json = const {
  '1': 'EventCreateTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 4, '10': 'ID'},
  ],
};

/// Descriptor for `EventCreateTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCreateTradeDescriptor = $convert.base64Decode('ChBFdmVudENyZWF0ZVRyYWRlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCSUQYAiABKARSAklE');
@$core.Deprecated('Use eventCancelTradeDescriptor instead')
const EventCancelTrade$json = const {
  '1': 'EventCancelTrade',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 4, '10': 'ID'},
  ],
};

/// Descriptor for `EventCancelTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCancelTradeDescriptor = $convert.base64Decode('ChBFdmVudENhbmNlbFRyYWRlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCSUQYAiABKARSAklE');
@$core.Deprecated('Use eventFulfillTradeDescriptor instead')
const EventFulfillTrade$json = const {
  '1': 'EventFulfillTrade',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 4, '10': 'ID'},
    const {'1': 'creator', '3': 2, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'fulfiller', '3': 3, '4': 1, '5': 9, '10': 'fulfiller'},
    const {'1': 'itemInputs', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'itemInputs'},
    const {'1': 'coinInputs', '3': 5, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinInputs'},
    const {'1': 'itemOutputs', '3': 6, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRef', '8': const {}, '10': 'itemOutputs'},
    const {'1': 'coinOutputs', '3': 7, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
  ],
};

/// Descriptor for `EventFulfillTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventFulfillTradeDescriptor = $convert.base64Decode('ChFFdmVudEZ1bGZpbGxUcmFkZRIOCgJJRBgBIAEoBFICSUQSGAoHY3JlYXRvchgCIAEoCVIHY3JlYXRvchIcCglmdWxmaWxsZXIYAyABKAlSCWZ1bGZpbGxlchJHCgppdGVtSW5wdXRzGAQgAygLMiEuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkl0ZW1SZWZCBMjeHwBSCml0ZW1JbnB1dHMSawoKY29pbklucHV0cxgFIAMoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIwyN4fAKrfHyhnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkNvaW5zUgpjb2luSW5wdXRzEkkKC2l0ZW1PdXRwdXRzGAYgAygLMiEuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkl0ZW1SZWZCBMjeHwBSC2l0ZW1PdXRwdXRzEm0KC2NvaW5PdXRwdXRzGAcgAygLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQjDI3h8Aqt8fKGdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuQ29pbnNSC2NvaW5PdXRwdXRz');
@$core.Deprecated('Use eventGooglePurchaseDescriptor instead')
const EventGooglePurchase$json = const {
  '1': 'EventGooglePurchase',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'productID', '3': 2, '4': 1, '5': 9, '10': 'productID'},
    const {'1': 'purchaseToken', '3': 3, '4': 1, '5': 9, '10': 'purchaseToken'},
    const {'1': 'receiptDataBase64', '3': 4, '4': 1, '5': 9, '10': 'receiptDataBase64'},
    const {'1': 'signature', '3': 5, '4': 1, '5': 9, '10': 'signature'},
  ],
};

/// Descriptor for `EventGooglePurchase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventGooglePurchaseDescriptor = $convert.base64Decode('ChNFdmVudEdvb2dsZVB1cmNoYXNlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISHAoJcHJvZHVjdElEGAIgASgJUglwcm9kdWN0SUQSJAoNcHVyY2hhc2VUb2tlbhgDIAEoCVINcHVyY2hhc2VUb2tlbhIsChFyZWNlaXB0RGF0YUJhc2U2NBgEIAEoCVIRcmVjZWlwdERhdGFCYXNlNjQSHAoJc2lnbmF0dXJlGAUgASgJUglzaWduYXR1cmU=');
@$core.Deprecated('Use eventStripePurchaseDescriptor instead')
const EventStripePurchase$json = const {
  '1': 'EventStripePurchase',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

/// Descriptor for `EventStripePurchase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventStripePurchaseDescriptor = $convert.base64Decode('ChNFdmVudFN0cmlwZVB1cmNoYXNlEhgKB2NyZWF0b3IYASABKAlSB2NyZWF0b3ISDgoCSUQYAiABKAlSAklE');
