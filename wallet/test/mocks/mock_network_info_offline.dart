import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';

import 'mock_constants.dart';

class MockNetworkInfoOffline extends NetworkInfo {
  String getIP() {
    return MOCK_IP;
  }

  @override
  Future<bool> get isConnected => Future.value(false);

  @override
  Stream<InternetConnectionStatus> onStatusChange() async* {
    yield INTERNET_CONNECTIVITY_STATUS_DISCONNECTED;
  }
}
