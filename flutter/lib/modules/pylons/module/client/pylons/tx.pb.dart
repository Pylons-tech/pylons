///
//  Generated code. Do not modify.
//  source: pylons/tx.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'package:pylons_wallet/modules/pylons/module/client/pylons/pylons.pb.dart' as $3;
import 'package:pylons_wallet/modules/pylons/module/client/cosmos/base/v1beta1/coin.pb.dart' as $2;

class MsgCheckExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCheckExecution', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ExecID', protoName: 'ExecID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PayToComplete', protoName: 'PayToComplete')
    ..hasRequiredFields = false
  ;

  MsgCheckExecution._() : super();
  factory MsgCheckExecution() => create();
  factory MsgCheckExecution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCheckExecution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCheckExecution clone() => MsgCheckExecution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCheckExecution copyWith(void Function(MsgCheckExecution) updates) => super.copyWith((message) => updates(message as MsgCheckExecution)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCheckExecution create() => MsgCheckExecution._();
  MsgCheckExecution createEmptyInstance() => create();
  static $pb.PbList<MsgCheckExecution> createRepeated() => $pb.PbList<MsgCheckExecution>();
  @$core.pragma('dart2js:noInline')
  static MsgCheckExecution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCheckExecution>(create);
  static MsgCheckExecution _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get execID => $_getSZ(0);
  @$pb.TagNumber(1)
  set execID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasExecID() => $_has(0);
  @$pb.TagNumber(1)
  void clearExecID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get payToComplete => $_getBF(2);
  @$pb.TagNumber(3)
  set payToComplete($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPayToComplete() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayToComplete() => clearField(3);
}

class MsgCheckExecutionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCheckExecutionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Output', $pb.PbFieldType.OY, protoName: 'Output')
    ..hasRequiredFields = false
  ;

  MsgCheckExecutionResponse._() : super();
  factory MsgCheckExecutionResponse() => create();
  factory MsgCheckExecutionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCheckExecutionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCheckExecutionResponse clone() => MsgCheckExecutionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCheckExecutionResponse copyWith(void Function(MsgCheckExecutionResponse) updates) => super.copyWith((message) => updates(message as MsgCheckExecutionResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCheckExecutionResponse create() => MsgCheckExecutionResponse._();
  MsgCheckExecutionResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCheckExecutionResponse> createRepeated() => $pb.PbList<MsgCheckExecutionResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCheckExecutionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCheckExecutionResponse>(create);
  static MsgCheckExecutionResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get output => $_getN(2);
  @$pb.TagNumber(3)
  set output($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOutput() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutput() => clearField(3);
}

class MsgCreateAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateAccount', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Requester', protoName: 'Requester')
    ..hasRequiredFields = false
  ;

  MsgCreateAccount._() : super();
  factory MsgCreateAccount() => create();
  factory MsgCreateAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateAccount clone() => MsgCreateAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateAccount copyWith(void Function(MsgCreateAccount) updates) => super.copyWith((message) => updates(message as MsgCreateAccount)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateAccount create() => MsgCreateAccount._();
  MsgCreateAccount createEmptyInstance() => create();
  static $pb.PbList<MsgCreateAccount> createRepeated() => $pb.PbList<MsgCreateAccount>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateAccount>(create);
  static MsgCreateAccount _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requester => $_getSZ(0);
  @$pb.TagNumber(1)
  set requester($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequester() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequester() => clearField(1);
}

class MsgCreateExecutionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateExecutionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgCreateExecutionResponse._() : super();
  factory MsgCreateExecutionResponse() => create();
  factory MsgCreateExecutionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateExecutionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateExecutionResponse clone() => MsgCreateExecutionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateExecutionResponse copyWith(void Function(MsgCreateExecutionResponse) updates) => super.copyWith((message) => updates(message as MsgCreateExecutionResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateExecutionResponse create() => MsgCreateExecutionResponse._();
  MsgCreateExecutionResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateExecutionResponse> createRepeated() => $pb.PbList<MsgCreateExecutionResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateExecutionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateExecutionResponse>(create);
  static MsgCreateExecutionResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgCreateCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Version', protoName: 'Version')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Developer', protoName: 'Developer')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'SupportEmail', protoName: 'SupportEmail')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Level', protoName: 'Level')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CostPerBlock', protoName: 'CostPerBlock')
    ..hasRequiredFields = false
  ;

  MsgCreateCookbook._() : super();
  factory MsgCreateCookbook() => create();
  factory MsgCreateCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateCookbook clone() => MsgCreateCookbook()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateCookbook copyWith(void Function(MsgCreateCookbook) updates) => super.copyWith((message) => updates(message as MsgCreateCookbook)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbook create() => MsgCreateCookbook._();
  MsgCreateCookbook createEmptyInstance() => create();
  static $pb.PbList<MsgCreateCookbook> createRepeated() => $pb.PbList<MsgCreateCookbook>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateCookbook>(create);
  static MsgCreateCookbook _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get developer => $_getSZ(4);
  @$pb.TagNumber(5)
  set developer($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeveloper() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeveloper() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get supportEmail => $_getSZ(5);
  @$pb.TagNumber(6)
  set supportEmail($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSupportEmail() => $_has(5);
  @$pb.TagNumber(6)
  void clearSupportEmail() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get level => $_getI64(6);
  @$pb.TagNumber(7)
  set level($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearLevel() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sender => $_getSZ(7);
  @$pb.TagNumber(8)
  set sender($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSender() => $_has(7);
  @$pb.TagNumber(8)
  void clearSender() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get costPerBlock => $_getI64(8);
  @$pb.TagNumber(9)
  set costPerBlock($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCostPerBlock() => $_has(8);
  @$pb.TagNumber(9)
  void clearCostPerBlock() => clearField(9);
}

class MsgCreateCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgCreateCookbookResponse._() : super();
  factory MsgCreateCookbookResponse() => create();
  factory MsgCreateCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateCookbookResponse clone() => MsgCreateCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateCookbookResponse copyWith(void Function(MsgCreateCookbookResponse) updates) => super.copyWith((message) => updates(message as MsgCreateCookbookResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbookResponse create() => MsgCreateCookbookResponse._();
  MsgCreateCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateCookbookResponse> createRepeated() => $pb.PbList<MsgCreateCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateCookbookResponse>(create);
  static MsgCreateCookbookResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class MsgCreateRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..pc<$3.CoinInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: $3.CoinInput.create)
    ..pc<$3.ItemInput>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: $3.ItemInput.create)
    ..pc<$3.WeightedOutputs>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Outputs', $pb.PbFieldType.PM, protoName: 'Outputs', subBuilder: $3.WeightedOutputs.create)
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockInterval', protoName: 'BlockInterval')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aOM<$3.EntriesList>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Entries', protoName: 'Entries', subBuilder: $3.EntriesList.create)
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ExtraInfo', protoName: 'ExtraInfo')
    ..hasRequiredFields = false
  ;

  MsgCreateRecipe._() : super();
  factory MsgCreateRecipe() => create();
  factory MsgCreateRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateRecipe clone() => MsgCreateRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateRecipe copyWith(void Function(MsgCreateRecipe) updates) => super.copyWith((message) => updates(message as MsgCreateRecipe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipe create() => MsgCreateRecipe._();
  MsgCreateRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgCreateRecipe> createRepeated() => $pb.PbList<MsgCreateRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateRecipe>(create);
  static MsgCreateRecipe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get cookbookID => $_getSZ(2);
  @$pb.TagNumber(3)
  set cookbookID($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCookbookID() => $_has(2);
  @$pb.TagNumber(3)
  void clearCookbookID() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$3.CoinInput> get coinInputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$3.ItemInput> get itemInputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$3.WeightedOutputs> get outputs => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get blockInterval => $_getI64(6);
  @$pb.TagNumber(7)
  set blockInterval($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBlockInterval() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockInterval() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sender => $_getSZ(7);
  @$pb.TagNumber(8)
  set sender($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSender() => $_has(7);
  @$pb.TagNumber(8)
  void clearSender() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => clearField(9);

  @$pb.TagNumber(10)
  $3.EntriesList get entries => $_getN(9);
  @$pb.TagNumber(10)
  set entries($3.EntriesList v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasEntries() => $_has(9);
  @$pb.TagNumber(10)
  void clearEntries() => clearField(10);
  @$pb.TagNumber(10)
  $3.EntriesList ensureEntries() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get extraInfo => $_getSZ(10);
  @$pb.TagNumber(11)
  set extraInfo($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasExtraInfo() => $_has(10);
  @$pb.TagNumber(11)
  void clearExtraInfo() => clearField(11);
}

class MsgCreateRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgCreateRecipeResponse._() : super();
  factory MsgCreateRecipeResponse() => create();
  factory MsgCreateRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateRecipeResponse clone() => MsgCreateRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateRecipeResponse copyWith(void Function(MsgCreateRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgCreateRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipeResponse create() => MsgCreateRecipeResponse._();
  MsgCreateRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateRecipeResponse> createRepeated() => $pb.PbList<MsgCreateRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateRecipeResponse>(create);
  static MsgCreateRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class MsgCreateTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.CoinInput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: $3.CoinInput.create)
    ..pc<$3.TradeItemInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: $3.TradeItemInput.create)
    ..pc<$2.Coin>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinOutputs', $pb.PbFieldType.PM, protoName: 'CoinOutputs', subBuilder: $2.Coin.create)
    ..pc<$3.Item>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemOutputs', $pb.PbFieldType.PM, protoName: 'ItemOutputs', subBuilder: $3.Item.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ExtraInfo', protoName: 'ExtraInfo')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  MsgCreateTrade._() : super();
  factory MsgCreateTrade() => create();
  factory MsgCreateTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateTrade clone() => MsgCreateTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateTrade copyWith(void Function(MsgCreateTrade) updates) => super.copyWith((message) => updates(message as MsgCreateTrade)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateTrade create() => MsgCreateTrade._();
  MsgCreateTrade createEmptyInstance() => create();
  static $pb.PbList<MsgCreateTrade> createRepeated() => $pb.PbList<MsgCreateTrade>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateTrade>(create);
  static MsgCreateTrade _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.CoinInput> get coinInputs => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$3.TradeItemInput> get itemInputs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$2.Coin> get coinOutputs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$3.Item> get itemOutputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get extraInfo => $_getSZ(4);
  @$pb.TagNumber(5)
  set extraInfo($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExtraInfo() => $_has(4);
  @$pb.TagNumber(5)
  void clearExtraInfo() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get sender => $_getSZ(5);
  @$pb.TagNumber(6)
  set sender($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSender() => $_has(5);
  @$pb.TagNumber(6)
  void clearSender() => clearField(6);
}

class MsgCreateTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TradeID', protoName: 'TradeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgCreateTradeResponse._() : super();
  factory MsgCreateTradeResponse() => create();
  factory MsgCreateTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateTradeResponse clone() => MsgCreateTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateTradeResponse copyWith(void Function(MsgCreateTradeResponse) updates) => super.copyWith((message) => updates(message as MsgCreateTradeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateTradeResponse create() => MsgCreateTradeResponse._();
  MsgCreateTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateTradeResponse> createRepeated() => $pb.PbList<MsgCreateTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateTradeResponse>(create);
  static MsgCreateTradeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tradeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set tradeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTradeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTradeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class MsgDisableRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgDisableRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  MsgDisableRecipe._() : super();
  factory MsgDisableRecipe() => create();
  factory MsgDisableRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgDisableRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgDisableRecipe clone() => MsgDisableRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgDisableRecipe copyWith(void Function(MsgDisableRecipe) updates) => super.copyWith((message) => updates(message as MsgDisableRecipe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgDisableRecipe create() => MsgDisableRecipe._();
  MsgDisableRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgDisableRecipe> createRepeated() => $pb.PbList<MsgDisableRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgDisableRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgDisableRecipe>(create);
  static MsgDisableRecipe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);
}

class MsgDisableRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgDisableRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgDisableRecipeResponse._() : super();
  factory MsgDisableRecipeResponse() => create();
  factory MsgDisableRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgDisableRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgDisableRecipeResponse clone() => MsgDisableRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgDisableRecipeResponse copyWith(void Function(MsgDisableRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgDisableRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgDisableRecipeResponse create() => MsgDisableRecipeResponse._();
  MsgDisableRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgDisableRecipeResponse> createRepeated() => $pb.PbList<MsgDisableRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgDisableRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgDisableRecipeResponse>(create);
  static MsgDisableRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgDisableTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgDisableTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TradeID', protoName: 'TradeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  MsgDisableTrade._() : super();
  factory MsgDisableTrade() => create();
  factory MsgDisableTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgDisableTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgDisableTrade clone() => MsgDisableTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgDisableTrade copyWith(void Function(MsgDisableTrade) updates) => super.copyWith((message) => updates(message as MsgDisableTrade)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgDisableTrade create() => MsgDisableTrade._();
  MsgDisableTrade createEmptyInstance() => create();
  static $pb.PbList<MsgDisableTrade> createRepeated() => $pb.PbList<MsgDisableTrade>();
  @$core.pragma('dart2js:noInline')
  static MsgDisableTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgDisableTrade>(create);
  static MsgDisableTrade _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tradeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set tradeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTradeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTradeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);
}

class MsgDisableTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgDisableTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgDisableTradeResponse._() : super();
  factory MsgDisableTradeResponse() => create();
  factory MsgDisableTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgDisableTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgDisableTradeResponse clone() => MsgDisableTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgDisableTradeResponse copyWith(void Function(MsgDisableTradeResponse) updates) => super.copyWith((message) => updates(message as MsgDisableTradeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgDisableTradeResponse create() => MsgDisableTradeResponse._();
  MsgDisableTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgDisableTradeResponse> createRepeated() => $pb.PbList<MsgDisableTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgDisableTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgDisableTradeResponse>(create);
  static MsgDisableTradeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgEnableRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgEnableRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  MsgEnableRecipe._() : super();
  factory MsgEnableRecipe() => create();
  factory MsgEnableRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgEnableRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgEnableRecipe clone() => MsgEnableRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgEnableRecipe copyWith(void Function(MsgEnableRecipe) updates) => super.copyWith((message) => updates(message as MsgEnableRecipe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgEnableRecipe create() => MsgEnableRecipe._();
  MsgEnableRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgEnableRecipe> createRepeated() => $pb.PbList<MsgEnableRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgEnableRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgEnableRecipe>(create);
  static MsgEnableRecipe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);
}

class MsgEnableRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgEnableRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgEnableRecipeResponse._() : super();
  factory MsgEnableRecipeResponse() => create();
  factory MsgEnableRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgEnableRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgEnableRecipeResponse clone() => MsgEnableRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgEnableRecipeResponse copyWith(void Function(MsgEnableRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgEnableRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgEnableRecipeResponse create() => MsgEnableRecipeResponse._();
  MsgEnableRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgEnableRecipeResponse> createRepeated() => $pb.PbList<MsgEnableRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgEnableRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgEnableRecipeResponse>(create);
  static MsgEnableRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgEnableTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgEnableTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TradeID', protoName: 'TradeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  MsgEnableTrade._() : super();
  factory MsgEnableTrade() => create();
  factory MsgEnableTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgEnableTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgEnableTrade clone() => MsgEnableTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgEnableTrade copyWith(void Function(MsgEnableTrade) updates) => super.copyWith((message) => updates(message as MsgEnableTrade)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgEnableTrade create() => MsgEnableTrade._();
  MsgEnableTrade createEmptyInstance() => create();
  static $pb.PbList<MsgEnableTrade> createRepeated() => $pb.PbList<MsgEnableTrade>();
  @$core.pragma('dart2js:noInline')
  static MsgEnableTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgEnableTrade>(create);
  static MsgEnableTrade _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tradeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set tradeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTradeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTradeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);
}

class MsgEnableTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgEnableTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgEnableTradeResponse._() : super();
  factory MsgEnableTradeResponse() => create();
  factory MsgEnableTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgEnableTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgEnableTradeResponse clone() => MsgEnableTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgEnableTradeResponse copyWith(void Function(MsgEnableTradeResponse) updates) => super.copyWith((message) => updates(message as MsgEnableTradeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgEnableTradeResponse create() => MsgEnableTradeResponse._();
  MsgEnableTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgEnableTradeResponse> createRepeated() => $pb.PbList<MsgEnableTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgEnableTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgEnableTradeResponse>(create);
  static MsgEnableTradeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgExecuteRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgExecuteRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemIDs', protoName: 'ItemIDs')
    ..hasRequiredFields = false
  ;

  MsgExecuteRecipe._() : super();
  factory MsgExecuteRecipe() => create();
  factory MsgExecuteRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgExecuteRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgExecuteRecipe clone() => MsgExecuteRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgExecuteRecipe copyWith(void Function(MsgExecuteRecipe) updates) => super.copyWith((message) => updates(message as MsgExecuteRecipe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipe create() => MsgExecuteRecipe._();
  MsgExecuteRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgExecuteRecipe> createRepeated() => $pb.PbList<MsgExecuteRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgExecuteRecipe>(create);
  static MsgExecuteRecipe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get itemIDs => $_getList(2);
}

class MsgExecuteRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgExecuteRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Output', $pb.PbFieldType.OY, protoName: 'Output')
    ..hasRequiredFields = false
  ;

  MsgExecuteRecipeResponse._() : super();
  factory MsgExecuteRecipeResponse() => create();
  factory MsgExecuteRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgExecuteRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgExecuteRecipeResponse clone() => MsgExecuteRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgExecuteRecipeResponse copyWith(void Function(MsgExecuteRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgExecuteRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipeResponse create() => MsgExecuteRecipeResponse._();
  MsgExecuteRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgExecuteRecipeResponse> createRepeated() => $pb.PbList<MsgExecuteRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgExecuteRecipeResponse>(create);
  static MsgExecuteRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get output => $_getN(2);
  @$pb.TagNumber(3)
  set output($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOutput() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutput() => clearField(3);
}

class MsgFiatItem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFiatItem', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..pc<$3.DoubleKeyValue>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Doubles', $pb.PbFieldType.PM, protoName: 'Doubles', subBuilder: $3.DoubleKeyValue.create)
    ..pc<$3.LongKeyValue>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Longs', $pb.PbFieldType.PM, protoName: 'Longs', subBuilder: $3.LongKeyValue.create)
    ..pc<$3.StringKeyValue>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Strings', $pb.PbFieldType.PM, protoName: 'Strings', subBuilder: $3.StringKeyValue.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TransferFee', protoName: 'TransferFee')
    ..hasRequiredFields = false
  ;

  MsgFiatItem._() : super();
  factory MsgFiatItem() => create();
  factory MsgFiatItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgFiatItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgFiatItem clone() => MsgFiatItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgFiatItem copyWith(void Function(MsgFiatItem) updates) => super.copyWith((message) => updates(message as MsgFiatItem)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgFiatItem create() => MsgFiatItem._();
  MsgFiatItem createEmptyInstance() => create();
  static $pb.PbList<MsgFiatItem> createRepeated() => $pb.PbList<MsgFiatItem>();
  @$core.pragma('dart2js:noInline')
  static MsgFiatItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgFiatItem>(create);
  static MsgFiatItem _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$3.DoubleKeyValue> get doubles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$3.LongKeyValue> get longs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$3.StringKeyValue> get strings => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get sender => $_getSZ(4);
  @$pb.TagNumber(5)
  set sender($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSender() => $_has(4);
  @$pb.TagNumber(5)
  void clearSender() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get transferFee => $_getI64(5);
  @$pb.TagNumber(6)
  set transferFee($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTransferFee() => $_has(5);
  @$pb.TagNumber(6)
  void clearTransferFee() => clearField(6);
}

class MsgFiatItemResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFiatItemResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemID', protoName: 'ItemID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgFiatItemResponse._() : super();
  factory MsgFiatItemResponse() => create();
  factory MsgFiatItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgFiatItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgFiatItemResponse clone() => MsgFiatItemResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgFiatItemResponse copyWith(void Function(MsgFiatItemResponse) updates) => super.copyWith((message) => updates(message as MsgFiatItemResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgFiatItemResponse create() => MsgFiatItemResponse._();
  MsgFiatItemResponse createEmptyInstance() => create();
  static $pb.PbList<MsgFiatItemResponse> createRepeated() => $pb.PbList<MsgFiatItemResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgFiatItemResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgFiatItemResponse>(create);
  static MsgFiatItemResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemID => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasItemID() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class MsgFulfillTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFulfillTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TradeID', protoName: 'TradeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemIDs', protoName: 'ItemIDs')
    ..hasRequiredFields = false
  ;

  MsgFulfillTrade._() : super();
  factory MsgFulfillTrade() => create();
  factory MsgFulfillTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgFulfillTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgFulfillTrade clone() => MsgFulfillTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgFulfillTrade copyWith(void Function(MsgFulfillTrade) updates) => super.copyWith((message) => updates(message as MsgFulfillTrade)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTrade create() => MsgFulfillTrade._();
  MsgFulfillTrade createEmptyInstance() => create();
  static $pb.PbList<MsgFulfillTrade> createRepeated() => $pb.PbList<MsgFulfillTrade>();
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgFulfillTrade>(create);
  static MsgFulfillTrade _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tradeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set tradeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTradeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTradeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get itemIDs => $_getList(2);
}

class MsgFulfillTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFulfillTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgFulfillTradeResponse._() : super();
  factory MsgFulfillTradeResponse() => create();
  factory MsgFulfillTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgFulfillTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgFulfillTradeResponse clone() => MsgFulfillTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgFulfillTradeResponse copyWith(void Function(MsgFulfillTradeResponse) updates) => super.copyWith((message) => updates(message as MsgFulfillTradeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTradeResponse create() => MsgFulfillTradeResponse._();
  MsgFulfillTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgFulfillTradeResponse> createRepeated() => $pb.PbList<MsgFulfillTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgFulfillTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgFulfillTradeResponse>(create);
  static MsgFulfillTradeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgGetPylons extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGetPylons', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$2.Coin>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Amount', $pb.PbFieldType.PM, protoName: 'Amount', subBuilder: $2.Coin.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Requester', protoName: 'Requester')
    ..hasRequiredFields = false
  ;

  MsgGetPylons._() : super();
  factory MsgGetPylons() => create();
  factory MsgGetPylons.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGetPylons.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgGetPylons clone() => MsgGetPylons()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgGetPylons copyWith(void Function(MsgGetPylons) updates) => super.copyWith((message) => updates(message as MsgGetPylons)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgGetPylons create() => MsgGetPylons._();
  MsgGetPylons createEmptyInstance() => create();
  static $pb.PbList<MsgGetPylons> createRepeated() => $pb.PbList<MsgGetPylons>();
  @$core.pragma('dart2js:noInline')
  static MsgGetPylons getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgGetPylons>(create);
  static MsgGetPylons _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$2.Coin> get amount => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get requester => $_getSZ(1);
  @$pb.TagNumber(2)
  set requester($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRequester() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequester() => clearField(2);
}

class MsgGetPylonsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGetPylonsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgGetPylonsResponse._() : super();
  factory MsgGetPylonsResponse() => create();
  factory MsgGetPylonsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGetPylonsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgGetPylonsResponse clone() => MsgGetPylonsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgGetPylonsResponse copyWith(void Function(MsgGetPylonsResponse) updates) => super.copyWith((message) => updates(message as MsgGetPylonsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgGetPylonsResponse create() => MsgGetPylonsResponse._();
  MsgGetPylonsResponse createEmptyInstance() => create();
  static $pb.PbList<MsgGetPylonsResponse> createRepeated() => $pb.PbList<MsgGetPylonsResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgGetPylonsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgGetPylonsResponse>(create);
  static MsgGetPylonsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgGoogleIAPGetPylons extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGoogleIAPGetPylons', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ProductID', protoName: 'ProductID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PurchaseToken', protoName: 'PurchaseToken')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ReceiptDataBase64', protoName: 'ReceiptDataBase64')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Signature', protoName: 'Signature')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Requester', protoName: 'Requester')
    ..hasRequiredFields = false
  ;

  MsgGoogleIAPGetPylons._() : super();
  factory MsgGoogleIAPGetPylons() => create();
  factory MsgGoogleIAPGetPylons.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGoogleIAPGetPylons.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgGoogleIAPGetPylons clone() => MsgGoogleIAPGetPylons()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgGoogleIAPGetPylons copyWith(void Function(MsgGoogleIAPGetPylons) updates) => super.copyWith((message) => updates(message as MsgGoogleIAPGetPylons)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgGoogleIAPGetPylons create() => MsgGoogleIAPGetPylons._();
  MsgGoogleIAPGetPylons createEmptyInstance() => create();
  static $pb.PbList<MsgGoogleIAPGetPylons> createRepeated() => $pb.PbList<MsgGoogleIAPGetPylons>();
  @$core.pragma('dart2js:noInline')
  static MsgGoogleIAPGetPylons getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgGoogleIAPGetPylons>(create);
  static MsgGoogleIAPGetPylons _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productID => $_getSZ(0);
  @$pb.TagNumber(1)
  set productID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProductID() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get purchaseToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set purchaseToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPurchaseToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPurchaseToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get receiptDataBase64 => $_getSZ(2);
  @$pb.TagNumber(3)
  set receiptDataBase64($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceiptDataBase64() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiptDataBase64() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get signature => $_getSZ(3);
  @$pb.TagNumber(4)
  set signature($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSignature() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignature() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get requester => $_getSZ(4);
  @$pb.TagNumber(5)
  set requester($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRequester() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequester() => clearField(5);
}

class MsgGoogleIAPGetPylonsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGoogleIAPGetPylonsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgGoogleIAPGetPylonsResponse._() : super();
  factory MsgGoogleIAPGetPylonsResponse() => create();
  factory MsgGoogleIAPGetPylonsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGoogleIAPGetPylonsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgGoogleIAPGetPylonsResponse clone() => MsgGoogleIAPGetPylonsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgGoogleIAPGetPylonsResponse copyWith(void Function(MsgGoogleIAPGetPylonsResponse) updates) => super.copyWith((message) => updates(message as MsgGoogleIAPGetPylonsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgGoogleIAPGetPylonsResponse create() => MsgGoogleIAPGetPylonsResponse._();
  MsgGoogleIAPGetPylonsResponse createEmptyInstance() => create();
  static $pb.PbList<MsgGoogleIAPGetPylonsResponse> createRepeated() => $pb.PbList<MsgGoogleIAPGetPylonsResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgGoogleIAPGetPylonsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgGoogleIAPGetPylonsResponse>(create);
  static MsgGoogleIAPGetPylonsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgSendCoins extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendCoins', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$2.Coin>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Amount', $pb.PbFieldType.PM, protoName: 'Amount', subBuilder: $2.Coin.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Receiver', protoName: 'Receiver')
    ..hasRequiredFields = false
  ;

  MsgSendCoins._() : super();
  factory MsgSendCoins() => create();
  factory MsgSendCoins.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSendCoins.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSendCoins clone() => MsgSendCoins()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgSendCoins copyWith(void Function(MsgSendCoins) updates) => super.copyWith((message) => updates(message as MsgSendCoins)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSendCoins create() => MsgSendCoins._();
  MsgSendCoins createEmptyInstance() => create();
  static $pb.PbList<MsgSendCoins> createRepeated() => $pb.PbList<MsgSendCoins>();
  @$core.pragma('dart2js:noInline')
  static MsgSendCoins getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSendCoins>(create);
  static MsgSendCoins _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$2.Coin> get amount => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get receiver => $_getSZ(2);
  @$pb.TagNumber(3)
  set receiver($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceiver() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiver() => clearField(3);
}

class MsgSendCoinsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendCoinsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgSendCoinsResponse._() : super();
  factory MsgSendCoinsResponse() => create();
  factory MsgSendCoinsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSendCoinsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSendCoinsResponse clone() => MsgSendCoinsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgSendCoinsResponse copyWith(void Function(MsgSendCoinsResponse) updates) => super.copyWith((message) => updates(message as MsgSendCoinsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSendCoinsResponse create() => MsgSendCoinsResponse._();
  MsgSendCoinsResponse createEmptyInstance() => create();
  static $pb.PbList<MsgSendCoinsResponse> createRepeated() => $pb.PbList<MsgSendCoinsResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgSendCoinsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSendCoinsResponse>(create);
  static MsgSendCoinsResponse _defaultInstance;
}

class MsgSendItems extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendItems', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemIDs', protoName: 'ItemIDs')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Receiver', protoName: 'Receiver')
    ..hasRequiredFields = false
  ;

  MsgSendItems._() : super();
  factory MsgSendItems() => create();
  factory MsgSendItems.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSendItems.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSendItems clone() => MsgSendItems()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgSendItems copyWith(void Function(MsgSendItems) updates) => super.copyWith((message) => updates(message as MsgSendItems)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSendItems create() => MsgSendItems._();
  MsgSendItems createEmptyInstance() => create();
  static $pb.PbList<MsgSendItems> createRepeated() => $pb.PbList<MsgSendItems>();
  @$core.pragma('dart2js:noInline')
  static MsgSendItems getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSendItems>(create);
  static MsgSendItems _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get itemIDs => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get receiver => $_getSZ(2);
  @$pb.TagNumber(3)
  set receiver($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceiver() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiver() => clearField(3);
}

class MsgSendItemsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendItemsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgSendItemsResponse._() : super();
  factory MsgSendItemsResponse() => create();
  factory MsgSendItemsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSendItemsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSendItemsResponse clone() => MsgSendItemsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgSendItemsResponse copyWith(void Function(MsgSendItemsResponse) updates) => super.copyWith((message) => updates(message as MsgSendItemsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSendItemsResponse create() => MsgSendItemsResponse._();
  MsgSendItemsResponse createEmptyInstance() => create();
  static $pb.PbList<MsgSendItemsResponse> createRepeated() => $pb.PbList<MsgSendItemsResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgSendItemsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSendItemsResponse>(create);
  static MsgSendItemsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class MsgUpdateItemString extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateItemString', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Field', protoName: 'Field')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Value', protoName: 'Value')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemID', protoName: 'ItemID')
    ..hasRequiredFields = false
  ;

  MsgUpdateItemString._() : super();
  factory MsgUpdateItemString() => create();
  factory MsgUpdateItemString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateItemString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateItemString clone() => MsgUpdateItemString()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUpdateItemString copyWith(void Function(MsgUpdateItemString) updates) => super.copyWith((message) => updates(message as MsgUpdateItemString)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateItemString create() => MsgUpdateItemString._();
  MsgUpdateItemString createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateItemString> createRepeated() => $pb.PbList<MsgUpdateItemString>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateItemString getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateItemString>(create);
  static MsgUpdateItemString _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sender => $_getSZ(2);
  @$pb.TagNumber(3)
  set sender($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSender() => $_has(2);
  @$pb.TagNumber(3)
  void clearSender() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get itemID => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemID($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasItemID() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemID() => clearField(4);
}

class MsgUpdateItemStringResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateItemStringResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..hasRequiredFields = false
  ;

  MsgUpdateItemStringResponse._() : super();
  factory MsgUpdateItemStringResponse() => create();
  factory MsgUpdateItemStringResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateItemStringResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateItemStringResponse clone() => MsgUpdateItemStringResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUpdateItemStringResponse copyWith(void Function(MsgUpdateItemStringResponse) updates) => super.copyWith((message) => updates(message as MsgUpdateItemStringResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateItemStringResponse create() => MsgUpdateItemStringResponse._();
  MsgUpdateItemStringResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateItemStringResponse> createRepeated() => $pb.PbList<MsgUpdateItemStringResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateItemStringResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateItemStringResponse>(create);
  static MsgUpdateItemStringResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class MsgUpdateCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Version', protoName: 'Version')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Developer', protoName: 'Developer')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'SupportEmail', protoName: 'SupportEmail')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  MsgUpdateCookbook._() : super();
  factory MsgUpdateCookbook() => create();
  factory MsgUpdateCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateCookbook clone() => MsgUpdateCookbook()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUpdateCookbook copyWith(void Function(MsgUpdateCookbook) updates) => super.copyWith((message) => updates(message as MsgUpdateCookbook)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbook create() => MsgUpdateCookbook._();
  MsgUpdateCookbook createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateCookbook> createRepeated() => $pb.PbList<MsgUpdateCookbook>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateCookbook>(create);
  static MsgUpdateCookbook _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get developer => $_getSZ(3);
  @$pb.TagNumber(4)
  set developer($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDeveloper() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeveloper() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get supportEmail => $_getSZ(4);
  @$pb.TagNumber(5)
  set supportEmail($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSupportEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearSupportEmail() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get sender => $_getSZ(5);
  @$pb.TagNumber(6)
  set sender($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSender() => $_has(5);
  @$pb.TagNumber(6)
  void clearSender() => clearField(6);
}

class MsgUpdateCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgUpdateCookbookResponse._() : super();
  factory MsgUpdateCookbookResponse() => create();
  factory MsgUpdateCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateCookbookResponse clone() => MsgUpdateCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUpdateCookbookResponse copyWith(void Function(MsgUpdateCookbookResponse) updates) => super.copyWith((message) => updates(message as MsgUpdateCookbookResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbookResponse create() => MsgUpdateCookbookResponse._();
  MsgUpdateCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateCookbookResponse> createRepeated() => $pb.PbList<MsgUpdateCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateCookbookResponse>(create);
  static MsgUpdateCookbookResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class MsgUpdateRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<$3.CoinInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: $3.CoinInput.create)
    ..pc<$3.ItemInput>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: $3.ItemInput.create)
    ..pc<$3.WeightedOutputs>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Outputs', $pb.PbFieldType.PM, protoName: 'Outputs', subBuilder: $3.WeightedOutputs.create)
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockInterval', protoName: 'BlockInterval')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aOM<$3.EntriesList>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Entries', protoName: 'Entries', subBuilder: $3.EntriesList.create)
    ..hasRequiredFields = false
  ;

  MsgUpdateRecipe._() : super();
  factory MsgUpdateRecipe() => create();
  factory MsgUpdateRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateRecipe clone() => MsgUpdateRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUpdateRecipe copyWith(void Function(MsgUpdateRecipe) updates) => super.copyWith((message) => updates(message as MsgUpdateRecipe)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipe create() => MsgUpdateRecipe._();
  MsgUpdateRecipe createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateRecipe> createRepeated() => $pb.PbList<MsgUpdateRecipe>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateRecipe>(create);
  static MsgUpdateRecipe _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookID => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookID() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get iD => $_getSZ(2);
  @$pb.TagNumber(3)
  set iD($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasID() => $_has(2);
  @$pb.TagNumber(3)
  void clearID() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$3.CoinInput> get coinInputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$3.ItemInput> get itemInputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$3.WeightedOutputs> get outputs => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get blockInterval => $_getI64(6);
  @$pb.TagNumber(7)
  set blockInterval($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBlockInterval() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockInterval() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sender => $_getSZ(7);
  @$pb.TagNumber(8)
  set sender($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSender() => $_has(7);
  @$pb.TagNumber(8)
  void clearSender() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => clearField(9);

  @$pb.TagNumber(10)
  $3.EntriesList get entries => $_getN(9);
  @$pb.TagNumber(10)
  set entries($3.EntriesList v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasEntries() => $_has(9);
  @$pb.TagNumber(10)
  void clearEntries() => clearField(10);
  @$pb.TagNumber(10)
  $3.EntriesList ensureEntries() => $_ensure(9);
}

class MsgUpdateRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Status', protoName: 'Status')
    ..hasRequiredFields = false
  ;

  MsgUpdateRecipeResponse._() : super();
  factory MsgUpdateRecipeResponse() => create();
  factory MsgUpdateRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateRecipeResponse clone() => MsgUpdateRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUpdateRecipeResponse copyWith(void Function(MsgUpdateRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgUpdateRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipeResponse create() => MsgUpdateRecipeResponse._();
  MsgUpdateRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateRecipeResponse> createRepeated() => $pb.PbList<MsgUpdateRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateRecipeResponse>(create);
  static MsgUpdateRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

