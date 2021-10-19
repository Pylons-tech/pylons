import 'dart:convert';

import 'package:alan/proto/cosmos/crisis/v1beta1/tx.pbgrpc.dart';
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


      var json = """{
                      "creator": "pylo1mwky96p8qzckfvus0cpcdzv9c2983az65lp37t",
                      "ID": "v1",                      
                      "name": "Legend of the Undead Dragon",
                      "description": "Cookbook for running pylons recreation of LOUD",
                      "developer": "Pylons Inc",
                      "version": "v1.0.0",
                      "supportEmail": "pylons@pylons.tech",
                      "costPerBlock": {
                      "denom": "pylo",
                      "amount": "1000"
                      },
                      "enabled": true
              }""";
      // print(wholeMessage);
      //
      // var registry = $pb.ExtensionRegistry();
      // registry.add($pb.Extension(extendee, name, tagNumber, fieldType))

      final jsonMap = jsonDecode(json);

      var msgObj = pylons.MsgCreateCookbook.create()..mergeFromProto3Json(jsonMap);



      // var msgObj = pylons.MsgCreateCookbook.fromJson(wholeMessage[2],);
      final result = await signingGateway
          .signTransaction(transaction: UnsignedAlanTransaction(messages: [msgObj]), walletLookupKey: walletLookupKey)
          .mapError<dynamic>((error) {
                print(error);
                throw error;
           }).flatMap(
              (signed) => signingGateway.broadcastTransaction(
                walletLookupKey: walletLookupKey,
                transaction: signed,
              ),
          );


      print(result);


      result.fold(
        (fail) => throw fail as Object,
        (hash) => debugPrint("new TX hash: ${hash.txHash}"),
      );
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }

    return SynchronousFuture('');
  }
}
