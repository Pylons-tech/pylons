import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';

class IBCTraceModel {
  DenomTrace denomTrace;
  String ibcHash;

  IBCTraceModel({required this.denomTrace, required this.ibcHash});

  factory IBCTraceModel.fromJson(Map<String, dynamic> json,  String ibcHash) {
   return  IBCTraceModel(denomTrace: DenomTrace.fromJson(json['denom_trace'] as Map<String, dynamic>), ibcHash: ibcHash);
  }

  @override
  String toString() {
    return 'IBCTraceModel{denomTrace: $denomTrace}';
  }
}

class DenomTrace {
  String path;
  IBCCoins baseDenom;

  DenomTrace({required this.path, required this.baseDenom});

  factory DenomTrace.fromJson(Map<String, dynamic> json) {
    return DenomTrace(path: json['path'].toString(), baseDenom: json['base_denom'].toString().toIBCCoinsEnum());
  }

  @override
  String toString() {
    return 'DenomTrace{path: $path, baseDenom: $baseDenom}';
  }
}
