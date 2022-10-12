import 'package:cosmos_utils/credentials_storage_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/modules/cosmos.tx.v1beta1/module/client/cosmos/base/abci/v1beta1/abci.pb.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

abstract class WalletsStore {
  /// This method loads the user stored wallets.
  Future<void> loadWallets();

  /// This method creates uer wallet and broadcast it in the blockchain
  /// Input: [mnemonic] mnemonic for creating user account, [userName] is the user entered nick name
  /// Output: [WalletPublicInfo] contains the address of the wallet
  Future<Either<Failure, AccountPublicInfo>> importAlanWallet(
    String mnemonic,
    String userName,
  );

  /// This method sends the money from one address to another
  /// Input : [WalletPublicInfo] contains the info regarding the current network
  /// [balance] the amount that we want to send
  /// [toAddress] the address to which we want to send
  Future<void> sendCosmosMoney(
    Balance balance,
    String toAddress,
  );

  /// This method creates the cookbook
  /// Input : [Map] containing the info related to the creation of cookbook
  /// Output : [String] response
  Future<SdkIpcResponse<String>> createCookbook(Map json);

  /// This method is for create recipe
  /// MsgCreateRecipe proto
  /// request fields: { String creator, String cookbookID, String ID, String name, String description, String version, List<CoinInput> coinInputs, List<ItemInput> itemInput, List<EntriesList> entries, List<WeightedOutputs> outputs, Int64 blockInterval}
  /// Input : [Map] containing the info related to the creation of recipe
  /// Output : [TransactionHash] hash of the transaction
  Future<SdkIpcResponse> createRecipe(Map json);

  /// This method is for execute recipe
  /// MsgExecuteRecipe proto
  /// request fields: {String creator, String cookbookID, String recipeID, List<String> itemIDs}
  /// Input : [Map] containing the info related to the execution of recipe
  /// Output : [Execution] of the recipe
  Future<SdkIpcResponse<Execution>> executeRecipe(Map json);

  /// This method is for create Trade
  /// MsgCreateTrade proto
  /// request fields: {String creator, list<CoinInput> coinInputs, List<ItemInputs> itemInputs, List<Coin> coinOutputs, List<ItemRef> itemOutputs, String extraInfo}
  /// Input : [Map] containing the info related to the creation of Trade
  /// Output : [TransactionHash] hash of the transaction
  Future<SdkIpcResponse> createTrade(Map json);

  /// This method is for fulfillTrade
  /// MsgFulfillTrade proto
  /// request fields: {String creator, Int64 ID, List<ItemRef> items, Int64 coinInputIndex ???}
  /// Input : [Map] containing the info related to the fulfillTrade
  /// Output : [TransactionHash] hash of the transaction
  Future<SdkIpcResponse> fulfillTrade(Map json);

  /// This method is for get Transaction info
  /// Input : [txHash] txHash
  /// Output : [TxResponse] Tx response
  Future<TxResponse> getTxs(String txHash);

  /// This method is for get Cookbook info by cookbookID
  /// Input : [cookbookID] cookbookID
  /// Output : [Cookbook?] return Cookbook for cookbookID, return null if not exists
  Future<Cookbook?> getCookbookById(String cookbookID);

  /// This method is for get list of cookbooks
  /// Input : [creator] creator ID
  /// Output : [List<Cookbook>] return list of Cookbooks created by creatorID
  Future<List<Cookbook>> getCookbooksByCreator(String creator);

  /// This method is for get Trade Info
  /// Input : [ID] tradeID
  /// Output : [Trade?] return Trade Info of the tradeID, reutrn null if not exists
  Future<Trade?> getTradeByID(Int64 ID);

  Future<List<Trade>> getTrades(String creator);

  /// This method is for get Recipe Info
  /// Input : [cookbookID, recipeID]
  /// Output : [Recipe] return Recipe of cookbookID, recipeID,
  /// else throws error
  Future<Either<Failure, Recipe>> getRecipe(String cookbookID, String recipeID);

  /// This method is for get Item info of cookbookID, itemID
  /// Input : [cookbookID, itemID]
  /// Output : [Item?] return Item info, return null if not exists
  Future<Item?> getItem(String cookbookID, String itemID);

  /// This method is for get list of Items info by owner
  /// Input : [owner] owner iD
  /// Output : [Item?] return list of Items owned by owner
  Future<List<Item>> getItemsByOwner(String owner);

  /// This method is for get account name from wallet address
  /// Input : [address] target wallet address
  /// Output : [String] return account name of the wallet address
  Future<String> getAccountNameByAddress(String address);

  /// This method is for get wallet address from account name
  /// Input : [username] target account name
  /// Output : [String] return wallet address from account name
  Future<String> getAccountAddressByName(String username);

  Future<List<Execution>> getRecipeExecutions(String cookbookID, String recipeID);

  /// This method is used for giving faucet token to the user based on the current wallet address
  /// Input : [denom] coin denomination
  /// Output : [int] the amount that the user has in its wallet
  Future<Either<Failure, int>> getFaucetCoin({String denom = ""});

