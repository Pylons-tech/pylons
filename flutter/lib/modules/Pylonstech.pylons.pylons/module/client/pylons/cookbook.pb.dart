///
//  Generated code. Do not modify.
//  source: pylons/cookbook.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/cosmos/base/v1beta1/coin.pb.dart' as $2;

class Cookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Cookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeVersion', protoName: 'nodeVersion')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'developer')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'supportEmail', protoName: 'supportEmail')
    ..aOM<$2.Coin>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'costPerBlock', protoName: 'costPerBlock', subBuilder: $2.Coin.create)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false
  ;

  Cookbook._() : super();
  factory Cookbook({
    $core.String? creator,
    $core.String? iD,
    $core.String? nodeVersion,
    $core.String? name,
    $core.String? description,
    $core.String? developer,
    $core.String? version,
    $core.String? supportEmail,
    $2.Coin? costPerBlock,
    $core.bool? enabled,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    if (nodeVersion != null) {
      _result.nodeVersion = nodeVersion;
    }
    if (name != null) {
      _result.name = name;
    }
    if (description != null) {
      _result.description = description;
    }
    if (developer != null) {
      _result.developer = developer;
    }
    if (version != null) {
      _result.version = version;
    }
    if (supportEmail != null) {
      _result.supportEmail = supportEmail;
    }
    if (costPerBlock != null) {
      _result.costPerBlock = costPerBlock;
    }
    if (enabled != null) {
      _result.enabled = enabled;
    }
    return _result;
  }
  factory Cookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Cookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Cookbook clone() => Cookbook()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Cookbook copyWith(void Function(Cookbook) updates) => super.copyWith((message) => updates(message as Cookbook)) as Cookbook; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Cookbook create() => Cookbook._();
  Cookbook createEmptyInstance() => create();
  static $pb.PbList<Cookbook> createRepeated() => $pb.PbList<Cookbook>();
  @$core.pragma('dart2js:noInline')
  static Cookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cookbook>(create);
  static Cookbook? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get nodeVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set nodeVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNodeVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearNodeVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get developer => $_getSZ(5);
  @$pb.TagNumber(6)
  set developer($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDeveloper() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeveloper() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get version => $_getSZ(6);
  @$pb.TagNumber(7)
  set version($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get supportEmail => $_getSZ(7);
  @$pb.TagNumber(8)
  set supportEmail($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSupportEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearSupportEmail() => clearField(8);

  @$pb.TagNumber(9)
  $2.Coin get costPerBlock => $_getN(8);
  @$pb.TagNumber(9)
  set costPerBlock($2.Coin v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasCostPerBlock() => $_has(8);
  @$pb.TagNumber(9)
  void clearCostPerBlock() => clearField(9);
  @$pb.TagNumber(9)
  $2.Coin ensureCostPerBlock() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.bool get enabled => $_getBF(9);
  @$pb.TagNumber(10)
  set enabled($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasEnabled() => $_has(9);
  @$pb.TagNumber(10)
  void clearEnabled() => clearField(10);
}

