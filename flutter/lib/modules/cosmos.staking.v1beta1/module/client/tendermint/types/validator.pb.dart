///
//  Generated code. Do not modify.
//  source: tendermint/types/validator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../crypto/keys.pb.dart' as $3;

class ValidatorSet extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ValidatorSet', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tendermint.types'), createEmptyInstance: create)
    ..pc<Validator>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'validators', $pb.PbFieldType.PM, subBuilder: Validator.create)
    ..aOM<Validator>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposer', subBuilder: Validator.create)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalVotingPower')
    ..hasRequiredFields = false
  ;

  ValidatorSet._() : super();
  factory ValidatorSet({
    $core.Iterable<Validator>? validators,
    Validator? proposer,
    $fixnum.Int64? totalVotingPower,
  }) {
    final _result = create();
    if (validators != null) {
      _result.validators.addAll(validators);
    }
    if (proposer != null) {
      _result.proposer = proposer;
    }
    if (totalVotingPower != null) {
      _result.totalVotingPower = totalVotingPower;
    }
    return _result;
  }
  factory ValidatorSet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidatorSet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidatorSet clone() => ValidatorSet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidatorSet copyWith(void Function(ValidatorSet) updates) => super.copyWith((message) => updates(message as ValidatorSet)) as ValidatorSet; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ValidatorSet create() => ValidatorSet._();
  ValidatorSet createEmptyInstance() => create();
  static $pb.PbList<ValidatorSet> createRepeated() => $pb.PbList<ValidatorSet>();
  @$core.pragma('dart2js:noInline')
  static ValidatorSet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidatorSet>(create);
  static ValidatorSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Validator> get validators => $_getList(0);

  @$pb.TagNumber(2)
  Validator get proposer => $_getN(1);
  @$pb.TagNumber(2)
  set proposer(Validator v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasProposer() => $_has(1);
  @$pb.TagNumber(2)
  void clearProposer() => clearField(2);
  @$pb.TagNumber(2)
  Validator ensureProposer() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalVotingPower => $_getI64(2);
  @$pb.TagNumber(3)
  set totalVotingPower($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalVotingPower() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalVotingPower() => clearField(3);
}

class Validator extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Validator', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tendermint.types'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address', $pb.PbFieldType.OY)
    ..aOM<$3.PublicKey>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubKey', subBuilder: $3.PublicKey.create)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'votingPower')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposerPriority')
    ..hasRequiredFields = false
  ;

  Validator._() : super();
  factory Validator({
    $core.List<$core.int>? address,
    $3.PublicKey? pubKey,
    $fixnum.Int64? votingPower,
    $fixnum.Int64? proposerPriority,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (pubKey != null) {
      _result.pubKey = pubKey;
    }
    if (votingPower != null) {
      _result.votingPower = votingPower;
    }
    if (proposerPriority != null) {
      _result.proposerPriority = proposerPriority;
    }
    return _result;
  }
  factory Validator.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Validator.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Validator clone() => Validator()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Validator copyWith(void Function(Validator) updates) => super.copyWith((message) => updates(message as Validator)) as Validator; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Validator create() => Validator._();
  Validator createEmptyInstance() => create();
  static $pb.PbList<Validator> createRepeated() => $pb.PbList<Validator>();
  @$core.pragma('dart2js:noInline')
  static Validator getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Validator>(create);
  static Validator? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get address => $_getN(0);
  @$pb.TagNumber(1)
  set address($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $3.PublicKey get pubKey => $_getN(1);
  @$pb.TagNumber(2)
  set pubKey($3.PublicKey v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPubKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPubKey() => clearField(2);
  @$pb.TagNumber(2)
  $3.PublicKey ensurePubKey() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get votingPower => $_getI64(2);
  @$pb.TagNumber(3)
  set votingPower($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVotingPower() => $_has(2);
  @$pb.TagNumber(3)
  void clearVotingPower() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get proposerPriority => $_getI64(3);
  @$pb.TagNumber(4)
  set proposerPriority($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProposerPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearProposerPriority() => clearField(4);
}

class SimpleValidator extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SimpleValidator', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tendermint.types'), createEmptyInstance: create)
    ..aOM<$3.PublicKey>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubKey', subBuilder: $3.PublicKey.create)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'votingPower')
    ..hasRequiredFields = false
  ;

  SimpleValidator._() : super();
  factory SimpleValidator({
    $3.PublicKey? pubKey,
    $fixnum.Int64? votingPower,
  }) {
    final _result = create();
    if (pubKey != null) {
      _result.pubKey = pubKey;
    }
    if (votingPower != null) {
      _result.votingPower = votingPower;
    }
    return _result;
  }
  factory SimpleValidator.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SimpleValidator.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SimpleValidator clone() => SimpleValidator()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SimpleValidator copyWith(void Function(SimpleValidator) updates) => super.copyWith((message) => updates(message as SimpleValidator)) as SimpleValidator; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SimpleValidator create() => SimpleValidator._();
  SimpleValidator createEmptyInstance() => create();
  static $pb.PbList<SimpleValidator> createRepeated() => $pb.PbList<SimpleValidator>();
  @$core.pragma('dart2js:noInline')
  static SimpleValidator getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SimpleValidator>(create);
  static SimpleValidator? _defaultInstance;

  @$pb.TagNumber(1)
  $3.PublicKey get pubKey => $_getN(0);
  @$pb.TagNumber(1)
  set pubKey($3.PublicKey v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubKey() => clearField(1);
  @$pb.TagNumber(1)
  $3.PublicKey ensurePubKey() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get votingPower => $_getI64(1);
  @$pb.TagNumber(2)
  set votingPower($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVotingPower() => $_has(1);
  @$pb.TagNumber(2)
  void clearVotingPower() => clearField(2);
}

