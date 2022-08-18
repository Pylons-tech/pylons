///
//  Generated code. Do not modify.
//  source: pylons/pylons/jwk.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use jWKDescriptor instead')
const JWK$json = {
  '1': 'JWK',
  '2': [
    {'1': 'kty', '3': 1, '4': 1, '5': 9, '10': 'kty'},
    {'1': 'use', '3': 2, '4': 1, '5': 9, '10': 'use'},
    {'1': 'alg', '3': 3, '4': 1, '5': 9, '10': 'alg'},
    {'1': 'kid', '3': 4, '4': 1, '5': 9, '10': 'kid'},
    {'1': 'n', '3': 5, '4': 1, '5': 9, '10': 'n'},
    {'1': 'e', '3': 6, '4': 1, '5': 9, '10': 'e'},
  ],
};

/// Descriptor for `JWK`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jWKDescriptor = $convert.base64Decode(
    'CgNKV0sSEAoDa3R5GAEgASgJUgNrdHkSEAoDdXNlGAIgASgJUgN1c2USEAoDYWxnGAMgASgJUgNhbGcSEAoDa2lkGAQgASgJUgNraWQSDAoBbhgFIAEoCVIBbhIMCgFlGAYgASgJUgFl');
