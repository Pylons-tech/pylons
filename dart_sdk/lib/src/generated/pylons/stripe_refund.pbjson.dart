///
//  Generated code. Do not modify.
//  source: pylons/pylons/stripe_refund.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use stripeRefundDescriptor instead')
const StripeRefund$json = const {
  '1': 'StripeRefund',
  '2': const [
    const {
      '1': 'payment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.pylons.pylons.PaymentInfo',
      '10': 'payment'
    },
    const {'1': 'settled', '3': 2, '4': 1, '5': 8, '10': 'settled'},
  ],
};

/// Descriptor for `StripeRefund`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stripeRefundDescriptor = $convert.base64Decode(
    'CgxTdHJpcGVSZWZ1bmQSNAoHcGF5bWVudBgBIAEoCzIaLnB5bG9ucy5weWxvbnMuUGF5bWVudEluZm9SB3BheW1lbnQSGAoHc2V0dGxlZBgCIAEoCFIHc2V0dGxlZA==');
