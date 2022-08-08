///
//  Generated code. Do not modify.
//  source: pylons/pylons/params.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../cosmos/base/v1beta1/coin.pb.dart' as $2;

class GoogleInAppPurchasePackage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GoogleInAppPurchasePackage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'packageName')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'productId')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount')
    ..hasRequiredFields = false;

  GoogleInAppPurchasePackage._() : super();
  factory GoogleInAppPurchasePackage({
    $core.String? packageName,
    $core.String? productId,
    $core.String? amount,
  }) {
    final _result = create();
    if (packageName != null) {
      _result.packageName = packageName;
    }
    if (productId != null) {
      _result.productId = productId;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory GoogleInAppPurchasePackage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GoogleInAppPurchasePackage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GoogleInAppPurchasePackage clone() =>
      GoogleInAppPurchasePackage()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GoogleInAppPurchasePackage copyWith(
          void Function(GoogleInAppPurchasePackage) updates) =>
      super.copyWith(
              (message) => updates(message as GoogleInAppPurchasePackage))
          as GoogleInAppPurchasePackage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GoogleInAppPurchasePackage create() => GoogleInAppPurchasePackage._();
  GoogleInAppPurchasePackage createEmptyInstance() => create();
  static $pb.PbList<GoogleInAppPurchasePackage> createRepeated() =>
      $pb.PbList<GoogleInAppPurchasePackage>();
  @$core.pragma('dart2js:noInline')
  static GoogleInAppPurchasePackage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoogleInAppPurchasePackage>(create);
  static GoogleInAppPurchasePackage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packageName => $_getSZ(0);
  @$pb.TagNumber(1)
  set packageName($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPackageName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackageName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get amount => $_getSZ(2);
  @$pb.TagNumber(3)
  set amount($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
}

class CoinIssuer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CoinIssuer',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'coinDenom')
    ..pc<GoogleInAppPurchasePackage>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'packages',
        $pb.PbFieldType.PM,
        subBuilder: GoogleInAppPurchasePackage.create)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'googleInAppPurchasePubKey')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'entityName')
    ..hasRequiredFields = false;

  CoinIssuer._() : super();
  factory CoinIssuer({
    $core.String? coinDenom,
    $core.Iterable<GoogleInAppPurchasePackage>? packages,
    $core.String? googleInAppPurchasePubKey,
    $core.String? entityName,
  }) {
    final _result = create();
    if (coinDenom != null) {
      _result.coinDenom = coinDenom;
    }
    if (packages != null) {
      _result.packages.addAll(packages);
    }
    if (googleInAppPurchasePubKey != null) {
      _result.googleInAppPurchasePubKey = googleInAppPurchasePubKey;
    }
    if (entityName != null) {
      _result.entityName = entityName;
    }
    return _result;
  }
  factory CoinIssuer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CoinIssuer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CoinIssuer clone() => CoinIssuer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CoinIssuer copyWith(void Function(CoinIssuer) updates) =>
      super.copyWith((message) => updates(message as CoinIssuer))
          as CoinIssuer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CoinIssuer create() => CoinIssuer._();
  CoinIssuer createEmptyInstance() => create();
  static $pb.PbList<CoinIssuer> createRepeated() => $pb.PbList<CoinIssuer>();
  @$core.pragma('dart2js:noInline')
  static CoinIssuer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CoinIssuer>(create);
  static CoinIssuer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get coinDenom => $_getSZ(0);
  @$pb.TagNumber(1)
  set coinDenom($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCoinDenom() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoinDenom() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<GoogleInAppPurchasePackage> get packages => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get googleInAppPurchasePubKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set googleInAppPurchasePubKey($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasGoogleInAppPurchasePubKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearGoogleInAppPurchasePubKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get entityName => $_getSZ(3);
  @$pb.TagNumber(4)
  set entityName($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasEntityName() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntityName() => clearField(4);
}

class PaymentProcessor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PaymentProcessor',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'coinDenom')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pubKey')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'processorPercentage')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'validatorsPercentage')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..hasRequiredFields = false;

  PaymentProcessor._() : super();
  factory PaymentProcessor({
    $core.String? coinDenom,
    $core.String? pubKey,
    $core.String? processorPercentage,
    $core.String? validatorsPercentage,
    $core.String? name,
  }) {
    final _result = create();
    if (coinDenom != null) {
      _result.coinDenom = coinDenom;
    }
    if (pubKey != null) {
      _result.pubKey = pubKey;
    }
    if (processorPercentage != null) {
      _result.processorPercentage = processorPercentage;
    }
    if (validatorsPercentage != null) {
      _result.validatorsPercentage = validatorsPercentage;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory PaymentProcessor.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PaymentProcessor.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PaymentProcessor clone() => PaymentProcessor()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PaymentProcessor copyWith(void Function(PaymentProcessor) updates) =>
      super.copyWith((message) => updates(message as PaymentProcessor))
          as PaymentProcessor; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PaymentProcessor create() => PaymentProcessor._();
  PaymentProcessor createEmptyInstance() => create();
  static $pb.PbList<PaymentProcessor> createRepeated() =>
      $pb.PbList<PaymentProcessor>();
  @$core.pragma('dart2js:noInline')
  static PaymentProcessor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaymentProcessor>(create);
  static PaymentProcessor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get coinDenom => $_getSZ(0);
  @$pb.TagNumber(1)
  set coinDenom($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCoinDenom() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoinDenom() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pubKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set pubKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPubKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPubKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get processorPercentage => $_getSZ(2);
  @$pb.TagNumber(3)
  set processorPercentage($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProcessorPercentage() => $_has(2);
  @$pb.TagNumber(3)
  void clearProcessorPercentage() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get validatorsPercentage => $_getSZ(3);
  @$pb.TagNumber(4)
  set validatorsPercentage($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasValidatorsPercentage() => $_has(3);
  @$pb.TagNumber(4)
  void clearValidatorsPercentage() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => clearField(5);
}

class Params extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Params',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..pc<CoinIssuer>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'coinIssuers',
        $pb.PbFieldType.PM,
        subBuilder: CoinIssuer.create)
    ..pc<PaymentProcessor>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentProcessors',
        $pb.PbFieldType.PM,
        subBuilder: PaymentProcessor.create)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'recipeFeePercentage')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'itemTransferFeePercentage')
    ..aOM<$2.Coin>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'updateItemStringFee',
        subBuilder: $2.Coin.create)
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'minTransferFee')
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'maxTransferFee')
    ..aOM<$2.Coin>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'updateUsernameFee',
        subBuilder: $2.Coin.create)
    ..aOS(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'distrEpochIdentifier')
    ..a<$fixnum.Int64>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'engineVersion',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'maxTxsInBlock',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  Params._() : super();
  factory Params({
    $core.Iterable<CoinIssuer>? coinIssuers,
    $core.Iterable<PaymentProcessor>? paymentProcessors,
    $core.String? recipeFeePercentage,
    $core.String? itemTransferFeePercentage,
    $2.Coin? updateItemStringFee,
    $core.String? minTransferFee,
    $core.String? maxTransferFee,
    $2.Coin? updateUsernameFee,
    $core.String? distrEpochIdentifier,
    $fixnum.Int64? engineVersion,
    $fixnum.Int64? maxTxsInBlock,
  }) {
    final _result = create();
    if (coinIssuers != null) {
      _result.coinIssuers.addAll(coinIssuers);
    }
    if (paymentProcessors != null) {
      _result.paymentProcessors.addAll(paymentProcessors);
    }
    if (recipeFeePercentage != null) {
      _result.recipeFeePercentage = recipeFeePercentage;
    }
    if (itemTransferFeePercentage != null) {
      _result.itemTransferFeePercentage = itemTransferFeePercentage;
    }
    if (updateItemStringFee != null) {
      _result.updateItemStringFee = updateItemStringFee;
    }
    if (minTransferFee != null) {
      _result.minTransferFee = minTransferFee;
    }
    if (maxTransferFee != null) {
      _result.maxTransferFee = maxTransferFee;
    }
    if (updateUsernameFee != null) {
      _result.updateUsernameFee = updateUsernameFee;
    }
    if (distrEpochIdentifier != null) {
      _result.distrEpochIdentifier = distrEpochIdentifier;
    }
    if (engineVersion != null) {
      _result.engineVersion = engineVersion;
    }
    if (maxTxsInBlock != null) {
      _result.maxTxsInBlock = maxTxsInBlock;
    }
    return _result;
  }
  factory Params.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Params.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Params clone() => Params()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Params copyWith(void Function(Params) updates) =>
      super.copyWith((message) => updates(message as Params))
          as Params; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Params create() => Params._();
  Params createEmptyInstance() => create();
  static $pb.PbList<Params> createRepeated() => $pb.PbList<Params>();
  @$core.pragma('dart2js:noInline')
  static Params getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Params>(create);
  static Params? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CoinIssuer> get coinIssuers => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<PaymentProcessor> get paymentProcessors => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get recipeFeePercentage => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeFeePercentage($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRecipeFeePercentage() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeFeePercentage() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get itemTransferFeePercentage => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemTransferFeePercentage($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasItemTransferFeePercentage() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemTransferFeePercentage() => clearField(4);

  @$pb.TagNumber(5)
  $2.Coin get updateItemStringFee => $_getN(4);
  @$pb.TagNumber(5)
  set updateItemStringFee($2.Coin v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasUpdateItemStringFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdateItemStringFee() => clearField(5);
  @$pb.TagNumber(5)
  $2.Coin ensureUpdateItemStringFee() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get minTransferFee => $_getSZ(5);
  @$pb.TagNumber(6)
  set minTransferFee($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasMinTransferFee() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinTransferFee() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get maxTransferFee => $_getSZ(6);
  @$pb.TagNumber(7)
  set maxTransferFee($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasMaxTransferFee() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxTransferFee() => clearField(7);

  @$pb.TagNumber(8)
  $2.Coin get updateUsernameFee => $_getN(7);
  @$pb.TagNumber(8)
  set updateUsernameFee($2.Coin v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasUpdateUsernameFee() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdateUsernameFee() => clearField(8);
  @$pb.TagNumber(8)
  $2.Coin ensureUpdateUsernameFee() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get distrEpochIdentifier => $_getSZ(8);
  @$pb.TagNumber(9)
  set distrEpochIdentifier($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasDistrEpochIdentifier() => $_has(8);
  @$pb.TagNumber(9)
  void clearDistrEpochIdentifier() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get engineVersion => $_getI64(9);
  @$pb.TagNumber(10)
  set engineVersion($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasEngineVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearEngineVersion() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get maxTxsInBlock => $_getI64(10);
  @$pb.TagNumber(11)
  set maxTxsInBlock($fixnum.Int64 v) {
    $_setInt64(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasMaxTxsInBlock() => $_has(10);
  @$pb.TagNumber(11)
  void clearMaxTxsInBlock() => clearField(11);
}
