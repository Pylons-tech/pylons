import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cosmos_utils/credentials_storage_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart'
as pylons;
import 'package:pylons_wallet/modules/cosmos.tx.v1beta1/module/client/cosmos/base/abci/v1beta1/abci.pb.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/stores/wallet_store_imp.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';


/// [WalletsStore] implementation that wraps a [WalletsStoreImp] instance, but injects mocked data into the responses
/// to queries relating to on-chain objects. Should never, ever be seen in production.
/// TODO: the json really shouldn't be hardcoded
class WalletsStoreDummyInventory extends WalletsStore {
  final WalletsStoreImp _baseInstance;
  WalletsStoreDummyInventory(this._baseInstance);

  static const String _ownedSelf = "OWNED_SELF";

  static final List<pylons.Cookbook> _mockedCookbooksDefault = [
    pylons.Cookbook(id: "Easel_CookBook_auto_cookbook_2022_01_20_200756_163",
        name:  "",
        creator: _ownedSelf,
        description: "",
        developer: "",
        supportEmail: "",
        version: "",
        enabled: true)
  ];

  static late List<pylons.Cookbook> _mockedCookbooks;

  static const List<pylons.Execution> _mockedExecutionsDefault = [

  ];

  static late List<pylons.Execution> _mockedExecutions;

  static const List<String> _mockedRecipesDefault = [
    '''
    {
       "cookbookID":"Easel_CookBook_auto_cookbook_2022_01_20_200756_163",
       "ID":"Easel_Recipe_auto_recipe_2022_01_20_200820_040",
       "name":"Babajajsksnjejej",
       "description":"Nannajsjskdkdkdkrjrjbsbsbbsbs",
       "version":"v0.1.0",
       "coinInputs":[
          {
             "coins":[
                {
                   "denom":"upylon",
                   "amount":"1000000"
                }
             ]
          }
       ],
       "entries":{
          "itemOutputs":[
             {
                "ID":"Easel_NFT",
                "doubles":[
                   {
                      "key":"Residual",
                      "weightRanges":[
                         {
                            "lower":"0",
                            "upper":"0",
                            "weight":1
                         }
                      ]
                   }
                ],
                "longs":[
                   {
                      "key":"Quantity",
                      "weightRanges":[
                         {
                            "lower":1,
                            "upper":1,
                            "weight":1
                         }
                      ]
                   },
                   {
                      "key":"Width",
                      "weightRanges":[
                         {
                            "lower":720,
                            "upper":720,
                            "weight":1
                         }
                      ]
                   },
                   {
                      "key":"Height",
                      "weightRanges":[
                         {
                            "lower":1280,
                            "upper":1280,
                            "weight":1
                         }
                      ]
                   }
                ],
                "strings":[
                   {
                      "key":"Name",
                      "value":"Babajajsksnjejej"
                   },
                   {
                      "key":"App_Type",
                      "value":"Easel"
                   },
                   {
                      "key":"Description",
                      "value":"Nannajsjskdkdkdkrjrjbsbsbbsbs"
                   },
                   {
                      "key":"NFT_URL",
                      "value":"https://ipfs.io/ipfs/bafkreiahbnmfa6ukihwragzjpnuukvodfipq3wukmtheec423mzvqwhxhq"
                   },
                   {
                      "key":"Creator",
                      "value":"Tescokksjjs"
                   }
                ],
                "transferFee":[
                   {
                      "denom":"upylon",
                      "amount":"1"
                   }
                ],
                "tradePercentage":"0",
                "quantity":"1",
                "amountMinted":"0",
                "tradeable":true
             }
          ]
       },
       "outputs":[
          {
             "entryIDs":[
                "Easel_NFT"
             ],
             "weight":1
          }
       ],
       "blockInterval":0,
       "costPerBlock":{
          "denom":"upylon",
          "amount":"0"
       },
       "enabled":true,
       "extraInfo":"extraInfo"
    }
    '''
  ];

  static late List<pylons.Recipe> _mockedRecipes;

