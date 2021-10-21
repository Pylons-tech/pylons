
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class CreateRecipeHandler implements BaseHandler {

  List<String> wholeMessage;

  CreateRecipeHandler(this.wholeMessage);

  @override
  Future<String> handle() async {

    var response = '';

    try {

      final jsonMap = jsonDecode(wholeMessage[2],) as Map;

      jsonMap.remove('nodeVersion');


      var walletsStore = GetIt.I.get<WalletsStore>();

      response = (await walletsStore.createCookBook(jsonMap)).txHash;

    } catch (e, stacktrace) {
      log('$e', name: 'Create Cook book Handler', stackTrace: stacktrace);
    }

    return SynchronousFuture(response);
  }
}
