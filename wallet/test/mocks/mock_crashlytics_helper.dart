import 'package:pylons_wallet/services/third_party_services/crashlytics_helper.dart';

class MockCrashlytics implements CrashlyticsHelper {
  @override
  void recordFatalError({required String error}) {}

  @override
  void setUserIdentifier({required String identifier}) {}
}
