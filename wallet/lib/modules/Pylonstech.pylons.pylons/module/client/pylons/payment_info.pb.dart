///
//  Generated code. Do not modify.
//  source: pylons/pylons/payment_info.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PaymentInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PaymentInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'processorName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payerAddr')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productId')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature')
    ..hasRequiredFields = false
  ;

  PaymentInfo._() : super();
  factory PaymentInfo({
    $core.String? purchaseId,
    $core.String? processorName,
    $core.String? payerAddr,
    $core.String? amount,
    $core.String? productId,
    $core.String? signature,
  }) {
    final _result = create();
    if (purchaseId != null) {
      _result.purchaseId = purchaseId;
    }
    if (processorName != null) {
      _result.processorName = processorName;
    }
    if (payerAddr != null) {
      _result.payerAddr = payerAddr;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (productId != null) {
      _result.productId = productId;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    return _result;
  }
  factory PaymentInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaymentInfo clone() => PaymentInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaymentInfo copyWith(void Function(PaymentInfo) updates) => super.copyWith((message) => updates(message as PaymentInfo)) as PaymentInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PaymentInfo create() => PaymentInfo._();
  PaymentInfo createEmptyInstance() => create();
  static $pb.PbList<PaymentInfo> createRepeated() => $pb.PbList<PaymentInfo>();
  @$core.pragma('dart2js:noInline')
  static PaymentInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentInfo>(create);
  static PaymentInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPurchaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get processorName => $_getSZ(1);
  @$pb.TagNumber(2)
  set processorName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProcessorName() => $_has(1);
  @$pb.TagNumber(2)
  void clearProcessorName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get payerAddr => $_getSZ(2);
  @$pb.TagNumber(3)
  set payerAddr($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPayerAddr() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayerAddr() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get amount => $_getSZ(3);
  @$pb.TagNumber(4)
  set amount($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get productId => $_getSZ(4);
  @$pb.TagNumber(5)
  set productId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProductId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProductId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get signature => $_getSZ(5);
  @$pb.TagNumber(6)
  set signature($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSignature() => $_has(5);
  @$pb.TagNumber(6)
  void clearSignature() => clearField(6);
}
