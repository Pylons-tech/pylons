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

    var signingGateway = PylonsApp.signingGateway;
    var currentWallet = PylonsApp.currentWallet;

    final walletLookupKey = WalletLookupKey(
      walletId: currentWallet.walletId,
      chainId: currentWallet.chainId,
      password: '',
    );



    for(var json in wholeMessage){
      var msgObj = pylons.MsgCreateCookbook.fromJson(json);
      final result = await signingGateway
          .signTransaction(
            transaction: UnsignedAlanTransaction(messages: [msgObj]),
            walletLookupKey: walletLookupKey)
          .mapError<dynamic>((error) => throw error)
          .flatMap((signed) => signingGateway.broadcastTransaction(
                      walletLookupKey: walletLookupKey,
                      transaction: signed,
          ),
      );
      result.fold(
            (fail) => throw fail as Object,
            (hash) => debugPrint("new TX hash: $hash"),
      );
    }


    return SynchronousFuture('');
  }
}
