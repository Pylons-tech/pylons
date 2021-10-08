import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:pylons_wallet/entities/amount.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/entities/denom.dart';
import 'package:pylons_wallet/utils/base_env.dart';

class PylonsBalance {

  BaseEnv baseEnv;

  PylonsBalance(this.baseEnv);

  Future<Balance> getBalance(String walletAddress) async {
    print(walletAddress);
    final uri = '${baseEnv.baseApiUrl}/cosmos/bank/v1beta1/balances/$walletAddress';
    final response = await http.get(Uri.parse(uri));
    final map = jsonDecode(response.body) as Map<String, dynamic>;
    if(map['balances'].length!=0){
      return Balance.fromJSON(map['balances'][0] as Map<String,dynamic>);
    }
    return Balance(denom: const Denom("pylon"), amount: Amount(Decimal.zero));
  }
}
