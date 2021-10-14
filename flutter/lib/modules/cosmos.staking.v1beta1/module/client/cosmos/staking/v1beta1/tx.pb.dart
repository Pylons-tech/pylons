///
//  Generated code. Do not modify.
//  source: cosmos/staking/v1beta1/tx.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'staking.pb.dart' as $11;
import '../../../google/protobuf/any.pb.dart' as $9;
import '../../base/v1beta1/coin.pb.dart' as $2;
import '../../../google/protobuf/timestamp.pb.dart' as $6;

class MsgCreateValidator extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateValidator', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..aOM<$11.Description>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description', subBuilder: $11.Description.create)
    ..aOM<$11.CommissionRates>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'commission', subBuilder: $11.CommissionRates.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minSelfDelegation')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'delegatorAddress')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'validatorAddress')
    ..aOM<$9.Any>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', subBuilder: $9.Any.create)
    ..aOM<$2.Coin>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  MsgCreateValidator._() : super();
  factory MsgCreateValidator({
    $11.Description? description,
    $11.CommissionRates? commission,
    $core.String? minSelfDelegation,
    $core.String? delegatorAddress,
    $core.String? validatorAddress,
    $9.Any? pubkey,
    $2.Coin? value,
  }) {
    final _result = create();
    if (description != null) {
      _result.description = description;
    }
    if (commission != null) {
      _result.commission = commission;
    }
    if (minSelfDelegation != null) {
      _result.minSelfDelegation = minSelfDelegation;
    }
    if (delegatorAddress != null) {
      _result.delegatorAddress = delegatorAddress;
    }
    if (validatorAddress != null) {
      _result.validatorAddress = validatorAddress;
    }
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory MsgCreateValidator.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateValidator.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateValidator clone() => MsgCreateValidator()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateValidator copyWith(void Function(MsgCreateValidator) updates) => super.copyWith((message) => updates(message as MsgCreateValidator)) as MsgCreateValidator; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateValidator create() => MsgCreateValidator._();
  MsgCreateValidator createEmptyInstance() => create();
  static $pb.PbList<MsgCreateValidator> createRepeated() => $pb.PbList<MsgCreateValidator>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateValidator getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateValidator>(create);
  static MsgCreateValidator? _defaultInstance;

  @$pb.TagNumber(1)
  $11.Description get description => $_getN(0);
  @$pb.TagNumber(1)
  set description($11.Description v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescription() => clearField(1);
  @$pb.TagNumber(1)
  $11.Description ensureDescription() => $_ensure(0);

  @$pb.TagNumber(2)
  $11.CommissionRates get commission => $_getN(1);
  @$pb.TagNumber(2)
  set commission($11.CommissionRates v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCommission() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommission() => clearField(2);
  @$pb.TagNumber(2)
  $11.CommissionRates ensureCommission() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get minSelfDelegation => $_getSZ(2);
  @$pb.TagNumber(3)
  set minSelfDelegation($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMinSelfDelegation() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinSelfDelegation() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get delegatorAddress => $_getSZ(3);
  @$pb.TagNumber(4)
  set delegatorAddress($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDelegatorAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelegatorAddress() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get validatorAddress => $_getSZ(4);
  @$pb.TagNumber(5)
  set validatorAddress($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValidatorAddress() => $_has(4);
  @$pb.TagNumber(5)
  void clearValidatorAddress() => clearField(5);

  @$pb.TagNumber(6)
  $9.Any get pubkey => $_getN(5);
  @$pb.TagNumber(6)
  set pubkey($9.Any v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasPubkey() => $_has(5);
  @$pb.TagNumber(6)
  void clearPubkey() => clearField(6);
  @$pb.TagNumber(6)
  $9.Any ensurePubkey() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Coin get value => $_getN(6);
  @$pb.TagNumber(7)
  set value($2.Coin v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearValue() => clearField(7);
  @$pb.TagNumber(7)
  $2.Coin ensureValue() => $_ensure(6);
}

class MsgCreateValidatorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateValidatorResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgCreateValidatorResponse._() : super();
  factory MsgCreateValidatorResponse() => create();
  factory MsgCreateValidatorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateValidatorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateValidatorResponse clone() => MsgCreateValidatorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateValidatorResponse copyWith(void Function(MsgCreateValidatorResponse) updates) => super.copyWith((message) => updates(message as MsgCreateValidatorResponse)) as MsgCreateValidatorResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateValidatorResponse create() => MsgCreateValidatorResponse._();
  MsgCreateValidatorResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateValidatorResponse> createRepeated() => $pb.PbList<MsgCreateValidatorResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateValidatorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateValidatorResponse>(create);
  static MsgCreateValidatorResponse? _defaultInstance;
}

class MsgEditValidator extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgEditValidator', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..aOM<$11.Description>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description', subBuilder: $11.Description.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'validatorAddress')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'commissionRate')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minSelfDelegation')
    ..hasRequiredFields = false
  ;

  MsgEditValidator._() : super();
  factory MsgEditValidator({
    $11.Description? description,
    $core.String? validatorAddress,
    $core.String? commissionRate,
    $core.String? minSelfDelegation,
  }) {
    final _result = create();
    if (description != null) {
      _result.description = description;
    }
    if (validatorAddress != null) {
      _result.validatorAddress = validatorAddress;
    }
    if (commissionRate != null) {
      _result.commissionRate = commissionRate;
    }
    if (minSelfDelegation != null) {
      _result.minSelfDelegation = minSelfDelegation;
    }
    return _result;
  }
  factory MsgEditValidator.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgEditValidator.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgEditValidator clone() => MsgEditValidator()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgEditValidator copyWith(void Function(MsgEditValidator) updates) => super.copyWith((message) => updates(message as MsgEditValidator)) as MsgEditValidator; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgEditValidator create() => MsgEditValidator._();
  MsgEditValidator createEmptyInstance() => create();
  static $pb.PbList<MsgEditValidator> createRepeated() => $pb.PbList<MsgEditValidator>();
  @$core.pragma('dart2js:noInline')
  static MsgEditValidator getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgEditValidator>(create);
  static MsgEditValidator? _defaultInstance;

  @$pb.TagNumber(1)
  $11.Description get description => $_getN(0);
  @$pb.TagNumber(1)
  set description($11.Description v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescription() => clearField(1);
  @$pb.TagNumber(1)
  $11.Description ensureDescription() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get validatorAddress => $_getSZ(1);
  @$pb.TagNumber(2)
  set validatorAddress($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValidatorAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidatorAddress() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get commissionRate => $_getSZ(2);
  @$pb.TagNumber(3)
  set commissionRate($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommissionRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommissionRate() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get minSelfDelegation => $_getSZ(3);
  @$pb.TagNumber(4)
  set minSelfDelegation($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinSelfDelegation() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinSelfDelegation() => clearField(4);
}

class MsgEditValidatorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgEditValidatorResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgEditValidatorResponse._() : super();
  factory MsgEditValidatorResponse() => create();
  factory MsgEditValidatorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgEditValidatorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgEditValidatorResponse clone() => MsgEditValidatorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgEditValidatorResponse copyWith(void Function(MsgEditValidatorResponse) updates) => super.copyWith((message) => updates(message as MsgEditValidatorResponse)) as MsgEditValidatorResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgEditValidatorResponse create() => MsgEditValidatorResponse._();
  MsgEditValidatorResponse createEmptyInstance() => create();
  static $pb.PbList<MsgEditValidatorResponse> createRepeated() => $pb.PbList<MsgEditValidatorResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgEditValidatorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgEditValidatorResponse>(create);
  static MsgEditValidatorResponse? _defaultInstance;
}

class MsgDelegate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgDelegate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'delegatorAddress')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'validatorAddress')
    ..aOM<$2.Coin>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  MsgDelegate._() : super();
  factory MsgDelegate({
    $core.String? delegatorAddress,
    $core.String? validatorAddress,
    $2.Coin? amount,
  }) {
    final _result = create();
    if (delegatorAddress != null) {
      _result.delegatorAddress = delegatorAddress;
    }
    if (validatorAddress != null) {
      _result.validatorAddress = validatorAddress;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory MsgDelegate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgDelegate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgDelegate clone() => MsgDelegate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgDelegate copyWith(void Function(MsgDelegate) updates) => super.copyWith((message) => updates(message as MsgDelegate)) as MsgDelegate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgDelegate create() => MsgDelegate._();
  MsgDelegate createEmptyInstance() => create();
  static $pb.PbList<MsgDelegate> createRepeated() => $pb.PbList<MsgDelegate>();
  @$core.pragma('dart2js:noInline')
  static MsgDelegate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgDelegate>(create);
  static MsgDelegate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get delegatorAddress => $_getSZ(0);
  @$pb.TagNumber(1)
  set delegatorAddress($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDelegatorAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelegatorAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get validatorAddress => $_getSZ(1);
  @$pb.TagNumber(2)
  set validatorAddress($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValidatorAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidatorAddress() => clearField(2);

  @$pb.TagNumber(3)
  $2.Coin get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($2.Coin v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  $2.Coin ensureAmount() => $_ensure(2);
}

class MsgDelegateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgDelegateResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgDelegateResponse._() : super();
  factory MsgDelegateResponse() => create();
  factory MsgDelegateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgDelegateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgDelegateResponse clone() => MsgDelegateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgDelegateResponse copyWith(void Function(MsgDelegateResponse) updates) => super.copyWith((message) => updates(message as MsgDelegateResponse)) as MsgDelegateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgDelegateResponse create() => MsgDelegateResponse._();
  MsgDelegateResponse createEmptyInstance() => create();
  static $pb.PbList<MsgDelegateResponse> createRepeated() => $pb.PbList<MsgDelegateResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgDelegateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgDelegateResponse>(create);
  static MsgDelegateResponse? _defaultInstance;
}

class MsgBeginRedelegate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgBeginRedelegate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'delegatorAddress')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'validatorSrcAddress')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'validatorDstAddress')
    ..aOM<$2.Coin>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  MsgBeginRedelegate._() : super();
  factory MsgBeginRedelegate({
    $core.String? delegatorAddress,
    $core.String? validatorSrcAddress,
    $core.String? validatorDstAddress,
    $2.Coin? amount,
  }) {
    final _result = create();
    if (delegatorAddress != null) {
      _result.delegatorAddress = delegatorAddress;
    }
    if (validatorSrcAddress != null) {
      _result.validatorSrcAddress = validatorSrcAddress;
    }
    if (validatorDstAddress != null) {
      _result.validatorDstAddress = validatorDstAddress;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory MsgBeginRedelegate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgBeginRedelegate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgBeginRedelegate clone() => MsgBeginRedelegate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgBeginRedelegate copyWith(void Function(MsgBeginRedelegate) updates) => super.copyWith((message) => updates(message as MsgBeginRedelegate)) as MsgBeginRedelegate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgBeginRedelegate create() => MsgBeginRedelegate._();
  MsgBeginRedelegate createEmptyInstance() => create();
  static $pb.PbList<MsgBeginRedelegate> createRepeated() => $pb.PbList<MsgBeginRedelegate>();
  @$core.pragma('dart2js:noInline')
  static MsgBeginRedelegate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgBeginRedelegate>(create);
  static MsgBeginRedelegate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get delegatorAddress => $_getSZ(0);
  @$pb.TagNumber(1)
  set delegatorAddress($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDelegatorAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelegatorAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get validatorSrcAddress => $_getSZ(1);
  @$pb.TagNumber(2)
  set validatorSrcAddress($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValidatorSrcAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidatorSrcAddress() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get validatorDstAddress => $_getSZ(2);
  @$pb.TagNumber(3)
  set validatorDstAddress($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasValidatorDstAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearValidatorDstAddress() => clearField(3);

  @$pb.TagNumber(4)
  $2.Coin get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($2.Coin v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => clearField(4);
  @$pb.TagNumber(4)
  $2.Coin ensureAmount() => $_ensure(3);
}

class MsgBeginRedelegateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgBeginRedelegateResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..aOM<$6.Timestamp>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'completionTime', subBuilder: $6.Timestamp.create)
    ..hasRequiredFields = false
  ;

  MsgBeginRedelegateResponse._() : super();
  factory MsgBeginRedelegateResponse({
    $6.Timestamp? completionTime,
  }) {
    final _result = create();
    if (completionTime != null) {
      _result.completionTime = completionTime;
    }
    return _result;
  }
  factory MsgBeginRedelegateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgBeginRedelegateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgBeginRedelegateResponse clone() => MsgBeginRedelegateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgBeginRedelegateResponse copyWith(void Function(MsgBeginRedelegateResponse) updates) => super.copyWith((message) => updates(message as MsgBeginRedelegateResponse)) as MsgBeginRedelegateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgBeginRedelegateResponse create() => MsgBeginRedelegateResponse._();
  MsgBeginRedelegateResponse createEmptyInstance() => create();
  static $pb.PbList<MsgBeginRedelegateResponse> createRepeated() => $pb.PbList<MsgBeginRedelegateResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgBeginRedelegateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgBeginRedelegateResponse>(create);
  static MsgBeginRedelegateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Timestamp get completionTime => $_getN(0);
  @$pb.TagNumber(1)
  set completionTime($6.Timestamp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCompletionTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompletionTime() => clearField(1);
  @$pb.TagNumber(1)
  $6.Timestamp ensureCompletionTime() => $_ensure(0);
}

class MsgUndelegate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUndelegate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'delegatorAddress')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'validatorAddress')
    ..aOM<$2.Coin>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  MsgUndelegate._() : super();
  factory MsgUndelegate({
    $core.String? delegatorAddress,
    $core.String? validatorAddress,
    $2.Coin? amount,
  }) {
    final _result = create();
    if (delegatorAddress != null) {
      _result.delegatorAddress = delegatorAddress;
    }
    if (validatorAddress != null) {
      _result.validatorAddress = validatorAddress;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory MsgUndelegate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUndelegate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUndelegate clone() => MsgUndelegate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUndelegate copyWith(void Function(MsgUndelegate) updates) => super.copyWith((message) => updates(message as MsgUndelegate)) as MsgUndelegate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUndelegate create() => MsgUndelegate._();
  MsgUndelegate createEmptyInstance() => create();
  static $pb.PbList<MsgUndelegate> createRepeated() => $pb.PbList<MsgUndelegate>();
  @$core.pragma('dart2js:noInline')
  static MsgUndelegate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUndelegate>(create);
  static MsgUndelegate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get delegatorAddress => $_getSZ(0);
  @$pb.TagNumber(1)
  set delegatorAddress($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDelegatorAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelegatorAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get validatorAddress => $_getSZ(1);
  @$pb.TagNumber(2)
  set validatorAddress($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValidatorAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidatorAddress() => clearField(2);

  @$pb.TagNumber(3)
  $2.Coin get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($2.Coin v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  $2.Coin ensureAmount() => $_ensure(2);
}

class MsgUndelegateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUndelegateResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cosmos.staking.v1beta1'), createEmptyInstance: create)
    ..aOM<$6.Timestamp>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'completionTime', subBuilder: $6.Timestamp.create)
    ..hasRequiredFields = false
  ;

  MsgUndelegateResponse._() : super();
  factory MsgUndelegateResponse({
    $6.Timestamp? completionTime,
  }) {
    final _result = create();
    if (completionTime != null) {
      _result.completionTime = completionTime;
    }
    return _result;
  }
  factory MsgUndelegateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUndelegateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUndelegateResponse clone() => MsgUndelegateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUndelegateResponse copyWith(void Function(MsgUndelegateResponse) updates) => super.copyWith((message) => updates(message as MsgUndelegateResponse)) as MsgUndelegateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUndelegateResponse create() => MsgUndelegateResponse._();
  MsgUndelegateResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUndelegateResponse> createRepeated() => $pb.PbList<MsgUndelegateResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUndelegateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUndelegateResponse>(create);
  static MsgUndelegateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Timestamp get completionTime => $_getN(0);
  @$pb.TagNumber(1)
  set completionTime($6.Timestamp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCompletionTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompletionTime() => clearField(1);
  @$pb.TagNumber(1)
  $6.Timestamp ensureCompletionTime() => $_ensure(0);
}