  static final List<pylons.Item> _mockedItemsDefault = [
    pylons.Item(
      id: "",
      owner: _ownedSelf,
      doubles: [
        pylons.DoubleKeyValue(
          key: 'Residual',
          value: '0'
        )
      ],
      longs: [
        pylons.LongKeyValue(
          key: 'Quantity',
          value : Int64()
        ),
        pylons.LongKeyValue(
            key: 'Height',
            value : Int64(1080)
        ),
        pylons.LongKeyValue(
            key: 'Width',
            value : Int64(720)
        )
      ],
      strings: [
        pylons.StringKeyValue(
          key: 'Name',
          value: 'Dummy item'
        ),
        pylons.StringKeyValue(
          key: 'Description',
          value: 'Instantiated item dummy value'
        ),
        pylons.StringKeyValue(
          key: 'App_Type',
          value: 'Easel'
        ),
        pylons.StringKeyValue(
          key: 'NFT_URL',
          value: 'https://ipfs.io/ipfs/bafkreiahbnmfa6ukihwragzjpnuukvodfipq3wukmtheec423mzvqwhxhq'
        ),
        pylons.StringKeyValue(
          key: 'Creator',
          value: 'Dummy'
        )
      ]
    )
  ];

  static late List<pylons.Item> _mockedItems;

  static late List<pylons.Trade> _mockedTrades;
  static const List<pylons.Trade> _mockedTradesDefault = [

  ];

  /// Wraps the current WalletsStoreImp instance with a WalletsStoreDummyInventory instance
  static Future<void> dummyInventory () async {
    if (!kDebugMode) throw Exception('WalletStoreDummyInventory.dummyInventory() was called in a production build! This should never happen!');
    final WalletsStore walletsStore = GetIt.I.get();
    final prf = await walletsStore.getProfile();
    final addr = await walletsStore.getAccountAddressByName(prf.data["username"] as String);

    if (walletsStore is WalletsStoreImp) {
      final WalletsStoreDummyInventory dummy = WalletsStoreDummyInventory(walletsStore);
      GetIt.I.allowReassignment = true;
      GetIt.I.registerSingleton<WalletsStore>(dummy);
      GetIt.I.allowReassignment = false;
    }
    else if (walletsStore is! WalletsStoreDummyInventory) {
      throw Exception("Can't wrap a wallet store of type other than WalletsStoreImp");
    }
    else {
      log('tried to wrap wallet store w/ dummy inventory, but wallet store was already wrapped');
    }
    _mockedCookbooks = _mockedCookbooksDefault;
    for (var i = 0; i < _mockedCookbooks.length; i++) {
      if (_mockedCookbooks[i].creator == _ownedSelf) {
        _mockedCookbooks[i].creator = addr;
      }
    }
    _mockedExecutions = _mockedExecutionsDefault;
    for (var i = 0; i < _mockedExecutions.length; i++) {
      if (_mockedExecutions[i].creator == _ownedSelf) {
        _mockedExecutions[i].creator = addr;
      }
    }
    _mockedRecipes = List<pylons.Recipe>.empty(growable: true);
    for (var i = 0; i < _mockedRecipesDefault.length; i++) {
      _mockedRecipes.add(pylons.Recipe.create()..mergeFromProto3Json(json.decode(_mockedRecipesDefault[i])));
    }
    _mockedItems = _mockedItemsDefault;
    for (var i = 0; i < _mockedItems.length; i++) {
      if (_mockedItems[i].owner == _ownedSelf) {
        _mockedItems[i].owner = addr;
      }
    }
    _mockedTrades = _mockedTradesDefault;
    for (var i = 0; i < _mockedTrades.length; i++) {
      if (_mockedTrades[i].creator == _ownedSelf) {
        _mockedTrades[i].creator = addr;
      }
    }

  }



  @override
  Future<SdkIpcResponse> createCookbook(Map json) {
    return _baseInstance.createCookbook(json);
  }

