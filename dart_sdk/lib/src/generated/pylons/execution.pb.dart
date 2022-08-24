///
//  Generated code. Do not modify.
//  source: pylons/pylons/execution.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'item.pb.dart' as $3;
import '../cosmos/base/v1beta1/coin.pb.dart' as $2;

class ItemRecord extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ItemRecord',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..pc<$3.DoubleKeyValue>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'doubles',
        $pb.PbFieldType.PM,
        subBuilder: $3.DoubleKeyValue.create)
    ..pc<$3.LongKeyValue>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'longs',
        $pb.PbFieldType.PM,
        subBuilder: $3.LongKeyValue.create)
    ..pc<$3.StringKeyValue>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'strings',
        $pb.PbFieldType.PM,
        subBuilder: $3.StringKeyValue.create)
    ..hasRequiredFields = false;

  ItemRecord._() : super();
  factory ItemRecord({
    $core.String? id,
    $core.Iterable<$3.DoubleKeyValue>? doubles,
    $core.Iterable<$3.LongKeyValue>? longs,
    $core.Iterable<$3.StringKeyValue>? strings,
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
  factory ItemRecord.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ItemRecord.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ItemRecord clone() => ItemRecord()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ItemRecord copyWith(void Function(ItemRecord) updates) =>
      super.copyWith((message) => updates(message as ItemRecord))
          as ItemRecord; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemRecord create() => ItemRecord._();
  ItemRecord createEmptyInstance() => create();
  static $pb.PbList<ItemRecord> createRepeated() => $pb.PbList<ItemRecord>();
  @$core.pragma('dart2js:noInline')
  static ItemRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ItemRecord>(create);
  static ItemRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$3.DoubleKeyValue> get doubles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$3.LongKeyValue> get longs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$3.StringKeyValue> get strings => $_getList(3);
}

class Execution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Execution',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'creator')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'recipeId')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cookbookId')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'recipeVersion')
    ..a<$fixnum.Int64>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeVersion',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockHeight')
    ..pc<ItemRecord>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'itemInputs',
        $pb.PbFieldType.PM,
        subBuilder: ItemRecord.create)
    ..pc<$2.Coin>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'coinInputs',
        $pb.PbFieldType.PM,
        subBuilder: $2.Coin.create)
    ..pc<$2.Coin>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'coinOutputs',
        $pb.PbFieldType.PM,
        subBuilder: $2.Coin.create)
    ..pPS(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'itemOutputIds')
    ..pPS(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'itemModifyOutputIds')
    ..hasRequiredFields = false;

  Execution._() : super();
  factory Execution({
    $core.String? creator,
    $core.String? id,
    $core.String? recipeId,
    $core.String? cookbookId,
    $core.String? recipeVersion,
    $fixnum.Int64? nodeVersion,
    $fixnum.Int64? blockHeight,
    $core.Iterable<ItemRecord>? itemInputs,
    $core.Iterable<$2.Coin>? coinInputs,
    $core.Iterable<$2.Coin>? coinOutputs,
    $core.Iterable<$core.String>? itemOutputIds,
    $core.Iterable<$core.String>? itemModifyOutputIds,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (id != null) {
      _result.id = id;
    }
    if (recipeId != null) {
      _result.recipeId = recipeId;
    }
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (recipeVersion != null) {
      _result.recipeVersion = recipeVersion;
    }
    if (nodeVersion != null) {
      _result.nodeVersion = nodeVersion;
    }
    if (blockHeight != null) {
      _result.blockHeight = blockHeight;
    }
    if (itemInputs != null) {
      _result.itemInputs.addAll(itemInputs);
    }
    if (coinInputs != null) {
      _result.coinInputs.addAll(coinInputs);
    }
    if (coinOutputs != null) {
      _result.coinOutputs.addAll(coinOutputs);
    }
    if (itemOutputIds != null) {
      _result.itemOutputIds.addAll(itemOutputIds);
    }
    if (itemModifyOutputIds != null) {
      _result.itemModifyOutputIds.addAll(itemModifyOutputIds);
    }
    return _result;
  }
  factory Execution.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Execution.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Execution clone() => Execution()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Execution copyWith(void Function(Execution) updates) =>
      super.copyWith((message) => updates(message as Execution))
          as Execution; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Execution create() => Execution._();
  Execution createEmptyInstance() => create();
  static $pb.PbList<Execution> createRepeated() => $pb.PbList<Execution>();
  @$core.pragma('dart2js:noInline')
  static Execution getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Execution>(create);
  static Execution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRecipeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get cookbookId => $_getSZ(3);
  @$pb.TagNumber(4)
  set cookbookId($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCookbookId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCookbookId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get recipeVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set recipeVersion($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRecipeVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipeVersion() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get nodeVersion => $_getI64(5);
  @$pb.TagNumber(6)
  set nodeVersion($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasNodeVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearNodeVersion() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get blockHeight => $_getI64(6);
  @$pb.TagNumber(7)
  set blockHeight($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBlockHeight() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockHeight() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<ItemRecord> get itemInputs => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$2.Coin> get coinInputs => $_getList(8);

  @$pb.TagNumber(10)
  $core.List<$2.Coin> get coinOutputs => $_getList(9);

  @$pb.TagNumber(11)
  $core.List<$core.String> get itemOutputIds => $_getList(10);

  @$pb.TagNumber(12)
  $core.List<$core.String> get itemModifyOutputIds => $_getList(11);
}
