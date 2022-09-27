import 'package:fixnum/fixnum.dart';

import '../generated/pylons/cookbook.pb.dart' as generated;

class Cookbook {
  final generated.Cookbook _native;

  Cookbook(this._native);

  static Cookbook? _current;
  static Cookbook? get current => _current;

  static void load (String id) async {
    throw UnimplementedError();
  }

  String getCreator() {
    return _native.creator;
  }

  String getId() {
    return _native.id;
  }

  Int64 getNodeVersion() {
    return _native.nodeVersion;
  }

  String getName() {
    return _native.name;
  }

  String getDescription() {
    return _native.description;
  }

  String getDeveloper() {
    return _native.developer;
  }

  String getVersion() {
    return _native.version;
  }

  String getSupportEmail() {
    return _native.supportEmail;
  }

  bool isEnabled() {
    return _native.enabled;
  }
}