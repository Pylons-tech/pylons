import 'package:evently/services/third_party_services/quick_node.dart';

class StorageResponseModel {
  bool? ok;
  Value? value;

  StorageResponseModel({this.ok, this.value});

  StorageResponseModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'] as bool?;
    value = json['value'] != null ? Value.fromJson(json['value'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ok'] = ok;
    if (value != null) {
      map['value'] = value?.toJson();
    }
    return map;
  }

  factory StorageResponseModel.initial() {
    return StorageResponseModel();
  }

  factory StorageResponseModel.fromQuickNode({required UploadIPFSOutput uploadIPFSOutput}) {
    return StorageResponseModel(
      ok: true,
      value: Value(
          cid: uploadIPFSOutput.pin?.cid,
          created: uploadIPFSOutput.created,
          size: int.parse(
            uploadIPFSOutput.info?.size ?? '0',
          ),
          pin: Pin(
            cid: uploadIPFSOutput.pin?.cid,
            created: uploadIPFSOutput.created,
            size: int.parse(
              uploadIPFSOutput.info?.size ?? '0',
            ),
            status: uploadIPFSOutput.status,
          )),
    );
  }
}

class Value {
  String? cid;
  String? created;
  String? type;
  String? scope;
  int? size;
  Pin? pin;

  Value({
    this.cid,
    this.created,
    this.type,
    this.scope,
    this.size,
    this.pin,
  });

  Value.fromJson(Map<String, dynamic> json) {
    cid = json['cid'] as String?;
    created = json['created'] as String?;
    type = json['type'] as String?;
    scope = json['scope'] as String?;
    size = json['size'] as int?;
    pin = json['pin'] != null ? Pin.fromJson(json['pin'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cid'] = cid;
    map['created'] = created;
    map['type'] = type;
    map['scope'] = scope;
    map['size'] = size;
    if (pin != null) {
      map['pin'] = pin?.toJson();
    }
    return map;
  }
}

class Pin {
  String? cid;
  String? created;
  int? size;
  String? status;

  Pin({this.cid, this.created, this.size, this.status});

  Pin.fromJson(Map<String, dynamic> json) {
    cid = json['cid'] as String?;
    created = json['created'] as String?;
    size = json['size'] as int?;
    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cid'] = cid;
    map['created'] = created;
    map['size'] = size;
    map['status'] = status;
    return map;
  }
}
