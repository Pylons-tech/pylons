import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pylons_wallet/pylons_app.dart';


class BuyPylons {

  Future<double> buy() async {
    print("Sending 100 pylon to ${PylonsApp.currentWallet.publicAddress}");
    final response = await http.post(
      //This the address that android emulator uses to communicate with host.
      // Get some pylon from the Faucet.
      Uri.parse(PylonsApp.baseEnv.baseFaucetUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "address": PylonsApp.currentWallet.publicAddress,
        "coins": [
          "100pylon"
        ]
      }),
    );
    if (response.statusCode!=200){
      print("Error");
      return 0.0;
    }
    print(response.body);
    return 0.0;
  }
}
