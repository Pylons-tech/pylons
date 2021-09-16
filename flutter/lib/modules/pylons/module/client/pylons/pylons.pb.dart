///
//  Generated code. Do not modify.
//  source: pylons/pylons.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'package:pylons_wallet/modules/pylons/module/client/cosmos/base/v1beta1/coin.pb.dart' as $2;

class EntriesList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EntriesList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<CoinOutput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinOutputs', $pb.PbFieldType.PM, protoName: 'CoinOutputs', subBuilder: CoinOutput.create)
    ..pc<ItemOutput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemOutputs', $pb.PbFieldType.PM, protoName: 'ItemOutputs', subBuilder: ItemOutput.create)
    ..pc<ItemModifyOutput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemModifyOutputs', $pb.PbFieldType.PM, protoName: 'ItemModifyOutputs', subBuilder: ItemModifyOutput.create)
    ..hasRequiredFields = false
  ;

  EntriesList._() : super();
  factory EntriesList() => create();
  factory EntriesList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntriesList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntriesList clone() => EntriesList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntriesList copyWith(void Function(EntriesList) updates) => super.copyWith((message) => updates(message as EntriesList)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EntriesList create() => EntriesList._();
  EntriesList createEmptyInstance() => create();
  static $pb.PbList<EntriesList> createRepeated() => $pb.PbList<EntriesList>();
  @$core.pragma('dart2js:noInline')
  static EntriesList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntriesList>(create);
  static EntriesList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CoinOutput> get coinOutputs => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<ItemOutput> get itemOutputs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<ItemModifyOutput> get itemModifyOutputs => $_getList(2);
}

class CoinInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Coin', protoName: 'Coin')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Count', protoName: 'Count')
    ..hasRequiredFields = false
  ;

  CoinInput._() : super();
  factory CoinInput() => create();
  factory CoinInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoinInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CoinInput clone() => CoinInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CoinInput copyWith(void Function(CoinInput) updates) => super.copyWith((message) => updates(message as CoinInput)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CoinInput create() => CoinInput._();
  CoinInput createEmptyInstance() => create();
  static $pb.PbList<CoinInput> createRepeated() => $pb.PbList<CoinInput>();
  @$core.pragma('dart2js:noInline')
  static CoinInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoinInput>(create);
  static CoinInput _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get coin => $_getSZ(0);
  @$pb.TagNumber(1)
  set coin($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoin() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoin() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get count => $_getI64(1);
  @$pb.TagNumber(2)
  set count($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => clearField(2);
}

class CoinOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Coin', protoName: 'Coin')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Count', protoName: 'Count')
    ..hasRequiredFields = false
  ;

  CoinOutput._() : super();
  factory CoinOutput() => create();
  factory CoinOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoinOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CoinOutput clone() => CoinOutput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CoinOutput copyWith(void Function(CoinOutput) updates) => super.copyWith((message) => updates(message as CoinOutput)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CoinOutput create() => CoinOutput._();
  CoinOutput createEmptyInstance() => create();
  static $pb.PbList<CoinOutput> createRepeated() => $pb.PbList<CoinOutput>();
  @$core.pragma('dart2js:noInline')
  static CoinOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoinOutput>(create);
  static CoinOutput _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get coin => $_getSZ(1);
  @$pb.TagNumber(2)
  set coin($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCoin() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoin() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get count => $_getSZ(2);
  @$pb.TagNumber(3)
  set count($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => clearField(3);
}

class DoubleInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleInputParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'MinValue', protoName: 'MinValue')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'MaxValue', protoName: 'MaxValue')
    ..hasRequiredFields = false
  ;

  DoubleInputParam._() : super();
  factory DoubleInputParam() => create();
  factory DoubleInputParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleInputParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DoubleInputParam clone() => DoubleInputParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DoubleInputParam copyWith(void Function(DoubleInputParam) updates) => super.copyWith((message) => updates(message as DoubleInputParam)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleInputParam create() => DoubleInputParam._();
  DoubleInputParam createEmptyInstance() => create();
  static $pb.PbList<DoubleInputParam> createRepeated() => $pb.PbList<DoubleInputParam>();
  @$core.pragma('dart2js:noInline')
  static DoubleInputParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleInputParam>(create);
  static DoubleInputParam _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get minValue => $_getSZ(1);
  @$pb.TagNumber(2)
  set minValue($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get maxValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set maxValue($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxValue() => clearField(3);
}

class DoubleWeightRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleWeightRange', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Lower', protoName: 'Lower')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Upper', protoName: 'Upper')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Weight', protoName: 'Weight')
    ..hasRequiredFields = false
  ;

  DoubleWeightRange._() : super();
  factory DoubleWeightRange() => create();
  factory DoubleWeightRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleWeightRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DoubleWeightRange clone() => DoubleWeightRange()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DoubleWeightRange copyWith(void Function(DoubleWeightRange) updates) => super.copyWith((message) => updates(message as DoubleWeightRange)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleWeightRange create() => DoubleWeightRange._();
  DoubleWeightRange createEmptyInstance() => create();
  static $pb.PbList<DoubleWeightRange> createRepeated() => $pb.PbList<DoubleWeightRange>();
  @$core.pragma('dart2js:noInline')
  static DoubleWeightRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleWeightRange>(create);
  static DoubleWeightRange _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lower => $_getSZ(0);
  @$pb.TagNumber(1)
  set lower($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLower() => $_has(0);
  @$pb.TagNumber(1)
  void clearLower() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get upper => $_getSZ(1);
  @$pb.TagNumber(2)
  set upper($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpper() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpper() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get weight => $_getI64(2);
  @$pb.TagNumber(3)
  set weight($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => clearField(3);
}

class LongParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Rate', protoName: 'Rate')
    ..pc<IntWeightRange>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'WeightRanges', $pb.PbFieldType.PM, protoName: 'WeightRanges', subBuilder: IntWeightRange.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Program', protoName: 'Program')
    ..hasRequiredFields = false
  ;

  LongParam._() : super();
  factory LongParam() => create();
  factory LongParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LongParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LongParam clone() => LongParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LongParam copyWith(void Function(LongParam) updates) => super.copyWith((message) => updates(message as LongParam)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LongParam create() => LongParam._();
  LongParam createEmptyInstance() => create();
  static $pb.PbList<LongParam> createRepeated() => $pb.PbList<LongParam>();
  @$core.pragma('dart2js:noInline')
  static LongParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LongParam>(create);
  static LongParam _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get rate => $_getSZ(1);
  @$pb.TagNumber(2)
  set rate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearRate() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<IntWeightRange> get weightRanges => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get program => $_getSZ(3);
  @$pb.TagNumber(4)
  set program($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProgram() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgram() => clearField(4);
}

class IntWeightRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IntWeightRange', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Lower', protoName: 'Lower')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Upper', protoName: 'Upper')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Weight', protoName: 'Weight')
    ..hasRequiredFields = false
  ;

  IntWeightRange._() : super();
  factory IntWeightRange() => create();
  factory IntWeightRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IntWeightRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IntWeightRange clone() => IntWeightRange()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IntWeightRange copyWith(void Function(IntWeightRange) updates) => super.copyWith((message) => updates(message as IntWeightRange)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IntWeightRange create() => IntWeightRange._();
  IntWeightRange createEmptyInstance() => create();
  static $pb.PbList<IntWeightRange> createRepeated() => $pb.PbList<IntWeightRange>();
  @$core.pragma('dart2js:noInline')
  static IntWeightRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IntWeightRange>(create);
  static IntWeightRange _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lower => $_getI64(0);
  @$pb.TagNumber(1)
  set lower($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLower() => $_has(0);
  @$pb.TagNumber(1)
  void clearLower() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get upper => $_getI64(1);
  @$pb.TagNumber(2)
  set upper($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpper() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpper() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get weight => $_getI64(2);
  @$pb.TagNumber(3)
  set weight($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => clearField(3);
}

class StringInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringInputParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..hasRequiredFields = false
  ;

  StringInputParam._() : super();
  factory StringInputParam() => create();
  factory StringInputParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StringInputParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StringInputParam clone() => StringInputParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StringInputParam copyWith(void Function(StringInputParam) updates) => super.copyWith((message) => updates(message as StringInputParam)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringInputParam create() => StringInputParam._();
  StringInputParam createEmptyInstance() => create();
  static $pb.PbList<StringInputParam> createRepeated() => $pb.PbList<StringInputParam>();
  @$core.pragma('dart2js:noInline')
  static StringInputParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StringInputParam>(create);
  static StringInputParam _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class FeeInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FeeInputParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'MinValue', protoName: 'MinValue')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'MaxValue', protoName: 'MaxValue')
    ..hasRequiredFields = false
  ;

  FeeInputParam._() : super();
  factory FeeInputParam() => create();
  factory FeeInputParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeeInputParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeeInputParam clone() => FeeInputParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeeInputParam copyWith(void Function(FeeInputParam) updates) => super.copyWith((message) => updates(message as FeeInputParam)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FeeInputParam create() => FeeInputParam._();
  FeeInputParam createEmptyInstance() => create();
  static $pb.PbList<FeeInputParam> createRepeated() => $pb.PbList<FeeInputParam>();
  @$core.pragma('dart2js:noInline')
  static FeeInputParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeeInputParam>(create);
  static FeeInputParam _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get minValue => $_getI64(0);
  @$pb.TagNumber(1)
  set minValue($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinValue() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxValue => $_getI64(1);
  @$pb.TagNumber(2)
  set maxValue($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxValue() => clearField(2);
}

class LongInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongInputParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'MinValue', protoName: 'MinValue')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'MaxValue', protoName: 'MaxValue')
    ..hasRequiredFields = false
  ;

  LongInputParam._() : super();
  factory LongInputParam() => create();
  factory LongInputParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LongInputParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LongInputParam clone() => LongInputParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LongInputParam copyWith(void Function(LongInputParam) updates) => super.copyWith((message) => updates(message as LongInputParam)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LongInputParam create() => LongInputParam._();
  LongInputParam createEmptyInstance() => create();
  static $pb.PbList<LongInputParam> createRepeated() => $pb.PbList<LongInputParam>();
  @$core.pragma('dart2js:noInline')
  static LongInputParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LongInputParam>(create);
  static LongInputParam _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get minValue => $_getI64(1);
  @$pb.TagNumber(2)
  set minValue($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinValue() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get maxValue => $_getI64(2);
  @$pb.TagNumber(3)
  set maxValue($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxValue() => clearField(3);
}

class ConditionList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConditionList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<DoubleInputParam>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Doubles', $pb.PbFieldType.PM, protoName: 'Doubles', subBuilder: DoubleInputParam.create)
    ..pc<LongInputParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Longs', $pb.PbFieldType.PM, protoName: 'Longs', subBuilder: LongInputParam.create)
    ..pc<StringInputParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Strings', $pb.PbFieldType.PM, protoName: 'Strings', subBuilder: StringInputParam.create)
    ..hasRequiredFields = false
  ;

  ConditionList._() : super();
  factory ConditionList() => create();
  factory ConditionList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConditionList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConditionList clone() => ConditionList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConditionList copyWith(void Function(ConditionList) updates) => super.copyWith((message) => updates(message as ConditionList)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConditionList create() => ConditionList._();
  ConditionList createEmptyInstance() => create();
  static $pb.PbList<ConditionList> createRepeated() => $pb.PbList<ConditionList>();
  @$core.pragma('dart2js:noInline')
  static ConditionList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConditionList>(create);
  static ConditionList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DoubleInputParam> get doubles => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<LongInputParam> get longs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<StringInputParam> get strings => $_getList(2);
}

class ItemInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<DoubleInputParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Doubles', $pb.PbFieldType.PM, protoName: 'Doubles', subBuilder: DoubleInputParam.create)
    ..pc<LongInputParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Longs', $pb.PbFieldType.PM, protoName: 'Longs', subBuilder: LongInputParam.create)
    ..pc<StringInputParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Strings', $pb.PbFieldType.PM, protoName: 'Strings', subBuilder: StringInputParam.create)
    ..aOM<FeeInputParam>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TransferFee', protoName: 'TransferFee', subBuilder: FeeInputParam.create)
    ..aOM<ConditionList>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Conditions', protoName: 'Conditions', subBuilder: ConditionList.create)
    ..hasRequiredFields = false
  ;

  ItemInput._() : super();
  factory ItemInput() => create();
  factory ItemInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemInput clone() => ItemInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemInput copyWith(void Function(ItemInput) updates) => super.copyWith((message) => updates(message as ItemInput)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemInput create() => ItemInput._();
  ItemInput createEmptyInstance() => create();
  static $pb.PbList<ItemInput> createRepeated() => $pb.PbList<ItemInput>();
  @$core.pragma('dart2js:noInline')
  static ItemInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemInput>(create);
  static ItemInput _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DoubleInputParam> get doubles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<LongInputParam> get longs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<StringInputParam> get strings => $_getList(3);

  @$pb.TagNumber(5)
  FeeInputParam get transferFee => $_getN(4);
  @$pb.TagNumber(5)
  set transferFee(FeeInputParam v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTransferFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearTransferFee() => clearField(5);
  @$pb.TagNumber(5)
  FeeInputParam ensureTransferFee() => $_ensure(4);

  @$pb.TagNumber(6)
  ConditionList get conditions => $_getN(5);
  @$pb.TagNumber(6)
  set conditions(ConditionList v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasConditions() => $_has(5);
  @$pb.TagNumber(6)
  void clearConditions() => clearField(6);
  @$pb.TagNumber(6)
  ConditionList ensureConditions() => $_ensure(5);
}

class WeightedOutputs extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WeightedOutputs', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'EntryIDs', protoName: 'EntryIDs')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Weight', protoName: 'Weight')
    ..hasRequiredFields = false
  ;

  WeightedOutputs._() : super();
  factory WeightedOutputs() => create();
  factory WeightedOutputs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WeightedOutputs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WeightedOutputs clone() => WeightedOutputs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WeightedOutputs copyWith(void Function(WeightedOutputs) updates) => super.copyWith((message) => updates(message as WeightedOutputs)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WeightedOutputs create() => WeightedOutputs._();
  WeightedOutputs createEmptyInstance() => create();
  static $pb.PbList<WeightedOutputs> createRepeated() => $pb.PbList<WeightedOutputs>();
  @$core.pragma('dart2js:noInline')
  static WeightedOutputs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WeightedOutputs>(create);
  static WeightedOutputs _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get entryIDs => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get weight => $_getSZ(1);
  @$pb.TagNumber(2)
  set weight($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeight() => clearField(2);
}

class StringParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Rate', protoName: 'Rate')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Program', protoName: 'Program')
    ..hasRequiredFields = false
  ;

  StringParam._() : super();
  factory StringParam() => create();
  factory StringParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StringParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StringParam clone() => StringParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StringParam copyWith(void Function(StringParam) updates) => super.copyWith((message) => updates(message as StringParam)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringParam create() => StringParam._();
  StringParam createEmptyInstance() => create();
  static $pb.PbList<StringParam> createRepeated() => $pb.PbList<StringParam>();
  @$core.pragma('dart2js:noInline')
  static StringParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StringParam>(create);
  static StringParam _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rate => $_getSZ(0);
  @$pb.TagNumber(1)
  set rate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearRate() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get value => $_getSZ(2);
  @$pb.TagNumber(3)
  set value($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get program => $_getSZ(3);
  @$pb.TagNumber(4)
  set program($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProgram() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgram() => clearField(4);
}

class DoubleParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Rate', protoName: 'Rate')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..pc<DoubleWeightRange>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'WeightRanges', $pb.PbFieldType.PM, protoName: 'WeightRanges', subBuilder: DoubleWeightRange.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Program', protoName: 'Program')
    ..hasRequiredFields = false
  ;

  DoubleParam._() : super();
  factory DoubleParam() => create();
  factory DoubleParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DoubleParam clone() => DoubleParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DoubleParam copyWith(void Function(DoubleParam) updates) => super.copyWith((message) => updates(message as DoubleParam)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleParam create() => DoubleParam._();
  DoubleParam createEmptyInstance() => create();
  static $pb.PbList<DoubleParam> createRepeated() => $pb.PbList<DoubleParam>();
  @$core.pragma('dart2js:noInline')
  static DoubleParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleParam>(create);
  static DoubleParam _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rate => $_getSZ(0);
  @$pb.TagNumber(1)
  set rate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearRate() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<DoubleWeightRange> get weightRanges => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get program => $_getSZ(3);
  @$pb.TagNumber(4)
  set program($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProgram() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgram() => clearField(4);
}

class ItemOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<DoubleParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Doubles', $pb.PbFieldType.PM, protoName: 'Doubles', subBuilder: DoubleParam.create)
    ..pc<LongParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Longs', $pb.PbFieldType.PM, protoName: 'Longs', subBuilder: LongParam.create)
    ..pc<StringParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Strings', $pb.PbFieldType.PM, protoName: 'Strings', subBuilder: StringParam.create)
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TransferFee', protoName: 'TransferFee')
    ..hasRequiredFields = false
  ;

  ItemOutput._() : super();
  factory ItemOutput() => create();
  factory ItemOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemOutput clone() => ItemOutput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemOutput copyWith(void Function(ItemOutput) updates) => super.copyWith((message) => updates(message as ItemOutput)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemOutput create() => ItemOutput._();
  ItemOutput createEmptyInstance() => create();
  static $pb.PbList<ItemOutput> createRepeated() => $pb.PbList<ItemOutput>();
  @$core.pragma('dart2js:noInline')
  static ItemOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemOutput>(create);
  static ItemOutput _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DoubleParam> get doubles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<LongParam> get longs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<StringParam> get strings => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get transferFee => $_getI64(4);
  @$pb.TagNumber(5)
  set transferFee($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTransferFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearTransferFee() => clearField(5);
}

class ItemModifyOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemModifyOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputRef', protoName: 'ItemInputRef')
    ..pc<DoubleParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Doubles', $pb.PbFieldType.PM, protoName: 'Doubles', subBuilder: DoubleParam.create)
    ..pc<LongParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Longs', $pb.PbFieldType.PM, protoName: 'Longs', subBuilder: LongParam.create)
    ..pc<StringParam>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Strings', $pb.PbFieldType.PM, protoName: 'Strings', subBuilder: StringParam.create)
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TransferFee', protoName: 'TransferFee')
    ..hasRequiredFields = false
  ;

  ItemModifyOutput._() : super();
  factory ItemModifyOutput() => create();
  factory ItemModifyOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemModifyOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemModifyOutput clone() => ItemModifyOutput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemModifyOutput copyWith(void Function(ItemModifyOutput) updates) => super.copyWith((message) => updates(message as ItemModifyOutput)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemModifyOutput create() => ItemModifyOutput._();
  ItemModifyOutput createEmptyInstance() => create();
  static $pb.PbList<ItemModifyOutput> createRepeated() => $pb.PbList<ItemModifyOutput>();
  @$core.pragma('dart2js:noInline')
  static ItemModifyOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemModifyOutput>(create);
  static ItemModifyOutput _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemInputRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemInputRef($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasItemInputRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemInputRef() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<DoubleParam> get doubles => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<LongParam> get longs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<StringParam> get strings => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get transferFee => $_getI64(5);
  @$pb.TagNumber(6)
  set transferFee($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTransferFee() => $_has(5);
  @$pb.TagNumber(6)
  void clearTransferFee() => clearField(6);
}

class ItemModifyParams extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemModifyParams', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<DoubleParam>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Doubles', $pb.PbFieldType.PM, protoName: 'Doubles', subBuilder: DoubleParam.create)
    ..pc<LongParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Longs', $pb.PbFieldType.PM, protoName: 'Longs', subBuilder: LongParam.create)
    ..pc<StringParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Strings', $pb.PbFieldType.PM, protoName: 'Strings', subBuilder: StringParam.create)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TransferFee', protoName: 'TransferFee')
    ..hasRequiredFields = false
  ;

  ItemModifyParams._() : super();
  factory ItemModifyParams() => create();
  factory ItemModifyParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemModifyParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemModifyParams clone() => ItemModifyParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemModifyParams copyWith(void Function(ItemModifyParams) updates) => super.copyWith((message) => updates(message as ItemModifyParams)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemModifyParams create() => ItemModifyParams._();
  ItemModifyParams createEmptyInstance() => create();
  static $pb.PbList<ItemModifyParams> createRepeated() => $pb.PbList<ItemModifyParams>();
  @$core.pragma('dart2js:noInline')
  static ItemModifyParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemModifyParams>(create);
  static ItemModifyParams _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DoubleParam> get doubles => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<LongParam> get longs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<StringParam> get strings => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get transferFee => $_getI64(3);
  @$pb.TagNumber(4)
  set transferFee($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTransferFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransferFee() => clearField(4);
}

class Item extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Item', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<DoubleKeyValue>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Doubles', $pb.PbFieldType.PM, protoName: 'Doubles', subBuilder: DoubleKeyValue.create)
    ..pc<LongKeyValue>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Longs', $pb.PbFieldType.PM, protoName: 'Longs', subBuilder: LongKeyValue.create)
    ..pc<StringKeyValue>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Strings', $pb.PbFieldType.PM, protoName: 'Strings', subBuilder: StringKeyValue.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'OwnerRecipeID', protoName: 'OwnerRecipeID')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'OwnerTradeID', protoName: 'OwnerTradeID')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Tradable', protoName: 'Tradable')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'LastUpdate', protoName: 'LastUpdate')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TransferFee', protoName: 'TransferFee')
    ..hasRequiredFields = false
  ;

  Item._() : super();
  factory Item() => create();
  factory Item.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Item.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Item clone() => Item()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Item copyWith(void Function(Item) updates) => super.copyWith((message) => updates(message as Item)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Item create() => Item._();
  Item createEmptyInstance() => create();
  static $pb.PbList<Item> createRepeated() => $pb.PbList<Item>();
  @$core.pragma('dart2js:noInline')
  static Item getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Item>(create);
  static Item _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<DoubleKeyValue> get doubles => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<LongKeyValue> get longs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<StringKeyValue> get strings => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get cookbookID => $_getSZ(5);
  @$pb.TagNumber(6)
  set cookbookID($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCookbookID() => $_has(5);
  @$pb.TagNumber(6)
  void clearCookbookID() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get sender => $_getSZ(6);
  @$pb.TagNumber(7)
  set sender($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSender() => $_has(6);
  @$pb.TagNumber(7)
  void clearSender() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get ownerRecipeID => $_getSZ(7);
  @$pb.TagNumber(8)
  set ownerRecipeID($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasOwnerRecipeID() => $_has(7);
  @$pb.TagNumber(8)
  void clearOwnerRecipeID() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get ownerTradeID => $_getSZ(8);
  @$pb.TagNumber(9)
  set ownerTradeID($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasOwnerTradeID() => $_has(8);
  @$pb.TagNumber(9)
  void clearOwnerTradeID() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get tradable => $_getBF(9);
  @$pb.TagNumber(10)
  set tradable($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTradable() => $_has(9);
  @$pb.TagNumber(10)
  void clearTradable() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get lastUpdate => $_getI64(10);
  @$pb.TagNumber(11)
  set lastUpdate($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasLastUpdate() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastUpdate() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get transferFee => $_getI64(11);
  @$pb.TagNumber(12)
  set transferFee($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasTransferFee() => $_has(11);
  @$pb.TagNumber(12)
  void clearTransferFee() => clearField(12);
}

class DoubleKeyValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleKeyValue', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..hasRequiredFields = false
  ;

  DoubleKeyValue._() : super();
  factory DoubleKeyValue() => create();
  factory DoubleKeyValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleKeyValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DoubleKeyValue clone() => DoubleKeyValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DoubleKeyValue copyWith(void Function(DoubleKeyValue) updates) => super.copyWith((message) => updates(message as DoubleKeyValue)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleKeyValue create() => DoubleKeyValue._();
  DoubleKeyValue createEmptyInstance() => create();
  static $pb.PbList<DoubleKeyValue> createRepeated() => $pb.PbList<DoubleKeyValue>();
  @$core.pragma('dart2js:noInline')
  static DoubleKeyValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleKeyValue>(create);
  static DoubleKeyValue _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class LongKeyValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongKeyValue', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..hasRequiredFields = false
  ;

  LongKeyValue._() : super();
  factory LongKeyValue() => create();
  factory LongKeyValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LongKeyValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LongKeyValue clone() => LongKeyValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LongKeyValue copyWith(void Function(LongKeyValue) updates) => super.copyWith((message) => updates(message as LongKeyValue)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LongKeyValue create() => LongKeyValue._();
  LongKeyValue createEmptyInstance() => create();
  static $pb.PbList<LongKeyValue> createRepeated() => $pb.PbList<LongKeyValue>();
  @$core.pragma('dart2js:noInline')
  static LongKeyValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LongKeyValue>(create);
  static LongKeyValue _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get value => $_getI64(1);
  @$pb.TagNumber(2)
  set value($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class StringKeyValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringKeyValue', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Key', protoName: 'Key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..hasRequiredFields = false
  ;

  StringKeyValue._() : super();
  factory StringKeyValue() => create();
  factory StringKeyValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StringKeyValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StringKeyValue clone() => StringKeyValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StringKeyValue copyWith(void Function(StringKeyValue) updates) => super.copyWith((message) => updates(message as StringKeyValue)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringKeyValue create() => StringKeyValue._();
  StringKeyValue createEmptyInstance() => create();
  static $pb.PbList<StringKeyValue> createRepeated() => $pb.PbList<StringKeyValue>();
  @$core.pragma('dart2js:noInline')
  static StringKeyValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StringKeyValue>(create);
  static StringKeyValue _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class TradeItemInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TradeItemInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOM<ItemInput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInput', protoName: 'ItemInput', subBuilder: ItemInput.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..hasRequiredFields = false
  ;

  TradeItemInput._() : super();
  factory TradeItemInput() => create();
  factory TradeItemInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TradeItemInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TradeItemInput clone() => TradeItemInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TradeItemInput copyWith(void Function(TradeItemInput) updates) => super.copyWith((message) => updates(message as TradeItemInput)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TradeItemInput create() => TradeItemInput._();
  TradeItemInput createEmptyInstance() => create();
  static $pb.PbList<TradeItemInput> createRepeated() => $pb.PbList<TradeItemInput>();
  @$core.pragma('dart2js:noInline')
  static TradeItemInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TradeItemInput>(create);
  static TradeItemInput _defaultInstance;

  @$pb.TagNumber(1)
  ItemInput get itemInput => $_getN(0);
  @$pb.TagNumber(1)
  set itemInput(ItemInput v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasItemInput() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemInput() => clearField(1);
  @$pb.TagNumber(1)
  ItemInput ensureItemInput() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get cookbookID => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookID() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookID() => clearField(2);
}

class LockedCoinDescribe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LockedCoinDescribe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<$2.Coin>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Amount', $pb.PbFieldType.PM, protoName: 'Amount', subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  LockedCoinDescribe._() : super();
  factory LockedCoinDescribe() => create();
  factory LockedCoinDescribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LockedCoinDescribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LockedCoinDescribe clone() => LockedCoinDescribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LockedCoinDescribe copyWith(void Function(LockedCoinDescribe) updates) => super.copyWith((message) => updates(message as LockedCoinDescribe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LockedCoinDescribe create() => LockedCoinDescribe._();
  LockedCoinDescribe createEmptyInstance() => create();
  static $pb.PbList<LockedCoinDescribe> createRepeated() => $pb.PbList<LockedCoinDescribe>();
  @$core.pragma('dart2js:noInline')
  static LockedCoinDescribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LockedCoinDescribe>(create);
  static LockedCoinDescribe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$2.Coin> get amount => $_getList(1);
}

class ShortenRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ShortenRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  ShortenRecipe._() : super();
  factory ShortenRecipe() => create();
  factory ShortenRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ShortenRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ShortenRecipe clone() => ShortenRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ShortenRecipe copyWith(void Function(ShortenRecipe) updates) => super.copyWith((message) => updates(message as ShortenRecipe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ShortenRecipe create() => ShortenRecipe._();
  ShortenRecipe createEmptyInstance() => create();
  static $pb.PbList<ShortenRecipe> createRepeated() => $pb.PbList<ShortenRecipe>();
  @$core.pragma('dart2js:noInline')
  static ShortenRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShortenRecipe>(create);
  static ShortenRecipe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookID => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookID() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sender => $_getSZ(4);
  @$pb.TagNumber(5)
  set sender($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSender() => $_has(4);
  @$pb.TagNumber(5)
  void clearSender() => clearField(5);
}

class Execution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Execution', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..pc<$2.Coin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: $2.Coin.create)
    ..pc<Item>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: Item.create)
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockHeight', protoName: 'BlockHeight')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Completed', protoName: 'Completed')
    ..hasRequiredFields = false
  ;

  Execution._() : super();
  factory Execution() => create();
  factory Execution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Execution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Execution clone() => Execution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Execution copyWith(void Function(Execution) updates) => super.copyWith((message) => updates(message as Execution)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Execution create() => Execution._();
  Execution createEmptyInstance() => create();
  static $pb.PbList<Execution> createRepeated() => $pb.PbList<Execution>();
  @$core.pragma('dart2js:noInline')
  static Execution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Execution>(create);
  static Execution _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipeID => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeID($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecipeID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeID() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get cookbookID => $_getSZ(3);
  @$pb.TagNumber(4)
  set cookbookID($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCookbookID() => $_has(3);
  @$pb.TagNumber(4)
  void clearCookbookID() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$2.Coin> get coinInputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<Item> get itemInputs => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get blockHeight => $_getI64(6);
  @$pb.TagNumber(7)
  set blockHeight($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBlockHeight() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockHeight() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sender => $_getSZ(7);
  @$pb.TagNumber(8)
  set sender($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSender() => $_has(7);
  @$pb.TagNumber(8)
  void clearSender() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get completed => $_getBF(8);
  @$pb.TagNumber(9)
  set completed($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCompleted() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompleted() => clearField(9);
}

class Cookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Cookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Version', protoName: 'Version')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Developer', protoName: 'Developer')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Level', protoName: 'Level')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'SupportEmail', protoName: 'SupportEmail')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CostPerBlock', protoName: 'CostPerBlock')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  Cookbook._() : super();
  factory Cookbook() => create();
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
  Cookbook copyWith(void Function(Cookbook) updates) => super.copyWith((message) => updates(message as Cookbook)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Cookbook create() => Cookbook._();
  Cookbook createEmptyInstance() => create();
  static $pb.PbList<Cookbook> createRepeated() => $pb.PbList<Cookbook>();
  @$core.pragma('dart2js:noInline')
  static Cookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cookbook>(create);
  static Cookbook _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get version => $_getSZ(4);
  @$pb.TagNumber(5)
  set version($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get developer => $_getSZ(5);
  @$pb.TagNumber(6)
  set developer($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDeveloper() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeveloper() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get level => $_getI64(6);
  @$pb.TagNumber(7)
  set level($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearLevel() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get supportEmail => $_getSZ(7);
  @$pb.TagNumber(8)
  set supportEmail($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSupportEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearSupportEmail() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get costPerBlock => $_getI64(8);
  @$pb.TagNumber(9)
  set costPerBlock($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCostPerBlock() => $_has(8);
  @$pb.TagNumber(9)
  void clearCostPerBlock() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get sender => $_getSZ(9);
  @$pb.TagNumber(10)
  set sender($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSender() => $_has(9);
  @$pb.TagNumber(10)
  void clearSender() => clearField(10);
}

class Recipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Recipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..pc<CoinInput>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: CoinInput.create)
    ..pc<ItemInput>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: ItemInput.create)
    ..aOM<EntriesList>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Entries', protoName: 'Entries', subBuilder: EntriesList.create)
    ..pc<WeightedOutputs>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Outputs', $pb.PbFieldType.PM, protoName: 'Outputs', subBuilder: WeightedOutputs.create)
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockInterval', protoName: 'BlockInterval')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Disabled', protoName: 'Disabled')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ExtraInfo', protoName: 'ExtraInfo')
    ..hasRequiredFields = false
  ;

  Recipe._() : super();
  factory Recipe() => create();
  factory Recipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Recipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Recipe clone() => Recipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Recipe copyWith(void Function(Recipe) updates) => super.copyWith((message) => updates(message as Recipe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Recipe create() => Recipe._();
  Recipe createEmptyInstance() => create();
  static $pb.PbList<Recipe> createRepeated() => $pb.PbList<Recipe>();
  @$core.pragma('dart2js:noInline')
  static Recipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Recipe>(create);
  static Recipe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get cookbookID => $_getSZ(2);
  @$pb.TagNumber(3)
  set cookbookID($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCookbookID() => $_has(2);
  @$pb.TagNumber(3)
  void clearCookbookID() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<CoinInput> get coinInputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<ItemInput> get itemInputs => $_getList(5);

  @$pb.TagNumber(7)
  EntriesList get entries => $_getN(6);
  @$pb.TagNumber(7)
  set entries(EntriesList v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasEntries() => $_has(6);
  @$pb.TagNumber(7)
  void clearEntries() => clearField(7);
  @$pb.TagNumber(7)
  EntriesList ensureEntries() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.List<WeightedOutputs> get outputs => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get blockInterval => $_getI64(9);
  @$pb.TagNumber(10)
  set blockInterval($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasBlockInterval() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlockInterval() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get sender => $_getSZ(10);
  @$pb.TagNumber(11)
  set sender($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSender() => $_has(10);
  @$pb.TagNumber(11)
  void clearSender() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get disabled => $_getBF(11);
  @$pb.TagNumber(12)
  set disabled($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasDisabled() => $_has(11);
  @$pb.TagNumber(12)
  void clearDisabled() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get extraInfo => $_getSZ(12);
  @$pb.TagNumber(13)
  set extraInfo($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasExtraInfo() => $_has(12);
  @$pb.TagNumber(13)
  void clearExtraInfo() => clearField(13);
}

class Trade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Trade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<CoinInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: CoinInput.create)
    ..pc<TradeItemInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: TradeItemInput.create)
    ..pc<$2.Coin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinOutputs', $pb.PbFieldType.PM, protoName: 'CoinOutputs', subBuilder: $2.Coin.create)
    ..pc<Item>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemOutputs', $pb.PbFieldType.PM, protoName: 'ItemOutputs', subBuilder: Item.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ExtraInfo', protoName: 'ExtraInfo')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'FulFiller', protoName: 'FulFiller')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Disabled', protoName: 'Disabled')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Completed', protoName: 'Completed')
    ..hasRequiredFields = false
  ;

  Trade._() : super();
  factory Trade() => create();
  factory Trade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Trade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Trade clone() => Trade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Trade copyWith(void Function(Trade) updates) => super.copyWith((message) => updates(message as Trade)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Trade create() => Trade._();
  Trade createEmptyInstance() => create();
  static $pb.PbList<Trade> createRepeated() => $pb.PbList<Trade>();
  @$core.pragma('dart2js:noInline')
  static Trade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Trade>(create);
  static Trade _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<CoinInput> get coinInputs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<TradeItemInput> get itemInputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$2.Coin> get coinOutputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<Item> get itemOutputs => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get extraInfo => $_getSZ(6);
  @$pb.TagNumber(7)
  set extraInfo($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasExtraInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearExtraInfo() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sender => $_getSZ(7);
  @$pb.TagNumber(8)
  set sender($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSender() => $_has(7);
  @$pb.TagNumber(8)
  void clearSender() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get fulFiller => $_getSZ(8);
  @$pb.TagNumber(9)
  set fulFiller($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFulFiller() => $_has(8);
  @$pb.TagNumber(9)
  void clearFulFiller() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get disabled => $_getBF(9);
  @$pb.TagNumber(10)
  set disabled($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDisabled() => $_has(9);
  @$pb.TagNumber(10)
  void clearDisabled() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get completed => $_getBF(10);
  @$pb.TagNumber(11)
  set completed($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCompleted() => $_has(10);
  @$pb.TagNumber(11)
  void clearCompleted() => clearField(11);
}

