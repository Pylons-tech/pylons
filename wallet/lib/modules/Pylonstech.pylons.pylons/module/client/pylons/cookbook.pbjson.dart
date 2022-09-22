///
//  Generated code. Do not modify.
//  source: pylons/pylons/cookbook.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use cookbookDescriptor instead')
const Cookbook$json = const {
  '1': 'Cookbook',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'node_version', '3': 3, '4': 1, '5': 4, '10': 'nodeVersion'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'developer', '3': 6, '4': 1, '5': 9, '10': 'developer'},
    const {'1': 'version', '3': 7, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'support_email', '3': 8, '4': 1, '5': 9, '10': 'supportEmail'},
    const {'1': 'enabled', '3': 9, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'recipe_limit', '3': 10, '4': 3, '5': 11, '6': '.pylons.pylons.Cookbook.RecipeLimitEntry', '10': 'recipeLimit'},
  ],
  '3': const [Cookbook_RecipeLimitEntry$json],
};

@$core.Deprecated('Use cookbookDescriptor instead')
const Cookbook_RecipeLimitEntry$json = const {
  '1': 'RecipeLimitEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.pylons.pylons.limit', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Cookbook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cookbookDescriptor = $convert.base64Decode('CghDb29rYm9vaxIYCgdjcmVhdG9yGAEgASgJUgdjcmVhdG9yEg4KAmlkGAIgASgJUgJpZBIhCgxub2RlX3ZlcnNpb24YAyABKARSC25vZGVWZXJzaW9uEhIKBG5hbWUYBCABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEhwKCWRldmVsb3BlchgGIAEoCVIJZGV2ZWxvcGVyEhgKB3ZlcnNpb24YByABKAlSB3ZlcnNpb24SIwoNc3VwcG9ydF9lbWFpbBgIIAEoCVIMc3VwcG9ydEVtYWlsEhgKB2VuYWJsZWQYCSABKAhSB2VuYWJsZWQSSwoMcmVjaXBlX2xpbWl0GAogAygLMigucHlsb25zLnB5bG9ucy5Db29rYm9vay5SZWNpcGVMaW1pdEVudHJ5UgtyZWNpcGVMaW1pdBpUChBSZWNpcGVMaW1pdEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EioKBXZhbHVlGAIgASgLMhQucHlsb25zLnB5bG9ucy5saW1pdFIFdmFsdWU6AjgB');
@$core.Deprecated('Use limitDescriptor instead')
const limit$json = const {
  '1': 'limit',
  '2': const [
    const {'1': 'quantity', '3': 1, '4': 1, '5': 4, '8': const {}, '10': 'quantity'},
    const {'1': 'amount_minted', '3': 2, '4': 1, '5': 4, '8': const {}, '10': 'amountMinted'},
  ],
};

/// Descriptor for `limit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List limitDescriptor = $convert.base64Decode('CgVsaW1pdBI5CghxdWFudGl0eRgBIAEoBEId6t4fGXF1YW50aXR5LG9taXRlbXB0eSxzdHJpbmdSCHF1YW50aXR5EkcKDWFtb3VudF9taW50ZWQYAiABKARCIureHx5hbW91bnRfbWludGVkLG9taXRlbXB0eSxzdHJpbmdSDGFtb3VudE1pbnRlZA==');
