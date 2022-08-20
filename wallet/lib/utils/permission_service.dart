import 'package:permission_handler/permission_handler.dart'
    as permission_handler show openAppSettings;
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  /// Check the status of a specific [Permission]
  Future<PermissionStatus> status(Permission permission);

  Future<PermissionStatus> request(Permission permission);

  /// Open the app settings.
  Future<bool> openAppSettings();
}

class PermissionsServiceImp implements PermissionService {
  /// Check the status of a specific [Permission]
  @override
  Future<PermissionStatus> status(Permission permission) {
    return permission.status;
  }

  /// Open the app settings.
  @override
  Future<bool> openAppSettings() {
    return permission_handler.openAppSettings();
  }

  /// Request permissions for a single permission.
  @override
  Future<PermissionStatus> request(Permission permission) {
    return permission.request();
  }
}
