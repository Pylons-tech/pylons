///
//  Generated code. Do not modify.
//  source: pylons/trade.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart' as $4;
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/cosmos/base/v1beta1/coin.pb.dart' as $2;

class ItemRef extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemRef',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemID', protoName: 'itemID')
    ..hasRequiredFields = false;

  ItemRef._() : super();
  factory ItemRef() => create();
  factory ItemRef.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemRef.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ItemRef clone() => ItemRef()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ItemRef copyWith(void Function(ItemRef) updates) => super.copyWith((message) => updates(message as ItemRef)) as ItemRef; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemRef create() => ItemRef._();
  ItemRef createEmptyInstance() => create();
  static $pb.PbList<ItemRef> createRepeated() => $pb.PbList<ItemRef>();
  @$core.pragma('dart2js:noInline')
  static ItemRef getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemRef>(create);
  static ItemRef? _defaultInstance;

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
  $core.String get itemID => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemID($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasItemID() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemID() => clearField(2);
}

class Trade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Trade',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$4.CoinInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, protoName: 'coinInputs', subBuilder: $4.CoinInput.create)
    ..pc<$4.ItemInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, protoName: 'itemInputs', subBuilder: $4.ItemInput.create)
    ..pc<$2.Coin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinOutputs', $pb.PbFieldType.PM, protoName: 'coinOutputs', subBuilder: $2.Coin.create)
    ..pc<ItemRef>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemOutputs', $pb.PbFieldType.PM, protoName: 'itemOutputs', subBuilder: ItemRef.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo', protoName: 'extraInfo')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiver')
    ..pc<ItemRef>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradedItemInputs', $pb.PbFieldType.PM, protoName: 'tradedItemInputs', subBuilder: ItemRef.create)
    ..hasRequiredFields = false;

  Trade._() : super();
  factory Trade() => create();
  factory Trade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Trade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Trade clone() => Trade()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Trade copyWith(void Function(Trade) updates) => super.copyWith((message) => updates(message as Trade)) as Trade; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Trade create() => Trade._();
  Trade createEmptyInstance() => create();
  static $pb.PbList<Trade> createRepeated() => $pb.PbList<Trade>();
  @$core.pragma('dart2js:noInline')
  static Trade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Trade>(create);
  static Trade? _defaultInstance;

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
  $fixnum.Int64 get iD => $_getI64(1);
  @$pb.TagNumber(2)
  set iD($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$4.CoinInput> get coinInputs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$4.ItemInput> get itemInputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$2.Coin> get coinOutputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<ItemRef> get itemOutputs => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get extraInfo => $_getSZ(6);
  @$pb.TagNumber(7)
  set extraInfo($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasExtraInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearExtraInfo() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get receiver => $_getSZ(7);
  @$pb.TagNumber(8)
  set receiver($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasReceiver() => $_has(7);
  @$pb.TagNumber(8)
  void clearReceiver() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<ItemRef> get tradedItemInputs => $_getList(8);
}
