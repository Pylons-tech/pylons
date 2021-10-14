///
//  Generated code. Do not modify.
//  source: pylons/recipe.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../cosmos/base/v1beta1/coin.pb.dart' as $2;
import 'item.pb.dart' as $3;

class DoubleInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleInputParam',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minValue', protoName: 'minValue')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxValue', protoName: 'maxValue')
    ..hasRequiredFields = false;

  DoubleInputParam._() : super();
  factory DoubleInputParam() => create();
  factory DoubleInputParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleInputParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DoubleInputParam clone() => DoubleInputParam()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DoubleInputParam copyWith(void Function(DoubleInputParam) updates) => super.copyWith((message) => updates(message as DoubleInputParam)) as DoubleInputParam; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleInputParam create() => DoubleInputParam._();
  DoubleInputParam createEmptyInstance() => create();
  static $pb.PbList<DoubleInputParam> createRepeated() => $pb.PbList<DoubleInputParam>();
  @$core.pragma('dart2js:noInline')
  static DoubleInputParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleInputParam>(create);
  static DoubleInputParam? _defaultInstance;

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
  $core.String get minValue => $_getSZ(1);
  @$pb.TagNumber(2)
  set minValue($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMinValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get maxValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set maxValue($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMaxValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxValue() => clearField(3);
}

class LongInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongInputParam',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minValue', protoName: 'minValue')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxValue', protoName: 'maxValue')
    ..hasRequiredFields = false;

  LongInputParam._() : super();
  factory LongInputParam() => create();
  factory LongInputParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LongInputParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LongInputParam clone() => LongInputParam()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LongInputParam copyWith(void Function(LongInputParam) updates) => super.copyWith((message) => updates(message as LongInputParam)) as LongInputParam; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LongInputParam create() => LongInputParam._();
  LongInputParam createEmptyInstance() => create();
  static $pb.PbList<LongInputParam> createRepeated() => $pb.PbList<LongInputParam>();
  @$core.pragma('dart2js:noInline')
  static LongInputParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LongInputParam>(create);
  static LongInputParam? _defaultInstance;

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
  $fixnum.Int64 get minValue => $_getI64(1);
  @$pb.TagNumber(2)
  set minValue($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMinValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinValue() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get maxValue => $_getI64(2);
  @$pb.TagNumber(3)
  set maxValue($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMaxValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxValue() => clearField(3);
}

class StringInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringInputParam',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false;

  StringInputParam._() : super();
  factory StringInputParam() => create();
  factory StringInputParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StringInputParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StringInputParam clone() => StringInputParam()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StringInputParam copyWith(void Function(StringInputParam) updates) => super.copyWith((message) => updates(message as StringInputParam)) as StringInputParam; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringInputParam create() => StringInputParam._();
  StringInputParam createEmptyInstance() => create();
  static $pb.PbList<StringInputParam> createRepeated() => $pb.PbList<StringInputParam>();
  @$core.pragma('dart2js:noInline')
  static StringInputParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StringInputParam>(create);
  static StringInputParam? _defaultInstance;

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

class ConditionList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConditionList',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<DoubleInputParam>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleInputParam.create)
    ..pc<LongInputParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongInputParam.create)
    ..pc<StringInputParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringInputParam.create)
    ..hasRequiredFields = false;

  ConditionList._() : super();
  factory ConditionList() => create();
  factory ConditionList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConditionList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConditionList clone() => ConditionList()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConditionList copyWith(void Function(ConditionList) updates) => super.copyWith((message) => updates(message as ConditionList)) as ConditionList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConditionList create() => ConditionList._();
  ConditionList createEmptyInstance() => create();
  static $pb.PbList<ConditionList> createRepeated() => $pb.PbList<ConditionList>();
  @$core.pragma('dart2js:noInline')
  static ConditionList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConditionList>(create);
  static ConditionList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DoubleInputParam> get doubles => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<LongInputParam> get longs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<StringInputParam> get strings => $_getList(2);
}

class ItemInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemInput',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<DoubleInputParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleInputParam.create)
    ..pc<LongInputParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongInputParam.create)
    ..pc<StringInputParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringInputParam.create)
    ..aOM<ConditionList>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'conditions', subBuilder: ConditionList.create)
    ..hasRequiredFields = false;

  ItemInput._() : super();
  factory ItemInput() => create();
  factory ItemInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ItemInput clone() => ItemInput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ItemInput copyWith(void Function(ItemInput) updates) => super.copyWith((message) => updates(message as ItemInput)) as ItemInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemInput create() => ItemInput._();
  ItemInput createEmptyInstance() => create();
  static $pb.PbList<ItemInput> createRepeated() => $pb.PbList<ItemInput>();
  @$core.pragma('dart2js:noInline')
  static ItemInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemInput>(create);
  static ItemInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) {
    $_setString(0, v);
  }

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
  ConditionList get conditions => $_getN(4);
  @$pb.TagNumber(5)
  set conditions(ConditionList v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasConditions() => $_has(4);
  @$pb.TagNumber(5)
  void clearConditions() => clearField(5);
  @$pb.TagNumber(5)
  ConditionList ensureConditions() => $_ensure(4);
}

class DoubleWeightRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleWeightRange',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lower')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'upper')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  DoubleWeightRange._() : super();
  factory DoubleWeightRange() => create();
  factory DoubleWeightRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleWeightRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DoubleWeightRange clone() => DoubleWeightRange()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DoubleWeightRange copyWith(void Function(DoubleWeightRange) updates) => super.copyWith((message) => updates(message as DoubleWeightRange)) as DoubleWeightRange; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleWeightRange create() => DoubleWeightRange._();
  DoubleWeightRange createEmptyInstance() => create();
  static $pb.PbList<DoubleWeightRange> createRepeated() => $pb.PbList<DoubleWeightRange>();
  @$core.pragma('dart2js:noInline')
  static DoubleWeightRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleWeightRange>(create);
  static DoubleWeightRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lower => $_getSZ(0);
  @$pb.TagNumber(1)
  set lower($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLower() => $_has(0);
  @$pb.TagNumber(1)
  void clearLower() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get upper => $_getSZ(1);
  @$pb.TagNumber(2)
  set upper($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUpper() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpper() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get weight => $_getI64(2);
  @$pb.TagNumber(3)
  set weight($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => clearField(3);
}

class DoubleParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleParam',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rate')
    ..pc<DoubleWeightRange>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weightRanges', $pb.PbFieldType.PM, protoName: 'weightRanges', subBuilder: DoubleWeightRange.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false;

  DoubleParam._() : super();
  factory DoubleParam() => create();
  factory DoubleParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DoubleParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DoubleParam clone() => DoubleParam()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DoubleParam copyWith(void Function(DoubleParam) updates) => super.copyWith((message) => updates(message as DoubleParam)) as DoubleParam; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleParam create() => DoubleParam._();
  DoubleParam createEmptyInstance() => create();
  static $pb.PbList<DoubleParam> createRepeated() => $pb.PbList<DoubleParam>();
  @$core.pragma('dart2js:noInline')
  static DoubleParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoubleParam>(create);
  static DoubleParam? _defaultInstance;

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
  $core.String get rate => $_getSZ(1);
  @$pb.TagNumber(2)
  set rate($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearRate() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<DoubleWeightRange> get weightRanges => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get program => $_getSZ(3);
  @$pb.TagNumber(4)
  set program($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasProgram() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgram() => clearField(4);
}

class IntWeightRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IntWeightRange',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lower')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'upper')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  IntWeightRange._() : super();
  factory IntWeightRange() => create();
  factory IntWeightRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IntWeightRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  IntWeightRange clone() => IntWeightRange()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  IntWeightRange copyWith(void Function(IntWeightRange) updates) => super.copyWith((message) => updates(message as IntWeightRange)) as IntWeightRange; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IntWeightRange create() => IntWeightRange._();
  IntWeightRange createEmptyInstance() => create();
  static $pb.PbList<IntWeightRange> createRepeated() => $pb.PbList<IntWeightRange>();
  @$core.pragma('dart2js:noInline')
  static IntWeightRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IntWeightRange>(create);
  static IntWeightRange? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lower => $_getI64(0);
  @$pb.TagNumber(1)
  set lower($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLower() => $_has(0);
  @$pb.TagNumber(1)
  void clearLower() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get upper => $_getI64(1);
  @$pb.TagNumber(2)
  set upper($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUpper() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpper() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get weight => $_getI64(2);
  @$pb.TagNumber(3)
  set weight($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => clearField(3);
}

class LongParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongParam',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rate')
    ..pc<IntWeightRange>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weightRanges', $pb.PbFieldType.PM, protoName: 'weightRanges', subBuilder: IntWeightRange.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false;

  LongParam._() : super();
  factory LongParam() => create();
  factory LongParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LongParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LongParam clone() => LongParam()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LongParam copyWith(void Function(LongParam) updates) => super.copyWith((message) => updates(message as LongParam)) as LongParam; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LongParam create() => LongParam._();
  LongParam createEmptyInstance() => create();
  static $pb.PbList<LongParam> createRepeated() => $pb.PbList<LongParam>();
  @$core.pragma('dart2js:noInline')
  static LongParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LongParam>(create);
  static LongParam? _defaultInstance;

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
  $core.String get rate => $_getSZ(1);
  @$pb.TagNumber(2)
  set rate($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearRate() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<IntWeightRange> get weightRanges => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get program => $_getSZ(3);
  @$pb.TagNumber(4)
  set program($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasProgram() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgram() => clearField(4);
}

class StringParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringParam',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rate')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false;

  StringParam._() : super();
  factory StringParam() => create();
  factory StringParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StringParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StringParam clone() => StringParam()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StringParam copyWith(void Function(StringParam) updates) => super.copyWith((message) => updates(message as StringParam)) as StringParam; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringParam create() => StringParam._();
  StringParam createEmptyInstance() => create();
  static $pb.PbList<StringParam> createRepeated() => $pb.PbList<StringParam>();
  @$core.pragma('dart2js:noInline')
  static StringParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StringParam>(create);
  static StringParam? _defaultInstance;

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
  $core.String get rate => $_getSZ(1);
  @$pb.TagNumber(2)
  set rate($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearRate() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get value => $_getSZ(2);
  @$pb.TagNumber(3)
  set value($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get program => $_getSZ(3);
  @$pb.TagNumber(4)
  set program($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasProgram() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgram() => clearField(4);
}

class CoinOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinOutput',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOM<$2.Coin>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', subBuilder: $2.Coin.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false;

  CoinOutput._() : super();
  factory CoinOutput() => create();
  factory CoinOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoinOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CoinOutput clone() => CoinOutput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CoinOutput copyWith(void Function(CoinOutput) updates) => super.copyWith((message) => updates(message as CoinOutput)) as CoinOutput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CoinOutput create() => CoinOutput._();
  CoinOutput createEmptyInstance() => create();
  static $pb.PbList<CoinOutput> createRepeated() => $pb.PbList<CoinOutput>();
  @$core.pragma('dart2js:noInline')
  static CoinOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoinOutput>(create);
  static CoinOutput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $2.Coin get coin => $_getN(1);
  @$pb.TagNumber(2)
  set coin($2.Coin v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCoin() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoin() => clearField(2);
  @$pb.TagNumber(2)
  $2.Coin ensureCoin() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get program => $_getSZ(2);
  @$pb.TagNumber(3)
  set program($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProgram() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgram() => clearField(3);
}

class ItemOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemOutput',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<DoubleParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleParam.create)
    ..pc<LongParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongParam.create)
    ..pc<StringParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringParam.create)
    ..pc<$3.StringKeyValue>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mutableStrings', $pb.PbFieldType.PM,
        protoName: 'mutableStrings', subBuilder: $3.StringKeyValue.create)
    ..pc<$2.Coin>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transferFee', $pb.PbFieldType.PM, protoName: 'transferFee', subBuilder: $2.Coin.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradePercentage', protoName: 'tradePercentage')
    ..a<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quantity', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountMinted', $pb.PbFieldType.OU6, protoName: 'amountMinted', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeable')
    ..hasRequiredFields = false;

  ItemOutput._() : super();
  factory ItemOutput() => create();
  factory ItemOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ItemOutput clone() => ItemOutput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ItemOutput copyWith(void Function(ItemOutput) updates) => super.copyWith((message) => updates(message as ItemOutput)) as ItemOutput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemOutput create() => ItemOutput._();
  ItemOutput createEmptyInstance() => create();
  static $pb.PbList<ItemOutput> createRepeated() => $pb.PbList<ItemOutput>();
  @$core.pragma('dart2js:noInline')
  static ItemOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemOutput>(create);
  static ItemOutput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) {
    $_setString(0, v);
  }

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
  $core.List<$3.StringKeyValue> get mutableStrings => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$2.Coin> get transferFee => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get tradePercentage => $_getSZ(6);
  @$pb.TagNumber(7)
  set tradePercentage($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTradePercentage() => $_has(6);
  @$pb.TagNumber(7)
  void clearTradePercentage() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get quantity => $_getI64(7);
  @$pb.TagNumber(8)
  set quantity($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasQuantity() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuantity() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get amountMinted => $_getI64(8);
  @$pb.TagNumber(9)
  set amountMinted($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasAmountMinted() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmountMinted() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get tradeable => $_getBF(9);
  @$pb.TagNumber(10)
  set tradeable($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasTradeable() => $_has(9);
  @$pb.TagNumber(10)
  void clearTradeable() => clearField(10);
}

class ItemModifyOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemModifyOutput',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputRef', protoName: 'itemInputRef')
    ..pc<DoubleParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleParam.create)
    ..pc<LongParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongParam.create)
    ..pc<StringParam>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringParam.create)
    ..pc<$3.StringKeyValue>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mutableStrings', $pb.PbFieldType.PM,
        protoName: 'mutableStrings', subBuilder: $3.StringKeyValue.create)
    ..pc<$2.Coin>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transferFee', $pb.PbFieldType.PM, protoName: 'transferFee', subBuilder: $2.Coin.create)
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradePercentage', protoName: 'tradePercentage')
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quantity', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountMinted', $pb.PbFieldType.OU6, protoName: 'amountMinted', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeable')
    ..hasRequiredFields = false;

  ItemModifyOutput._() : super();
  factory ItemModifyOutput() => create();
  factory ItemModifyOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemModifyOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ItemModifyOutput clone() => ItemModifyOutput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ItemModifyOutput copyWith(void Function(ItemModifyOutput) updates) => super.copyWith((message) => updates(message as ItemModifyOutput)) as ItemModifyOutput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemModifyOutput create() => ItemModifyOutput._();
  ItemModifyOutput createEmptyInstance() => create();
  static $pb.PbList<ItemModifyOutput> createRepeated() => $pb.PbList<ItemModifyOutput>();
  @$core.pragma('dart2js:noInline')
  static ItemModifyOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemModifyOutput>(create);
  static ItemModifyOutput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemInputRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemInputRef($core.String v) {
    $_setString(1, v);
  }

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
  $core.List<$3.StringKeyValue> get mutableStrings => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<$2.Coin> get transferFee => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get tradePercentage => $_getSZ(7);
  @$pb.TagNumber(8)
  set tradePercentage($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasTradePercentage() => $_has(7);
  @$pb.TagNumber(8)
  void clearTradePercentage() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get quantity => $_getI64(8);
  @$pb.TagNumber(9)
  set quantity($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasQuantity() => $_has(8);
  @$pb.TagNumber(9)
  void clearQuantity() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get amountMinted => $_getI64(9);
  @$pb.TagNumber(10)
  set amountMinted($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasAmountMinted() => $_has(9);
  @$pb.TagNumber(10)
  void clearAmountMinted() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get tradeable => $_getBF(10);
  @$pb.TagNumber(11)
  set tradeable($core.bool v) {
    $_setBool(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasTradeable() => $_has(10);
  @$pb.TagNumber(11)
  void clearTradeable() => clearField(11);
}

class EntriesList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EntriesList',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<CoinOutput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinOutputs', $pb.PbFieldType.PM, protoName: 'coinOutputs', subBuilder: CoinOutput.create)
    ..pc<ItemOutput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemOutputs', $pb.PbFieldType.PM, protoName: 'itemOutputs', subBuilder: ItemOutput.create)
    ..pc<ItemModifyOutput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemModifyOutputs', $pb.PbFieldType.PM,
        protoName: 'itemModifyOutputs', subBuilder: ItemModifyOutput.create)
    ..hasRequiredFields = false;

  EntriesList._() : super();
  factory EntriesList() => create();
  factory EntriesList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntriesList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  EntriesList clone() => EntriesList()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  EntriesList copyWith(void Function(EntriesList) updates) => super.copyWith((message) => updates(message as EntriesList)) as EntriesList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EntriesList create() => EntriesList._();
  EntriesList createEmptyInstance() => create();
  static $pb.PbList<EntriesList> createRepeated() => $pb.PbList<EntriesList>();
  @$core.pragma('dart2js:noInline')
  static EntriesList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntriesList>(create);
  static EntriesList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CoinOutput> get coinOutputs => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<ItemOutput> get itemOutputs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<ItemModifyOutput> get itemModifyOutputs => $_getList(2);
}

class WeightedOutputs extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WeightedOutputs',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entryIDs', protoName: 'entryIDs')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  WeightedOutputs._() : super();
  factory WeightedOutputs() => create();
  factory WeightedOutputs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WeightedOutputs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WeightedOutputs clone() => WeightedOutputs()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WeightedOutputs copyWith(void Function(WeightedOutputs) updates) => super.copyWith((message) => updates(message as WeightedOutputs)) as WeightedOutputs; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WeightedOutputs create() => WeightedOutputs._();
  WeightedOutputs createEmptyInstance() => create();
  static $pb.PbList<WeightedOutputs> createRepeated() => $pb.PbList<WeightedOutputs>();
  @$core.pragma('dart2js:noInline')
  static WeightedOutputs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WeightedOutputs>(create);
  static WeightedOutputs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get entryIDs => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get weight => $_getI64(1);
  @$pb.TagNumber(2)
  set weight($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasWeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeight() => clearField(2);
}

class CoinInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinInput',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<$2.Coin>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coins', $pb.PbFieldType.PM, subBuilder: $2.Coin.create)
    ..hasRequiredFields = false;

  CoinInput._() : super();
  factory CoinInput() => create();
  factory CoinInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoinInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CoinInput clone() => CoinInput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CoinInput copyWith(void Function(CoinInput) updates) => super.copyWith((message) => updates(message as CoinInput)) as CoinInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CoinInput create() => CoinInput._();
  CoinInput createEmptyInstance() => create();
  static $pb.PbList<CoinInput> createRepeated() => $pb.PbList<CoinInput>();
  @$core.pragma('dart2js:noInline')
  static CoinInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoinInput>(create);
  static CoinInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$2.Coin> get coins => $_getList(0);
}

class Recipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Recipe',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeVersion', protoName: 'nodeVersion')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..pc<CoinInput>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, protoName: 'coinInputs', subBuilder: CoinInput.create)
    ..pc<ItemInput>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, protoName: 'itemInputs', subBuilder: ItemInput.create)
    ..aOM<EntriesList>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entries', subBuilder: EntriesList.create)
    ..pc<WeightedOutputs>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: WeightedOutputs.create)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockInterval', protoName: 'blockInterval')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo', protoName: 'extraInfo')
    ..hasRequiredFields = false;

  Recipe._() : super();
  factory Recipe() => create();
  factory Recipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Recipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Recipe clone() => Recipe()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Recipe copyWith(void Function(Recipe) updates) => super.copyWith((message) => updates(message as Recipe)) as Recipe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Recipe create() => Recipe._();
  Recipe createEmptyInstance() => create();
  static $pb.PbList<Recipe> createRepeated() => $pb.PbList<Recipe>();
  @$core.pragma('dart2js:noInline')
  static Recipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Recipe>(create);
  static Recipe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get nodeVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set nodeVersion($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasNodeVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearNodeVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get version => $_getSZ(5);
  @$pb.TagNumber(6)
  set version($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<CoinInput> get coinInputs => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<ItemInput> get itemInputs => $_getList(7);

  @$pb.TagNumber(9)
  EntriesList get entries => $_getN(8);
  @$pb.TagNumber(9)
  set entries(EntriesList v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasEntries() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntries() => clearField(9);
  @$pb.TagNumber(9)
  EntriesList ensureEntries() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.List<WeightedOutputs> get outputs => $_getList(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get blockInterval => $_getI64(10);
  @$pb.TagNumber(11)
  set blockInterval($fixnum.Int64 v) {
    $_setInt64(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasBlockInterval() => $_has(10);
  @$pb.TagNumber(11)
  void clearBlockInterval() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get enabled => $_getBF(11);
  @$pb.TagNumber(12)
  set enabled($core.bool v) {
    $_setBool(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasEnabled() => $_has(11);
  @$pb.TagNumber(12)
  void clearEnabled() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get extraInfo => $_getSZ(12);
  @$pb.TagNumber(13)
  set extraInfo($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasExtraInfo() => $_has(12);
  @$pb.TagNumber(13)
  void clearExtraInfo() => clearField(13);
}
