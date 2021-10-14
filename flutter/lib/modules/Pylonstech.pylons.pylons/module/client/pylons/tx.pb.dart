///
//  Generated code. Do not modify.
//  source: pylons/tx.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'trade.pb.dart' as $6;
import 'recipe.pb.dart' as $4;
import '../cosmos/base/v1beta1/coin.pb.dart' as $2;

class MsgUpdateAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateAccount',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false;

  MsgUpdateAccount._() : super();
  factory MsgUpdateAccount() => create();
  factory MsgUpdateAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgUpdateAccount clone() => MsgUpdateAccount()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgUpdateAccount copyWith(void Function(MsgUpdateAccount) updates) => super.copyWith((message) => updates(message as MsgUpdateAccount)) as MsgUpdateAccount; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateAccount create() => MsgUpdateAccount._();
  MsgUpdateAccount createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateAccount> createRepeated() => $pb.PbList<MsgUpdateAccount>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateAccount>(create);
  static MsgUpdateAccount? _defaultInstance;

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
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);
}

class MsgUpdateAccountResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateAccountResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgUpdateAccountResponse._() : super();
  factory MsgUpdateAccountResponse() => create();
  factory MsgUpdateAccountResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateAccountResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgUpdateAccountResponse clone() => MsgUpdateAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgUpdateAccountResponse copyWith(void Function(MsgUpdateAccountResponse) updates) =>
      super.copyWith((message) => updates(message as MsgUpdateAccountResponse)) as MsgUpdateAccountResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateAccountResponse create() => MsgUpdateAccountResponse._();
  MsgUpdateAccountResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateAccountResponse> createRepeated() => $pb.PbList<MsgUpdateAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateAccountResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateAccountResponse>(create);
  static MsgUpdateAccountResponse? _defaultInstance;
}

class MsgCreateAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateAccount',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false;

  MsgCreateAccount._() : super();
  factory MsgCreateAccount() => create();
  factory MsgCreateAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateAccount clone() => MsgCreateAccount()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateAccount copyWith(void Function(MsgCreateAccount) updates) => super.copyWith((message) => updates(message as MsgCreateAccount)) as MsgCreateAccount; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateAccount create() => MsgCreateAccount._();
  MsgCreateAccount createEmptyInstance() => create();
  static $pb.PbList<MsgCreateAccount> createRepeated() => $pb.PbList<MsgCreateAccount>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateAccount>(create);
  static MsgCreateAccount? _defaultInstance;

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
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);
}

class MsgCreateAccountResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateAccountResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgCreateAccountResponse._() : super();
  factory MsgCreateAccountResponse() => create();
  factory MsgCreateAccountResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateAccountResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateAccountResponse clone() => MsgCreateAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateAccountResponse copyWith(void Function(MsgCreateAccountResponse) updates) =>
      super.copyWith((message) => updates(message as MsgCreateAccountResponse)) as MsgCreateAccountResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateAccountResponse create() => MsgCreateAccountResponse._();
  MsgCreateAccountResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateAccountResponse> createRepeated() => $pb.PbList<MsgCreateAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateAccountResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateAccountResponse>(create);
  static MsgCreateAccountResponse? _defaultInstance;
}

class MsgFulfillTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFulfillTrade',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputsIndex', $pb.PbFieldType.OU6, protoName: 'coinInputsIndex', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$6.ItemRef>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: $6.ItemRef.create)
    ..hasRequiredFields = false;

  MsgFulfillTrade._() : super();
  factory MsgFulfillTrade() => create();
  factory MsgFulfillTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgFulfillTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgFulfillTrade clone() => MsgFulfillTrade()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgFulfillTrade copyWith(void Function(MsgFulfillTrade) updates) => super.copyWith((message) => updates(message as MsgFulfillTrade)) as MsgFulfillTrade; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTrade create() => MsgFulfillTrade._();
  MsgFulfillTrade createEmptyInstance() => create();
  static $pb.PbList<MsgFulfillTrade> createRepeated() => $pb.PbList<MsgFulfillTrade>();
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgFulfillTrade>(create);
  static MsgFulfillTrade? _defaultInstance;

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
  $fixnum.Int64 get coinInputsIndex => $_getI64(2);
  @$pb.TagNumber(3)
  set coinInputsIndex($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCoinInputsIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoinInputsIndex() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$6.ItemRef> get items => $_getList(3);
}

class MsgFulfillTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFulfillTradeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgFulfillTradeResponse._() : super();
  factory MsgFulfillTradeResponse() => create();
  factory MsgFulfillTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgFulfillTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgFulfillTradeResponse clone() => MsgFulfillTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgFulfillTradeResponse copyWith(void Function(MsgFulfillTradeResponse) updates) =>
      super.copyWith((message) => updates(message as MsgFulfillTradeResponse)) as MsgFulfillTradeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTradeResponse create() => MsgFulfillTradeResponse._();
  MsgFulfillTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgFulfillTradeResponse> createRepeated() => $pb.PbList<MsgFulfillTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgFulfillTradeResponse>(create);
  static MsgFulfillTradeResponse? _defaultInstance;
}

class MsgCreateTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateTrade',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..pc<$4.CoinInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, protoName: 'coinInputs', subBuilder: $4.CoinInput.create)
    ..pc<$4.ItemInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, protoName: 'itemInputs', subBuilder: $4.ItemInput.create)
    ..pc<$2.Coin>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinOutputs', $pb.PbFieldType.PM, protoName: 'coinOutputs', subBuilder: $2.Coin.create)
    ..pc<$6.ItemRef>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemOutputs', $pb.PbFieldType.PM, protoName: 'itemOutputs', subBuilder: $6.ItemRef.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo', protoName: 'extraInfo')
    ..hasRequiredFields = false;

  MsgCreateTrade._() : super();
  factory MsgCreateTrade() => create();
  factory MsgCreateTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateTrade clone() => MsgCreateTrade()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateTrade copyWith(void Function(MsgCreateTrade) updates) => super.copyWith((message) => updates(message as MsgCreateTrade)) as MsgCreateTrade; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateTrade create() => MsgCreateTrade._();
  MsgCreateTrade createEmptyInstance() => create();
  static $pb.PbList<MsgCreateTrade> createRepeated() => $pb.PbList<MsgCreateTrade>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateTrade>(create);
  static MsgCreateTrade? _defaultInstance;

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
  $core.List<$4.CoinInput> get coinInputs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$4.ItemInput> get itemInputs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$2.Coin> get coinOutputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$6.ItemRef> get itemOutputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get extraInfo => $_getSZ(5);
  @$pb.TagNumber(6)
  set extraInfo($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasExtraInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearExtraInfo() => clearField(6);
}

class MsgCreateTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateTradeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  MsgCreateTradeResponse._() : super();
  factory MsgCreateTradeResponse() => create();
  factory MsgCreateTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateTradeResponse clone() => MsgCreateTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateTradeResponse copyWith(void Function(MsgCreateTradeResponse) updates) =>
      super.copyWith((message) => updates(message as MsgCreateTradeResponse)) as MsgCreateTradeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateTradeResponse create() => MsgCreateTradeResponse._();
  MsgCreateTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateTradeResponse> createRepeated() => $pb.PbList<MsgCreateTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateTradeResponse>(create);
  static MsgCreateTradeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get iD => $_getI64(0);
  @$pb.TagNumber(1)
  set iD($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);
}

class MsgCancelTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCancelTrade',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  MsgCancelTrade._() : super();
  factory MsgCancelTrade() => create();
  factory MsgCancelTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCancelTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCancelTrade clone() => MsgCancelTrade()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCancelTrade copyWith(void Function(MsgCancelTrade) updates) => super.copyWith((message) => updates(message as MsgCancelTrade)) as MsgCancelTrade; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCancelTrade create() => MsgCancelTrade._();
  MsgCancelTrade createEmptyInstance() => create();
  static $pb.PbList<MsgCancelTrade> createRepeated() => $pb.PbList<MsgCancelTrade>();
  @$core.pragma('dart2js:noInline')
  static MsgCancelTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCancelTrade>(create);
  static MsgCancelTrade? _defaultInstance;

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
}

class MsgCancelTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCancelTradeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgCancelTradeResponse._() : super();
  factory MsgCancelTradeResponse() => create();
  factory MsgCancelTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCancelTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCancelTradeResponse clone() => MsgCancelTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCancelTradeResponse copyWith(void Function(MsgCancelTradeResponse) updates) =>
      super.copyWith((message) => updates(message as MsgCancelTradeResponse)) as MsgCancelTradeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCancelTradeResponse create() => MsgCancelTradeResponse._();
  MsgCancelTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCancelTradeResponse> createRepeated() => $pb.PbList<MsgCancelTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCancelTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCancelTradeResponse>(create);
  static MsgCancelTradeResponse? _defaultInstance;
}

class MsgCompleteExecutionEarly extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCompleteExecutionEarly',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false;

  MsgCompleteExecutionEarly._() : super();
  factory MsgCompleteExecutionEarly() => create();
  factory MsgCompleteExecutionEarly.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCompleteExecutionEarly.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCompleteExecutionEarly clone() => MsgCompleteExecutionEarly()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCompleteExecutionEarly copyWith(void Function(MsgCompleteExecutionEarly) updates) =>
      super.copyWith((message) => updates(message as MsgCompleteExecutionEarly)) as MsgCompleteExecutionEarly; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCompleteExecutionEarly create() => MsgCompleteExecutionEarly._();
  MsgCompleteExecutionEarly createEmptyInstance() => create();
  static $pb.PbList<MsgCompleteExecutionEarly> createRepeated() => $pb.PbList<MsgCompleteExecutionEarly>();
  @$core.pragma('dart2js:noInline')
  static MsgCompleteExecutionEarly getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCompleteExecutionEarly>(create);
  static MsgCompleteExecutionEarly? _defaultInstance;

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
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class MsgCompleteExecutionEarlyResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCompleteExecutionEarlyResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false;

  MsgCompleteExecutionEarlyResponse._() : super();
  factory MsgCompleteExecutionEarlyResponse() => create();
  factory MsgCompleteExecutionEarlyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCompleteExecutionEarlyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCompleteExecutionEarlyResponse clone() => MsgCompleteExecutionEarlyResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCompleteExecutionEarlyResponse copyWith(void Function(MsgCompleteExecutionEarlyResponse) updates) =>
      super.copyWith((message) => updates(message as MsgCompleteExecutionEarlyResponse)) as MsgCompleteExecutionEarlyResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCompleteExecutionEarlyResponse create() => MsgCompleteExecutionEarlyResponse._();
  MsgCompleteExecutionEarlyResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCompleteExecutionEarlyResponse> createRepeated() => $pb.PbList<MsgCompleteExecutionEarlyResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCompleteExecutionEarlyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCompleteExecutionEarlyResponse>(create);
  static MsgCompleteExecutionEarlyResponse? _defaultInstance;

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
}

class MsgTransferCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgTransferCookbook',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipient')
    ..hasRequiredFields = false;

  MsgTransferCookbook._() : super();
  factory MsgTransferCookbook() => create();
  factory MsgTransferCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgTransferCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgTransferCookbook clone() => MsgTransferCookbook()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgTransferCookbook copyWith(void Function(MsgTransferCookbook) updates) =>
      super.copyWith((message) => updates(message as MsgTransferCookbook)) as MsgTransferCookbook; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgTransferCookbook create() => MsgTransferCookbook._();
  MsgTransferCookbook createEmptyInstance() => create();
  static $pb.PbList<MsgTransferCookbook> createRepeated() => $pb.PbList<MsgTransferCookbook>();
  @$core.pragma('dart2js:noInline')
  static MsgTransferCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgTransferCookbook>(create);
  static MsgTransferCookbook? _defaultInstance;

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
  $core.String get recipient => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipient($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRecipient() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipient() => clearField(3);
}

class MsgTransferCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgTransferCookbookResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgTransferCookbookResponse._() : super();
  factory MsgTransferCookbookResponse() => create();
  factory MsgTransferCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgTransferCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgTransferCookbookResponse clone() => MsgTransferCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgTransferCookbookResponse copyWith(void Function(MsgTransferCookbookResponse) updates) =>
      super.copyWith((message) => updates(message as MsgTransferCookbookResponse)) as MsgTransferCookbookResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgTransferCookbookResponse create() => MsgTransferCookbookResponse._();
  MsgTransferCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<MsgTransferCookbookResponse> createRepeated() => $pb.PbList<MsgTransferCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgTransferCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgTransferCookbookResponse>(create);
  static MsgTransferCookbookResponse? _defaultInstance;
}

class MsgGoogleInAppPurchaseGetCoins extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGoogleInAppPurchaseGetCoins',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productID', protoName: 'productID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseToken', protoName: 'purchaseToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiptDataBase64', protoName: 'receiptDataBase64')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature')
    ..hasRequiredFields = false;

  MsgGoogleInAppPurchaseGetCoins._() : super();
  factory MsgGoogleInAppPurchaseGetCoins() => create();
  factory MsgGoogleInAppPurchaseGetCoins.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGoogleInAppPurchaseGetCoins.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoins clone() => MsgGoogleInAppPurchaseGetCoins()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoins copyWith(void Function(MsgGoogleInAppPurchaseGetCoins) updates) =>
      super.copyWith((message) => updates(message as MsgGoogleInAppPurchaseGetCoins)) as MsgGoogleInAppPurchaseGetCoins; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgGoogleInAppPurchaseGetCoins create() => MsgGoogleInAppPurchaseGetCoins._();
  MsgGoogleInAppPurchaseGetCoins createEmptyInstance() => create();
  static $pb.PbList<MsgGoogleInAppPurchaseGetCoins> createRepeated() => $pb.PbList<MsgGoogleInAppPurchaseGetCoins>();
  @$core.pragma('dart2js:noInline')
  static MsgGoogleInAppPurchaseGetCoins getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgGoogleInAppPurchaseGetCoins>(create);
  static MsgGoogleInAppPurchaseGetCoins? _defaultInstance;

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
  $core.String get productID => $_getSZ(1);
  @$pb.TagNumber(2)
  set productID($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProductID() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get purchaseToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set purchaseToken($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPurchaseToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurchaseToken() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get receiptDataBase64 => $_getSZ(3);
  @$pb.TagNumber(4)
  set receiptDataBase64($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasReceiptDataBase64() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceiptDataBase64() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get signature => $_getSZ(4);
  @$pb.TagNumber(5)
  set signature($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignature() => clearField(5);
}

class MsgGoogleInAppPurchaseGetCoinsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGoogleInAppPurchaseGetCoinsResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgGoogleInAppPurchaseGetCoinsResponse._() : super();
  factory MsgGoogleInAppPurchaseGetCoinsResponse() => create();
  factory MsgGoogleInAppPurchaseGetCoinsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGoogleInAppPurchaseGetCoinsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoinsResponse clone() => MsgGoogleInAppPurchaseGetCoinsResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoinsResponse copyWith(void Function(MsgGoogleInAppPurchaseGetCoinsResponse) updates) =>
      super.copyWith((message) => updates(message as MsgGoogleInAppPurchaseGetCoinsResponse)) as MsgGoogleInAppPurchaseGetCoinsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgGoogleInAppPurchaseGetCoinsResponse create() => MsgGoogleInAppPurchaseGetCoinsResponse._();
  MsgGoogleInAppPurchaseGetCoinsResponse createEmptyInstance() => create();
  static $pb.PbList<MsgGoogleInAppPurchaseGetCoinsResponse> createRepeated() => $pb.PbList<MsgGoogleInAppPurchaseGetCoinsResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgGoogleInAppPurchaseGetCoinsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgGoogleInAppPurchaseGetCoinsResponse>(create);
  static MsgGoogleInAppPurchaseGetCoinsResponse? _defaultInstance;
}

class MsgSendItems extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendItems',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiver')
    ..pc<$6.ItemRef>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: $6.ItemRef.create)
    ..hasRequiredFields = false;

  MsgSendItems._() : super();
  factory MsgSendItems() => create();
  factory MsgSendItems.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSendItems.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgSendItems clone() => MsgSendItems()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgSendItems copyWith(void Function(MsgSendItems) updates) => super.copyWith((message) => updates(message as MsgSendItems)) as MsgSendItems; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSendItems create() => MsgSendItems._();
  MsgSendItems createEmptyInstance() => create();
  static $pb.PbList<MsgSendItems> createRepeated() => $pb.PbList<MsgSendItems>();
  @$core.pragma('dart2js:noInline')
  static MsgSendItems getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSendItems>(create);
  static MsgSendItems? _defaultInstance;

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
  $core.String get receiver => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiver($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReceiver() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiver() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$6.ItemRef> get items => $_getList(2);
}

class MsgSendItemsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendItemsResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgSendItemsResponse._() : super();
  factory MsgSendItemsResponse() => create();
  factory MsgSendItemsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSendItemsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgSendItemsResponse clone() => MsgSendItemsResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgSendItemsResponse copyWith(void Function(MsgSendItemsResponse) updates) =>
      super.copyWith((message) => updates(message as MsgSendItemsResponse)) as MsgSendItemsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSendItemsResponse create() => MsgSendItemsResponse._();
  MsgSendItemsResponse createEmptyInstance() => create();
  static $pb.PbList<MsgSendItemsResponse> createRepeated() => $pb.PbList<MsgSendItemsResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgSendItemsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSendItemsResponse>(create);
  static MsgSendItemsResponse? _defaultInstance;
}

class MsgExecuteRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgExecuteRecipe',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipeID', protoName: 'recipeID')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputsIndex', $pb.PbFieldType.OU6, protoName: 'coinInputsIndex', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemIDs', protoName: 'itemIDs')
    ..hasRequiredFields = false;

  MsgExecuteRecipe._() : super();
  factory MsgExecuteRecipe() => create();
  factory MsgExecuteRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgExecuteRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgExecuteRecipe clone() => MsgExecuteRecipe()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgExecuteRecipe copyWith(void Function(MsgExecuteRecipe) updates) => super.copyWith((message) => updates(message as MsgExecuteRecipe)) as MsgExecuteRecipe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipe create() => MsgExecuteRecipe._();
  MsgExecuteRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgExecuteRecipe> createRepeated() => $pb.PbList<MsgExecuteRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgExecuteRecipe>(create);
  static MsgExecuteRecipe? _defaultInstance;

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
  $core.String get recipeID => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeID($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRecipeID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeID() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get coinInputsIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set coinInputsIndex($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCoinInputsIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoinInputsIndex() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get itemIDs => $_getList(4);
}

class MsgExecuteRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgExecuteRecipeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false;

  MsgExecuteRecipeResponse._() : super();
  factory MsgExecuteRecipeResponse() => create();
  factory MsgExecuteRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgExecuteRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgExecuteRecipeResponse clone() => MsgExecuteRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgExecuteRecipeResponse copyWith(void Function(MsgExecuteRecipeResponse) updates) =>
      super.copyWith((message) => updates(message as MsgExecuteRecipeResponse)) as MsgExecuteRecipeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipeResponse create() => MsgExecuteRecipeResponse._();
  MsgExecuteRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgExecuteRecipeResponse> createRepeated() => $pb.PbList<MsgExecuteRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgExecuteRecipeResponse>(create);
  static MsgExecuteRecipeResponse? _defaultInstance;

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
}

