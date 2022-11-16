///
import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use genericAuthorizationDescriptor instead')
const GenericAuthorization$json = const {
  '1': 'GenericAuthorization',
  '2': const [
    const {'1': 'msg', '3': 1, '4': 1, '5': 9, '10': 'msg'},
  ],
  '7': const {},
};

/// Descriptor for `GenericAuthorization`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericAuthorizationDescriptor = $convert.base64Decode('ChRHZW5lcmljQXV0aG9yaXphdGlvbhIQCgNtc2cYASABKAlSA21zZzoR0rQtDUF1dGhvcml6YXRpb24=');
@$core.Deprecated('Use grantDescriptor instead')
const Grant$json = const {
  '1': 'Grant',
  '2': const [
    const {'1': 'authorization', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Any', '8': const {}, '10': 'authorization'},
    const {'1': 'expiration', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '8': const {}, '10': 'expiration'},
  ],
};

/// Descriptor for `Grant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List grantDescriptor = $convert.base64Decode('CgVHcmFudBJNCg1hdXRob3JpemF0aW9uGAEgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueUIRyrQtDUF1dGhvcml6YXRpb25SDWF1dGhvcml6YXRpb24SRAoKZXhwaXJhdGlvbhgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBCCJDfHwHI3h8AUgpleHBpcmF0aW9u');
@$core.Deprecated('Use grantAuthorizationDescriptor instead')
const GrantAuthorization$json = const {
  '1': 'GrantAuthorization',
  '2': const [
    const {'1': 'granter', '3': 1, '4': 1, '5': 9, '10': 'granter'},
    const {'1': 'grantee', '3': 2, '4': 1, '5': 9, '10': 'grantee'},
    const {'1': 'authorization', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Any', '8': const {}, '10': 'authorization'},
    const {'1': 'expiration', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '8': const {}, '10': 'expiration'},
  ],
};

/// Descriptor for `GrantAuthorization`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List grantAuthorizationDescriptor = $convert.base64Decode('ChJHcmFudEF1dGhvcml6YXRpb24SGAoHZ3JhbnRlchgBIAEoCVIHZ3JhbnRlchIYCgdncmFudGVlGAIgASgJUgdncmFudGVlEk0KDWF1dGhvcml6YXRpb24YAyABKAsyFC5nb29nbGUucHJvdG9idWYuQW55QhHKtC0NQXV0aG9yaXphdGlvblINYXV0aG9yaXphdGlvbhJECgpleHBpcmF0aW9uGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEIIyN4fAJDfHwFSCmV4cGlyYXRpb24=');
