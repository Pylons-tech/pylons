///
//  Generated code. Do not modify.
//  source: pylons/pylons/apple_in_app_purchase_order.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AppleInAppPurchaseOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'AppleInAppPurchaseOrder',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'pylons.pylons'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'quantity')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'productId')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'purchaseId')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'purchaseDate')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'creator')
    ..hasRequiredFields = false;

  AppleInAppPurchaseOrder._() : super();
  factory AppleInAppPurchaseOrder({
    $core.String? quantity,
    $core.String? productId,
    $core.String? purchaseId,
    $core.String? purchaseDate,
    $core.String? creator,
  }) {
    final _result = create();
    if (quantity != null) {
      _result.quantity = quantity;
    }
    if (productId != null) {
      _result.productId = productId;
    }
    if (purchaseId != null) {
      _result.purchaseId = purchaseId;
    }
    if (purchaseDate != null) {
      _result.purchaseDate = purchaseDate;
    }
    if (creator != null) {
      _result.creator = creator;
    }
    return _result;
  }
  factory AppleInAppPurchaseOrder.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AppleInAppPurchaseOrder.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AppleInAppPurchaseOrder clone() =>
      AppleInAppPurchaseOrder()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AppleInAppPurchaseOrder copyWith(
          void Function(AppleInAppPurchaseOrder) updates) =>
      super.copyWith((message) => updates(message as AppleInAppPurchaseOrder))
          as AppleInAppPurchaseOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AppleInAppPurchaseOrder create() => AppleInAppPurchaseOrder._();
  AppleInAppPurchaseOrder createEmptyInstance() => create();
  static $pb.PbList<AppleInAppPurchaseOrder> createRepeated() =>
      $pb.PbList<AppleInAppPurchaseOrder>();
  @$core.pragma('dart2js:noInline')
  static AppleInAppPurchaseOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppleInAppPurchaseOrder>(create);
  static AppleInAppPurchaseOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get quantity => $_getSZ(0);
  @$pb.TagNumber(1)
  set quantity($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasQuantity() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuantity() => clearField(1);

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
  $core.String get purchaseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set purchaseId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPurchaseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurchaseId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get purchaseDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set purchaseDate($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPurchaseDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearPurchaseDate() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get creator => $_getSZ(4);
  @$pb.TagNumber(5)
  set creator($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCreator() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreator() => clearField(5);
}
