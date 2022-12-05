///
//  Generated code. Do not modify.
//  source: pylons/pylons/tx.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'payment_info.pb.dart' as $7;
import 'redeem_info.pb.dart' as $5;
import 'trade.pb.dart' as $8;
import 'recipe.pb.dart' as $4;
import '../cosmos/base/v1beta1/coin.pb.dart' as $2;

class MsgAppleIap extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgAppleIap', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiptDataBase64')
    ..hasRequiredFields = false
  ;

  MsgAppleIap._() : super();
  factory MsgAppleIap({
    $core.String? creator,
    $core.String? productId,
    $core.String? purchaseId,
    $core.String? receiptDataBase64,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (productId != null) {
      _result.productId = productId;
    }
    if (purchaseId != null) {
      _result.purchaseId = purchaseId;
    }
    if (receiptDataBase64 != null) {
      _result.receiptDataBase64 = receiptDataBase64;
    }
    return _result;
  }
  factory MsgAppleIap.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgAppleIap.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgAppleIap clone() => MsgAppleIap()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgAppleIap copyWith(void Function(MsgAppleIap) updates) => super.copyWith((message) => updates(message as MsgAppleIap)) as MsgAppleIap; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgAppleIap create() => MsgAppleIap._();
  MsgAppleIap createEmptyInstance() => create();
  static $pb.PbList<MsgAppleIap> createRepeated() => $pb.PbList<MsgAppleIap>();
  @$core.pragma('dart2js:noInline')
  static MsgAppleIap getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgAppleIap>(create);
  static MsgAppleIap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get purchaseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set purchaseId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPurchaseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurchaseId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get receiptDataBase64 => $_getSZ(3);
  @$pb.TagNumber(4)
  set receiptDataBase64($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasReceiptDataBase64() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceiptDataBase64() => clearField(4);
}

class MsgAppleIapResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgAppleIapResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgAppleIapResponse._() : super();
  factory MsgAppleIapResponse() => create();
  factory MsgAppleIapResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgAppleIapResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgAppleIapResponse clone() => MsgAppleIapResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgAppleIapResponse copyWith(void Function(MsgAppleIapResponse) updates) => super.copyWith((message) => updates(message as MsgAppleIapResponse)) as MsgAppleIapResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgAppleIapResponse create() => MsgAppleIapResponse._();
  MsgAppleIapResponse createEmptyInstance() => create();
  static $pb.PbList<MsgAppleIapResponse> createRepeated() => $pb.PbList<MsgAppleIapResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgAppleIapResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgAppleIapResponse>(create);
  static MsgAppleIapResponse? _defaultInstance;
}

class MsgAddStripeRefund extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgAddStripeRefund', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOM<$7.PaymentInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payment', subBuilder: $7.PaymentInfo.create)
    ..hasRequiredFields = false
  ;

  MsgAddStripeRefund._() : super();
  factory MsgAddStripeRefund({
    $core.String? creator,
    $7.PaymentInfo? payment,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (payment != null) {
      _result.payment = payment;
    }
    return _result;
  }
  factory MsgAddStripeRefund.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgAddStripeRefund.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgAddStripeRefund clone() => MsgAddStripeRefund()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgAddStripeRefund copyWith(void Function(MsgAddStripeRefund) updates) => super.copyWith((message) => updates(message as MsgAddStripeRefund)) as MsgAddStripeRefund; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgAddStripeRefund create() => MsgAddStripeRefund._();
  MsgAddStripeRefund createEmptyInstance() => create();
  static $pb.PbList<MsgAddStripeRefund> createRepeated() => $pb.PbList<MsgAddStripeRefund>();
  @$core.pragma('dart2js:noInline')
  static MsgAddStripeRefund getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgAddStripeRefund>(create);
  static MsgAddStripeRefund? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $7.PaymentInfo get payment => $_getN(1);
  @$pb.TagNumber(2)
  set payment($7.PaymentInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPayment() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayment() => clearField(2);
  @$pb.TagNumber(2)
  $7.PaymentInfo ensurePayment() => $_ensure(1);
}

class MsgAddStripeRefundResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgAddStripeRefundResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgAddStripeRefundResponse._() : super();
  factory MsgAddStripeRefundResponse() => create();
  factory MsgAddStripeRefundResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgAddStripeRefundResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgAddStripeRefundResponse clone() => MsgAddStripeRefundResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgAddStripeRefundResponse copyWith(void Function(MsgAddStripeRefundResponse) updates) => super.copyWith((message) => updates(message as MsgAddStripeRefundResponse)) as MsgAddStripeRefundResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgAddStripeRefundResponse create() => MsgAddStripeRefundResponse._();
  MsgAddStripeRefundResponse createEmptyInstance() => create();
  static $pb.PbList<MsgAddStripeRefundResponse> createRepeated() => $pb.PbList<MsgAddStripeRefundResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgAddStripeRefundResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgAddStripeRefundResponse>(create);
  static MsgAddStripeRefundResponse? _defaultInstance;
}

class MsgBurnDebtToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgBurnDebtToken', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOM<$5.RedeemInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'redeemInfo', subBuilder: $5.RedeemInfo.create)
    ..hasRequiredFields = false
  ;

  MsgBurnDebtToken._() : super();
  factory MsgBurnDebtToken({
    $core.String? creator,
    $5.RedeemInfo? redeemInfo,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (redeemInfo != null) {
      _result.redeemInfo = redeemInfo;
    }
    return _result;
  }
  factory MsgBurnDebtToken.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgBurnDebtToken.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgBurnDebtToken clone() => MsgBurnDebtToken()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgBurnDebtToken copyWith(void Function(MsgBurnDebtToken) updates) => super.copyWith((message) => updates(message as MsgBurnDebtToken)) as MsgBurnDebtToken; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgBurnDebtToken create() => MsgBurnDebtToken._();
  MsgBurnDebtToken createEmptyInstance() => create();
  static $pb.PbList<MsgBurnDebtToken> createRepeated() => $pb.PbList<MsgBurnDebtToken>();
  @$core.pragma('dart2js:noInline')
  static MsgBurnDebtToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgBurnDebtToken>(create);
  static MsgBurnDebtToken? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $5.RedeemInfo get redeemInfo => $_getN(1);
  @$pb.TagNumber(2)
  set redeemInfo($5.RedeemInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRedeemInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedeemInfo() => clearField(2);
  @$pb.TagNumber(2)
  $5.RedeemInfo ensureRedeemInfo() => $_ensure(1);
}

class MsgBurnDebtTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgBurnDebtTokenResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgBurnDebtTokenResponse._() : super();
  factory MsgBurnDebtTokenResponse() => create();
  factory MsgBurnDebtTokenResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgBurnDebtTokenResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgBurnDebtTokenResponse clone() => MsgBurnDebtTokenResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgBurnDebtTokenResponse copyWith(void Function(MsgBurnDebtTokenResponse) updates) => super.copyWith((message) => updates(message as MsgBurnDebtTokenResponse)) as MsgBurnDebtTokenResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgBurnDebtTokenResponse create() => MsgBurnDebtTokenResponse._();
  MsgBurnDebtTokenResponse createEmptyInstance() => create();
  static $pb.PbList<MsgBurnDebtTokenResponse> createRepeated() => $pb.PbList<MsgBurnDebtTokenResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgBurnDebtTokenResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgBurnDebtTokenResponse>(create);
  static MsgBurnDebtTokenResponse? _defaultInstance;
}

class MsgUpdateAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateAccount', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false
  ;

  MsgUpdateAccount._() : super();
  factory MsgUpdateAccount({
    $core.String? creator,
    $core.String? username,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (username != null) {
      _result.username = username;
    }
    return _result;
  }
  factory MsgUpdateAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateAccount clone() => MsgUpdateAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);
}

class MsgUpdateAccountResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateAccountResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgUpdateAccountResponse._() : super();
  factory MsgUpdateAccountResponse() => create();
  factory MsgUpdateAccountResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgUpdateAccountResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgUpdateAccountResponse clone() => MsgUpdateAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgUpdateAccountResponse copyWith(void Function(MsgUpdateAccountResponse) updates) => super.copyWith((message) => updates(message as MsgUpdateAccountResponse)) as MsgUpdateAccountResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateAccount', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'referralAddress')
    ..hasRequiredFields = false
  ;

  MsgCreateAccount._() : super();
  factory MsgCreateAccount({
    $core.String? creator,
    $core.String? token,
    $core.String? referralAddress,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (token != null) {
      _result.token = token;
    }
    if (referralAddress != null) {
      _result.referralAddress = referralAddress;
    }
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get referralAddress => $_getSZ(2);
  @$pb.TagNumber(3)
  set referralAddress($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReferralAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearReferralAddress() => clearField(3);
}

class MsgSetUsername extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSetUsername', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false
  ;

  MsgSetUsername._() : super();
  factory MsgSetUsername({
    $core.String? creator,
    $core.String? username,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (username != null) {
      _result.username = username;
    }
    return _result;
  }
  factory MsgSetUsername.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSetUsername.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSetUsername clone() => MsgSetUsername()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgSetUsername copyWith(void Function(MsgSetUsername) updates) => super.copyWith((message) => updates(message as MsgSetUsername)) as MsgSetUsername; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSetUsername create() => MsgSetUsername._();
  MsgSetUsername createEmptyInstance() => create();
  static $pb.PbList<MsgSetUsername> createRepeated() => $pb.PbList<MsgSetUsername>();
  @$core.pragma('dart2js:noInline')
  static MsgSetUsername getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSetUsername>(create);
  static MsgSetUsername? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);
}

class MsgSetUsernameResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSetUsernameResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgSetUsernameResponse._() : super();
  factory MsgSetUsernameResponse() => create();
  factory MsgSetUsernameResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSetUsernameResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSetUsernameResponse clone() => MsgSetUsernameResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgSetUsernameResponse copyWith(void Function(MsgSetUsernameResponse) updates) => super.copyWith((message) => updates(message as MsgSetUsernameResponse)) as MsgSetUsernameResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgSetUsernameResponse create() => MsgSetUsernameResponse._();
  MsgSetUsernameResponse createEmptyInstance() => create();
  static $pb.PbList<MsgSetUsernameResponse> createRepeated() => $pb.PbList<MsgSetUsernameResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgSetUsernameResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgSetUsernameResponse>(create);
  static MsgSetUsernameResponse? _defaultInstance;
}

class MsgCreateAccountResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateAccountResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgCreateAccountResponse._() : super();
  factory MsgCreateAccountResponse() => create();
  factory MsgCreateAccountResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCreateAccountResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCreateAccountResponse clone() => MsgCreateAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCreateAccountResponse copyWith(void Function(MsgCreateAccountResponse) updates) => super.copyWith((message) => updates(message as MsgCreateAccountResponse)) as MsgCreateAccountResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFulfillTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputsIndex', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$8.ItemRef>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: $8.ItemRef.create)
    ..pc<$7.PaymentInfo>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentInfos', $pb.PbFieldType.PM, subBuilder: $7.PaymentInfo.create)
    ..hasRequiredFields = false
  ;

  MsgFulfillTrade._() : super();
  factory MsgFulfillTrade({
    $core.String? creator,
    $fixnum.Int64? id,
    $fixnum.Int64? coinInputsIndex,
    $core.Iterable<$8.ItemRef>? items,
    $core.Iterable<$7.PaymentInfo>? paymentInfos,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (id != null) {
      _result.id = id;
    }
    if (coinInputsIndex != null) {
      _result.coinInputsIndex = coinInputsIndex;
    }
    if (items != null) {
      _result.items.addAll(items);
    }
    if (paymentInfos != null) {
      _result.paymentInfos.addAll(paymentInfos);
    }
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get coinInputsIndex => $_getI64(2);
  @$pb.TagNumber(3)
  set coinInputsIndex($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCoinInputsIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoinInputsIndex() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$8.ItemRef> get items => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$7.PaymentInfo> get paymentInfos => $_getList(4);
}

class MsgFulfillTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgFulfillTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
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
  MsgFulfillTradeResponse copyWith(void Function(MsgFulfillTradeResponse) updates) => super.copyWith((message) => updates(message as MsgFulfillTradeResponse)) as MsgFulfillTradeResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..pc<$4.CoinInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, subBuilder: $4.CoinInput.create)
    ..pc<$4.ItemInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, subBuilder: $4.ItemInput.create)
    ..pc<$2.Coin>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinOutputs', $pb.PbFieldType.PM, subBuilder: $2.Coin.create)
    ..pc<$8.ItemRef>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemOutputs', $pb.PbFieldType.PM, subBuilder: $8.ItemRef.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo')
    ..hasRequiredFields = false
  ;

  MsgCreateTrade._() : super();
  factory MsgCreateTrade({
    $core.String? creator,
    $core.Iterable<$4.CoinInput>? coinInputs,
    $core.Iterable<$4.ItemInput>? itemInputs,
    $core.Iterable<$2.Coin>? coinOutputs,
    $core.Iterable<$8.ItemRef>? itemOutputs,
    $core.String? extraInfo,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (coinInputs != null) {
      _result.coinInputs.addAll(coinInputs);
    }
    if (itemInputs != null) {
      _result.itemInputs.addAll(itemInputs);
    }
    if (coinOutputs != null) {
      _result.coinOutputs.addAll(coinOutputs);
    }
    if (itemOutputs != null) {
      _result.itemOutputs.addAll(itemOutputs);
    }
    if (extraInfo != null) {
      _result.extraInfo = extraInfo;
    }
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
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
  $core.List<$8.ItemRef> get itemOutputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get extraInfo => $_getSZ(5);
  @$pb.TagNumber(6)
  set extraInfo($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasExtraInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearExtraInfo() => clearField(6);
}

class MsgCreateTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  MsgCreateTradeResponse._() : super();
  factory MsgCreateTradeResponse({
    $fixnum.Int64? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
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
  MsgCreateTradeResponse copyWith(void Function(MsgCreateTradeResponse) updates) => super.copyWith((message) => updates(message as MsgCreateTradeResponse)) as MsgCreateTradeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCreateTradeResponse create() => MsgCreateTradeResponse._();
  MsgCreateTradeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCreateTradeResponse> createRepeated() => $pb.PbList<MsgCreateTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCreateTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCreateTradeResponse>(create);
  static MsgCreateTradeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class MsgCancelTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCancelTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  MsgCancelTrade._() : super();
  factory MsgCancelTrade({
    $core.String? creator,
    $fixnum.Int64? id,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory MsgCancelTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCancelTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCancelTrade clone() => MsgCancelTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);
}

class MsgCancelTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCancelTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgCancelTradeResponse._() : super();
  factory MsgCancelTradeResponse() => create();
  factory MsgCancelTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCancelTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCancelTradeResponse clone() => MsgCancelTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCancelTradeResponse copyWith(void Function(MsgCancelTradeResponse) updates) => super.copyWith((message) => updates(message as MsgCancelTradeResponse)) as MsgCancelTradeResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCompleteExecutionEarly', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  MsgCompleteExecutionEarly._() : super();
  factory MsgCompleteExecutionEarly({
    $core.String? creator,
    $core.String? id,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory MsgCompleteExecutionEarly.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCompleteExecutionEarly.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCompleteExecutionEarly clone() => MsgCompleteExecutionEarly()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCompleteExecutionEarly copyWith(void Function(MsgCompleteExecutionEarly) updates) => super.copyWith((message) => updates(message as MsgCompleteExecutionEarly)) as MsgCompleteExecutionEarly; // ignore: deprecated_member_use
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);
}

class MsgCompleteExecutionEarlyResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCompleteExecutionEarlyResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  MsgCompleteExecutionEarlyResponse._() : super();
  factory MsgCompleteExecutionEarlyResponse({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory MsgCompleteExecutionEarlyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgCompleteExecutionEarlyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgCompleteExecutionEarlyResponse clone() => MsgCompleteExecutionEarlyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgCompleteExecutionEarlyResponse copyWith(void Function(MsgCompleteExecutionEarlyResponse) updates) => super.copyWith((message) => updates(message as MsgCompleteExecutionEarlyResponse)) as MsgCompleteExecutionEarlyResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgCompleteExecutionEarlyResponse create() => MsgCompleteExecutionEarlyResponse._();
  MsgCompleteExecutionEarlyResponse createEmptyInstance() => create();
  static $pb.PbList<MsgCompleteExecutionEarlyResponse> createRepeated() => $pb.PbList<MsgCompleteExecutionEarlyResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgCompleteExecutionEarlyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgCompleteExecutionEarlyResponse>(create);
  static MsgCompleteExecutionEarlyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class MsgTransferCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgTransferCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipient')
    ..hasRequiredFields = false
  ;

  MsgTransferCookbook._() : super();
  factory MsgTransferCookbook({
    $core.String? creator,
    $core.String? id,
    $core.String? recipient,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (id != null) {
      _result.id = id;
    }
    if (recipient != null) {
      _result.recipient = recipient;
    }
    return _result;
  }
  factory MsgTransferCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgTransferCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgTransferCookbook clone() => MsgTransferCookbook()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgTransferCookbook copyWith(void Function(MsgTransferCookbook) updates) => super.copyWith((message) => updates(message as MsgTransferCookbook)) as MsgTransferCookbook; // ignore: deprecated_member_use
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipient => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipient($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecipient() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipient() => clearField(3);
}

class MsgTransferCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgTransferCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgTransferCookbookResponse._() : super();
  factory MsgTransferCookbookResponse() => create();
  factory MsgTransferCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgTransferCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgTransferCookbookResponse clone() => MsgTransferCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgTransferCookbookResponse copyWith(void Function(MsgTransferCookbookResponse) updates) => super.copyWith((message) => updates(message as MsgTransferCookbookResponse)) as MsgTransferCookbookResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGoogleInAppPurchaseGetCoins', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiptDataBase64')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature')
    ..hasRequiredFields = false
  ;

  MsgGoogleInAppPurchaseGetCoins._() : super();
  factory MsgGoogleInAppPurchaseGetCoins({
    $core.String? creator,
    $core.String? productId,
    $core.String? purchaseToken,
    $core.String? receiptDataBase64,
    $core.String? signature,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (productId != null) {
      _result.productId = productId;
    }
    if (purchaseToken != null) {
      _result.purchaseToken = purchaseToken;
    }
    if (receiptDataBase64 != null) {
      _result.receiptDataBase64 = receiptDataBase64;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    return _result;
  }
  factory MsgGoogleInAppPurchaseGetCoins.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGoogleInAppPurchaseGetCoins.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoins clone() => MsgGoogleInAppPurchaseGetCoins()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoins copyWith(void Function(MsgGoogleInAppPurchaseGetCoins) updates) => super.copyWith((message) => updates(message as MsgGoogleInAppPurchaseGetCoins)) as MsgGoogleInAppPurchaseGetCoins; // ignore: deprecated_member_use
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get purchaseToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set purchaseToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPurchaseToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurchaseToken() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get receiptDataBase64 => $_getSZ(3);
  @$pb.TagNumber(4)
  set receiptDataBase64($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasReceiptDataBase64() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceiptDataBase64() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get signature => $_getSZ(4);
  @$pb.TagNumber(5)
  set signature($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignature() => clearField(5);
}

class MsgGoogleInAppPurchaseGetCoinsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgGoogleInAppPurchaseGetCoinsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgGoogleInAppPurchaseGetCoinsResponse._() : super();
  factory MsgGoogleInAppPurchaseGetCoinsResponse() => create();
  factory MsgGoogleInAppPurchaseGetCoinsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgGoogleInAppPurchaseGetCoinsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoinsResponse clone() => MsgGoogleInAppPurchaseGetCoinsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgGoogleInAppPurchaseGetCoinsResponse copyWith(void Function(MsgGoogleInAppPurchaseGetCoinsResponse) updates) => super.copyWith((message) => updates(message as MsgGoogleInAppPurchaseGetCoinsResponse)) as MsgGoogleInAppPurchaseGetCoinsResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendItems', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiver')
    ..pc<$8.ItemRef>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: $8.ItemRef.create)
    ..hasRequiredFields = false
  ;

  MsgSendItems._() : super();
  factory MsgSendItems({
    $core.String? creator,
    $core.String? receiver,
    $core.Iterable<$8.ItemRef>? items,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (receiver != null) {
      _result.receiver = receiver;
    }
    if (items != null) {
      _result.items.addAll(items);
    }
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get receiver => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiver($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReceiver() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiver() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$8.ItemRef> get items => $_getList(2);
}

class MsgSendItemsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSendItemsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
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
  MsgSendItemsResponse copyWith(void Function(MsgSendItemsResponse) updates) => super.copyWith((message) => updates(message as MsgSendItemsResponse)) as MsgSendItemsResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgExecuteRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipeId')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputsIndex', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemIds')
    ..pc<$7.PaymentInfo>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentInfos', $pb.PbFieldType.PM, subBuilder: $7.PaymentInfo.create)
    ..hasRequiredFields = false
  ;

  MsgExecuteRecipe._() : super();
  factory MsgExecuteRecipe({
    $core.String? creator,
    $core.String? cookbookId,
    $core.String? recipeId,
    $fixnum.Int64? coinInputsIndex,
    $core.Iterable<$core.String>? itemIds,
    $core.Iterable<$7.PaymentInfo>? paymentInfos,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (recipeId != null) {
      _result.recipeId = recipeId;
    }
    if (coinInputsIndex != null) {
      _result.coinInputsIndex = coinInputsIndex;
    }
    if (itemIds != null) {
      _result.itemIds.addAll(itemIds);
    }
    if (paymentInfos != null) {
      _result.paymentInfos.addAll(paymentInfos);
    }
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecipeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get coinInputsIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set coinInputsIndex($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCoinInputsIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoinInputsIndex() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get itemIds => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$7.PaymentInfo> get paymentInfos => $_getList(5);
}

class MsgExecuteRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgExecuteRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  MsgExecuteRecipeResponse._() : super();
  factory MsgExecuteRecipeResponse({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
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
  MsgExecuteRecipeResponse copyWith(void Function(MsgExecuteRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgExecuteRecipeResponse)) as MsgExecuteRecipeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipeResponse create() => MsgExecuteRecipeResponse._();
  MsgExecuteRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<MsgExecuteRecipeResponse> createRepeated() => $pb.PbList<MsgExecuteRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgExecuteRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgExecuteRecipeResponse>(create);
  static MsgExecuteRecipeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class MsgSetItemString extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSetItemString', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'field')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  MsgSetItemString._() : super();
  factory MsgSetItemString({
    $core.String? creator,
    $core.String? cookbookId,
    $core.String? id,
    $core.String? field_5,
    $core.String? value,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (id != null) {
      _result.id = id;
    }
    if (field_5 != null) {
      _result.field_5 = field_5;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory MsgSetItemString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSetItemString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSetItemString clone() => MsgSetItemString()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookId() => clearField(2);

  @$pb.TagNumber(4)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(4)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get field_5 => $_getSZ(3);
  @$pb.TagNumber(5)
  set field_5($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasField_5() => $_has(3);
  @$pb.TagNumber(5)
  void clearField_5() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(6)
  set value($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(6)
  void clearValue() => clearField(6);
}

class MsgSetItemStringResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgSetItemStringResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgSetItemStringResponse._() : super();
  factory MsgSetItemStringResponse() => create();
  factory MsgSetItemStringResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgSetItemStringResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgSetItemStringResponse clone() => MsgSetItemStringResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgSetItemStringResponse copyWith(void Function(MsgSetItemStringResponse) updates) => super.copyWith((message) => updates(message as MsgSetItemStringResponse)) as MsgSetItemStringResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..pc<$4.CoinInput>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, subBuilder: $4.CoinInput.create)
    ..pc<$4.ItemInput>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, subBuilder: $4.ItemInput.create)
    ..aOM<$4.EntriesList>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entries', subBuilder: $4.EntriesList.create)
    ..pc<$4.WeightedOutputs>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: $4.WeightedOutputs.create)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockInterval')
    ..aOM<$2.Coin>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'costPerBlock', subBuilder: $2.Coin.create)
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo')
    ..hasRequiredFields = false
  ;

  MsgCreateRecipe._() : super();
  factory MsgCreateRecipe({
    $core.String? creator,
    $core.String? cookbookId,
    $core.String? id,
    $core.String? name,
    $core.String? description,
    $core.String? version,
    $core.Iterable<$4.CoinInput>? coinInputs,
    $core.Iterable<$4.ItemInput>? itemInputs,
    $4.EntriesList? entries,
    $core.Iterable<$4.WeightedOutputs>? outputs,
    $fixnum.Int64? blockInterval,
    $2.Coin? costPerBlock,
    $core.bool? enabled,
    $core.String? extraInfo,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (id != null) {
      _result.id = id;
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
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

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
  $core.List<$4.CoinInput> get coinInputs => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$4.ItemInput> get itemInputs => $_getList(7);

  @$pb.TagNumber(9)
  $4.EntriesList get entries => $_getN(8);
  @$pb.TagNumber(9)
  set entries($4.EntriesList v) { setField(9, v); }
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
}

class MsgCreateRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
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
  MsgCreateRecipeResponse copyWith(void Function(MsgCreateRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgCreateRecipeResponse)) as MsgCreateRecipeResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..pc<$4.CoinInput>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, subBuilder: $4.CoinInput.create)
    ..pc<$4.ItemInput>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, subBuilder: $4.ItemInput.create)
    ..aOM<$4.EntriesList>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entries', subBuilder: $4.EntriesList.create)
    ..pc<$4.WeightedOutputs>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: $4.WeightedOutputs.create)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockInterval')
    ..aOM<$2.Coin>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'costPerBlock', subBuilder: $2.Coin.create)
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extraInfo')
    ..hasRequiredFields = false
  ;

  MsgUpdateRecipe._() : super();
  factory MsgUpdateRecipe({
    $core.String? creator,
    $core.String? cookbookId,
    $core.String? id,
    $core.String? name,
    $core.String? description,
    $core.String? version,
    $core.Iterable<$4.CoinInput>? coinInputs,
    $core.Iterable<$4.ItemInput>? itemInputs,
    $4.EntriesList? entries,
    $core.Iterable<$4.WeightedOutputs>? outputs,
    $fixnum.Int64? blockInterval,
    $2.Coin? costPerBlock,
    $core.bool? enabled,
    $core.String? extraInfo,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (id != null) {
      _result.id = id;
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
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

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
  $core.List<$4.CoinInput> get coinInputs => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$4.ItemInput> get itemInputs => $_getList(7);

  @$pb.TagNumber(9)
  $4.EntriesList get entries => $_getN(8);
  @$pb.TagNumber(9)
  set entries($4.EntriesList v) { setField(9, v); }
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
}

class MsgUpdateRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
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
  MsgUpdateRecipeResponse copyWith(void Function(MsgUpdateRecipeResponse) updates) => super.copyWith((message) => updates(message as MsgUpdateRecipeResponse)) as MsgUpdateRecipeResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'developer')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'supportEmail')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false
  ;

  MsgCreateCookbook._() : super();
  factory MsgCreateCookbook({
    $core.String? creator,
    $core.String? id,
    $core.String? name,
    $core.String? description,
    $core.String? developer,
    $core.String? version,
    $core.String? supportEmail,
    $core.bool? enabled,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (description != null) {
      _result.description = description;
    }
    if (developer != null) {
      _result.developer = developer;
    }
    if (version != null) {
      _result.version = version;
    }
    if (supportEmail != null) {
      _result.supportEmail = supportEmail;
    }
    if (enabled != null) {
      _result.enabled = enabled;
    }
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

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
  $core.String get developer => $_getSZ(4);
  @$pb.TagNumber(5)
  set developer($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeveloper() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeveloper() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get version => $_getSZ(5);
  @$pb.TagNumber(6)
  set version($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get supportEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set supportEmail($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSupportEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearSupportEmail() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get enabled => $_getBF(7);
  @$pb.TagNumber(8)
  set enabled($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasEnabled() => $_has(7);
  @$pb.TagNumber(8)
  void clearEnabled() => clearField(8);
}

class MsgCreateCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgCreateCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
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
  MsgCreateCookbookResponse copyWith(void Function(MsgCreateCookbookResponse) updates) => super.copyWith((message) => updates(message as MsgCreateCookbookResponse)) as MsgCreateCookbookResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'developer')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'supportEmail')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false
  ;

  MsgUpdateCookbook._() : super();
  factory MsgUpdateCookbook({
    $core.String? creator,
    $core.String? id,
    $core.String? name,
    $core.String? description,
    $core.String? developer,
    $core.String? version,
    $core.String? supportEmail,
    $core.bool? enabled,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (description != null) {
      _result.description = description;
    }
    if (developer != null) {
      _result.developer = developer;
    }
    if (version != null) {
      _result.version = version;
    }
    if (supportEmail != null) {
      _result.supportEmail = supportEmail;
    }
    if (enabled != null) {
      _result.enabled = enabled;
    }
    return _result;
  }
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
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

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
  $core.String get developer => $_getSZ(4);
  @$pb.TagNumber(5)
  set developer($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeveloper() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeveloper() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get version => $_getSZ(5);
  @$pb.TagNumber(6)
  set version($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get supportEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set supportEmail($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSupportEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearSupportEmail() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get enabled => $_getBF(7);
  @$pb.TagNumber(8)
  set enabled($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasEnabled() => $_has(7);
  @$pb.TagNumber(8)
  void clearEnabled() => clearField(8);
}

class MsgUpdateCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgUpdateCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
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
  MsgUpdateCookbookResponse copyWith(void Function(MsgUpdateCookbookResponse) updates) => super.copyWith((message) => updates(message as MsgUpdateCookbookResponse)) as MsgUpdateCookbookResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbookResponse create() => MsgUpdateCookbookResponse._();
  MsgUpdateCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<MsgUpdateCookbookResponse> createRepeated() => $pb.PbList<MsgUpdateCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgUpdateCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgUpdateCookbookResponse>(create);
  static MsgUpdateCookbookResponse? _defaultInstance;
}

class MsgRegisterKYCAddress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgRegisterKYCAddress', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountAddr')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'level', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'provider')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'providerId')
    ..hasRequiredFields = false
  ;

  MsgRegisterKYCAddress._() : super();
  factory MsgRegisterKYCAddress({
    $core.String? accountAddr,
    $core.String? username,
    $fixnum.Int64? level,
    $core.String? provider,
    $core.String? providerId,
  }) {
    final _result = create();
    if (accountAddr != null) {
      _result.accountAddr = accountAddr;
    }
    if (username != null) {
      _result.username = username;
    }
    if (level != null) {
      _result.level = level;
    }
    if (provider != null) {
      _result.provider = provider;
    }
    if (providerId != null) {
      _result.providerId = providerId;
    }
    return _result;
  }
  factory MsgRegisterKYCAddress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgRegisterKYCAddress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgRegisterKYCAddress clone() => MsgRegisterKYCAddress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgRegisterKYCAddress copyWith(void Function(MsgRegisterKYCAddress) updates) => super.copyWith((message) => updates(message as MsgRegisterKYCAddress)) as MsgRegisterKYCAddress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgRegisterKYCAddress create() => MsgRegisterKYCAddress._();
  MsgRegisterKYCAddress createEmptyInstance() => create();
  static $pb.PbList<MsgRegisterKYCAddress> createRepeated() => $pb.PbList<MsgRegisterKYCAddress>();
  @$core.pragma('dart2js:noInline')
  static MsgRegisterKYCAddress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgRegisterKYCAddress>(create);
  static MsgRegisterKYCAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountAddr => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountAddr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountAddr() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get level => $_getI64(2);
  @$pb.TagNumber(3)
  set level($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLevel() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get provider => $_getSZ(3);
  @$pb.TagNumber(4)
  set provider($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProvider() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvider() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get providerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set providerId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProviderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProviderId() => clearField(5);
}

class MsgRegisterKYCAddressResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgRegisterKYCAddressResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgRegisterKYCAddressResponse._() : super();
  factory MsgRegisterKYCAddressResponse() => create();
  factory MsgRegisterKYCAddressResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgRegisterKYCAddressResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgRegisterKYCAddressResponse clone() => MsgRegisterKYCAddressResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgRegisterKYCAddressResponse copyWith(void Function(MsgRegisterKYCAddressResponse) updates) => super.copyWith((message) => updates(message as MsgRegisterKYCAddressResponse)) as MsgRegisterKYCAddressResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgRegisterKYCAddressResponse create() => MsgRegisterKYCAddressResponse._();
  MsgRegisterKYCAddressResponse createEmptyInstance() => create();
  static $pb.PbList<MsgRegisterKYCAddressResponse> createRepeated() => $pb.PbList<MsgRegisterKYCAddressResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgRegisterKYCAddressResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgRegisterKYCAddressResponse>(create);
  static MsgRegisterKYCAddressResponse? _defaultInstance;
}

class MsgRemoveKYCAddress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgRemoveKYCAddress', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountAddr')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'level', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'provider')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'providerId')
    ..hasRequiredFields = false
  ;

  MsgRemoveKYCAddress._() : super();
  factory MsgRemoveKYCAddress({
    $core.String? accountAddr,
    $core.String? username,
    $fixnum.Int64? level,
    $core.String? provider,
    $core.String? providerId,
  }) {
    final _result = create();
    if (accountAddr != null) {
      _result.accountAddr = accountAddr;
    }
    if (username != null) {
      _result.username = username;
    }
    if (level != null) {
      _result.level = level;
    }
    if (provider != null) {
      _result.provider = provider;
    }
    if (providerId != null) {
      _result.providerId = providerId;
    }
    return _result;
  }
  factory MsgRemoveKYCAddress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgRemoveKYCAddress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgRemoveKYCAddress clone() => MsgRemoveKYCAddress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgRemoveKYCAddress copyWith(void Function(MsgRemoveKYCAddress) updates) => super.copyWith((message) => updates(message as MsgRemoveKYCAddress)) as MsgRemoveKYCAddress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgRemoveKYCAddress create() => MsgRemoveKYCAddress._();
  MsgRemoveKYCAddress createEmptyInstance() => create();
  static $pb.PbList<MsgRemoveKYCAddress> createRepeated() => $pb.PbList<MsgRemoveKYCAddress>();
  @$core.pragma('dart2js:noInline')
  static MsgRemoveKYCAddress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgRemoveKYCAddress>(create);
  static MsgRemoveKYCAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountAddr => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountAddr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountAddr() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get level => $_getI64(2);
  @$pb.TagNumber(3)
  set level($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLevel() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get provider => $_getSZ(3);
  @$pb.TagNumber(4)
  set provider($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProvider() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvider() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get providerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set providerId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProviderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProviderId() => clearField(5);
}

class MsgRemoveKYCAddressResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgRemoveKYCAddressResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MsgRemoveKYCAddressResponse._() : super();
  factory MsgRemoveKYCAddressResponse() => create();
  factory MsgRemoveKYCAddressResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgRemoveKYCAddressResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgRemoveKYCAddressResponse clone() => MsgRemoveKYCAddressResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgRemoveKYCAddressResponse copyWith(void Function(MsgRemoveKYCAddressResponse) updates) => super.copyWith((message) => updates(message as MsgRemoveKYCAddressResponse)) as MsgRemoveKYCAddressResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgRemoveKYCAddressResponse create() => MsgRemoveKYCAddressResponse._();
  MsgRemoveKYCAddressResponse createEmptyInstance() => create();
  static $pb.PbList<MsgRemoveKYCAddressResponse> createRepeated() => $pb.PbList<MsgRemoveKYCAddressResponse>();
  @$core.pragma('dart2js:noInline')
  static MsgRemoveKYCAddressResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgRemoveKYCAddressResponse>(create);
  static MsgRemoveKYCAddressResponse? _defaultInstance;
}

