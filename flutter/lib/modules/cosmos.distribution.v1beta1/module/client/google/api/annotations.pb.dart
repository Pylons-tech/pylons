///
//  Generated code. Do not modify.
//  source: google/api/annotations.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package:pylons_wallet/modules/cosmos.distribution.v1beta1/module/client/google/api/http.pb.dart' as $4;

class Annotations {
  static final http = $pb.Extension<$4.HttpRule>(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'google.protobuf.MethodOptions', const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'http', 72295728, $pb.PbFieldType.OM, defaultOrMaker: $4.HttpRule.getDefault, subBuilder: $4.HttpRule.create);
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(http);
  }
}