  @override
  Future<SdkIpcResponse> createRecipe(Map json) {
    return _baseInstance.createRecipe(json);
  }

  @override
  Future<SdkIpcResponse> createTrade(Map json) {
    return _baseInstance.createTrade(json);
  }

  @override
  Future<SdkIpcResponse> executeRecipe(Map json) {
    return _baseInstance.executeRecipe(json);
  }

  @override
  Future<SdkIpcResponse> fulfillTrade(Map json) {
    return _baseInstance.fulfillTrade(json);
  }

  @override
  Future<String> getAccountAddressByName(String username) {
    return _baseInstance.getAccountAddressByName(username);
  }

  @override
  Future<String> getAccountNameByAddress(String address) {
    return _baseInstance.getAccountNameByAddress(address);
  }

  @override
  Future<SdkIpcResponse> getAllRecipesByCookbookId({required String cookbookId}) {
    return _baseInstance.getAllRecipesByCookbookId(cookbookId: cookbookId);
  }

  @override
  Observable<bool> getAreWalletsLoading() {
    return _baseInstance.getAreWalletsLoading();
  }

  @override
  Future<pylons.Cookbook?> getCookbookById(String cookbookID) async {
    for (int i = 0; i < _mockedCookbooks.length; i ++) {
      if (_mockedCookbooks[i].id == cookbookID) return _mockedCookbooks[i];
    }
    return _baseInstance.getCookbookById(cookbookID);
  }

  @override
  Future<SdkIpcResponse> getCookbookByIdForSDK({required String cookbookId}) {
    return _baseInstance.getCookbookByIdForSDK(cookbookId: cookbookId);
  }

  @override
  Future<List<pylons.Cookbook>> getCookbooksByCreator(String creator) async {
    return await _baseInstance.getCookbooksByCreator(creator) + _mockedCookbooks.where((element) => element.creator == creator).toList();
  }

  @override
  Future<SdkIpcResponse> getExecutionBasedOnId({required String id}) {
    return _baseInstance.getExecutionBasedOnId(id: id);
  }

