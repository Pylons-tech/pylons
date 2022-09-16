///
//  Generated code. Do not modify.
//  source: pylons/pylons/google_iap_order.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class GoogleInAppPurchaseOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GoogleInAppPurchaseOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiptDataBase64')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature')
    ..hasRequiredFields = false
  ;

  GoogleInAppPurchaseOrder._() : super();
  factory GoogleInAppPurchaseOrder({
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
  factory GoogleInAppPurchaseOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GoogleInAppPurchaseOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GoogleInAppPurchaseOrder clone() => GoogleInAppPurchaseOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GoogleInAppPurchaseOrder copyWith(void Function(GoogleInAppPurchaseOrder) updates) => super.copyWith((message) => updates(message as GoogleInAppPurchaseOrder)) as GoogleInAppPurchaseOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GoogleInAppPurchaseOrder create() => GoogleInAppPurchaseOrder._();
  GoogleInAppPurchaseOrder createEmptyInstance() => create();
  static $pb.PbList<GoogleInAppPurchaseOrder> createRepeated() => $pb.PbList<GoogleInAppPurchaseOrder>();
  @$core.pragma('dart2js:noInline')
  static GoogleInAppPurchaseOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GoogleInAppPurchaseOrder>(create);
  static GoogleInAppPurchaseOrder? _defaultInstance;

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

