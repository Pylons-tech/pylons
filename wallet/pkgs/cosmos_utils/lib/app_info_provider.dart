import 'package:cosmos_utils/app_info_extractor.dart';

class AppInfoProvider {
  Future<AppInfo> get appInfo async {
    _appInfo ??= await getAppInfo();
    return _appInfo!;
  }

  AppInfo? _appInfo;

  Future<String> getAppVersion() async => (await appInfo).version;

  Future<String> getAppName() async => (await appInfo).appName;

  Future<String> getPackageName() async => (await appInfo).packageName;

  Future<String> getBuildNumber() async => (await appInfo).buildNumber;
}