  @override
  Future<SdkIpcResponse> getExecutionByRecipeId({required String cookbookId, required String recipeId}) {
    return _baseInstance.getExecutionByRecipeId(cookbookId: cookbookId, recipeId: recipeId);
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin({String denom = ""}) {
    return _baseInstance.getFaucetCoin();
  }

  @override
  Future<pylons.Item?> getItem(String cookbookID, String itemID) async {
    for (var i = 0; i < _mockedItems.length; i++) {
      if (_mockedItems[i].id == itemID && _mockedItems[i].cookbookId == cookbookID) {
        return _mockedItems[i];
      }
    }
    return _baseInstance.getItem(cookbookID, itemID);
  }

  @override
  Future<SdkIpcResponse> getItemByIdForSDK({required String cookBookId, required String itemId}) {
    return _baseInstance.getItemByIdForSDK(cookBookId: cookBookId, itemId: itemId);
  }



  @override
  Future<SdkIpcResponse> getItemListByOwner({required String owner}){
    return _baseInstance.getItemListByOwner(owner: owner);
  }

  @override
  Future<List<pylons.Item>> getItemsByOwner(String owner) async {
    return await _baseInstance.getItemsByOwner(owner) + _mockedItems.where((element) => element.owner == owner).toList();
  }

  @override
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure() {
    return _baseInstance.getLoadWalletsFailure();
  }

  @override
  Future<SdkIpcResponse> getProfile() {
    return _baseInstance.getProfile();
  }

  @override
  Future<Either<Failure, pylons.Recipe>> getRecipe(String cookbookID, String recipeID) async {
    for (var i = 0; i < _mockedRecipes.length; i++) {
      if (_mockedRecipes[i].id == recipeID && _mockedRecipes[i].cookbookId == cookbookID) {
        return Right(_mockedRecipes[i]);
      }
    }
    return _baseInstance.getRecipe(cookbookID, recipeID);
  }

  @override
  Future<SdkIpcResponse> getRecipeByIdForSDK({required String cookbookId, required String recipeId}) {
    return _baseInstance.getRecipeByIdForSDK(cookbookId: cookbookId, recipeId: recipeId);
  }

  @override
  Future<List<pylons.Execution>> getRecipeExecutions(String cookbookID, String recipeID) async {
    return await _baseInstance.getRecipeExecutions(cookbookID, recipeID) + _mockedExecutions.where((element) => element.recipeId == recipeID && element.cookbookId == cookbookID).toList();
  }


  @override
  Future<List<pylons.Recipe>> getRecipesByCookbookID(String cookbookID) async {
    return await _baseInstance.getRecipesByCookbookID(cookbookID) + _mockedRecipes.where((element) => element.cookbookId == cookbookID).toList();
  }

  @override
  Observable<bool> getStateUpdatedFlag() {
    return _baseInstance.getStateUpdatedFlag();
  }

  @override
  Future<pylons.Trade?> getTradeByID(Int64 ID) async {
    for (var i = 0; i < _mockedTrades.length; i++) {
      if (_mockedTrades[i].id == ID) return _mockedTrades[i];
    }
    return _baseInstance.getTradeByID(ID);
  }

  @override
  Future<List<pylons.Trade>> getTrades(String creator) async {
    return await _baseInstance.getTrades(creator) + _mockedTrades.where((element) => element.creator == creator).toList();
  }

  @override
  Future<SdkIpcResponse> getTradesForSDK({required String creator}) {
    return _baseInstance.getTradesForSDK(creator: creator);
  }

  @override
  Future<TxResponse> getTxs(String txHash) {
    return _baseInstance.getTxs(txHash);
  }

  @override
  Observable<List<AccountPublicInfo>> getWallets() {
    return _baseInstance.getWallets();
  }

  @override
  Future<Either<Failure, AccountPublicInfo>> importAlanWallet(String mnemonic, String userName) {
    return _baseInstance.importAlanWallet(mnemonic, userName);
  }

  @override
  Future<Either<Failure, AccountPublicInfo>> importPylonsAccount({required String mnemonic, required String username}) {
    return _baseInstance.importPylonsAccount(mnemonic: mnemonic, username: username);
  }

  @override
  Future<bool> isAccountExists(String username) {
    return _baseInstance.isAccountExists(username);
  }

  @override
  Future<void> loadWallets() {
    return _baseInstance.loadWallets();
  }

  @override
  Future<void> sendCosmosMoney(Balance balance, String toAddress) {
    return _baseInstance.sendCosmosMoney(balance, toAddress);
  }

  @override
  void setStateUpdatedFlag({required bool flag}) {
    return _baseInstance.setStateUpdatedFlag(flag: flag);
  }

  @override
  Future<String> signPureMessage(String message) {
    return _baseInstance.signPureMessage(message);
  }

  @override
  Future<SdkIpcResponse> updateCookbook(Map jsonMap) {
    return _baseInstance.updateCookbook(jsonMap);
  }

  @override
  Future<SdkIpcResponse> updateRecipe(Map jsonMap) {
    return _baseInstance.updateRecipe(jsonMap);
  }


  @override
  Future<bool> deleteAccounts() {
    return _baseInstance.deleteAccounts();
  }

  @override
  Either<Failure, bool> saveInitialLink({required String initialLink}) {
  return  _baseInstance.saveInitialLink(initialLink: initialLink);
  }

  @override
  Either<Failure, String> getInitialLink() {
    return  _baseInstance.getInitialLink();

  }

  @override
  Future<Either<Failure, String>> sendGoogleInAppPurchaseCoinsRequest(GoogleInAppPurchaseModel googleInAppPurchaseModel) {
    // TODO: implement sendGoogleInAppPurchaseCoinsRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> sendAppleInAppPurchaseCoinsRequest(AppleInAppPurchaseModel appleInAppPurchaseModel) {
    // TODO: implement sendAppleInAppPurchaseCoinsRequest
    throw UnimplementedError();
  }


}
