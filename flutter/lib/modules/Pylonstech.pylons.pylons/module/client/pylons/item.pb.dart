///
//  Generated code. Do not modify.
//  source: pylons/item.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/cosmos/base/v1beta1/coin.pb.dart' as $2;

class DoubleKeyValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleKeyValue',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..hasRequiredFields = false;

  DoubleKeyValue._() : super();
  factory DoubleKeyValue() => create();
  factory DoubleKeyValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleKeyValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DoubleKeyValue clone() => DoubleKeyValue()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DoubleKeyValue copyWith(void Function(DoubleKeyValue) updates) => super.copyWith((message) => updates(message as DoubleKeyValue)) as DoubleKeyValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleKeyValue create() => DoubleKeyValue._();
  DoubleKeyValue createEmptyInstance() => create();
  static $pb.PbList<DoubleKeyValue> createRepeated() => $pb.PbList<DoubleKeyValue>();
  @$core.pragma('dart2js:noInline')
  static DoubleKeyValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleKeyValue>(create);
  static DoubleKeyValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class LongKeyValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongKeyValue',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..hasRequiredFields = false;

  LongKeyValue._() : super();
  factory LongKeyValue() => create();
  factory LongKeyValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LongKeyValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LongKeyValue clone() => LongKeyValue()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LongKeyValue copyWith(void Function(LongKeyValue) updates) => super.copyWith((message) => updates(message as LongKeyValue)) as LongKeyValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LongKeyValue create() => LongKeyValue._();
  LongKeyValue createEmptyInstance() => create();
  static $pb.PbList<LongKeyValue> createRepeated() => $pb.PbList<LongKeyValue>();
  @$core.pragma('dart2js:noInline')
  static LongKeyValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LongKeyValue>(create);
  static LongKeyValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get value => $_getI64(1);
  @$pb.TagNumber(2)
  set value($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class StringKeyValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringKeyValue',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..hasRequiredFields = false;

  StringKeyValue._() : super();
  factory StringKeyValue() => create();
  factory StringKeyValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StringKeyValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StringKeyValue clone() => StringKeyValue()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StringKeyValue copyWith(void Function(StringKeyValue) updates) => super.copyWith((message) => updates(message as StringKeyValue)) as StringKeyValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringKeyValue create() => StringKeyValue._();
  StringKeyValue createEmptyInstance() => create();
  static $pb.PbList<StringKeyValue> createRepeated() => $pb.PbList<StringKeyValue>();
  @$core.pragma('dart2js:noInline')
  static StringKeyValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StringKeyValue>(create);
  static StringKeyValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class Item extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Item',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'owner')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeVersion', protoName: 'nodeVersion')
    ..pc<DoubleKeyValue>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleKeyValue.create)
    ..pc<LongKeyValue>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongKeyValue.create)
    ..pc<StringKeyValue>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringKeyValue.create)
    ..pc<StringKeyValue>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mutableStrings', $pb.PbFieldType.PM, protoName: 'mutableStrings', subBuilder: StringKeyValue.create)
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeable')
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastUpdate', protoName: 'lastUpdate')
    ..pc<$2.Coin>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transferFee', $pb.PbFieldType.PM, protoName: 'transferFee', subBuilder: $2.Coin.create)
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradePercentage', protoName: 'tradePercentage')
    ..hasRequiredFields = false;

  Item._() : super();
  factory Item() => create();
  factory Item.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Item.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Item clone() => Item()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Item copyWith(void Function(Item) updates) => super.copyWith((message) => updates(message as Item)) as Item; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Item create() => Item._();
  Item createEmptyInstance() => create();
  static $pb.PbList<Item> createRepeated() => $pb.PbList<Item>();
  @$core.pragma('dart2js:noInline')
  static Item getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Item>(create);
  static Item? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get owner => $_getSZ(0);
  @$pb.TagNumber(1)
  set owner($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOwner() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwner() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookID => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookID($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCookbookID() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get iD => $_getSZ(2);
  @$pb.TagNumber(3)
  set iD($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasID() => $_has(2);
  @$pb.TagNumber(3)
  void clearID() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get nodeVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set nodeVersion($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasNodeVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearNodeVersion() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<DoubleKeyValue> get doubles => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<LongKeyValue> get longs => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<StringKeyValue> get strings => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<StringKeyValue> get mutableStrings => $_getList(7);

  @$pb.TagNumber(9)
  $core.bool get tradeable => $_getBF(8);
  @$pb.TagNumber(9)
  set tradeable($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasTradeable() => $_has(8);
  @$pb.TagNumber(9)
  void clearTradeable() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get lastUpdate => $_getI64(9);
  @$pb.TagNumber(10)
  set lastUpdate($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasLastUpdate() => $_has(9);
  @$pb.TagNumber(10)
  void clearLastUpdate() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<$2.Coin> get transferFee => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get tradePercentage => $_getSZ(11);
  @$pb.TagNumber(12)
  set tradePercentage($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasTradePercentage() => $_has(11);
  @$pb.TagNumber(12)
  void clearTradePercentage() => clearField(12);
}
