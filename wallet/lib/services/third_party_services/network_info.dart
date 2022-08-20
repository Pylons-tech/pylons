import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract Class for providing network info
/// [isConnected] method is used for testing
abstract class NetworkInfo {
  /// This method tells whether the system is connected with the internet or not
  Future<bool> get isConnected;

  /// This method returns the IP with which the user is connected
  String getIP();

  Stream<InternetConnectionStatus> onStatusChange();
}

/// [NetworkInfoImpl] implementation of [NetworkInfo]
/// Provides info regarding the network info using network info package
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  /// This method provides info regarding network connectivity using InternetConnectionChecker
  /// Output: [bool] tells whether connected to internet or not
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  String getIP() {
    if (connectionChecker.addresses.isEmpty) {
      throw 'No IP Found';
    }
    return connectionChecker.addresses.last.address.address;
  }

  @override
  Stream<InternetConnectionStatus> onStatusChange() {
    return connectionChecker.onStatusChange;
  }
}
