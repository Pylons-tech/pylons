///
//  Generated code. Do not modify.
//  source: pylons/pylons/execution.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use itemRecordDescriptor instead')
const ItemRecord$json = const {
  '1': 'ItemRecord',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'doubles', '3': 2, '4': 3, '5': 11, '6': '.pylons.pylons.DoubleKeyValue', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 3, '4': 3, '5': 11, '6': '.pylons.pylons.LongKeyValue', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 4, '4': 3, '5': 11, '6': '.pylons.pylons.StringKeyValue', '8': const {}, '10': 'strings'},
  ],
};

/// Descriptor for `ItemRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemRecordDescriptor = $convert.base64Decode('CgpJdGVtUmVjb3JkEg4KAmlkGAEgASgJUgJpZBI9Cgdkb3VibGVzGAIgAygLMh0ucHlsb25zLnB5bG9ucy5Eb3VibGVLZXlWYWx1ZUIEyN4fAFIHZG91YmxlcxI3CgVsb25ncxgDIAMoCzIbLnB5bG9ucy5weWxvbnMuTG9uZ0tleVZhbHVlQgTI3h8AUgVsb25ncxI9CgdzdHJpbmdzGAQgAygLMh0ucHlsb25zLnB5bG9ucy5TdHJpbmdLZXlWYWx1ZUIEyN4fAFIHc3RyaW5ncw==');
@$core.Deprecated('Use executionDescriptor instead')
const Execution$json = const {
  '1': 'Execution',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'recipe_id', '3': 3, '4': 1, '5': 9, '10': 'recipeId'},
    const {'1': 'cookbook_id', '3': 4, '4': 1, '5': 9, '10': 'cookbookId'},
    const {'1': 'recipe_version', '3': 5, '4': 1, '5': 9, '10': 'recipeVersion'},
    const {'1': 'node_version', '3': 6, '4': 1, '5': 4, '10': 'nodeVersion'},
    const {'1': 'block_height', '3': 7, '4': 1, '5': 3, '10': 'blockHeight'},
    const {'1': 'item_inputs', '3': 8, '4': 3, '5': 11, '6': '.pylons.pylons.ItemRecord', '8': const {}, '10': 'itemInputs'},
    const {'1': 'coin_inputs', '3': 9, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinInputs'},
    const {'1': 'coin_outputs', '3': 10, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'item_output_ids', '3': 11, '4': 3, '5': 9, '8': const {}, '10': 'itemOutputIds'},
    const {'1': 'item_modify_output_ids', '3': 12, '4': 3, '5': 9, '8': const {}, '10': 'itemModifyOutputIds'},
  ],
};

/// Descriptor for `Execution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executionDescriptor = $convert.base64Decode('CglFeGVjdXRpb24SGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIOCgJpZBgCIAEoCVICaWQSGwoJcmVjaXBlX2lkGAMgASgJUghyZWNpcGVJZBIfCgtjb29rYm9va19pZBgEIAEoCVIKY29va2Jvb2tJZBIlCg5yZWNpcGVfdmVyc2lvbhgFIAEoCVINcmVjaXBlVmVyc2lvbhIhCgxub2RlX3ZlcnNpb24YBiABKARSC25vZGVWZXJzaW9uEiEKDGJsb2NrX2hlaWdodBgHIAEoA1ILYmxvY2tIZWlnaHQSQAoLaXRlbV9pbnB1dHMYCCADKAsyGS5weWxvbnMucHlsb25zLkl0ZW1SZWNvcmRCBMjeHwBSCml0ZW1JbnB1dHMSbAoLY29pbl9pbnB1dHMYCSADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1IKY29pbklucHV0cxJuCgxjb2luX291dHB1dHMYCiADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1ILY29pbk91dHB1dHMSLAoPaXRlbV9vdXRwdXRfaWRzGAsgAygJQgTI3h8AUg1pdGVtT3V0cHV0SWRzEjkKFml0ZW1fbW9kaWZ5X291dHB1dF9pZHMYDCADKAlCBMjeHwBSE2l0ZW1Nb2RpZnlPdXRwdXRJZHM=');
