///
//  Generated code. Do not modify.
//  source: tendermint/types/block.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'types.pb.dart' as $7;
import 'evidence.pb.dart' as $8;

class Block extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Block', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tendermint.types'), createEmptyInstance: create)
    ..aOM<$7.Header>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'header', subBuilder: $7.Header.create)
    ..aOM<$7.Data>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', subBuilder: $7.Data.create)
    ..aOM<$8.EvidenceList>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'evidence', subBuilder: $8.EvidenceList.create)
    ..aOM<$7.Commit>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastCommit', subBuilder: $7.Commit.create)
    ..hasRequiredFields = false
  ;

  Block._() : super();
  factory Block({
    $7.Header? header,
    $7.Data? data,
    $8.EvidenceList? evidence,
    $7.Commit? lastCommit,
  }) {
    final _result = create();
    if (header != null) {
      _result.header = header;
    }
    if (data != null) {
      _result.data = data;
    }
    if (evidence != null) {
      _result.evidence = evidence;
    }
    if (lastCommit != null) {
      _result.lastCommit = lastCommit;
    }
    return _result;
  }
  factory Block.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Block.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Block clone() => Block()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Block copyWith(void Function(Block) updates) => super.copyWith((message) => updates(message as Block)) as Block; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Block create() => Block._();
  Block createEmptyInstance() => create();
  static $pb.PbList<Block> createRepeated() => $pb.PbList<Block>();
  @$core.pragma('dart2js:noInline')
  static Block getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Block>(create);
  static Block? _defaultInstance;

  @$pb.TagNumber(1)
  $7.Header get header => $_getN(0);
  @$pb.TagNumber(1)
  set header($7.Header v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeader() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeader() => clearField(1);
  @$pb.TagNumber(1)
  $7.Header ensureHeader() => $_ensure(0);

  @$pb.TagNumber(2)
  $7.Data get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($7.Data v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
  @$pb.TagNumber(2)
  $7.Data ensureData() => $_ensure(1);

  @$pb.TagNumber(3)
  $8.EvidenceList get evidence => $_getN(2);
  @$pb.TagNumber(3)
  set evidence($8.EvidenceList v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => clearField(3);
  @$pb.TagNumber(3)
  $8.EvidenceList ensureEvidence() => $_ensure(2);

  @$pb.TagNumber(4)
  $7.Commit get lastCommit => $_getN(3);
  @$pb.TagNumber(4)
  set lastCommit($7.Commit v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLastCommit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastCommit() => clearField(4);
  @$pb.TagNumber(4)
  $7.Commit ensureLastCommit() => $_ensure(3);
}

