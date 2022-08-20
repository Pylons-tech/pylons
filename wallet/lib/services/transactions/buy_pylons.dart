import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class BuyPylons {
  Future<double> buy() async {
    final response = await http.post(
      //This the address that android emulator uses to communicate with host.
      // Get some pylon from the Faucet.
      Uri.parse(GetIt.I.get()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "address": '',
        "coins": ["100pylon"]
      }),
    );
    if (response.statusCode != HttpStatus.ok) {
      return 0.0;
    }
    return 0.0;
  }
}
