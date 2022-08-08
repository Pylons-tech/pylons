///
//  Generated code. Do not modify.
//  source: pylons/pylons/redeem_info.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use redeemInfoDescriptor instead')
const RedeemInfo$json = {
  '1': 'RedeemInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'processor_name', '3': 2, '4': 1, '5': 9, '10': 'processorName'},
    {'1': 'address', '3': 3, '4': 1, '5': 9, '10': 'address'},
    {'1': 'amount', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'amount'},
    {'1': 'signature', '3': 5, '4': 1, '5': 9, '10': 'signature'},
  ],
};

/// Descriptor for `RedeemInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redeemInfoDescriptor = $convert.base64Decode(
    'CgpSZWRlZW1JbmZvEg4KAmlkGAEgASgJUgJpZBIlCg5wcm9jZXNzb3JfbmFtZRgCIAEoCVINcHJvY2Vzc29yTmFtZRIYCgdhZGRyZXNzGAMgASgJUgdhZGRyZXNzEkYKBmFtb3VudBgEIAEoCUIuyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkludFIGYW1vdW50EhwKCXNpZ25hdHVyZRgFIAEoCVIJc2lnbmF0dXJl');
@$core.Deprecated('Use createPaymentAccountDescriptor instead')
const CreatePaymentAccount$json = {
  '1': 'CreatePaymentAccount',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'signature', '3': 3, '4': 1, '5': 9, '10': 'signature'},
  ],
};

/// Descriptor for `CreatePaymentAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPaymentAccountDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVQYXltZW50QWNjb3VudBIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEhQKBXRva2VuGAIgASgJUgV0b2tlbhIcCglzaWduYXR1cmUYAyABKAlSCXNpZ25hdHVyZQ==');
