///
//  Generated code. Do not modify.
//  source: pylons/pylons/item.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../cosmos/base/v1beta1/coin.pb.dart' as $2;

class DoubleKeyValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DoubleKeyValue',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'key')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  DoubleKeyValue._() : super();
  factory DoubleKeyValue({
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
  factory DoubleKeyValue.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DoubleKeyValue.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DoubleKeyValue clone() => DoubleKeyValue()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DoubleKeyValue copyWith(void Function(DoubleKeyValue) updates) =>
      super.copyWith((message) => updates(message as DoubleKeyValue))
          as DoubleKeyValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DoubleKeyValue create() => DoubleKeyValue._();
  DoubleKeyValue createEmptyInstance() => create();
  static $pb.PbList<DoubleKeyValue> createRepeated() =>
      $pb.PbList<DoubleKeyValue>();
  @$core.pragma('dart2js:noInline')
  static DoubleKeyValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DoubleKeyValue>(create);
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'LongKeyValue',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'key')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  LongKeyValue._() : super();
  factory LongKeyValue({
    $core.String? key,
    $fixnum.Int64? value,
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
  factory LongKeyValue.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LongKeyValue.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LongKeyValue clone() => LongKeyValue()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LongKeyValue copyWith(void Function(LongKeyValue) updates) =>
      super.copyWith((message) => updates(message as LongKeyValue))
          as LongKeyValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LongKeyValue create() => LongKeyValue._();
  LongKeyValue createEmptyInstance() => create();
  static $pb.PbList<LongKeyValue> createRepeated() =>
      $pb.PbList<LongKeyValue>();
  @$core.pragma('dart2js:noInline')
  static LongKeyValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LongKeyValue>(create);
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'StringKeyValue',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'key')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  StringKeyValue._() : super();
  factory StringKeyValue({
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
  factory StringKeyValue.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StringKeyValue.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StringKeyValue clone() => StringKeyValue()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StringKeyValue copyWith(void Function(StringKeyValue) updates) =>
      super.copyWith((message) => updates(message as StringKeyValue))
          as StringKeyValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringKeyValue create() => StringKeyValue._();
  StringKeyValue createEmptyInstance() => create();
  static $pb.PbList<StringKeyValue> createRepeated() =>
      $pb.PbList<StringKeyValue>();
  @$core.pragma('dart2js:noInline')
  static StringKeyValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StringKeyValue>(create);
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Item',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'owner')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cookbookId')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..a<$fixnum.Int64>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeVersion',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<DoubleKeyValue>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'doubles',
        $pb.PbFieldType.PM,
        subBuilder: DoubleKeyValue.create)
    ..pc<LongKeyValue>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'longs',
        $pb.PbFieldType.PM,
        subBuilder: LongKeyValue.create)
    ..pc<StringKeyValue>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'strings',
        $pb.PbFieldType.PM,
        subBuilder: StringKeyValue.create)
    ..pc<StringKeyValue>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mutableStrings',
        $pb.PbFieldType.PM,
        subBuilder: StringKeyValue.create)
    ..aOB(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tradeable')
    ..aInt64(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lastUpdate')
    ..pc<$2.Coin>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'transferFee',
        $pb.PbFieldType.PM,
        subBuilder: $2.Coin.create)
    ..aOS(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tradePercentage')
    ..aInt64(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'createdAt')
    ..aInt64(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'updatedAt')
    ..aOS(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'recipeId')
    ..hasRequiredFields = false;

  Item._() : super();
  factory Item({
    $core.String? owner,
    $core.String? cookbookId,
    $core.String? id,
    $fixnum.Int64? nodeVersion,
    $core.Iterable<DoubleKeyValue>? doubles,
    $core.Iterable<LongKeyValue>? longs,
    $core.Iterable<StringKeyValue>? strings,
    $core.Iterable<StringKeyValue>? mutableStrings,
    $core.bool? tradeable,
    $fixnum.Int64? lastUpdate,
    $core.Iterable<$2.Coin>? transferFee,
    $core.String? tradePercentage,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $core.String? recipeId,
  }) {
    final _result = create();
    if (owner != null) {
      _result.owner = owner;
    }
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (id != null) {
      _result.id = id;
    }
    if (nodeVersion != null) {
      _result.nodeVersion = nodeVersion;
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
    if (tradeable != null) {
      _result.tradeable = tradeable;
    }
    if (lastUpdate != null) {
      _result.lastUpdate = lastUpdate;
    }
    if (transferFee != null) {
      _result.transferFee.addAll(transferFee);
    }
    if (tradePercentage != null) {
      _result.tradePercentage = tradePercentage;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    if (recipeId != null) {
      _result.recipeId = recipeId;
    }
    return _result;
  }
  factory Item.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Item.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Item clone() => Item()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Item copyWith(void Function(Item) updates) =>
      super.copyWith((message) => updates(message as Item))
          as Item; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Item create() => Item._();
  Item createEmptyInstance() => create();
  static $pb.PbList<Item> createRepeated() => $pb.PbList<Item>();
  @$core.pragma('dart2js:noInline')
  static Item getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Item>(create);
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
  $core.String get cookbookId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCookbookId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get nodeVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set nodeVersion($fixnum.Int64 v) {
    $_setInt64(3, v);
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

  @$pb.TagNumber(13)
  $fixnum.Int64 get createdAt => $_getI64(12);
  @$pb.TagNumber(13)
  set createdAt($fixnum.Int64 v) {
    $_setInt64(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get updatedAt => $_getI64(13);
  @$pb.TagNumber(14)
  set updatedAt($fixnum.Int64 v) {
    $_setInt64(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasUpdatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearUpdatedAt() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get recipeId => $_getSZ(14);
  @$pb.TagNumber(15)
  set recipeId($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasRecipeId() => $_has(14);
  @$pb.TagNumber(15)
  void clearRecipeId() => clearField(15);
}
