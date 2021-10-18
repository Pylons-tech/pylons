import 'package:alan/alan.dart';
import 'package:flutter/cupertino.dart';
import 'package:grpc/grpc.dart';

class BaseEnv {
  late NetworkInfo _networkInfo;
  late String _baseApiUrl;
  late String _baseEthUrl;
  late String _baseFaucetUrl;
  late String _baseWsUrl;

  void setEnv({
    required String lcdUrl,
    required String grpcUrl,
    required String lcdPort,
    required String grpcPort,
    required String ethUrl,
    required String wsUrl,
    required String tendermintPort,
    String? faucetUrl,
    String? faucetPort,
  }) {
    _networkInfo = NetworkInfo(
      bech32Hrp: 'pylo',
      lcdInfo: LCDInfo(
          host: lcdUrl,
          port: int.parse(lcdPort)
      ),
      grpcInfo: GRPCInfo(
          host: grpcUrl,
          port: int.parse(grpcPort),
          credentials: ChannelCredentials.secure(
            onBadCertificate: (cert, host) {
                debugPrint("host: $host, cert: $cert");
                return true;
              },
          )
      ),
    );
    _baseApiUrl = "$lcdUrl:$lcdPort";
    _baseEthUrl = ethUrl;
    _baseFaucetUrl = "$faucetUrl:$faucetPort";
    _baseWsUrl = "$wsUrl:$tendermintPort";
  }

  NetworkInfo get networkInfo => _networkInfo;

  String get baseApiUrl => _baseApiUrl;

  String get baseEthUrl => _baseEthUrl;

  String get baseFaucetUrl => _baseFaucetUrl;

  String get baseWsUrl => _baseWsUrl;
}
