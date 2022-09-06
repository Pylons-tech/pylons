import 'package:pylons_wallet/services/third_party_services/analytics_helper.dart';

class MockAnalyticsHelper implements AnalyticsHelper {
  @override
  Future<void> setUserId({required String address}) {
    throw UnimplementedError();
  }
}
