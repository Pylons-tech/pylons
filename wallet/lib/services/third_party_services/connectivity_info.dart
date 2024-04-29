import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract Class for providing network info
/// [isConnected] method is used for testing
abstract class ConnectivityInfo {
  /// This method tells whether the system is connected with the internet or not
  Future<bool> get isConnected;

  Stream<InternetConnectionStatus> onStatusChange();
}

/// [NetworkInfoImpl] implementation of [NetworkInfo]
/// Provides info regarding the network info using network info package
class ConnectivityInfoImpl implements ConnectivityInfo {
  final InternetConnectionChecker connectionChecker;

  ConnectivityInfoImpl(this.connectionChecker);

  /// This method provides info regarding network connectivity using InternetConnectionChecker
  /// Output: [bool] tells whether connected to internet or not
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus> onStatusChange() {
    return connectionChecker.onStatusChange;
  }
}
