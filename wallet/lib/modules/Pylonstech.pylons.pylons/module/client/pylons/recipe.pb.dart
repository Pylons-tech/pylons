///
//  Generated code. Do not modify.
//  source: pylons/pylons/recipe.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../cosmos/base/v1beta1/coin.pb.dart' as $2;
import 'item.pb.dart' as $3;

class DoubleInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleInputParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minValue')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxValue')
    ..hasRequiredFields = false
  ;

  DoubleInputParam._() : super();
  factory DoubleInputParam({
    $core.String? key,
    $core.String? minValue,
    $core.String? maxValue,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (minValue != null) {
      _result.minValue = minValue;
    }
    if (maxValue != null) {
      _result.maxValue = maxValue;
    }
    return _result;
  }
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

class LongInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongInputParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minValue')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxValue')
    ..hasRequiredFields = false
  ;

  LongInputParam._() : super();
  factory LongInputParam({
    $core.String? key,
    $fixnum.Int64? minValue,
    $fixnum.Int64? maxValue,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (minValue != null) {
      _result.minValue = minValue;
    }
    if (maxValue != null) {
      _result.maxValue = maxValue;
    }
    return _result;
  }
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

class StringInputParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringInputParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  StringInputParam._() : super();
  factory StringInputParam({
    $core.String? key,
    $core.String? value,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
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

class ItemInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..pc<DoubleInputParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleInputParam.create)
    ..pc<LongInputParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongInputParam.create)
    ..pc<StringInputParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringInputParam.create)
    ..hasRequiredFields = false
  ;

  ItemInput._() : super();
  factory ItemInput({
    $core.String? id,
    $core.Iterable<DoubleInputParam>? doubles,
    $core.Iterable<LongInputParam>? longs,
    $core.Iterable<StringInputParam>? strings,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (doubles != null) {
      _result.doubles.addAll(doubles);
    }
    if (longs != null) {
      _result.longs.addAll(longs);
    }
    if (strings != null) {
      _result.strings.addAll(strings);
    }
    return _result;
  }
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DoubleInputParam> get doubles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<LongInputParam> get longs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<StringInputParam> get strings => $_getList(3);
}

class DoubleWeightRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleWeightRange', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lower')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'upper')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  DoubleWeightRange._() : super();
  factory DoubleWeightRange({
    $core.String? lower,
    $core.String? upper,
    $fixnum.Int64? weight,
  }) {
    final _result = create();
    if (lower != null) {
      _result.lower = lower;
    }
    if (upper != null) {
      _result.upper = upper;
    }
    if (weight != null) {
      _result.weight = weight;
    }
    return _result;
  }
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

class DoubleParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DoubleParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..pc<DoubleWeightRange>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weightRanges', $pb.PbFieldType.PM, protoName: 'weightRanges', subBuilder: DoubleWeightRange.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false
  ;

  DoubleParam._() : super();
  factory DoubleParam({
    $core.String? key,
    $core.Iterable<DoubleWeightRange>? weightRanges,
    $core.String? program,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (weightRanges != null) {
      _result.weightRanges.addAll(weightRanges);
    }
    if (program != null) {
      _result.program = program;
    }
    return _result;
  }
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
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DoubleWeightRange> get weightRanges => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get program => $_getSZ(2);
  @$pb.TagNumber(3)
  set program($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProgram() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgram() => clearField(3);
}

class IntWeightRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IntWeightRange', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lower')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'upper')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  IntWeightRange._() : super();
  factory IntWeightRange({
    $fixnum.Int64? lower,
    $fixnum.Int64? upper,
    $fixnum.Int64? weight,
  }) {
    final _result = create();
    if (lower != null) {
      _result.lower = lower;
    }
    if (upper != null) {
      _result.upper = upper;
    }
    if (weight != null) {
      _result.weight = weight;
    }
    return _result;
  }
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

class LongParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LongParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..pc<IntWeightRange>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weightRanges', $pb.PbFieldType.PM, protoName: 'weightRanges', subBuilder: IntWeightRange.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false
  ;

  LongParam._() : super();
  factory LongParam({
    $core.String? key,
    $core.Iterable<IntWeightRange>? weightRanges,
    $core.String? program,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (weightRanges != null) {
      _result.weightRanges.addAll(weightRanges);
    }
    if (program != null) {
      _result.program = program;
    }
    return _result;
  }
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
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<IntWeightRange> get weightRanges => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get program => $_getSZ(2);
  @$pb.TagNumber(3)
  set program($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProgram() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgram() => clearField(3);
}

class StringParam extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StringParam', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false
  ;

  StringParam._() : super();
  factory StringParam({
    $core.String? key,
    $core.String? value,
    $core.String? program,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value = value;
    }
    if (program != null) {
      _result.program = program;
    }
    return _result;
  }
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

  @$pb.TagNumber(3)
  $core.String get program => $_getSZ(2);
  @$pb.TagNumber(3)
  set program($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProgram() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgram() => clearField(3);
}

class CoinOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<$2.Coin>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', subBuilder: $2.Coin.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'program')
    ..hasRequiredFields = false
  ;

  CoinOutput._() : super();
  factory CoinOutput({
    $core.String? id,
    $2.Coin? coin,
    $core.String? program,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (coin != null) {
      _result.coin = coin;
    }
    if (program != null) {
      _result.program = program;
    }
    return _result;
  }
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $2.Coin get coin => $_getN(1);
  @$pb.TagNumber(2)
  set coin($2.Coin v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCoin() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoin() => clearField(2);
  @$pb.TagNumber(2)
  $2.Coin ensureCoin() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get program => $_getSZ(2);
  @$pb.TagNumber(3)
  set program($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProgram() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgram() => clearField(3);
}

class ItemOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..pc<DoubleParam>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleParam.create)
    ..pc<LongParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongParam.create)
    ..pc<StringParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringParam.create)
    ..pc<$3.StringKeyValue>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mutableStrings', $pb.PbFieldType.PM, subBuilder: $3.StringKeyValue.create)
    ..pc<$2.Coin>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transferFee', $pb.PbFieldType.PM, subBuilder: $2.Coin.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradePercentage')
    ..a<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quantity', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountMinted', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeable')
    ..hasRequiredFields = false
  ;

  ItemOutput._() : super();
  factory ItemOutput({
    $core.String? id,
    $core.Iterable<DoubleParam>? doubles,
    $core.Iterable<LongParam>? longs,
    $core.Iterable<StringParam>? strings,
    $core.Iterable<$3.StringKeyValue>? mutableStrings,
    $core.Iterable<$2.Coin>? transferFee,
    $core.String? tradePercentage,
    $fixnum.Int64? quantity,
    $fixnum.Int64? amountMinted,
    $core.bool? tradeable,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (doubles != null) {
      _result.doubles.addAll(doubles);
    }
    if (longs != null) {
      _result.longs.addAll(longs);
    }
    if (strings != null) {
      _result.strings.addAll(strings);
    }
    if (mutableStrings != null) {
      _result.mutableStrings.addAll(mutableStrings);
    }
    if (transferFee != null) {
      _result.transferFee.addAll(transferFee);
    }
    if (tradePercentage != null) {
      _result.tradePercentage = tradePercentage;
    }
    if (quantity != null) {
      _result.quantity = quantity;
    }
    if (amountMinted != null) {
      _result.amountMinted = amountMinted;
    }
    if (tradeable != null) {
      _result.tradeable = tradeable;
    }
    return _result;
  }
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

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
  set tradePercentage($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTradePercentage() => $_has(6);
  @$pb.TagNumber(7)
  void clearTradePercentage() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get quantity => $_getI64(7);
  @$pb.TagNumber(8)
  set quantity($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasQuantity() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuantity() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get amountMinted => $_getI64(8);
  @$pb.TagNumber(9)
  set amountMinted($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasAmountMinted() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmountMinted() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get tradeable => $_getBF(9);
  @$pb.TagNumber(10)
  set tradeable($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTradeable() => $_has(9);
  @$pb.TagNumber(10)
  void clearTradeable() => clearField(10);
}

class ItemModifyOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemModifyOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputRef')
    ..pc<DoubleParam>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubles', $pb.PbFieldType.PM, subBuilder: DoubleParam.create)
    ..pc<LongParam>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longs', $pb.PbFieldType.PM, subBuilder: LongParam.create)
    ..pc<StringParam>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: StringParam.create)
    ..pc<$3.StringKeyValue>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mutableStrings', $pb.PbFieldType.PM, subBuilder: $3.StringKeyValue.create)
    ..pc<$2.Coin>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transferFee', $pb.PbFieldType.PM, subBuilder: $2.Coin.create)
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradePercentage')
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quantity', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountMinted', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeable')
    ..hasRequiredFields = false
  ;

  ItemModifyOutput._() : super();
  factory ItemModifyOutput({
    $core.String? id,
    $core.String? itemInputRef,
    $core.Iterable<DoubleParam>? doubles,
    $core.Iterable<LongParam>? longs,
    $core.Iterable<StringParam>? strings,
    $core.Iterable<$3.StringKeyValue>? mutableStrings,
    $core.Iterable<$2.Coin>? transferFee,
    $core.String? tradePercentage,
    $fixnum.Int64? quantity,
    $fixnum.Int64? amountMinted,
    $core.bool? tradeable,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (itemInputRef != null) {
      _result.itemInputRef = itemInputRef;
    }
    if (doubles != null) {
      _result.doubles.addAll(doubles);
    }
    if (longs != null) {
      _result.longs.addAll(longs);
    }
    if (strings != null) {
      _result.strings.addAll(strings);
    }
    if (mutableStrings != null) {
      _result.mutableStrings.addAll(mutableStrings);
    }
    if (transferFee != null) {
      _result.transferFee.addAll(transferFee);
    }
    if (tradePercentage != null) {
      _result.tradePercentage = tradePercentage;
    }
    if (quantity != null) {
      _result.quantity = quantity;
    }
    if (amountMinted != null) {
      _result.amountMinted = amountMinted;
    }
    if (tradeable != null) {
      _result.tradeable = tradeable;
    }
    return _result;
  }
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

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
  $core.List<$3.StringKeyValue> get mutableStrings => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<$2.Coin> get transferFee => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get tradePercentage => $_getSZ(7);
  @$pb.TagNumber(8)
  set tradePercentage($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTradePercentage() => $_has(7);
  @$pb.TagNumber(8)
  void clearTradePercentage() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get quantity => $_getI64(8);
  @$pb.TagNumber(9)
  set quantity($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasQuantity() => $_has(8);
  @$pb.TagNumber(9)
  void clearQuantity() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get amountMinted => $_getI64(9);
  @$pb.TagNumber(10)
  set amountMinted($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasAmountMinted() => $_has(9);
  @$pb.TagNumber(10)
  void clearAmountMinted() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get tradeable => $_getBF(10);
  @$pb.TagNumber(11)
  set tradeable($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasTradeable() => $_has(10);
  @$pb.TagNumber(11)
  void clearTradeable() => clearField(11);
}

class EntriesList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EntriesList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<CoinOutput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinOutputs', $pb.PbFieldType.PM, subBuilder: CoinOutput.create)
    ..pc<ItemOutput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemOutputs', $pb.PbFieldType.PM, subBuilder: ItemOutput.create)
    ..pc<ItemModifyOutput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemModifyOutputs', $pb.PbFieldType.PM, subBuilder: ItemModifyOutput.create)
    ..hasRequiredFields = false
  ;

  EntriesList._() : super();
  factory EntriesList({
    $core.Iterable<CoinOutput>? coinOutputs,
    $core.Iterable<ItemOutput>? itemOutputs,
    $core.Iterable<ItemModifyOutput>? itemModifyOutputs,
  }) {
    final _result = create();
    if (coinOutputs != null) {
      _result.coinOutputs.addAll(coinOutputs);
    }
    if (itemOutputs != null) {
      _result.itemOutputs.addAll(itemOutputs);
    }
    if (itemModifyOutputs != null) {
      _result.itemModifyOutputs.addAll(itemModifyOutputs);
    }
    return _result;
  }
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WeightedOutputs', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entryIds')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  WeightedOutputs._() : super();
  factory WeightedOutputs({
    $core.Iterable<$core.String>? entryIds,
    $fixnum.Int64? weight,
  }) {
    final _result = create();
    if (entryIds != null) {
      _result.entryIds.addAll(entryIds);
    }
    if (weight != null) {
      _result.weight = weight;
    }
    return _result;
  }
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
  $core.List<$core.String> get entryIds => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get weight => $_getI64(1);
  @$pb.TagNumber(2)
  set weight($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeight() => clearField(2);
}

class CoinInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$2.Coin>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coins', $pb.PbFieldType.PM, subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  CoinInput._() : super();
  factory CoinInput({
    $core.Iterable<$2.Coin>? coins,
  }) {
    final _result = create();
    if (coins != null) {
      _result.coins.addAll(coins);
    }
    return _result;
  }
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Recipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeVersion', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..pc<CoinInput>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, subBuilder: CoinInput.create)
    ..pc<ItemInput>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, subBuilder: ItemInput.create)
    ..aOM<EntriesList>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entries', subBuilder: EntriesList.create)
    ..pc<WeightedOutputs>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: WeightedOutputs.create)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockInterval')
    ..aOM<$2.Coin>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'costPerBlock', subBuilder: $2.Coin.create)
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo')
    ..aInt64(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..aInt64(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  Recipe._() : super();
  factory Recipe({
    $core.String? cookbookId,
    $core.String? id,
    $fixnum.Int64? nodeVersion,
    $core.String? name,
    $core.String? description,
    $core.String? version,
    $core.Iterable<CoinInput>? coinInputs,
    $core.Iterable<ItemInput>? itemInputs,
    EntriesList? entries,
    $core.Iterable<WeightedOutputs>? outputs,
    $fixnum.Int64? blockInterval,
    $2.Coin? costPerBlock,
    $core.bool? enabled,
    $core.String? extraInfo,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (id != null) {
      _result.id = id;
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
    if (version != null) {
      _result.version = version;
    }
    if (coinInputs != null) {
      _result.coinInputs.addAll(coinInputs);
    }
    if (itemInputs != null) {
      _result.itemInputs.addAll(itemInputs);
    }
    if (entries != null) {
      _result.entries = entries;
    }
    if (outputs != null) {
      _result.outputs.addAll(outputs);
    }
    if (blockInterval != null) {
      _result.blockInterval = blockInterval;
    }
    if (costPerBlock != null) {
      _result.costPerBlock = costPerBlock;
    }
    if (enabled != null) {
      _result.enabled = enabled;
    }
    if (extraInfo != null) {
      _result.extraInfo = extraInfo;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
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
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nodeVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set nodeVersion($fixnum.Int64 v) { $_setInt64(2, v); }
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
  $core.String get version => $_getSZ(5);
  @$pb.TagNumber(6)
  set version($core.String v) { $_setString(5, v); }
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
  set entries(EntriesList v) { setField(9, v); }
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
  set blockInterval($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasBlockInterval() => $_has(10);
  @$pb.TagNumber(11)
  void clearBlockInterval() => clearField(11);

  @$pb.TagNumber(12)
  $2.Coin get costPerBlock => $_getN(11);
  @$pb.TagNumber(12)
  set costPerBlock($2.Coin v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCostPerBlock() => $_has(11);
  @$pb.TagNumber(12)
  void clearCostPerBlock() => clearField(12);
  @$pb.TagNumber(12)
  $2.Coin ensureCostPerBlock() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.bool get enabled => $_getBF(12);
  @$pb.TagNumber(13)
  set enabled($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasEnabled() => $_has(12);
  @$pb.TagNumber(13)
  void clearEnabled() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get extraInfo => $_getSZ(13);
  @$pb.TagNumber(14)
  set extraInfo($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasExtraInfo() => $_has(13);
  @$pb.TagNumber(14)
  void clearExtraInfo() => clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get createdAt => $_getI64(14);
  @$pb.TagNumber(15)
  set createdAt($fixnum.Int64 v) { $_setInt64(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasCreatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedAt() => clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get updatedAt => $_getI64(15);
  @$pb.TagNumber(16)
  set updatedAt($fixnum.Int64 v) { $_setInt64(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasUpdatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearUpdatedAt() => clearField(16);
}

