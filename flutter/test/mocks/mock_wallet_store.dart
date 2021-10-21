import 'package:alan/alan.dart';
import 'package:mobx/src/core.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:transaction_signing_gateway/alan/alan_private_wallet_credentials.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';

import 'mock_constants.dart';

class MockWalletStore implements WalletsStore{
  @override
  Future<void> broadcastWalletCreationMessageOnBlockchain(AlanPrivateWalletCredentials creds, String creatorAddress, String userName) {
    // TODO: implement broadcastWalletCreationMessageOnBlockchain
    throw UnimplementedError();
  }

  @override
  Future<TransactionHash> createCookBook(Map<dynamic, dynamic> json) async {
    return MOCK_TRANSACTION;
  }

  @override
  TransactionSigningGateway createCustomSigningGateway() {
    // TODO: implement createCustomSigningGateway
    throw UnimplementedError();
  }

  @override
  Observable<bool> getAreWalletsLoading() {
    // TODO: implement getAreWalletsLoading
    throw UnimplementedError();
  }

  @override
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure() {
    // TODO: implement getLoadWalletsFailure
    throw UnimplementedError();
  }

  @override
  Observable<List<WalletPublicInfo>> getWallets() {
    // TODO: implement getWallets
    throw UnimplementedError();
  }

  @override
  Future<WalletPublicInfo> importAlanWallet(String mnemonic, String userName) {
    // TODO: implement importAlanWallet
    throw UnimplementedError();
  }

  @override
  Future<void> loadWallets() {
    // TODO: implement loadWallets
    throw UnimplementedError();
  }

  @override
  Future<void> sendCosmosMoney(WalletPublicInfo info, Balance balance, String toAddress
      ) {
    // TODO: implement sendCosmosMoney
    throw UnimplementedError();
  }

}