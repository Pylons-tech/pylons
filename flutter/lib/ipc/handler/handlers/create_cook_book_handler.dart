import 'dart:convert';

import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/pylons_app.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction.dart';
import 'package:transaction_signing_gateway/model/wallet_lookup_key.dart';


class CreateCookBookHandler implements BaseHandler {
  List<String> wholeMessage;

  CreateCookBookHandler(this.wholeMessage);

  @override
  Future<String> handle() async {

    try {
      final signingGateway = PylonsApp.signingGateway;
      final currentWallet = PylonsApp.currentWallet;

      final walletLookupKey = WalletLookupKey(
        walletId: currentWallet.walletId,
        chainId: currentWallet.chainId,
        password: '',
      );

      // print(wholeMessage);
      //
      // var registry = $pb.ExtensionRegistry();
      // registry.add($pb.Extension(extendee, name, tagNumber, fieldType))

      final jsonMap = jsonDecode(wholeMessage[2]);

      var msgObj = pylons.MsgCreateCookbook.create()
        ..mergeFromProto3Json(jsonMap);


      final store = PylonsApp.walletsStore;

      store.createCookBook(msgObj);


    } catch(e, stacktrace){
      print(e);
      print(stacktrace);
    }

    return SynchronousFuture('');
  }
}
