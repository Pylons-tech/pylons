///
//  Generated code. Do not modify.
//  source: pylons/execution.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use itemRecordDescriptor instead')
const ItemRecord$json = const {
  '1': 'ItemRecord',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'doubles', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.DoubleKeyValue', '8': const {}, '10': 'doubles'},
    const {'1': 'longs', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.LongKeyValue', '8': const {}, '10': 'longs'},
    const {'1': 'strings', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.StringKeyValue', '8': const {}, '10': 'strings'},
  ],
};

/// Descriptor for `ItemRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemRecordDescriptor = $convert.base64Decode('CgpJdGVtUmVjb3JkEg4KAklEGAEgASgJUgJJRBJICgdkb3VibGVzGAIgAygLMiguUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkRvdWJsZUtleVZhbHVlQgTI3h8AUgdkb3VibGVzEkIKBWxvbmdzGAMgAygLMiYuUHlsb25zdGVjaC5weWxvbnMucHlsb25zLkxvbmdLZXlWYWx1ZUIEyN4fAFIFbG9uZ3MSSAoHc3RyaW5ncxgEIAMoCzIoLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5TdHJpbmdLZXlWYWx1ZUIEyN4fAFIHc3RyaW5ncw==');
@$core.Deprecated('Use executionDescriptor instead')
const Execution$json = const {
  '1': 'Execution',
  '2': const [
    const {'1': 'creator', '3': 1, '4': 1, '5': 9, '10': 'creator'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'recipeID', '3': 3, '4': 1, '5': 9, '10': 'recipeID'},
    const {'1': 'cookbookID', '3': 4, '4': 1, '5': 9, '10': 'cookbookID'},
    const {'1': 'recipeVersion', '3': 5, '4': 1, '5': 9, '10': 'recipeVersion'},
    const {'1': 'nodeVersion', '3': 6, '4': 1, '5': 9, '10': 'nodeVersion'},
    const {'1': 'blockHeight', '3': 7, '4': 1, '5': 3, '10': 'blockHeight'},
    const {'1': 'itemInputs', '3': 8, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.ItemRecord', '8': const {}, '10': 'itemInputs'},
    const {'1': 'coinInputs', '3': 9, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinInputs'},
    const {'1': 'coinOutputs', '3': 10, '4': 3, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'coinOutputs'},
    const {'1': 'itemOutputIDs', '3': 11, '4': 3, '5': 9, '8': const {}, '10': 'itemOutputIDs'},
    const {'1': 'itemModifyOutputIDs', '3': 12, '4': 3, '5': 9, '8': const {}, '10': 'itemModifyOutputIDs'},
  ],
};

/// Descriptor for `Execution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executionDescriptor = $convert.base64Decode('CglFeGVjdXRpb24SGAoHY3JlYXRvchgBIAEoCVIHY3JlYXRvchIOCgJJRBgCIAEoCVICSUQSGgoIcmVjaXBlSUQYAyABKAlSCHJlY2lwZUlEEh4KCmNvb2tib29rSUQYBCABKAlSCmNvb2tib29rSUQSJAoNcmVjaXBlVmVyc2lvbhgFIAEoCVINcmVjaXBlVmVyc2lvbhIgCgtub2RlVmVyc2lvbhgGIAEoCVILbm9kZVZlcnNpb24SIAoLYmxvY2tIZWlnaHQYByABKANSC2Jsb2NrSGVpZ2h0EkoKCml0ZW1JbnB1dHMYCCADKAsyJC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuSXRlbVJlY29yZEIEyN4fAFIKaXRlbUlucHV0cxJrCgpjb2luSW5wdXRzGAkgAygLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQjDI3h8Aqt8fKGdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuQ29pbnNSCmNvaW5JbnB1dHMSbQoLY29pbk91dHB1dHMYCiADKAsyGS5jb3Ntb3MuYmFzZS52MWJldGExLkNvaW5CMMjeHwCq3x8oZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5Db2luc1ILY29pbk91dHB1dHMSKgoNaXRlbU91dHB1dElEcxgLIAMoCUIEyN4fAFINaXRlbU91dHB1dElEcxI2ChNpdGVtTW9kaWZ5T3V0cHV0SURzGAwgAygJQgTI3h8AUhNpdGVtTW9kaWZ5T3V0cHV0SURz');
