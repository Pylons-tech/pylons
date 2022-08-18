///
//  Generated code. Do not modify.
//  source: pylons/pylons/apple_in_app_purchase_order.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use appleInAppPurchaseOrderDescriptor instead')
const AppleInAppPurchaseOrder$json = const {
  '1': 'AppleInAppPurchaseOrder',
  '2': const [
    const {'1': 'quantity', '3': 1, '4': 1, '5': 9, '10': 'quantity'},
    const {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    const {'1': 'purchase_id', '3': 3, '4': 1, '5': 9, '10': 'purchaseId'},
    const {'1': 'purchase_date', '3': 4, '4': 1, '5': 9, '10': 'purchaseDate'},
    const {'1': 'creator', '3': 5, '4': 1, '5': 9, '10': 'creator'},
  ],
};

/// Descriptor for `AppleInAppPurchaseOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appleInAppPurchaseOrderDescriptor =
    $convert.base64Decode(
        'ChdBcHBsZUluQXBwUHVyY2hhc2VPcmRlchIaCghxdWFudGl0eRgBIAEoCVIIcXVhbnRpdHkSHQoKcHJvZHVjdF9pZBgCIAEoCVIJcHJvZHVjdElkEh8KC3B1cmNoYXNlX2lkGAMgASgJUgpwdXJjaGFzZUlkEiMKDXB1cmNoYXNlX2RhdGUYBCABKAlSDHB1cmNoYXNlRGF0ZRIYCgdjcmVhdG9yGAUgASgJUgdjcmVhdG9y');
