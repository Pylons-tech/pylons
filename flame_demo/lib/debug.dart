import 'dart:io';

class Debug {
  static bool get isOfflineBuild {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}