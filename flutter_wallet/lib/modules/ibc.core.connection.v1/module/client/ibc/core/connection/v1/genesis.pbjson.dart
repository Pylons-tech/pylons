///
//  Generated code. Do not modify.
//  source: ibc/core/connection/v1/genesis.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use genesisStateDescriptor instead')
const GenesisState$json = const {
  '1': 'GenesisState',
  '2': const [
    const {'1': 'connections', '3': 1, '4': 3, '5': 11, '6': '.ibc.core.connection.v1.IdentifiedConnection', '8': const {}, '10': 'connections'},
    const {'1': 'client_connection_paths', '3': 2, '4': 3, '5': 11, '6': '.ibc.core.connection.v1.ConnectionPaths', '8': const {}, '10': 'clientConnectionPaths'},
    const {'1': 'next_connection_sequence', '3': 3, '4': 1, '5': 4, '8': const {}, '10': 'nextConnectionSequence'},
    const {'1': 'params', '3': 4, '4': 1, '5': 11, '6': '.ibc.core.connection.v1.Params', '8': const {}, '10': 'params'},
  ],
};

/// Descriptor for `GenesisState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genesisStateDescriptor = $convert.base64Decode('CgxHZW5lc2lzU3RhdGUSVAoLY29ubmVjdGlvbnMYASADKAsyLC5pYmMuY29yZS5jb25uZWN0aW9uLnYxLklkZW50aWZpZWRDb25uZWN0aW9uQgTI3h8AUgtjb25uZWN0aW9ucxKHAQoXY2xpZW50X2Nvbm5lY3Rpb25fcGF0aHMYAiADKAsyJy5pYmMuY29yZS5jb25uZWN0aW9uLnYxLkNvbm5lY3Rpb25QYXRoc0ImyN4fAPLeHx55YW1sOiJjbGllbnRfY29ubmVjdGlvbl9wYXRocyJSFWNsaWVudENvbm5lY3Rpb25QYXRocxJdChhuZXh0X2Nvbm5lY3Rpb25fc2VxdWVuY2UYAyABKARCI/LeHx95YW1sOiJuZXh0X2Nvbm5lY3Rpb25fc2VxdWVuY2UiUhZuZXh0Q29ubmVjdGlvblNlcXVlbmNlEjwKBnBhcmFtcxgEIAEoCzIeLmliYy5jb3JlLmNvbm5lY3Rpb24udjEuUGFyYW1zQgTI3h8AUgZwYXJhbXM=');
