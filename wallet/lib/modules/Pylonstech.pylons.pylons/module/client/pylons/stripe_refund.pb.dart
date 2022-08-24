///
//  Generated code. Do not modify.
//  source: pylons/pylons/stripe_refund.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'payment_info.pb.dart' as $7;

class StripeRefund extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StripeRefund', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$7.PaymentInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payment', subBuilder: $7.PaymentInfo.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settled')
    ..hasRequiredFields = false
  ;

  StripeRefund._() : super();
  factory StripeRefund({
    $7.PaymentInfo? payment,
    $core.bool? settled,
  }) {
    final _result = create();
    if (payment != null) {
      _result.payment = payment;
    }
    if (settled != null) {
      _result.settled = settled;
    }
    return _result;
  }
  factory StripeRefund.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StripeRefund.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StripeRefund clone() => StripeRefund()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StripeRefund copyWith(void Function(StripeRefund) updates) => super.copyWith((message) => updates(message as StripeRefund)) as StripeRefund; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StripeRefund create() => StripeRefund._();
  StripeRefund createEmptyInstance() => create();
  static $pb.PbList<StripeRefund> createRepeated() => $pb.PbList<StripeRefund>();
  @$core.pragma('dart2js:noInline')
  static StripeRefund getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StripeRefund>(create);
  static StripeRefund? _defaultInstance;

  @$pb.TagNumber(1)
  $7.PaymentInfo get payment => $_getN(0);
  @$pb.TagNumber(1)
  set payment($7.PaymentInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayment() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayment() => clearField(1);
  @$pb.TagNumber(1)
  $7.PaymentInfo ensurePayment() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get settled => $_getBF(1);
  @$pb.TagNumber(2)
  set settled($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSettled() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettled() => clearField(2);
}
