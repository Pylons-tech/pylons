///
//  Generated code. Do not modify.
//  source: pylons/params.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use googleInAppPurchasePackageDescriptor instead')
const GoogleInAppPurchasePackage$json = const {
  '1': 'GoogleInAppPurchasePackage',
  '2': const [
    const {'1': 'PackageName', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'PackageName'},
    const {'1': 'ProductID', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'ProductID'},
    const {'1': 'Amount', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'Amount'},
  ],
};

/// Descriptor for `GoogleInAppPurchasePackage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List googleInAppPurchasePackageDescriptor = $convert.base64Decode('ChpHb29nbGVJbkFwcFB1cmNoYXNlUGFja2FnZRI5CgtQYWNrYWdlTmFtZRgBIAEoCUIX8t4fE3lhbWw6InBhY2thZ2VfbmFtZSJSC1BhY2thZ2VOYW1lEjMKCVByb2R1Y3RJRBgCIAEoCUIV8t4fEXlhbWw6InByb2R1Y3RfaWQiUglQcm9kdWN0SUQSVwoGQW1vdW50GAMgASgJQj/I3h8A8t4fDXlhbWw6ImFtb3VudCLa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5JbnRSBkFtb3VudA==');
@$core.Deprecated('Use coinIssuerDescriptor instead')
const CoinIssuer$json = const {
  '1': 'CoinIssuer',
  '2': const [
    const {'1': 'CoinDenom', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'CoinDenom'},
    const {'1': 'Packages', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.GoogleInAppPurchasePackage', '8': const {}, '10': 'Packages'},
    const {'1': 'GoogleInAppPurchasePubKey', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'GoogleInAppPurchasePubKey'},
  ],
};

/// Descriptor for `CoinIssuer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinIssuerDescriptor = $convert.base64Decode('CgpDb2luSXNzdWVyEjMKCUNvaW5EZW5vbRgBIAEoCUIV8t4fEXlhbWw6ImNvaW5fZGVub20iUglDb2luRGVub20SdAoIUGFja2FnZXMYAiADKAsyNC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuR29vZ2xlSW5BcHBQdXJjaGFzZVBhY2thZ2VCIvLeHxp5YW1sOiJnb29nbGVfaWFwX3BhY2thZ2VzIsjeHwBSCFBhY2thZ2VzEloKGUdvb2dsZUluQXBwUHVyY2hhc2VQdWJLZXkYAyABKAlCHPLeHxh5YW1sOiJnb29nbGVfaWFwX3B1YmtleSJSGUdvb2dsZUluQXBwUHVyY2hhc2VQdWJLZXk=');
@$core.Deprecated('Use paramsDescriptor instead')
const Params$json = const {
  '1': 'Params',
  '2': const [
    const {'1': 'minNameFieldLength', '3': 1, '4': 1, '5': 4, '8': const {}, '10': 'minNameFieldLength'},
    const {'1': 'minDescriptionFieldLength', '3': 2, '4': 1, '5': 4, '8': const {}, '10': 'minDescriptionFieldLength'},
    const {'1': 'coinIssuers', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinIssuer', '8': const {}, '10': 'coinIssuers'},
    const {'1': 'recipeFeePercentage', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'recipeFeePercentage'},
    const {'1': 'itemTransferFeePercentage', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'itemTransferFeePercentage'},
    const {'1': 'UpdateItemStringFee', '3': 6, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'UpdateItemStringFee'},
    const {'1': 'minTransferFee', '3': 7, '4': 1, '5': 9, '8': const {}, '10': 'minTransferFee'},
    const {'1': 'maxTransferFee', '3': 8, '4': 1, '5': 9, '8': const {}, '10': 'maxTransferFee'},
    const {'1': 'UpdateUsernameFee', '3': 9, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'UpdateUsernameFee'},
  ],
  '7': const {},
};

/// Descriptor for `Params`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paramsDescriptor = $convert.base64Decode('CgZQYXJhbXMSUAoSbWluTmFtZUZpZWxkTGVuZ3RoGAEgASgEQiDy3h8ceWFtbDoibWluX25hbWVfZmllbGRfbGVuZ3RoIlISbWluTmFtZUZpZWxkTGVuZ3RoEmUKGW1pbkRlc2NyaXB0aW9uRmllbGRMZW5ndGgYAiABKARCJ/LeHyN5YW1sOiJtaW5fZGVzY3JpcHRpb25fZmllbGRfbGVuZ3RoIlIZbWluRGVzY3JpcHRpb25GaWVsZExlbmd0aBJjCgtjb2luSXNzdWVycxgDIAMoCzIkLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Db2luSXNzdWVyQhvy3h8TeWFtbDoiY29pbl9pc3N1ZXJzIsjeHwBSC2NvaW5Jc3N1ZXJzEoABChNyZWNpcGVGZWVQZXJjZW50YWdlGAQgASgJQk7y3h8ceWFtbDoicmVjaXBlX2ZlZV9wZXJjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSE3JlY2lwZUZlZVBlcmNlbnRhZ2USkwEKGWl0ZW1UcmFuc2ZlckZlZVBlcmNlbnRhZ2UYBSABKAlCVfLeHyN5YW1sOiJpdGVtX3RyYW5zZmVyX2ZlZV9wZXJjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSGWl0ZW1UcmFuc2ZlckZlZVBlcmNlbnRhZ2UScgoTVXBkYXRlSXRlbVN0cmluZ0ZlZRgGIAEoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIl8t4fHXlhbWw6InVwZGF0ZV9pdGVtX3N0cmluZ19mZWUiyN4fAFITVXBkYXRlSXRlbVN0cmluZ0ZlZRJxCg5taW5UcmFuc2ZlckZlZRgHIAEoCUJJ8t4fF3lhbWw6Im1pbl90cmFuc2Zlcl9mZWUiyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkludFIObWluVHJhbnNmZXJGZWUScQoObWF4VHJhbnNmZXJGZWUYCCABKAlCSfLeHxd5YW1sOiJtYXhfdHJhbnNmZXJfZmVlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5JbnRSDm1heFRyYW5zZmVyRmVlEmsKEVVwZGF0ZVVzZXJuYW1lRmVlGAkgASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQiLy3h8aeWFtbDoidXBkYXRlX3VzZXJuYW1lX2ZlZSLI3h8AUhFVcGRhdGVVc2VybmFtZUZlZToEmKAfAA==');
