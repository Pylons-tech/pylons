///
//  Generated code. Do not modify.
//  source: pylons/event.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'cookbook.pb.dart' as $5;
import 'recipe.pb.dart' as $4;
import '../cosmos/base/v1beta1/coin.pb.dart' as $2;
import 'item.pb.dart' as $3;
import 'trade.pb.dart' as $6;

class EventCreateAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCreateAccount', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false
  ;

  EventCreateAccount._() : super();
  factory EventCreateAccount({
    $core.String? address,
    $core.String? username,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (username != null) {
      _result.username = username;
    }
    return _result;
  }
  factory EventCreateAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCreateAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCreateAccount clone() => EventCreateAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCreateAccount copyWith(void Function(EventCreateAccount) updates) => super.copyWith((message) => updates(message as EventCreateAccount)) as EventCreateAccount; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCreateAccount create() => EventCreateAccount._();
  EventCreateAccount createEmptyInstance() => create();
  static $pb.PbList<EventCreateAccount> createRepeated() => $pb.PbList<EventCreateAccount>();
  @$core.pragma('dart2js:noInline')
  static EventCreateAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCreateAccount>(create);
  static EventCreateAccount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);
}

class EventUpdateAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventUpdateAccount', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false
  ;

  EventUpdateAccount._() : super();
  factory EventUpdateAccount({
    $core.String? address,
    $core.String? username,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (username != null) {
      _result.username = username;
    }
    return _result;
  }
  factory EventUpdateAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventUpdateAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventUpdateAccount clone() => EventUpdateAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventUpdateAccount copyWith(void Function(EventUpdateAccount) updates) => super.copyWith((message) => updates(message as EventUpdateAccount)) as EventUpdateAccount; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventUpdateAccount create() => EventUpdateAccount._();
  EventUpdateAccount createEmptyInstance() => create();
  static $pb.PbList<EventUpdateAccount> createRepeated() => $pb.PbList<EventUpdateAccount>();
  @$core.pragma('dart2js:noInline')
  static EventUpdateAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventUpdateAccount>(create);
  static EventUpdateAccount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);
}

class EventCreateCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCreateCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false
  ;

  EventCreateCookbook._() : super();
  factory EventCreateCookbook({
    $core.String? creator,
    $core.String? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventCreateCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCreateCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCreateCookbook clone() => EventCreateCookbook()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCreateCookbook copyWith(void Function(EventCreateCookbook) updates) => super.copyWith((message) => updates(message as EventCreateCookbook)) as EventCreateCookbook; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCreateCookbook create() => EventCreateCookbook._();
  EventCreateCookbook createEmptyInstance() => create();
  static $pb.PbList<EventCreateCookbook> createRepeated() => $pb.PbList<EventCreateCookbook>();
  @$core.pragma('dart2js:noInline')
  static EventCreateCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCreateCookbook>(create);
  static EventCreateCookbook? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class EventUpdateCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventUpdateCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$5.Cookbook>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'originalCookbook', protoName: 'originalCookbook', subBuilder: $5.Cookbook.create)
    ..hasRequiredFields = false
  ;

  EventUpdateCookbook._() : super();
  factory EventUpdateCookbook({
    $5.Cookbook? originalCookbook,
  }) {
    final _result = create();
    if (originalCookbook != null) {
      _result.originalCookbook = originalCookbook;
    }
    return _result;
  }
  factory EventUpdateCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventUpdateCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventUpdateCookbook clone() => EventUpdateCookbook()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventUpdateCookbook copyWith(void Function(EventUpdateCookbook) updates) => super.copyWith((message) => updates(message as EventUpdateCookbook)) as EventUpdateCookbook; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventUpdateCookbook create() => EventUpdateCookbook._();
  EventUpdateCookbook createEmptyInstance() => create();
  static $pb.PbList<EventUpdateCookbook> createRepeated() => $pb.PbList<EventUpdateCookbook>();
  @$core.pragma('dart2js:noInline')
  static EventUpdateCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventUpdateCookbook>(create);
  static EventUpdateCookbook? _defaultInstance;

  @$pb.TagNumber(1)
  $5.Cookbook get originalCookbook => $_getN(0);
  @$pb.TagNumber(1)
  set originalCookbook($5.Cookbook v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOriginalCookbook() => $_has(0);
  @$pb.TagNumber(1)
  void clearOriginalCookbook() => clearField(1);
  @$pb.TagNumber(1)
  $5.Cookbook ensureOriginalCookbook() => $_ensure(0);
}

class EventTransferCookbook extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventTransferCookbook', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiver')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false
  ;

  EventTransferCookbook._() : super();
  factory EventTransferCookbook({
    $core.String? sender,
    $core.String? receiver,
    $core.String? iD,
  }) {
    final _result = create();
    if (sender != null) {
      _result.sender = sender;
    }
    if (receiver != null) {
      _result.receiver = receiver;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventTransferCookbook.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventTransferCookbook.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventTransferCookbook clone() => EventTransferCookbook()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventTransferCookbook copyWith(void Function(EventTransferCookbook) updates) => super.copyWith((message) => updates(message as EventTransferCookbook)) as EventTransferCookbook; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventTransferCookbook create() => EventTransferCookbook._();
  EventTransferCookbook createEmptyInstance() => create();
  static $pb.PbList<EventTransferCookbook> createRepeated() => $pb.PbList<EventTransferCookbook>();
  @$core.pragma('dart2js:noInline')
  static EventTransferCookbook getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventTransferCookbook>(create);
  static EventTransferCookbook? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sender => $_getSZ(0);
  @$pb.TagNumber(1)
  set sender($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSender() => $_has(0);
  @$pb.TagNumber(1)
  void clearSender() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get receiver => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiver($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReceiver() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiver() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get iD => $_getSZ(2);
  @$pb.TagNumber(3)
  set iD($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasID() => $_has(2);
  @$pb.TagNumber(3)
  void clearID() => clearField(3);
}

class EventCreateRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCreateRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false
  ;

  EventCreateRecipe._() : super();
  factory EventCreateRecipe({
    $core.String? creator,
    $core.String? cookbookID,
    $core.String? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (cookbookID != null) {
      _result.cookbookID = cookbookID;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventCreateRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCreateRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCreateRecipe clone() => EventCreateRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCreateRecipe copyWith(void Function(EventCreateRecipe) updates) => super.copyWith((message) => updates(message as EventCreateRecipe)) as EventCreateRecipe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCreateRecipe create() => EventCreateRecipe._();
  EventCreateRecipe createEmptyInstance() => create();
  static $pb.PbList<EventCreateRecipe> createRepeated() => $pb.PbList<EventCreateRecipe>();
  @$core.pragma('dart2js:noInline')
  static EventCreateRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCreateRecipe>(create);
  static EventCreateRecipe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

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
}

class EventUpdateRecipe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventUpdateRecipe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$4.Recipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'originalRecipe', protoName: 'originalRecipe', subBuilder: $4.Recipe.create)
    ..hasRequiredFields = false
  ;

  EventUpdateRecipe._() : super();
  factory EventUpdateRecipe({
    $4.Recipe? originalRecipe,
  }) {
    final _result = create();
    if (originalRecipe != null) {
      _result.originalRecipe = originalRecipe;
    }
    return _result;
  }
  factory EventUpdateRecipe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventUpdateRecipe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventUpdateRecipe clone() => EventUpdateRecipe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventUpdateRecipe copyWith(void Function(EventUpdateRecipe) updates) => super.copyWith((message) => updates(message as EventUpdateRecipe)) as EventUpdateRecipe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventUpdateRecipe create() => EventUpdateRecipe._();
  EventUpdateRecipe createEmptyInstance() => create();
  static $pb.PbList<EventUpdateRecipe> createRepeated() => $pb.PbList<EventUpdateRecipe>();
  @$core.pragma('dart2js:noInline')
  static EventUpdateRecipe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventUpdateRecipe>(create);
  static EventUpdateRecipe? _defaultInstance;

  @$pb.TagNumber(1)
  $4.Recipe get originalRecipe => $_getN(0);
  @$pb.TagNumber(1)
  set originalRecipe($4.Recipe v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOriginalRecipe() => $_has(0);
  @$pb.TagNumber(1)
  void clearOriginalRecipe() => clearField(1);
  @$pb.TagNumber(1)
  $4.Recipe ensureOriginalRecipe() => $_ensure(0);
}

class EventCreateExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCreateExecution', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false
  ;

  EventCreateExecution._() : super();
  factory EventCreateExecution({
    $core.String? creator,
    $core.String? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventCreateExecution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCreateExecution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCreateExecution clone() => EventCreateExecution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCreateExecution copyWith(void Function(EventCreateExecution) updates) => super.copyWith((message) => updates(message as EventCreateExecution)) as EventCreateExecution; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCreateExecution create() => EventCreateExecution._();
  EventCreateExecution createEmptyInstance() => create();
  static $pb.PbList<EventCreateExecution> createRepeated() => $pb.PbList<EventCreateExecution>();
  @$core.pragma('dart2js:noInline')
  static EventCreateExecution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCreateExecution>(create);
  static EventCreateExecution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class EventCompleteExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCompleteExecution', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<$2.Coin>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'burnCoins', $pb.PbFieldType.PM, protoName: 'burnCoins', subBuilder: $2.Coin.create)
    ..pc<$2.Coin>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payCoins', $pb.PbFieldType.PM, protoName: 'payCoins', subBuilder: $2.Coin.create)
    ..pc<$2.Coin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transferCoins', $pb.PbFieldType.PM, protoName: 'transferCoins', subBuilder: $2.Coin.create)
    ..pc<$2.Coin>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feeCoins', $pb.PbFieldType.PM, protoName: 'feeCoins', subBuilder: $2.Coin.create)
    ..pc<$2.Coin>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinOutputs', $pb.PbFieldType.PM, protoName: 'coinOutputs', subBuilder: $2.Coin.create)
    ..pc<$3.Item>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mintItems', $pb.PbFieldType.PM, protoName: 'mintItems', subBuilder: $3.Item.create)
    ..pc<$3.Item>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'modifyItems', $pb.PbFieldType.PM, protoName: 'modifyItems', subBuilder: $3.Item.create)
    ..hasRequiredFields = false
  ;

  EventCompleteExecution._() : super();
  factory EventCompleteExecution({
    $core.String? creator,
    $core.String? iD,
    $core.Iterable<$2.Coin>? burnCoins,
    $core.Iterable<$2.Coin>? payCoins,
    $core.Iterable<$2.Coin>? transferCoins,
    $core.Iterable<$2.Coin>? feeCoins,
    $core.Iterable<$2.Coin>? coinOutputs,
    $core.Iterable<$3.Item>? mintItems,
    $core.Iterable<$3.Item>? modifyItems,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    if (burnCoins != null) {
      _result.burnCoins.addAll(burnCoins);
    }
    if (payCoins != null) {
      _result.payCoins.addAll(payCoins);
    }
    if (transferCoins != null) {
      _result.transferCoins.addAll(transferCoins);
    }
    if (feeCoins != null) {
      _result.feeCoins.addAll(feeCoins);
    }
    if (coinOutputs != null) {
      _result.coinOutputs.addAll(coinOutputs);
    }
    if (mintItems != null) {
      _result.mintItems.addAll(mintItems);
    }
    if (modifyItems != null) {
      _result.modifyItems.addAll(modifyItems);
    }
    return _result;
  }
  factory EventCompleteExecution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCompleteExecution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCompleteExecution clone() => EventCompleteExecution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCompleteExecution copyWith(void Function(EventCompleteExecution) updates) => super.copyWith((message) => updates(message as EventCompleteExecution)) as EventCompleteExecution; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCompleteExecution create() => EventCompleteExecution._();
  EventCompleteExecution createEmptyInstance() => create();
  static $pb.PbList<EventCompleteExecution> createRepeated() => $pb.PbList<EventCompleteExecution>();
  @$core.pragma('dart2js:noInline')
  static EventCompleteExecution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCompleteExecution>(create);
  static EventCompleteExecution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$2.Coin> get burnCoins => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$2.Coin> get payCoins => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$2.Coin> get transferCoins => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$2.Coin> get feeCoins => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<$2.Coin> get coinOutputs => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$3.Item> get mintItems => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$3.Item> get modifyItems => $_getList(8);
}

class EventDropExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventDropExecution', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false
  ;

  EventDropExecution._() : super();
  factory EventDropExecution({
    $core.String? creator,
    $core.String? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventDropExecution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventDropExecution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventDropExecution clone() => EventDropExecution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventDropExecution copyWith(void Function(EventDropExecution) updates) => super.copyWith((message) => updates(message as EventDropExecution)) as EventDropExecution; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventDropExecution create() => EventDropExecution._();
  EventDropExecution createEmptyInstance() => create();
  static $pb.PbList<EventDropExecution> createRepeated() => $pb.PbList<EventDropExecution>();
  @$core.pragma('dart2js:noInline')
  static EventDropExecution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventDropExecution>(create);
  static EventDropExecution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class EventCompleteExecutionEarly extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCompleteExecutionEarly', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false
  ;

  EventCompleteExecutionEarly._() : super();
  factory EventCompleteExecutionEarly({
    $core.String? creator,
    $core.String? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventCompleteExecutionEarly.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCompleteExecutionEarly.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCompleteExecutionEarly clone() => EventCompleteExecutionEarly()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCompleteExecutionEarly copyWith(void Function(EventCompleteExecutionEarly) updates) => super.copyWith((message) => updates(message as EventCompleteExecutionEarly)) as EventCompleteExecutionEarly; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCompleteExecutionEarly create() => EventCompleteExecutionEarly._();
  EventCompleteExecutionEarly createEmptyInstance() => create();
  static $pb.PbList<EventCompleteExecutionEarly> createRepeated() => $pb.PbList<EventCompleteExecutionEarly>();
  @$core.pragma('dart2js:noInline')
  static EventCompleteExecutionEarly getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCompleteExecutionEarly>(create);
  static EventCompleteExecutionEarly? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class EventSendItems extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventSendItems', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiver')
    ..pc<$6.ItemRef>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: $6.ItemRef.create)
    ..hasRequiredFields = false
  ;

  EventSendItems._() : super();
  factory EventSendItems({
    $core.String? sender,
    $core.String? receiver,
    $core.Iterable<$6.ItemRef>? items,
  }) {
    final _result = create();
    if (sender != null) {
      _result.sender = sender;
    }
    if (receiver != null) {
      _result.receiver = receiver;
    }
    if (items != null) {
      _result.items.addAll(items);
    }
    return _result;
  }
  factory EventSendItems.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventSendItems.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventSendItems clone() => EventSendItems()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventSendItems copyWith(void Function(EventSendItems) updates) => super.copyWith((message) => updates(message as EventSendItems)) as EventSendItems; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventSendItems create() => EventSendItems._();
  EventSendItems createEmptyInstance() => create();
  static $pb.PbList<EventSendItems> createRepeated() => $pb.PbList<EventSendItems>();
  @$core.pragma('dart2js:noInline')
  static EventSendItems getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventSendItems>(create);
  static EventSendItems? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sender => $_getSZ(0);
  @$pb.TagNumber(1)
  set sender($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSender() => $_has(0);
  @$pb.TagNumber(1)
  void clearSender() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get receiver => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiver($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReceiver() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiver() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$6.ItemRef> get items => $_getList(2);
}

class EventSetItemString extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventSetItemString', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<$3.StringKeyValue>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'originalMutableStrings', $pb.PbFieldType.PM, protoName: 'originalMutableStrings', subBuilder: $3.StringKeyValue.create)
    ..hasRequiredFields = false
  ;

  EventSetItemString._() : super();
  factory EventSetItemString({
    $core.String? creator,
    $core.String? cookbookID,
    $core.String? iD,
    $core.Iterable<$3.StringKeyValue>? originalMutableStrings,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (cookbookID != null) {
      _result.cookbookID = cookbookID;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    if (originalMutableStrings != null) {
      _result.originalMutableStrings.addAll(originalMutableStrings);
    }
    return _result;
  }
  factory EventSetItemString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventSetItemString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventSetItemString clone() => EventSetItemString()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventSetItemString copyWith(void Function(EventSetItemString) updates) => super.copyWith((message) => updates(message as EventSetItemString)) as EventSetItemString; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventSetItemString create() => EventSetItemString._();
  EventSetItemString createEmptyInstance() => create();
  static $pb.PbList<EventSetItemString> createRepeated() => $pb.PbList<EventSetItemString>();
  @$core.pragma('dart2js:noInline')
  static EventSetItemString getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventSetItemString>(create);
  static EventSetItemString? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

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
  $core.List<$3.StringKeyValue> get originalMutableStrings => $_getList(3);
}

class EventCreateTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCreateTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  EventCreateTrade._() : super();
  factory EventCreateTrade({
    $core.String? creator,
    $fixnum.Int64? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventCreateTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCreateTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCreateTrade clone() => EventCreateTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCreateTrade copyWith(void Function(EventCreateTrade) updates) => super.copyWith((message) => updates(message as EventCreateTrade)) as EventCreateTrade; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCreateTrade create() => EventCreateTrade._();
  EventCreateTrade createEmptyInstance() => create();
  static $pb.PbList<EventCreateTrade> createRepeated() => $pb.PbList<EventCreateTrade>();
  @$core.pragma('dart2js:noInline')
  static EventCreateTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCreateTrade>(create);
  static EventCreateTrade? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get iD => $_getI64(1);
  @$pb.TagNumber(2)
  set iD($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class EventCancelTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventCancelTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  EventCancelTrade._() : super();
  factory EventCancelTrade({
    $core.String? creator,
    $fixnum.Int64? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventCancelTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventCancelTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventCancelTrade clone() => EventCancelTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventCancelTrade copyWith(void Function(EventCancelTrade) updates) => super.copyWith((message) => updates(message as EventCancelTrade)) as EventCancelTrade; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventCancelTrade create() => EventCancelTrade._();
  EventCancelTrade createEmptyInstance() => create();
  static $pb.PbList<EventCancelTrade> createRepeated() => $pb.PbList<EventCancelTrade>();
  @$core.pragma('dart2js:noInline')
  static EventCancelTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventCancelTrade>(create);
  static EventCancelTrade? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get iD => $_getI64(1);
  @$pb.TagNumber(2)
  set iD($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class EventFulfillTrade extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventFulfillTrade', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fulfiller')
    ..pc<$6.ItemRef>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemInputs', $pb.PbFieldType.PM, protoName: 'itemInputs', subBuilder: $6.ItemRef.create)
    ..pc<$2.Coin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinInputs', $pb.PbFieldType.PM, protoName: 'coinInputs', subBuilder: $2.Coin.create)
    ..pc<$6.ItemRef>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemOutputs', $pb.PbFieldType.PM, protoName: 'itemOutputs', subBuilder: $6.ItemRef.create)
    ..pc<$2.Coin>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinOutputs', $pb.PbFieldType.PM, protoName: 'coinOutputs', subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  EventFulfillTrade._() : super();
  factory EventFulfillTrade({
    $fixnum.Int64? iD,
    $core.String? creator,
    $core.String? fulfiller,
    $core.Iterable<$6.ItemRef>? itemInputs,
    $core.Iterable<$2.Coin>? coinInputs,
    $core.Iterable<$6.ItemRef>? itemOutputs,
    $core.Iterable<$2.Coin>? coinOutputs,
  }) {
    final _result = create();
    if (iD != null) {
      _result.iD = iD;
    }
    if (creator != null) {
      _result.creator = creator;
    }
    if (fulfiller != null) {
      _result.fulfiller = fulfiller;
    }
    if (itemInputs != null) {
      _result.itemInputs.addAll(itemInputs);
    }
    if (coinInputs != null) {
      _result.coinInputs.addAll(coinInputs);
    }
    if (itemOutputs != null) {
      _result.itemOutputs.addAll(itemOutputs);
    }
    if (coinOutputs != null) {
      _result.coinOutputs.addAll(coinOutputs);
    }
    return _result;
  }
  factory EventFulfillTrade.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventFulfillTrade.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventFulfillTrade clone() => EventFulfillTrade()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventFulfillTrade copyWith(void Function(EventFulfillTrade) updates) => super.copyWith((message) => updates(message as EventFulfillTrade)) as EventFulfillTrade; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventFulfillTrade create() => EventFulfillTrade._();
  EventFulfillTrade createEmptyInstance() => create();
  static $pb.PbList<EventFulfillTrade> createRepeated() => $pb.PbList<EventFulfillTrade>();
  @$core.pragma('dart2js:noInline')
  static EventFulfillTrade getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventFulfillTrade>(create);
  static EventFulfillTrade? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get iD => $_getI64(0);
  @$pb.TagNumber(1)
  set iD($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get creator => $_getSZ(1);
  @$pb.TagNumber(2)
  set creator($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreator() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreator() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get fulfiller => $_getSZ(2);
  @$pb.TagNumber(3)
  set fulfiller($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFulfiller() => $_has(2);
  @$pb.TagNumber(3)
  void clearFulfiller() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$6.ItemRef> get itemInputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$2.Coin> get coinInputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$6.ItemRef> get itemOutputs => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<$2.Coin> get coinOutputs => $_getList(6);
}

class EventGooglePurchase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventGooglePurchase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productID', protoName: 'productID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseToken', protoName: 'purchaseToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiptDataBase64', protoName: 'receiptDataBase64')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature')
    ..hasRequiredFields = false
  ;

  EventGooglePurchase._() : super();
  factory EventGooglePurchase({
    $core.String? creator,
    $core.String? productID,
    $core.String? purchaseToken,
    $core.String? receiptDataBase64,
    $core.String? signature,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (productID != null) {
      _result.productID = productID;
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
  factory EventGooglePurchase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventGooglePurchase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventGooglePurchase clone() => EventGooglePurchase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventGooglePurchase copyWith(void Function(EventGooglePurchase) updates) => super.copyWith((message) => updates(message as EventGooglePurchase)) as EventGooglePurchase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventGooglePurchase create() => EventGooglePurchase._();
  EventGooglePurchase createEmptyInstance() => create();
  static $pb.PbList<EventGooglePurchase> createRepeated() => $pb.PbList<EventGooglePurchase>();
  @$core.pragma('dart2js:noInline')
  static EventGooglePurchase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventGooglePurchase>(create);
  static EventGooglePurchase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get productID => $_getSZ(1);
  @$pb.TagNumber(2)
  set productID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProductID() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductID() => clearField(2);

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

class EventStripePurchase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventStripePurchase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false
  ;

  EventStripePurchase._() : super();
  factory EventStripePurchase({
    $core.String? creator,
    $core.String? iD,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (iD != null) {
      _result.iD = iD;
    }
    return _result;
  }
  factory EventStripePurchase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventStripePurchase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventStripePurchase clone() => EventStripePurchase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventStripePurchase copyWith(void Function(EventStripePurchase) updates) => super.copyWith((message) => updates(message as EventStripePurchase)) as EventStripePurchase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventStripePurchase create() => EventStripePurchase._();
  EventStripePurchase createEmptyInstance() => create();
  static $pb.PbList<EventStripePurchase> createRepeated() => $pb.PbList<EventStripePurchase>();
  @$core.pragma('dart2js:noInline')
  static EventStripePurchase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventStripePurchase>(create);
  static EventStripePurchase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

