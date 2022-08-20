///
//  Generated code. Do not modify.
//  source: pylons/pylons/standard_error.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use standardErrorDescriptor instead')
const StandardError$json = {
  '1': 'StandardError',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `StandardError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List standardErrorDescriptor = $convert.base64Decode(
    'Cg1TdGFuZGFyZEVycm9yEhIKBGNvZGUYASABKAlSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
