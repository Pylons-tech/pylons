///
//  Generated code. Do not modify.
//  source: pylons/pylons/payment_info.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use paymentInfoDescriptor instead')
const PaymentInfo$json = const {
  '1': 'PaymentInfo',
  '2': const [
    const {'1': 'purchase_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseId'},
    const {'1': 'processor_name', '3': 2, '4': 1, '5': 9, '10': 'processorName'},
    const {'1': 'payer_addr', '3': 3, '4': 1, '5': 9, '10': 'payerAddr'},
    const {'1': 'amount', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'amount'},
    const {'1': 'product_id', '3': 5, '4': 1, '5': 9, '10': 'productId'},
    const {'1': 'signature', '3': 6, '4': 1, '5': 9, '10': 'signature'},
  ],
};

/// Descriptor for `PaymentInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentInfoDescriptor = $convert.base64Decode('CgtQYXltZW50SW5mbxIfCgtwdXJjaGFzZV9pZBgBIAEoCVIKcHVyY2hhc2VJZBIlCg5wcm9jZXNzb3JfbmFtZRgCIAEoCVINcHJvY2Vzc29yTmFtZRIdCgpwYXllcl9hZGRyGAMgASgJUglwYXllckFkZHISRgoGYW1vdW50GAQgASgJQi7I3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuSW50UgZhbW91bnQSHQoKcHJvZHVjdF9pZBgFIAEoCVIJcHJvZHVjdElkEhwKCXNpZ25hdHVyZRgGIAEoCVIJc2lnbmF0dXJl');