  /// check if account with username exists
  /// Input:[String] username
  /// Output" [bool] if exists true, else false
  Future<bool> isAccountExists(String username);

  /// This method updates the recipe in the block chain
  /// Input : [Map] containing the info related to the updation of recipe
  /// Output : [SdkIpcResponse] response
  Future<SdkIpcResponse> updateRecipe(Map<dynamic, dynamic> jsonMap);

  Observable<List<AccountPublicInfo>> getWallets();

  Observable<bool> getAreWalletsLoading();

  Observable<CredentialsStorageFailure?> getLoadWalletsFailure();

  /// This method imports the pylons wallet based on mnemonic
  /// Input : [mnemonic] the mnemonic associated with the account
  /// Output: [WalletPublicInfo] returns the wallet public info about the account
  /// else returns failure
  Future<Either<Failure, AccountPublicInfo>> importPylonsAccount({required String mnemonic});

  /// This method updates the cookbook in the block chain
  /// Input : [Map] containing the info related to the updation of cookbook
  /// Output : [SdkIpcResponse] response
  Future<SdkIpcResponse> updateCookbook(Map<dynamic, dynamic> jsonMap);

  /// This method returns the user profile
  /// Output : [SdkIpcResponse] contains the info related to the profile.
  Future<SdkIpcResponse> getProfile();

  Future<String> signPureMessage(String message);

  /// This method returns the recipes based on cookbook
  /// Input : [cookbookID] id of the cookbook
  /// Output : [SdkIpcResponse] returns the recipes
  Future<List<Recipe>> getRecipesByCookbookID(String cookbookID);

  /// This method returns the recipes based on cookbook
  /// Input : [cookbookId] id of the cookbook
  /// Output : [SdkIpcResponse] returns the recipes
  Future<SdkIpcResponse> getAllRecipesByCookbookId({required String cookbookId});

  /// This method returns the recipes based on cookbook
  /// Input : [cookbookId] id of the cookbook
  /// Output : [SdkIpcResponse] returns the cookbook
  Future<SdkIpcResponse> getCookbookByIdForSDK({required String cookbookId});

  Observable<bool> getStateUpdatedFlag();

  void setStateUpdatedFlag({required bool flag});

  /// This method returns the recipes based on cookbook
  /// Input: [cookbookId] the id of the cookbook that contains recipe, [recipeId] the id of the recipe whose list of execution you want
  /// Output : [SdkIpcResponse] returns the cookbook
  Future<SdkIpcResponse> getExecutionByRecipeId({required String cookbookId, required String recipeId});

  /// This method returns the recipes based on cookbook
  /// Input : [cookbookId] the id of the cookbook which contains the recipe, [recipeId] the id of the recipe
  /// Output : [SdkIpcResponse] returns the recipe with the specified id
  Future<SdkIpcResponse> getRecipeByIdForSDK({required String cookbookId, required String recipeId});

  /// This method returns the Item based on id
  /// Input : [cookBookId] the id of the cookbook which contains the cookbook, [itemId] the id of the item
  /// Output: [SdkIpcResponse] returns the item
  Future<SdkIpcResponse> getItemByIdForSDK({required String cookBookId, required String itemId});

  /// This method returns the list of item based on it
  /// Input : [owner] the id of the owner
  /// Output: [SdkIpcResponse] returns the item list
  Future<SdkIpcResponse> getItemListByOwner({required String owner});

  /// This method returns the execution based on id
  /// Input : [id] the id of the execution
  /// Output: [pylons.Execution] returns execution
  Future<SdkIpcResponse> getExecutionBasedOnId({required String id});

  /// Get all current trades based on the given [creator]
  /// Input : [creator] the id of the creator
  /// Output: [List<pylons.Trade>] returns a list of trades
  Future<SdkIpcResponse> getTradesForSDK({required String creator});

  /// This method will delete the accounts from the device
  /// Output: [bool] if successful will return true else return false
  Future<bool> deleteAccounts();

  /// This method will save link in local cache for future use on home page
  /// Output: [bool] if successful will return true else return false
  Either<Failure, bool> saveInitialLink({required String initialLink});

  /// This method will get link from local cache
  /// Output: [String] if successful will return String
  Either<Failure, String> getInitialLink();

  /// This method will send google in app purchase request to the chain
  /// Input: [GoogleInAppPurchaseModel] contains the input data for the api.
  /// Output: if successful will return the [String] hash of the transaction
  /// else will give failure
  Future<Either<Failure, String>> sendGoogleInAppPurchaseCoinsRequest(GoogleInAppPurchaseModel googleInAppPurchaseModel);

  /// This method will send apple in app purchase request to the chain
  /// Input: [AppleInAppPurchaseModel] contains the input data for the api.
  /// Output: if successful will return the [String] hash of the transaction
  /// else will give failure
  Future<Either<Failure, String>> sendAppleInAppPurchaseCoinsRequest(AppleInAppPurchaseModel appleInAppPurchaseModel);

}
