///
//  Generated code. Do not modify.
//  source: pylons/pylons/accounts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userMapDescriptor instead')
const UserMap$json = {
  '1': 'UserMap',
  '2': [
    {'1': 'account_addr', '3': 1, '4': 1, '5': 9, '10': 'accountAddr'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `UserMap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userMapDescriptor = $convert.base64Decode(
    'CgdVc2VyTWFwEiEKDGFjY291bnRfYWRkchgBIAEoCVILYWNjb3VudEFkZHISGgoIdXNlcm5hbWUYAiABKAlSCHVzZXJuYW1l');
@$core.Deprecated('Use usernameDescriptor instead')
const Username$json = {
  '1': 'Username',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `Username`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List usernameDescriptor =
    $convert.base64Decode('CghVc2VybmFtZRIUCgV2YWx1ZRgBIAEoCVIFdmFsdWU=');
@$core.Deprecated('Use accountAddrDescriptor instead')
const AccountAddr$json = {
  '1': 'AccountAddr',
  '2': [
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `AccountAddr`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountAddrDescriptor =
    $convert.base64Decode('CgtBY2NvdW50QWRkchIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU=');
@$core.Deprecated('Use referralKVDescriptor instead')
const ReferralKV$json = {
  '1': 'ReferralKV',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {
      '1': 'users',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.pylons.pylons.RefereeSignup',
      '10': 'users'
    },
  ],
};

/// Descriptor for `ReferralKV`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List referralKVDescriptor = $convert.base64Decode(
    'CgpSZWZlcnJhbEtWEhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSMgoFdXNlcnMYAiADKAsyHC5weWxvbnMucHlsb25zLlJlZmVyZWVTaWdudXBSBXVzZXJz');
@$core.Deprecated('Use refereeSignupDescriptor instead')
const RefereeSignup$json = {
  '1': 'RefereeSignup',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'address', '3': 2, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `RefereeSignup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refereeSignupDescriptor = $convert.base64Decode(
    'Cg1SZWZlcmVlU2lnbnVwEhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIYCgdhZGRyZXNzGAIgASgJUgdhZGRyZXNz');