class MsgSetItemString extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSetItemString',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'field')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false;

  MsgSetItemString._() : super();
  factory MsgSetItemString() => create();
  factory MsgSetItemString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSetItemString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgSetItemString clone() => MsgSetItemString()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgSetItemString copyWith(void Function(MsgSetItemString) updates) => super.copyWith((message) => updates(message as MsgSetItemString)) as MsgSetItemString; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSetItemString create() => MsgSetItemString._();
  MsgSetItemString createEmptyInstance() => create();
  static $pb.PbList<MsgSetItemString> createRepeated() => $pb.PbList<MsgSetItemString>();
  @$core.pragma('dart2js:noInline')
  static MsgSetItemString getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSetItemString>(create);
  static MsgSetItemString? _defaultInstance;

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
  $core.String get cookbookID => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookID($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCookbookID() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookID() => clearField(2);

  @$pb.TagNumber(4)
  $core.String get iD => $_getSZ(2);
  @$pb.TagNumber(4)
  set iD($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasID() => $_has(2);
  @$pb.TagNumber(4)
  void clearID() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get field_5 => $_getSZ(3);
  @$pb.TagNumber(5)
  set field_5($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasField_5() => $_has(3);
  @$pb.TagNumber(5)
  void clearField_5() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(6)
  set value($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(6)
  void clearValue() => clearField(6);
}

class MsgSetItemStringResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSetItemStringResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgSetItemStringResponse._() : super();
  factory MsgSetItemStringResponse() => create();
  factory MsgSetItemStringResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSetItemStringResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgSetItemStringResponse clone() => MsgSetItemStringResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgSetItemStringResponse copyWith(void Function(MsgSetItemStringResponse) updates) =>
      super.copyWith((message) => updates(message as MsgSetItemStringResponse)) as MsgSetItemStringResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSetItemStringResponse create() => MsgSetItemStringResponse._();
  MsgSetItemStringResponse createEmptyInstance() => create();
  static $pb.PbList<MsgSetItemStringResponse> createRepeated() => $pb.PbList<MsgSetItemStringResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgSetItemStringResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSetItemStringResponse>(create);
  static MsgSetItemStringResponse? _defaultInstance;
}

class MsgCreateRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateRecipe',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..pc<$4.CoinInput>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, protoName: 'coinInputs', subBuilder: $4.CoinInput.create)
    ..pc<$4.ItemInput>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, protoName: 'itemInputs', subBuilder: $4.ItemInput.create)
    ..aOM<$4.EntriesList>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entries', subBuilder: $4.EntriesList.create)
    ..pc<$4.WeightedOutputs>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: $4.WeightedOutputs.create)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockInterval', protoName: 'blockInterval')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo', protoName: 'extraInfo')
    ..hasRequiredFields = false;

  MsgCreateRecipe._() : super();
  factory MsgCreateRecipe() => create();
  factory MsgCreateRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateRecipe clone() => MsgCreateRecipe()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateRecipe copyWith(void Function(MsgCreateRecipe) updates) => super.copyWith((message) => updates(message as MsgCreateRecipe)) as MsgCreateRecipe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipe create() => MsgCreateRecipe._();
  MsgCreateRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgCreateRecipe> createRepeated() => $pb.PbList<MsgCreateRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateRecipe>(create);
  static MsgCreateRecipe? _defaultInstance;

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
  $core.List<$4.CoinInput> get coinInputs => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$4.ItemInput> get itemInputs => $_getList(7);

  @$pb.TagNumber(9)
  $4.EntriesList get entries => $_getN(8);
  @$pb.TagNumber(9)
  set entries($4.EntriesList v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasEntries() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntries() => clearField(9);
  @$pb.TagNumber(9)
  $4.EntriesList ensureEntries() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.List<$4.WeightedOutputs> get outputs => $_getList(9);

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

class MsgCreateRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateRecipeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgCreateRecipeResponse._() : super();
  factory MsgCreateRecipeResponse() => create();
  factory MsgCreateRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateRecipeResponse clone() => MsgCreateRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateRecipeResponse copyWith(void Function(MsgCreateRecipeResponse) updates) =>
      super.copyWith((message) => updates(message as MsgCreateRecipeResponse)) as MsgCreateRecipeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipeResponse create() => MsgCreateRecipeResponse._();
  MsgCreateRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateRecipeResponse> createRepeated() => $pb.PbList<MsgCreateRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateRecipeResponse>(create);
  static MsgCreateRecipeResponse? _defaultInstance;
}

class MsgUpdateRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateRecipe',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..pc<$4.CoinInput>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, protoName: 'coinInputs', subBuilder: $4.CoinInput.create)
    ..pc<$4.ItemInput>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, protoName: 'itemInputs', subBuilder: $4.ItemInput.create)
    ..aOM<$4.EntriesList>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entries', subBuilder: $4.EntriesList.create)
    ..pc<$4.WeightedOutputs>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: $4.WeightedOutputs.create)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockInterval', protoName: 'blockInterval')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo', protoName: 'extraInfo')
    ..hasRequiredFields = false;

  MsgUpdateRecipe._() : super();
  factory MsgUpdateRecipe() => create();
  factory MsgUpdateRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgUpdateRecipe clone() => MsgUpdateRecipe()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgUpdateRecipe copyWith(void Function(MsgUpdateRecipe) updates) => super.copyWith((message) => updates(message as MsgUpdateRecipe)) as MsgUpdateRecipe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipe create() => MsgUpdateRecipe._();
  MsgUpdateRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateRecipe> createRepeated() => $pb.PbList<MsgUpdateRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateRecipe>(create);
  static MsgUpdateRecipe? _defaultInstance;

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
  $core.List<$4.CoinInput> get coinInputs => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$4.ItemInput> get itemInputs => $_getList(7);

  @$pb.TagNumber(9)
  $4.EntriesList get entries => $_getN(8);
  @$pb.TagNumber(9)
  set entries($4.EntriesList v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasEntries() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntries() => clearField(9);
  @$pb.TagNumber(9)
  $4.EntriesList ensureEntries() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.List<$4.WeightedOutputs> get outputs => $_getList(9);

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

class MsgUpdateRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateRecipeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgUpdateRecipeResponse._() : super();
  factory MsgUpdateRecipeResponse() => create();
  factory MsgUpdateRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgUpdateRecipeResponse clone() => MsgUpdateRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgUpdateRecipeResponse copyWith(void Function(MsgUpdateRecipeResponse) updates) =>
      super.copyWith((message) => updates(message as MsgUpdateRecipeResponse)) as MsgUpdateRecipeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipeResponse create() => MsgUpdateRecipeResponse._();
  MsgUpdateRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateRecipeResponse> createRepeated() => $pb.PbList<MsgUpdateRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateRecipeResponse>(create);
  static MsgUpdateRecipeResponse? _defaultInstance;
}

class MsgCreateCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateCookbook',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'developer')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'supportEmail', protoName: 'supportEmail')
    ..aOM<$2.Coin>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'costPerBlock', protoName: 'costPerBlock', subBuilder: $2.Coin.create)
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false;

  MsgCreateCookbook._() : super();
  factory MsgCreateCookbook() => create();
  factory MsgCreateCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateCookbook clone() => MsgCreateCookbook()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateCookbook copyWith(void Function(MsgCreateCookbook) updates) => super.copyWith((message) => updates(message as MsgCreateCookbook)) as MsgCreateCookbook; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbook create() => MsgCreateCookbook._();
  MsgCreateCookbook createEmptyInstance() => create();
  static $pb.PbList<MsgCreateCookbook> createRepeated() => $pb.PbList<MsgCreateCookbook>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateCookbook>(create);
  static MsgCreateCookbook? _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get developer => $_getSZ(4);
  @$pb.TagNumber(5)
  set developer($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDeveloper() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeveloper() => clearField(5);

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
  $core.String get supportEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set supportEmail($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasSupportEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearSupportEmail() => clearField(7);

  @$pb.TagNumber(8)
  $2.Coin get costPerBlock => $_getN(7);
  @$pb.TagNumber(8)
  set costPerBlock($2.Coin v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCostPerBlock() => $_has(7);
  @$pb.TagNumber(8)
  void clearCostPerBlock() => clearField(8);
  @$pb.TagNumber(8)
  $2.Coin ensureCostPerBlock() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get enabled => $_getBF(8);
  @$pb.TagNumber(9)
  set enabled($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearEnabled() => clearField(9);
}

class MsgCreateCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateCookbookResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgCreateCookbookResponse._() : super();
  factory MsgCreateCookbookResponse() => create();
  factory MsgCreateCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgCreateCookbookResponse clone() => MsgCreateCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgCreateCookbookResponse copyWith(void Function(MsgCreateCookbookResponse) updates) =>
      super.copyWith((message) => updates(message as MsgCreateCookbookResponse)) as MsgCreateCookbookResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbookResponse create() => MsgCreateCookbookResponse._();
  MsgCreateCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateCookbookResponse> createRepeated() => $pb.PbList<MsgCreateCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateCookbookResponse>(create);
  static MsgCreateCookbookResponse? _defaultInstance;
}

class MsgUpdateCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateCookbook',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'developer')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'supportEmail', protoName: 'supportEmail')
    ..aOM<$2.Coin>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'costPerBlock', protoName: 'costPerBlock', subBuilder: $2.Coin.create)
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false;

  MsgUpdateCookbook._() : super();
  factory MsgUpdateCookbook() => create();
  factory MsgUpdateCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgUpdateCookbook clone() => MsgUpdateCookbook()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgUpdateCookbook copyWith(void Function(MsgUpdateCookbook) updates) => super.copyWith((message) => updates(message as MsgUpdateCookbook)) as MsgUpdateCookbook; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbook create() => MsgUpdateCookbook._();
  MsgUpdateCookbook createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateCookbook> createRepeated() => $pb.PbList<MsgUpdateCookbook>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateCookbook>(create);
  static MsgUpdateCookbook? _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get developer => $_getSZ(4);
  @$pb.TagNumber(5)
  set developer($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDeveloper() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeveloper() => clearField(5);

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
  $core.String get supportEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set supportEmail($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasSupportEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearSupportEmail() => clearField(7);

  @$pb.TagNumber(8)
  $2.Coin get costPerBlock => $_getN(7);
  @$pb.TagNumber(8)
  set costPerBlock($2.Coin v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCostPerBlock() => $_has(7);
  @$pb.TagNumber(8)
  void clearCostPerBlock() => clearField(8);
  @$pb.TagNumber(8)
  $2.Coin ensureCostPerBlock() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get enabled => $_getBF(8);
  @$pb.TagNumber(9)
  set enabled($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearEnabled() => clearField(9);
}

class MsgUpdateCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateCookbookResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  MsgUpdateCookbookResponse._() : super();
  factory MsgUpdateCookbookResponse() => create();
  factory MsgUpdateCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgUpdateCookbookResponse clone() => MsgUpdateCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgUpdateCookbookResponse copyWith(void Function(MsgUpdateCookbookResponse) updates) =>
      super.copyWith((message) => updates(message as MsgUpdateCookbookResponse)) as MsgUpdateCookbookResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbookResponse create() => MsgUpdateCookbookResponse._();
  MsgUpdateCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateCookbookResponse> createRepeated() => $pb.PbList<MsgUpdateCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateCookbookResponse>(create);
  static MsgUpdateCookbookResponse? _defaultInstance;
}
