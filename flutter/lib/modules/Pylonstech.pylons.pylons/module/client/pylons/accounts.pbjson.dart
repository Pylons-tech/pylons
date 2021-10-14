///
//  Generated code. Do not modify.
//  source: pylons/accounts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use userMapDescriptor instead')
const UserMap$json = const {
  '1': 'UserMap',
  '2': const [
    const {'1': 'accountAddr', '3': 1, '4': 1, '5': 9, '10': 'accountAddr'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `UserMap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userMapDescriptor = $convert.base64Decode('CgdVc2VyTWFwEiAKC2FjY291bnRBZGRyGAEgASgJUgthY2NvdW50QWRkchIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use usernameDescriptor instead')
const Username$json = const {
  '1': 'Username',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `Username`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List usernameDescriptor = $convert.base64Decode('CghVc2VybmFtZRIUCgV2YWx1ZRgBIAEoCVIFdmFsdWU=');
@$core.Deprecated('Use accountAddrDescriptor instead')
const AccountAddr$json = const {
  '1': 'AccountAddr',
  '2': const [
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `AccountAddr`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountAddrDescriptor = $convert.base64Decode('CgtBY2NvdW50QWRkchIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU=');
