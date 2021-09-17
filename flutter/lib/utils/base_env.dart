import 'package:alan/alan.dart';

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
    String? faucetPort,
  }) {
    _networkInfo = NetworkInfo(
      bech32Hrp: 'cosmos',
      lcdInfo: LCDInfo(host: lcdUrl, port: int.parse(lcdPort)),
      grpcInfo: GRPCInfo(host: grpcUrl, port: int.parse(grpcPort)),
    );
    _baseApiUrl = "$lcdUrl:$lcdPort";
    _baseEthUrl = ethUrl;
    _baseFaucetUrl = "$lcdUrl:$faucetPort";
    _baseWsUrl = "$wsUrl:$tendermintPort";
  }

  NetworkInfo get networkInfo => _networkInfo;

  String get baseApiUrl => _baseApiUrl;

  String get baseEthUrl => _baseEthUrl;

  String get baseFaucetUrl => _baseFaucetUrl;

  String get baseWsUrl => _baseWsUrl;
}

const lcdPort = String.fromEnvironment('LCD_PORT', defaultValue: '1317');
const grpcPort = String.fromEnvironment('GRPC_PORT', defaultValue: '9091');
const lcdUrl = String.fromEnvironment('LCD_URL', defaultValue: '192.168.2.122');
const grpcUrl = String.fromEnvironment('GRPC_URL', defaultValue: '192.168.2.122');
const ethUrl = String.fromEnvironment('ETH_URL', defaultValue: 'HTTP://127.0.0.1:7545');
const wsUrl = String.fromEnvironment('WS_URL', defaultValue: 'ws://192.168.2.122');
const faucetPort = String.fromEnvironment('FAUCET_PORT', defaultValue: '4500');
const tendermintPort = String.fromEnvironment('TENDERMINT_PORT', defaultValue: '26657');
