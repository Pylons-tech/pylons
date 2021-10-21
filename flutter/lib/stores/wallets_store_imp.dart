

import 'package:alan/alan.dart' as alan;
import 'package:cosmos_utils/extensions.dart';
import 'package:cosmos_utils/future_either.dart';
import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/custom_transaction_signer/custom_transaction_signer.dart';
import 'package:pylons_wallet/utils/token_sender.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/wallet_lookup_key.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

class WalletsStoreImp implements WalletsStore {
  final TransactionSigningGateway _transactionSigningGateway;
  final BaseEnv baseEnv;

  WalletsStoreImp(this._transactionSigningGateway, this.baseEnv);



  final Observable<bool> isSendMoneyLoading = Observable(false);
  final Observable<bool> isSendMoneyError = Observable(false);
  final Observable<bool> isBalancesLoading = Observable(false);
  final Observable<bool> isError = Observable(false);

  final Observable<List<Balance>> balancesList = Observable([]);

  final Observable<CredentialsStorageFailure?> loadWalletsFailureObservable = Observable(null);

  Observable<List<WalletPublicInfo>> wallets = Observable([]);


  final Observable<bool> areWalletsLoadingObservable = Observable(false);


  /// This method loads the user stored wallets.
  @override
  Future<void> loadWallets() async {
    areWalletsLoadingObservable.value = true;
    final walletsResultEither = await _transactionSigningGateway.getWalletsList();
    walletsResultEither.fold(
      (fail) => loadWalletsFailureObservable.value = fail,
      (newWallets) => wallets.value = newWallets,
    );
    areWalletsLoadingObservable.value = false;
  }




  /// This method creates uer wallet and broadcast it in the blockchain
  /// Input: [mnemonic] mnemonic for creating user account, [userName] is the user entered nick name
  /// Output: [WalletPublicInfo] contains the address of the wallet
  @override
  Future<WalletPublicInfo> importAlanWallet(
    String mnemonic,
    String userName,
  ) async {
    final wallet = alan.Wallet.derive(mnemonic.split(" "), baseEnv.networkInfo);
    final creds = AlanPrivateWalletCredentials(
      publicInfo: WalletPublicInfo(
        chainId: 'pylons',
        walletId: userName,
        name: userName,
        publicAddress: wallet.bech32Address,
      ),
      mnemonic: mnemonic,
    );


    wallets.value.add(creds.publicInfo);

    await broadcastWalletCreationMessageOnBlockchain(creds, wallet.bech32Address, userName);



    return creds.publicInfo;
  }



  /// This method broadcast the wallet creation message on the blockchain
  /// Input: [AlanPrivateWalletCredentials] credential of the newly created wallet
  /// [creatorAddress] The address of the new wallet
  /// [userName] The name that the user entered
  @override
  Future<void> broadcastWalletCreationMessageOnBlockchain(AlanPrivateWalletCredentials creds, String creatorAddress, String userName) async {
    await _transactionSigningGateway.storeWalletCredentials(
      credentials: creds,
      password: '',
    );

    final info = wallets.value.last;


    final msgObj = pylons.MsgCreateAccount.create()..mergeFromProto3Json({'creator': creatorAddress, 'username': userName});

    final walletLookupKey = WalletLookupKey(
      walletId: info.walletId,
      chainId: info.chainId,
      password: '',
    );

    final unsignedTransaction = UnsignedAlanTransaction(messages: [msgObj]);



    final customSigningGateway = createCustomSigningGateway();



    final result = await customSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey).mapError<dynamic>((error) {

      throw error;
    }).flatMap(
          (signed) => customSigningGateway.broadcastTransaction(
        walletLookupKey: walletLookupKey,
        transaction: signed,
      ),
    );
    print(result);
  }

  /// This method creates the custom signing Gateway for the user
  /// Output : [TransactionSigningGateway] custom signing Gateway with custom logic
  @override
  TransactionSigningGateway createCustomSigningGateway() {
    return  TransactionSigningGateway(
      transactionSummaryUI: NoOpTransactionSummaryUI(),
      signers: [
        CustomTransactionSigner(baseEnv.networkInfo),
      ],
      broadcasters: [
        AlanTransactionBroadcaster(baseEnv.networkInfo),
      ],
      infoStorage: MobileKeyInfoStorage(
        serializers: [AlanCredentialsSerializer()],
      ),
    );
  }




  /// This method sends the money from one address to another
  /// Input : [WalletPublicInfo] contains the info regarding the current network
  /// [balance] the amount that we want to send
  /// [toAddress] the address to which we want to send
  @override
  Future<void> sendCosmosMoney(
    WalletPublicInfo info,
    Balance balance,
    String toAddress,
  ) async {
    isSendMoneyLoading.value = true;
    isSendMoneyError.value = false;
    try {
      await TokenSender(_transactionSigningGateway).sendCosmosMoney(
        info,
        balance,
        toAddress,
      );
    } catch (ex) {
      isError.value = true;
    }
    isSendMoneyLoading.value = false;
  }

  /// This method creates the cookbook
  /// Input : [Map] containing the info related to the creation of cookbook
  /// Output : [TransactionHash] hash of the transaction
  @override
  Future<TransactionHash> createCookBook(Map json) async {
    final msgObj = pylons.MsgCreateCookbook.create()..mergeFromProto3Json(json);

    final unsignedTransaction = UnsignedAlanTransaction(messages: [msgObj]);

    final info = wallets.value.last;

    final walletLookupKey = WalletLookupKey(
      walletId: info.walletId,
      chainId: info.chainId,
      password: '',
    );

    msgObj.creator = info.publicAddress;

    final result = await _transactionSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey).mapError<dynamic>((error) {
      print(error);
      throw error;
    }).flatMap(
      (signed) => _transactionSigningGateway.broadcastTransaction(
        walletLookupKey: walletLookupKey,
        transaction: signed,
      ),
    );

    return result.getOrElse(() => TransactionHash(txHash: ''));
  }

  @override
  Observable<List<WalletPublicInfo>> getWallets() {
    return wallets;
  }

  @override
  Observable<bool> getAreWalletsLoading() {
    return areWalletsLoadingObservable;
  }

  @override
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure() {
    return loadWalletsFailureObservable;
  }
}
