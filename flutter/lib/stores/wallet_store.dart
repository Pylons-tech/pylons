import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

abstract class WalletsStore {








  /// This method loads the user stored wallets.
  Future<void> loadWallets();

  /// This method creates uer wallet and broadcast it in the blockchain
  /// Input: [mnemonic] mnemonic for creating user account, [userName] is the user entered nick name
  /// Output: [WalletPublicInfo] contains the address of the wallet
  Future<WalletPublicInfo> importAlanWallet(
    String mnemonic,
    String userName,
  );

  /// This method broadcast the wallet creation message on the blockchain
  /// Input: [AlanPrivateWalletCredentials] credential of the newly created wallet
  /// [creatorAddress] The address of the new wallet
  /// [userName] The name that the user entered
  Future<void> broadcastWalletCreationMessageOnBlockchain(AlanPrivateWalletCredentials creds, String creatorAddress, String userName);

  /// This method creates the custom signing Gateway for the user
  /// Output : [TransactionSigningGateway] custom signing Gateway with custom logic
  TransactionSigningGateway createCustomSigningGateway();

  /// This method sends the money from one address to another
  /// Input : [WalletPublicInfo] contains the info regarding the current network
  /// [balance] the amount that we want to send
  /// [toAddress] the address to which we want to send
  Future<void> sendCosmosMoney(
    WalletPublicInfo info,
    Balance balance,
    String toAddress,
  );

  /// This method creates the cookbook
  /// Input : [Map] containing the info related to the creation of cookbook
  /// Output : [TransactionHash] hash of the transaction
  Future<TransactionHash> createCookBook(Map json);




  Observable<List<WalletPublicInfo>> getWallets();


  Observable<bool> getAreWalletsLoading();
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure();

}
