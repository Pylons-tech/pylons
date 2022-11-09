import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

class AccountProvider {
  AccountProvider({required this.transactionSigningGateway}) {
    accountPublicInfo = null;
  }

  Future<void> loadWallets() async {
    loading = true;
    final walletsResultEither = await transactionSigningGateway.getAccountsList();
    walletsResultEither.fold(
      (fail) => failureMessage = fail.message,
      (newWallets) {
        if (newWallets.isNotEmpty) {
          accountPublicInfo = newWallets.first;
        }
      },
    );

    loading = false;
  }

  bool loading = true;
  AccountPublicInfo? accountPublicInfo;
  TransactionSigningGateway transactionSigningGateway;
  String failureMessage = "";
}
