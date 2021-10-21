
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/pylons_app.dart';

class CreateRecipeHandler implements BaseHandler {

  List<String> wholeMessage;

  CreateRecipeHandler(this.wholeMessage);

  @override
  Future<String> handle() async {

    var response = '';

    try {

      final jsonMap = jsonDecode(wholeMessage[2],) as Map;

      jsonMap.remove('nodeVersion');


      response = (await PylonsApp.walletsStore.createRecipe(jsonMap)).txHash;

    } catch (e, stacktrace) {
      log('$e', name: 'Create Cook book Handler', stackTrace: stacktrace);
    }

    return SynchronousFuture(response);
  }
}
