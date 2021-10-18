///
//  Generated code. Do not modify.
//  source: pylons/genesis.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'cookbook.pb.dart' as $5;
import 'recipe.pb.dart' as $4;
import 'item.pb.dart' as $3;
import 'execution.pb.dart' as $7;
import 'google_iap_order.pb.dart' as $8;
import 'params.pb.dart' as $9;
import 'trade.pb.dart' as $6;
import 'accounts.pb.dart' as $10;

class GenesisState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GenesisState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<$5.Cookbook>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookList', $pb.PbFieldType.PM, protoName: 'cookbookList', subBuilder: $5.Cookbook.create)
    ..pc<$4.Recipe>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipeList', $pb.PbFieldType.PM, protoName: 'recipeList', subBuilder: $4.Recipe.create)
    ..pc<$3.Item>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemList', $pb.PbFieldType.PM, protoName: 'itemList', subBuilder: $3.Item.create)
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pendingExecutionCount', $pb.PbFieldType.OU6, protoName: 'pendingExecutionCount', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$7.Execution>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pendingExecutionList', $pb.PbFieldType.PM, protoName: 'pendingExecutionList', subBuilder: $7.Execution.create)
    ..a<$fixnum.Int64>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'executionCount', $pb.PbFieldType.OU6, protoName: 'executionCount', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$7.Execution>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'executionList', $pb.PbFieldType.PM, protoName: 'executionList', subBuilder: $7.Execution.create)
    ..pc<$8.GoogleInAppPurchaseOrder>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'googleInAppPurchaseOrderList', $pb.PbFieldType.PM, protoName: 'googleInAppPurchaseOrderList', subBuilder: $8.GoogleInAppPurchaseOrder.create)
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'googleIAPOrderCount', $pb.PbFieldType.OU6, protoName: 'googleIAPOrderCount', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$9.Params>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'params', subBuilder: $9.Params.create)
    ..a<$fixnum.Int64>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entityCount', $pb.PbFieldType.OU6, protoName: 'entityCount', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeCount', $pb.PbFieldType.OU6, protoName: 'tradeCount', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$6.Trade>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeList', $pb.PbFieldType.PM, protoName: 'tradeList', subBuilder: $6.Trade.create)
    ..pc<$10.UserMap>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountList', $pb.PbFieldType.PM, protoName: 'accountList', subBuilder: $10.UserMap.create)
    ..hasRequiredFields = false
  ;

  GenesisState._() : super();
  factory GenesisState({
    $core.Iterable<$5.Cookbook>? cookbookList,
    $core.Iterable<$4.Recipe>? recipeList,
    $core.Iterable<$3.Item>? itemList,
    $fixnum.Int64? pendingExecutionCount,
    $core.Iterable<$7.Execution>? pendingExecutionList,
    $fixnum.Int64? executionCount,
    $core.Iterable<$7.Execution>? executionList,
    $core.Iterable<$8.GoogleInAppPurchaseOrder>? googleInAppPurchaseOrderList,
    $fixnum.Int64? googleIAPOrderCount,
    $9.Params? params,
    $fixnum.Int64? entityCount,
    $fixnum.Int64? tradeCount,
    $core.Iterable<$6.Trade>? tradeList,
    $core.Iterable<$10.UserMap>? accountList,
  }) {
    final _result = create();
    if (cookbookList != null) {
      _result.cookbookList.addAll(cookbookList);
    }
    if (recipeList != null) {
      _result.recipeList.addAll(recipeList);
    }
    if (itemList != null) {
      _result.itemList.addAll(itemList);
    }
    if (pendingExecutionCount != null) {
      _result.pendingExecutionCount = pendingExecutionCount;
    }
    if (pendingExecutionList != null) {
      _result.pendingExecutionList.addAll(pendingExecutionList);
    }
    if (executionCount != null) {
      _result.executionCount = executionCount;
    }
    if (executionList != null) {
      _result.executionList.addAll(executionList);
    }
    if (googleInAppPurchaseOrderList != null) {
      _result.googleInAppPurchaseOrderList.addAll(googleInAppPurchaseOrderList);
    }
    if (googleIAPOrderCount != null) {
      _result.googleIAPOrderCount = googleIAPOrderCount;
    }
    if (params != null) {
      _result.params = params;
    }
    if (entityCount != null) {
      _result.entityCount = entityCount;
    }
    if (tradeCount != null) {
      _result.tradeCount = tradeCount;
    }
    if (tradeList != null) {
      _result.tradeList.addAll(tradeList);
    }
    if (accountList != null) {
      _result.accountList.addAll(accountList);
    }
    return _result;
  }
  factory GenesisState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenesisState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenesisState clone() => GenesisState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenesisState copyWith(void Function(GenesisState) updates) => super.copyWith((message) => updates(message as GenesisState)) as GenesisState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenesisState create() => GenesisState._();
  GenesisState createEmptyInstance() => create();
  static $pb.PbList<GenesisState> createRepeated() => $pb.PbList<GenesisState>();
  @$core.pragma('dart2js:noInline')
  static GenesisState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenesisState>(create);
  static GenesisState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$5.Cookbook> get cookbookList => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$4.Recipe> get recipeList => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$3.Item> get itemList => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get pendingExecutionCount => $_getI64(3);
  @$pb.TagNumber(4)
  set pendingExecutionCount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPendingExecutionCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearPendingExecutionCount() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$7.Execution> get pendingExecutionList => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get executionCount => $_getI64(5);
  @$pb.TagNumber(6)
  set executionCount($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasExecutionCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearExecutionCount() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$7.Execution> get executionList => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$8.GoogleInAppPurchaseOrder> get googleInAppPurchaseOrderList => $_getList(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get googleIAPOrderCount => $_getI64(8);
  @$pb.TagNumber(9)
  set googleIAPOrderCount($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasGoogleIAPOrderCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearGoogleIAPOrderCount() => clearField(9);

  @$pb.TagNumber(10)
  $9.Params get params => $_getN(9);
  @$pb.TagNumber(10)
  set params($9.Params v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasParams() => $_has(9);
  @$pb.TagNumber(10)
  void clearParams() => clearField(10);
  @$pb.TagNumber(10)
  $9.Params ensureParams() => $_ensure(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get entityCount => $_getI64(10);
  @$pb.TagNumber(11)
  set entityCount($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasEntityCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearEntityCount() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get tradeCount => $_getI64(11);
  @$pb.TagNumber(12)
  set tradeCount($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasTradeCount() => $_has(11);
  @$pb.TagNumber(12)
  void clearTradeCount() => clearField(12);

  @$pb.TagNumber(13)
  $core.List<$6.Trade> get tradeList => $_getList(12);

  @$pb.TagNumber(14)
  $core.List<$10.UserMap> get accountList => $_getList(13);
}

