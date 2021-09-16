import 'package:pylons_wallet/entities/balance.dart';
import 'package:alan/proto/cosmos/bank/v1beta1/export.dart' as bank;
import 'package:alan/alan.dart' as alan;
import 'package:transaction_signing_gateway/alan/alan_transaction.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/wallet_lookup_key.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';

class TokenSender {
  TransactionSigningGateway transactionSigningGateway;

  TokenSender(this.transactionSigningGateway);

  Future<void> sendPylons(
      WalletPublicInfo info,
      Balance balance,
      String toAddress,
      ) async {
    final message = bank.MsgSend.create()
      ..fromAddress = info.publicAddress
      ..toAddress = toAddress;
    message.amount.add(
      alan.Coin.create()
        ..denom = balance.denom.text
        ..amount = balance.amount.value.toString(),
    );

    final unsignedTransaction = UnsignedAlanTransaction(messages: [message]);

    final walletLookupKey = WalletLookupKey(
      walletId: info.walletId,
      chainId: info.chainId,
      password: '',
    );

    final signedAlanTransaction = await transactionSigningGateway.signTransaction(
      transaction: unsignedTransaction,
      walletLookupKey: walletLookupKey,
    );
    await signedAlanTransaction.fold<Future?>(
          (fail) => null,
          (signedTransaction) => transactionSigningGateway.broadcastTransaction(
          walletLookupKey: walletLookupKey, transaction: signedTransaction),
    );
  }
}
