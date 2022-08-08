import 'package:alan/alan.dart' as alan;
import 'package:alan/proto/cosmos/bank/v1beta1/export.dart' as bank;
import 'package:pylons_wallet/model/balance.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';

class TokenSender {
  TransactionSigningGateway transactionSigningGateway;

  TokenSender(this.transactionSigningGateway);

  Future<void> sendPylons(
    AccountPublicInfo info,
    Balance balance,
    String toAddress,
  ) async {
    final message = bank.MsgSend.create()
      ..fromAddress = info.publicAddress
      ..toAddress = toAddress;
    message.amount.add(
      alan.Coin.create()
        ..denom = balance.denom
        ..amount = balance.amount.value.toString(),
    );

    final unsignedTransaction = UnsignedAlanTransaction(messages: [message]);

    final walletLookupKey = AccountLookupKey(
      chainId: info.chainId,
      password: '',
      accountId: info.accountId,
    );

    final signedAlanTransaction =
        await transactionSigningGateway.signTransaction(
      transaction: unsignedTransaction,
      accountLookupKey: walletLookupKey,
    );
    await signedAlanTransaction.fold<Future?>(
      (fail) => null,
      (signedTransaction) => transactionSigningGateway.broadcastTransaction(
          accountLookupKey: walletLookupKey, transaction: signedTransaction),
    );
  }
}
