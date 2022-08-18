///
//  Generated code. Do not modify.
//  source: pylons/pylons/google_iap_order.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use googleInAppPurchaseOrderDescriptor instead')
const GoogleInAppPurchaseOrder$json = const {
  '1': 'GoogleInAppPurchaseOrder',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    const {
      '1': 'purchase_token',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'purchaseToken'
    },
    const {
      '1': 'receipt_data_base64',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'receiptDataBase64'
    },
    const {'1': 'signature', '3': 5, '4': 1, '5': 9, '10': 'signature'},
  ],
};

/// Descriptor for `GoogleInAppPurchaseOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List googleInAppPurchaseOrderDescriptor =
    $convert.base64Decode(
        'ChhHb29nbGVJbkFwcFB1cmNoYXNlT3JkZXISGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIdCgpwcm9kdWN0X2lkGAIgASgJUglwcm9kdWN0SWQSJQoOcHVyY2hhc2VfdG9rZW4YAyABKAlSDXB1cmNoYXNlVG9rZW4SLgoTcmVjZWlwdF9kYXRhX2Jhc2U2NBgEIAEoCVIRcmVjZWlwdERhdGFCYXNlNjQSHAoJc2lnbmF0dXJlGAUgASgJUglzaWduYXR1cmU=');
