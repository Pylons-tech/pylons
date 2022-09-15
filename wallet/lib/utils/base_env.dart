import 'dart:convert';

import 'package:alan/alan.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grpc/grpc.dart';
import 'package:pylons_wallet/services/third_party_services/remote_config_service/models/sku_model.dart';
import 'package:pylons_wallet/utils/constants.dart';

class BaseEnv {
  late NetworkInfo _networkInfo;
  late String _baseApiUrl;
  late String _baseEthUrl;

  late String _stripeUrl;
  late String _stripePubKey;
  late bool _stripeTestEnv;
  late String _stripeCallbackUrl;
  late String _stripeCallbackRefreshUrl;
  late String _chainId;
  late String _ibcTraceUrl;
  late String _faucetUrl;
  late String _baseMongoUrl;
  late List<SKUModel> _skus;

  void setEnv(
      {required String lcdUrl,
      required String grpcUrl,
      required String lcdPort,
      required String grpcPort,
      required String ethUrl,
      required String chainId,
      required String faucetUrl,
      required String ibcTraceUrl,
      required String mongoUrl,
        required String skus,
      String? stripeUrl,
      String? stripePubKey,
      bool? stripeTestEnv,
      String? stripeCallbackUrl,
      String? stripeCallbackRefreshUrl}) {
    _networkInfo = NetworkInfo(
      bech32Hrp: kPylo,
      lcdInfo: LCDInfo(host: lcdUrl, port: int.parse(lcdPort)),
      grpcInfo: GRPCInfo(
        host: grpcUrl,
        port: int.parse(grpcPort),
        credentials: (dotenv.env[kENV]! == kLocal)
            ? const ChannelCredentials.insecure()
            : const ChannelCredentials.insecure(),
      ),
      chainId: chainId,
    );
    _baseApiUrl = "$lcdUrl:$lcdPort";
    _baseMongoUrl = mongoUrl;
    _baseEthUrl = ethUrl;

    _stripeUrl = stripeUrl ?? "";
    _stripePubKey = stripePubKey ?? "";
    _stripeTestEnv = stripeTestEnv ?? true;
    _stripeCallbackUrl = stripeCallbackUrl ?? "";
    _stripeCallbackRefreshUrl = stripeCallbackRefreshUrl ?? "";
    _chainId = chainId;
    _ibcTraceUrl = ibcTraceUrl;
    _faucetUrl = faucetUrl;


    final List jsonSkuList = jsonDecode(skus) as List;
    _skus = jsonSkuList.map(( e) => SKUModel.fromJson(e as Map )).toList();

  }

  NetworkInfo get networkInfo => _networkInfo;

  String get baseApiUrl => _baseApiUrl;

  String get baseMongoUrl => _baseMongoUrl;

  String get baseEthUrl => _baseEthUrl;

  String get baseStripeUrl => _stripeUrl;

  String get baseStripPubKey => _stripePubKey;

  bool get baseStripeTestEnv => _stripeTestEnv;

  String get baseStripeCallbackUrl => _stripeCallbackUrl;

  String get baseStripeCallbackRefreshUrl => _stripeCallbackRefreshUrl;

  String get chainId => _chainId;

  String get denomTraceUrl => _ibcTraceUrl;

  String get faucetUrl => _faucetUrl;


  List<SKUModel> get skus => _skus;

  @override
  String toString() {
    return 'BaseEnv{_networkInfo: $_networkInfo, _baseApiUrl: $_baseApiUrl, _baseEthUrl: $_baseEthUrl,  _stripeUrl: $_stripeUrl, _stripePubKey: $_stripePubKey, _stripeTestEnv: $_stripeTestEnv, _stripeCallbackUrl: $_stripeCallbackUrl, _stripeCallbackRefreshUrl: $_stripeCallbackRefreshUrl, _chainId: $_chainId, _ibcTraceUrl: $_ibcTraceUrl, _faucetUrl: $_faucetUrl}';
  }


}
