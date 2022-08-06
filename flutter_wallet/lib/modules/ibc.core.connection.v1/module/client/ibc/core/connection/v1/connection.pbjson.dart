///
//  Generated code. Do not modify.
//  source: ibc/core/connection/v1/connection.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use stateDescriptor instead')
const State$json = const {
  '1': 'State',
  '2': const [
    const {'1': 'STATE_UNINITIALIZED_UNSPECIFIED', '2': 0, '3': const {}},
    const {'1': 'STATE_INIT', '2': 1, '3': const {}},
    const {'1': 'STATE_TRYOPEN', '2': 2, '3': const {}},
    const {'1': 'STATE_OPEN', '2': 3, '3': const {}},
  ],
  '3': const {},
};

/// Descriptor for `State`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stateDescriptor = $convert.base64Decode('CgVTdGF0ZRI2Ch9TVEFURV9VTklOSVRJQUxJWkVEX1VOU1BFQ0lGSUVEEAAaEYqdIA1VTklOSVRJQUxJWkVEEhgKClNUQVRFX0lOSVQQARoIip0gBElOSVQSHgoNU1RBVEVfVFJZT1BFThACGguKnSAHVFJZT1BFThIYCgpTVEFURV9PUEVOEAMaCIqdIARPUEVOGgSIox4A');
@$core.Deprecated('Use connectionEndDescriptor instead')
const ConnectionEnd$json = const {
  '1': 'ConnectionEnd',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'versions', '3': 2, '4': 3, '5': 11, '6': '.ibc.core.connection.v1.Version', '10': 'versions'},
    const {'1': 'state', '3': 3, '4': 1, '5': 14, '6': '.ibc.core.connection.v1.State', '10': 'state'},
    const {'1': 'counterparty', '3': 4, '4': 1, '5': 11, '6': '.ibc.core.connection.v1.Counterparty', '8': const {}, '10': 'counterparty'},
    const {'1': 'delay_period', '3': 5, '4': 1, '5': 4, '8': const {}, '10': 'delayPeriod'},
  ],
  '7': const {},
};

/// Descriptor for `ConnectionEnd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionEndDescriptor = $convert.base64Decode('Cg1Db25uZWN0aW9uRW5kEjEKCWNsaWVudF9pZBgBIAEoCUIU8t4fEHlhbWw6ImNsaWVudF9pZCJSCGNsaWVudElkEjsKCHZlcnNpb25zGAIgAygLMh8uaWJjLmNvcmUuY29ubmVjdGlvbi52MS5WZXJzaW9uUgh2ZXJzaW9ucxIzCgVzdGF0ZRgDIAEoDjIdLmliYy5jb3JlLmNvbm5lY3Rpb24udjEuU3RhdGVSBXN0YXRlEk4KDGNvdW50ZXJwYXJ0eRgEIAEoCzIkLmliYy5jb3JlLmNvbm5lY3Rpb24udjEuQ291bnRlcnBhcnR5QgTI3h8AUgxjb3VudGVycGFydHkSOgoMZGVsYXlfcGVyaW9kGAUgASgEQhfy3h8TeWFtbDoiZGVsYXlfcGVyaW9kIlILZGVsYXlQZXJpb2Q6BIigHwA=');
@$core.Deprecated('Use identifiedConnectionDescriptor instead')
const IdentifiedConnection$json = const {
  '1': 'IdentifiedConnection',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'id'},
    const {'1': 'client_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'versions', '3': 3, '4': 3, '5': 11, '6': '.ibc.core.connection.v1.Version', '10': 'versions'},
    const {'1': 'state', '3': 4, '4': 1, '5': 14, '6': '.ibc.core.connection.v1.State', '10': 'state'},
    const {'1': 'counterparty', '3': 5, '4': 1, '5': 11, '6': '.ibc.core.connection.v1.Counterparty', '8': const {}, '10': 'counterparty'},
    const {'1': 'delay_period', '3': 6, '4': 1, '5': 4, '8': const {}, '10': 'delayPeriod'},
  ],
  '7': const {},
};

