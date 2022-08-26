///
//  Generated code. Do not modify.
//  source: pylons/pylons/jwk.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class JWK extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JWK', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kty')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'use')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'alg')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kid')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'n')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'e')
    ..hasRequiredFields = false
  ;

  JWK._() : super();
  factory JWK({
    $core.String? kty,
    $core.String? use,
    $core.String? alg,
    $core.String? kid,
    $core.String? n,
    $core.String? e,
  }) {
    final _result = create();
    if (kty != null) {
      _result.kty = kty;
    }
    if (use != null) {
      _result.use = use;
    }
    if (alg != null) {
      _result.alg = alg;
    }
    if (kid != null) {
      _result.kid = kid;
    }
    if (n != null) {
      _result.n = n;
    }
    if (e != null) {
      _result.e = e;
    }
    return _result;
  }
  factory JWK.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JWK.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JWK clone() => JWK()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JWK copyWith(void Function(JWK) updates) => super.copyWith((message) => updates(message as JWK)) as JWK; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JWK create() => JWK._();
  JWK createEmptyInstance() => create();
  static $pb.PbList<JWK> createRepeated() => $pb.PbList<JWK>();
  @$core.pragma('dart2js:noInline')
  static JWK getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JWK>(create);
  static JWK? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get kty => $_getSZ(0);
  @$pb.TagNumber(1)
  set kty($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKty() => $_has(0);
  @$pb.TagNumber(1)
  void clearKty() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get use => $_getSZ(1);
  @$pb.TagNumber(2)
  set use($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUse() => $_has(1);
  @$pb.TagNumber(2)
  void clearUse() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get alg => $_getSZ(2);
  @$pb.TagNumber(3)
  set alg($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAlg() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlg() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get kid => $_getSZ(3);
  @$pb.TagNumber(4)
  set kid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasKid() => $_has(3);
  @$pb.TagNumber(4)
  void clearKid() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get n => $_getSZ(4);
  @$pb.TagNumber(5)
  set n($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasN() => $_has(4);
  @$pb.TagNumber(5)
  void clearN() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get e => $_getSZ(5);
  @$pb.TagNumber(6)
  set e($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasE() => $_has(5);
  @$pb.TagNumber(6)
  void clearE() => clearField(6);
}
