///
//  Generated code. Do not modify.
//  source: cosmos/crypto/secp256k1/keys.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use pubKeyDescriptor instead')
const PubKey$json = const {
  '1': 'PubKey',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 12, '10': 'key'},
  ],
  '7': const {},
};

/// Descriptor for `PubKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pubKeyDescriptor = $convert.base64Decode('CgZQdWJLZXkSEAoDa2V5GAEgASgMUgNrZXk6BJigHwA=');
@$core.Deprecated('Use privKeyDescriptor instead')
const PrivKey$json = const {
  '1': 'PrivKey',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 12, '10': 'key'},
  ],
};

/// Descriptor for `PrivKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privKeyDescriptor = $convert.base64Decode('CgdQcml2S2V5EhAKA2tleRgBIAEoDFIDa2V5');