/// Descriptor for `IdentifiedConnection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifiedConnectionDescriptor = $convert.base64Decode('ChRJZGVudGlmaWVkQ29ubmVjdGlvbhIdCgJpZBgBIAEoCUIN8t4fCXlhbWw6ImlkIlICaWQSMQoJY2xpZW50X2lkGAIgASgJQhTy3h8QeWFtbDoiY2xpZW50X2lkIlIIY2xpZW50SWQSOwoIdmVyc2lvbnMYAyADKAsyHy5pYmMuY29yZS5jb25uZWN0aW9uLnYxLlZlcnNpb25SCHZlcnNpb25zEjMKBXN0YXRlGAQgASgOMh0uaWJjLmNvcmUuY29ubmVjdGlvbi52MS5TdGF0ZVIFc3RhdGUSTgoMY291bnRlcnBhcnR5GAUgASgLMiQuaWJjLmNvcmUuY29ubmVjdGlvbi52MS5Db3VudGVycGFydHlCBMjeHwBSDGNvdW50ZXJwYXJ0eRI6CgxkZWxheV9wZXJpb2QYBiABKARCF/LeHxN5YW1sOiJkZWxheV9wZXJpb2QiUgtkZWxheVBlcmlvZDoEiKAfAA==');
@$core.Deprecated('Use counterpartyDescriptor instead')
const Counterparty$json = const {
  '1': 'Counterparty',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'connection_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'connectionId'},
    const {'1': 'prefix', '3': 3, '4': 1, '5': 11, '6': '.ibc.core.commitment.v1.MerklePrefix', '8': const {}, '10': 'prefix'},
  ],
  '7': const {},
};

/// Descriptor for `Counterparty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List counterpartyDescriptor = $convert.base64Decode('CgxDb3VudGVycGFydHkSMQoJY2xpZW50X2lkGAEgASgJQhTy3h8QeWFtbDoiY2xpZW50X2lkIlIIY2xpZW50SWQSPQoNY29ubmVjdGlvbl9pZBgCIAEoCUIY8t4fFHlhbWw6ImNvbm5lY3Rpb25faWQiUgxjb25uZWN0aW9uSWQSQgoGcHJlZml4GAMgASgLMiQuaWJjLmNvcmUuY29tbWl0bWVudC52MS5NZXJrbGVQcmVmaXhCBMjeHwBSBnByZWZpeDoEiKAfAA==');
@$core.Deprecated('Use clientPathsDescriptor instead')
const ClientPaths$json = const {
  '1': 'ClientPaths',
  '2': const [
    const {'1': 'paths', '3': 1, '4': 3, '5': 9, '10': 'paths'},
  ],
};

/// Descriptor for `ClientPaths`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientPathsDescriptor = $convert.base64Decode('CgtDbGllbnRQYXRocxIUCgVwYXRocxgBIAMoCVIFcGF0aHM=');
@$core.Deprecated('Use connectionPathsDescriptor instead')
const ConnectionPaths$json = const {
  '1': 'ConnectionPaths',
  '2': const [
    const {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'clientId'},
    const {'1': 'paths', '3': 2, '4': 3, '5': 9, '10': 'paths'},
  ],
};

/// Descriptor for `ConnectionPaths`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionPathsDescriptor = $convert.base64Decode('Cg9Db25uZWN0aW9uUGF0aHMSMQoJY2xpZW50X2lkGAEgASgJQhTy3h8QeWFtbDoiY2xpZW50X2lkIlIIY2xpZW50SWQSFAoFcGF0aHMYAiADKAlSBXBhdGhz');
@$core.Deprecated('Use versionDescriptor instead')
const Version$json = const {
  '1': 'Version',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 1, '5': 9, '10': 'identifier'},
    const {'1': 'features', '3': 2, '4': 3, '5': 9, '10': 'features'},
  ],
  '7': const {},
};

/// Descriptor for `Version`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List versionDescriptor = $convert.base64Decode('CgdWZXJzaW9uEh4KCmlkZW50aWZpZXIYASABKAlSCmlkZW50aWZpZXISGgoIZmVhdHVyZXMYAiADKAlSCGZlYXR1cmVzOgSIoB8A');
@$core.Deprecated('Use paramsDescriptor instead')
const Params$json = const {
  '1': 'Params',
  '2': const [
    const {'1': 'max_expected_time_per_block', '3': 1, '4': 1, '5': 4, '8': const {}, '10': 'maxExpectedTimePerBlock'},
  ],
};

/// Descriptor for `Params`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paramsDescriptor = $convert.base64Decode('CgZQYXJhbXMSZAobbWF4X2V4cGVjdGVkX3RpbWVfcGVyX2Jsb2NrGAEgASgEQiby3h8ieWFtbDoibWF4X2V4cGVjdGVkX3RpbWVfcGVyX2Jsb2NrIlIXbWF4RXhwZWN0ZWRUaW1lUGVyQmxvY2s=');
