import 'dart:async';
import 'dart:convert';

import 'package:cosmos_utils/credentials_storage_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/model/execution_list_by_recipe_response.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/modules/cosmos.tx.v1beta1/module/client/cosmos/base/abci/v1beta1/abci.pb.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';

import 'mock_constants.dart';
import 'mock_wallet_public_info.dart';

class MockWalletStore implements WalletsStore {
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
  Observable<List<AccountPublicInfo>> getWallets() {
    return Observable([
      const AccountPublicInfo(
          name: 'test',
          publicAddress: 'pylo1e5s74e92q3gunldrpqdnrlc8jg9l3xw6s7hea9',
          chainId: 'pylons-devtestnet',
          accountId: '0')
    ]);
  }

  @override
  Future<Either<Failure, AccountPublicInfo>> importAlanWallet(
      String mnemonic, String userName) {
    // TODO: implement importAlanWallet
    throw UnimplementedError();
  }

  @override
  Future<void> loadWallets() {
    // TODO: implement loadWallets
    throw UnimplementedError();
  }

  @override
  Future<void> sendCosmosMoney(Balance balance, String toAddress) {
    // TODO: implement sendCosmosMoney
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> createRecipe(Map json) async {
    return SdkIpcResponse.success(
        data: MOCK_TRANSACTION.hash, sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> createTrade(Map json) {
    // TODO: implement createTrade
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> executeRecipe(Map json) {
    // TODO: implement executeRecipe
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> fulfillTrade(Map json) {
    // TODO: implement fulfillTrade
    throw UnimplementedError();
  }

  @override
  Future<Cookbook> getCookbookById(String cookbookID) {
    // TODO: implement getCookbookById
    throw UnimplementedError();
  }

  @override
  Future<List<Cookbook>> getCookbooksByCreator(String creator) {
    // TODO: implement getCookbooksByCreator
    throw UnimplementedError();
  }

  @override
  Future<Item> getItem(String cookbookID, String itemID) {
    // TODO: implement getItem
    throw UnimplementedError();
  }

  @override
  Future<List<Item>> getItemsByOwner(String owner) {
    return Completer<List<Item>>().future;
  }

  @override
  Future<Trade?> getTradeByID(Int64 ID) {
    // TODO: implement getTradeByID
    throw UnimplementedError();
  }

  @override
  Future<String> getAccountAddressByName(String username) {
    // TODO: implement getAccountAddressByName
    throw UnimplementedError();
  }

  @override
  Future<String> getAccountNameByAddress(String address) {
    // TODO: implement getAccountNameByAddress
    throw UnimplementedError();
  }

  @override
  Future<List<Execution>> getRecipeExecutions(
      String cookbookID, String recipeID) {
    // TODO: implement getRecipeEexecutions
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> createCookbook(Map json) async {
    return SdkIpcResponse.success(
        data: MOCK_TRANSACTION.hash, sender: '', transaction: '');
  }

  @override
  Future<bool> isAccountExists(String username) {
    // TODO: implement isAccountExists
    throw UnimplementedError();
  }

  @override
  Future<List<Trade>> getTrades(String creator) {
    // TODO: implement getTrades
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> updateRecipe(Map jsonMap) {
    // TODO: implement updateRecipe
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> updateCookbook(Map<dynamic, dynamic> jsonMap) async {
    return SdkIpcResponse.success(
        data: MOCK_TRANSACTION.hash, sender: '', transaction: '');
  }

  @override
  Future<Either<Failure, Recipe>> getRecipe(
      String cookbookID, String recipeID) {
    // TODO: implement getRecipe
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> getProfile() async {
    return SdkIpcResponse.success(
        data: {"username": MOCK_USERNAME}, sender: '', transaction: '');
  }

  @override
  Future<String> signPureMessage(String message) {
    // TODO: implement signPureMessage
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> getAllRecipesByCookbookId(
      {required String cookbookId}) async {
    return SdkIpcResponse.success(data: [], sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> getCookbookByIdForSDK(
      {required String cookbookId}) async {
    return SdkIpcResponse.success(
        data: MOCK_COOKBOOK, sender: '', transaction: '');
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin({String denom = ""}) {
    // TODO: implement getFaucetCoin
    throw UnimplementedError();
  }

  final Observable<bool> isStateUpdated = Observable(false);

  @override
  Observable<bool> getStateUpdatedFlag() {
    return isStateUpdated;
  }

  @override
  void setStateUpdatedFlag({required bool flag}) {
    Timer(const Duration(milliseconds: 2000), () async {
      isStateUpdated.value = flag;
      isStateUpdated.reportChanged();
    });
  }

  @override
  Future<SdkIpcResponse> getRecipeByIdForSDK(
      {required String cookbookId, required String recipeId}) async {
    if (cookbookId != MOCK_COOKBOOK_ID && recipeId != MOCK_RECIPE_ID) {
      throw MOCK_ERROR;
    }

    return SdkIpcResponse.success(
        data: MOCK_RECIPE, sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> getExecutionByRecipeId(
      {required String cookbookId, required String recipeId}) async {
    if (cookbookId != MOCK_COOKBOOK_ID && recipeId != MOCK_RECIPE_ID) {
      throw MOCK_ERROR;
    }

    return SdkIpcResponse.success(
        data: ExecutionListByRecipeResponse.empty(),
        sender: '',
        transaction: '');
  }

  @override
  Future<List<Recipe>> getRecipesByCookbookID(String cookbookID) {
    // TODO: implement getRecipesByCookbookID
    throw UnimplementedError();
  }

  @override
  Future<SdkIpcResponse> getItemByIdForSDK(
      {required String cookBookId, required String itemId}) async {
    if (cookBookId != MOCK_COOKBOOK_ID && itemId != MOCK_ITEM_ID) {
      throw MOCK_ERROR;
    }

    return SdkIpcResponse.success(
        data: jsonEncode(MOCK_ITEM.toProto3Json()),
        sender: '',
        transaction: '');
  }

  @override
  Future<SdkIpcResponse> getItemListByOwner({required String owner}) async {
    if (owner != MOCK_ADDRESS) {
      throw MOCK_ERROR;
    }

    return SdkIpcResponse.success(
        data: jsonEncode([MOCK_ITEM.toProto3Json()]),
        sender: '',
        transaction: '');
  }

  @override
  Future<SdkIpcResponse> getExecutionBasedOnId({required String id}) async {
    if (id != MOCK_EXECUTION_ID) {
      throw MOCK_ERROR;
    }

    return SdkIpcResponse.success(
        data: jsonEncode(MOCK_EXECUTION.toProto3Json()),
        sender: '',
        transaction: '');
  }

  @override
  Future<SdkIpcResponse> getTradesForSDK({required String creator}) async {
    if (creator != MOCK_ADDRESS) {
      throw MOCK_ERROR;
    }

    return SdkIpcResponse.success(data: [], sender: '', transaction: '');
  }

  @override
  Future<Either<Failure, AccountPublicInfo>> importPylonsAccount(
      {required String mnemonic, required String username}) async {
    if (mnemonic != MOCK_MNEMONIC && username != MOCK_USERNAME) {
      throw MOCK_ERROR;
    }

    return Right(MockAccountPublicInfo());
  }

  @override
  Future<bool> deleteAccounts() async {
    return true;
  }

  @override
  Either<Failure, String> getInitialLink() {
    // TODO: implement getInitialLink
    throw UnimplementedError();
  }

  @override
  Either<Failure, bool> saveInitialLink({required String initialLink}) {
    // TODO: implement saveInitialLink
    throw UnimplementedError();
  }

  @override
  Future<TxResponse> getTxs(String txHash) {
    // TODO: implement getTxs
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> sendGoogleInAppPurchaseCoinsRequest(
      GoogleInAppPurchaseModel googleInAppPurchaseModel) {
    // TODO: implement sendGoogleInAppPurchaseCoinsRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> sendAppleInAppPurchaseCoinsRequest(
      AppleInAppPurchaseModel appleInAppPurchaseModel) {
    // TODO: implement sendAppleInAppPurchaseCoinsRequest
    throw UnimplementedError();
  }
}
