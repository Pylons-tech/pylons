///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AuthorizationType extends $pb.ProtobufEnum {
  static const AuthorizationType AUTHORIZATION_TYPE_UNSPECIFIED = AuthorizationType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTHORIZATION_TYPE_UNSPECIFIED');
  static const AuthorizationType AUTHORIZATION_TYPE_DELEGATE = AuthorizationType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTHORIZATION_TYPE_DELEGATE');
  static const AuthorizationType AUTHORIZATION_TYPE_UNDELEGATE = AuthorizationType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTHORIZATION_TYPE_UNDELEGATE');
  static const AuthorizationType AUTHORIZATION_TYPE_REDELEGATE = AuthorizationType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTHORIZATION_TYPE_REDELEGATE');

  static const $core.List<AuthorizationType> values = <AuthorizationType> [
    AUTHORIZATION_TYPE_UNSPECIFIED,
    AUTHORIZATION_TYPE_DELEGATE,
    AUTHORIZATION_TYPE_UNDELEGATE,
    AUTHORIZATION_TYPE_REDELEGATE,
  ];

  static final $core.Map<$core.int, AuthorizationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AuthorizationType? valueOf($core.int value) => _byValue[value];

  const AuthorizationType._($core.int v, $core.String n) : super(v, n);
}

