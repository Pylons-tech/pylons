import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';

import 'mock_constants.dart';

class MockNetworkInfoOnline extends NetworkInfo {
  @override
  Future<bool> get isConnected => Future.value(true);

  @override
  Stream<InternetConnectionStatus> onStatusChange() async* {
    yield INTERNET_CONNECTIVITY_STATUS_CONNECTED;
  }
}
