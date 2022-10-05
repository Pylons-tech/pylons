import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:alan/alan.dart' as alan;
import 'package:cosmos_utils/credentials_storage_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:protobuf/protobuf.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_profile_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/model/wallet_creation_model.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/modules/cosmos.tx.v1beta1/module/client/cosmos/base/abci/v1beta1/abci.pb.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/crashlytics_helper.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/services/third_party_services/remote_notifications_service.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/custom_transaction_signing_gateaway/custom_transaction_signing_gateway.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/token_sender.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

class WalletsStoreImp implements WalletsStore {
  final Repository repository;
  final CrashlyticsHelper crashlyticsHelper;

  WalletsStoreImp({required this.repository, required this.crashlyticsHelper});

  final Observable<bool> isSendMoneyLoading = Observable(false);
  final Observable<bool> isSendMoneyError = Observable(false);
  final Observable<bool> isBalancesLoading = Observable(false);
  final Observable<bool> isError = Observable(false);

  final Observable<bool> isStateUpdated = Observable(false);

  final Observable<List<Balance>> balancesList = Observable([]);

  final Observable<CredentialsStorageFailure?> loadWalletsFailureObservable = Observable(null);

  Observable<List<AccountPublicInfo>> wallets = Observable([]);

  final Observable<bool> areWalletsLoadingObservable = Observable(false);

  /// This method loads the user stored wallets.
  @override
  Future<void> loadWallets() async {
    final transactionSigningGateway = getTransactionSigningGateway();

    areWalletsLoadingObservable.value = true;
    final walletsResultEither = await transactionSigningGateway.getAccountsList();
    walletsResultEither.fold(
      (fail) => loadWalletsFailureObservable.value = fail,
      (newWallets) => wallets.value = newWallets,
    );

    areWalletsLoadingObservable.value = false;
  }

  /// This method creates user wallet and broadcast it in the blockchain
  /// Input: [mnemonic] mnemonic for creating user account, [userName] is the user entered nick name
  /// Output: [WalletPublicInfo] contains the address of the wallet
  @override
  Future<Either<Failure, AccountPublicInfo>> importAlanWallet(
    String mnemonic,
    String userName,
  ) async {
    final baseEnv = getBaseEnv();
    var wallet = alan.Wallet.derive(mnemonic.split(" "), baseEnv.networkInfo);

    wallet = alan.Wallet.convert(wallet, baseEnv.networkInfo);
    final creds = AlanPrivateAccountCredentials(
      publicInfo: AccountPublicInfo(
        chainId: baseEnv.chainId,
        name: userName,
        publicAddress: wallet.bech32Address,
        accountId: userName,
      ),
      mnemonic: mnemonic,
    );

    final response = await broadcastWalletCreationMessageOnBlockchain(WalletCreationModel(
      creatorAddress: wallet.bech32Address,
      userName: userName,
      creds: creds,
    ));

    if (!response.success) {
      crashlyticsHelper.recordFatalError(error: response.error);
      return Left(WalletCreationFailure("wallet_creation_failed".tr()));
    }

    wallets.value.add(creds.publicInfo);
    await repository.saveMnemonic(mnemonic);
    final String token = await getRemoteNotificationServiceToken();
    await repository.updateFcmToken(address: creds.publicInfo.publicAddress, fcmToken: token);
    await repository.setUserIdentifierInAnalytics(address: creds.publicInfo.publicAddress);
    crashlyticsHelper.setUserIdentifier(identifier: creds.publicInfo.publicAddress);
    return Right(creds.publicInfo);
  }

  /// This method broadcast the wallet creation message on the blockchain
  /// Input: [AlanPrivateWalletCredentials] credential of the newly created wallet
  /// [creatorAddress] The address of the new wallet
  /// [userName] The name that the user entered

  Future<SdkIpcResponse> broadcastWalletCreationMessageOnBlockchain(WalletCreationModel walletCreationModel) async {
    final customTransactionSigningGateway = getCustomTransactionSigningGateway();

    try {
      await customTransactionSigningGateway.storeAccountCredentials(
        credentials: walletCreationModel.creds,
        password: '',
      );

      final info = walletCreationModel.creds.publicInfo;

      final result = await repository.createAccount(walletCreationModel: walletCreationModel, publicInfo: info);

      if (result.isLeft()) {
        await deleteAccountCredentials(customTransactionSigningGateway, info);
        return SdkIpcResponse.failure(sender: '', error: result.swap().toOption().toNullable().toString(), errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG);
      }

      return SdkIpcResponse.success(sender: '', data: result.getOrElse(() => TransactionResponse.initial()).hash, transaction: '');
    } catch (error) {
      await deleteAccountCredentials(customTransactionSigningGateway, walletCreationModel.creds.publicInfo);
      log(error.toString());
      crashlyticsHelper.recordFatalError(error: error.toString());
    }
    return SdkIpcResponse.failure(sender: '', error: "account_creation_failed".tr(), errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG);
  }

  Future<Either<CredentialsStorageFailure, Unit>> deleteAccountCredentials(CustomTransactionSigningGateway customTransactionSigningGateway, AccountPublicInfo info) {
    return customTransactionSigningGateway.deleteAccountCredentials(
      info: info,
    );
  }

  /// This method sends the money from one address to another
  /// Input : [WalletPublicInfo] contains the info regarding the current network
  /// [balance] the amount that we want to send
  /// [toAddress] the address to which we want to send
  @override
  Future<void> sendCosmosMoney(
    Balance balance,
    String toAddress,
  ) async {
    isSendMoneyLoading.value = true;
    isSendMoneyError.value = false;
    final transactionSigningGateway = getTransactionSigningGateway();
    try {
      await TokenSender(transactionSigningGateway).sendCosmosMoney(
        wallets.value.last,
        balance,
        toAddress,
      );
    } catch (ex) {
      isError.value = true;
    }
    isSendMoneyLoading.value = false;
  }

  @override
  Future<String> signPureMessage(String message) async {
    final baseEnv = getBaseEnv();
    final customTransactionSigningGateway = getCustomTransactionSigningGateway();
    final walletsResultEither = await customTransactionSigningGateway.getWalletsList();
    final accountsList = walletsResultEither.getOrElse(() => []);

    final info = accountsList.last;
    final walletLookupKey = createWalletLookUp(info);
    return customTransactionSigningGateway.signPureMessage(networkInfo: baseEnv.networkInfo, walletLookupKey: walletLookupKey, msg: message);
  }

  Future<SdkIpcResponse> _signAndBroadcast(GeneratedMessage message) async {
    final transactionSigningGateway = getTransactionSigningGateway();
    final customTransactionSigningGateway = getCustomTransactionSigningGateway();
    final unsignedTransaction = UnsignedAlanTransaction(messages: [message]);

    final walletsResultEither = await customTransactionSigningGateway.getWalletsList();

    if (walletsResultEither.isLeft()) {
      crashlyticsHelper.recordFatalError(error: walletsResultEither.swap().toOption().toNullable()!.message);
      return SdkIpcResponse.failure(sender: '', error: SOMETHING_WRONG_FETCHING_WALLETS, errorCode: HandlerFactory.ERR_FETCHING_WALLETS);
    }

    final accountsList = walletsResultEither.getOrElse(() => []);
    if (accountsList.isEmpty) {
      return SdkIpcResponse.failure(sender: '', error: "no_profile_found".tr(), errorCode: HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST);
    }
    final info = accountsList.last;
    final walletLookupKey = createWalletLookUp(info);

    final signedTransaction = await transactionSigningGateway.signTransaction(transaction: unsignedTransaction, accountLookupKey: walletLookupKey);

    if (signedTransaction.isLeft()) {
      crashlyticsHelper.recordFatalError(error: signedTransaction.swap().toOption().toNullable()!.toString());
      return SdkIpcResponse.failure(sender: '', error: 'something_wrong_signing_transaction'.tr(), errorCode: HandlerFactory.ERR_SIG_TRANSACTION);
    }

    final response = await customTransactionSigningGateway.broadcastTransaction(
      walletLookupKey: walletLookupKey,
      transaction: signedTransaction.toOption().toNullable()!,
    );

    if (response.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: response.swap().toOption().toNullable().toString(), errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG);
    }

    return SdkIpcResponse.success(sender: '', data: response.getOrElse(() => TransactionResponse.initial()).hash, transaction: '');
  }

  AccountLookupKey createWalletLookUp(AccountPublicInfo info) {
    final walletLookupKey = AccountLookupKey(
      chainId: info.chainId,
      password: '',
      accountId: info.accountId,
    );
    return walletLookupKey;
  }

  /// This method creates the cookbook
  /// Input : [Map] containing the info related to the creation of cookbook
  /// Output : [TransactionHash] hash of the transaction
  @override
  Future<SdkIpcResponse<String>> createCookbook(Map json) async {
    final msgObj = pylons.MsgCreateCookbook.create()..mergeFromProto3Json(json);
    msgObj.creator = wallets.value.last.publicAddress;
    final sdkResponse = await _signAndBroadcast(msgObj);
    if (!sdkResponse.success) {
      return SdkIpcResponse.failure(error: sdkResponse.error, sender: sdkResponse.sender, errorCode: sdkResponse.errorCode);
    }

    final cookBookResponseEither = await repository.getCookbookBasedOnId(cookBookId: json["id"].toString());

    if (cookBookResponseEither.isLeft()) {
      return SdkIpcResponse.failure(error: sdkResponse.error, sender: sdkResponse.sender, errorCode: sdkResponse.errorCode);
    }

    return SdkIpcResponse.success(data: jsonEncode(cookBookResponseEither.toOption().toNullable()!.toProto3Json()), sender: sdkResponse.sender, transaction: sdkResponse.data.toString());
  }

  @override
  Observable<List<AccountPublicInfo>> getWallets() {
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

  @override
  Future<SdkIpcResponse> createRecipe(Map json) async {
    final msgObj = pylons.MsgCreateRecipe.create()..mergeFromProto3Json(json);
    msgObj.creator = wallets.value.last.publicAddress;
    final sdkResponse = await _signAndBroadcast(msgObj);
    if (!sdkResponse.success) {
      return SdkIpcResponse.failure(error: sdkResponse.error, sender: sdkResponse.sender, errorCode: sdkResponse.errorCode);
    }

    final recipeResponseEither = await repository.getRecipe(recipeId: json["id"].toString(), cookBookId: json["cookbookId"].toString());

    if (recipeResponseEither.isLeft()) {
      return SdkIpcResponse.failure(error: sdkResponse.error, sender: sdkResponse.sender, errorCode: sdkResponse.errorCode);
    }

    return SdkIpcResponse.success(data: jsonEncode(recipeResponseEither.toOption().toNullable()!.toProto3Json()), sender: sdkResponse.sender, transaction: sdkResponse.data.toString());
  }

  LocalTransactionModel createInitialLocalTransactionModel({
    required TransactionTypeEnum transactionTypeEnum,
    required String transactionData,
    required String transactionCurrency,
    required String transactionPrice,
    required String transactionDescription,
  }) {
    final LocalTransactionModel txManager = LocalTransactionModel(
        transactionType: transactionTypeEnum.name,
        transactionData: transactionData,
        transactionCurrency: transactionCurrency,
        transactionPrice: transactionPrice,
        transactionDescription: transactionDescription,
        transactionHash: "",
        dateTime: DateTime.now().millisecondsSinceEpoch,
        status: TransactionStatus.Undefined.name);
    return txManager;
  }

  @override
  Future<SdkIpcResponse> createTrade(Map json) async {
    final msgObj = pylons.MsgCreateTrade.create()..mergeFromProto3Json(json);
    msgObj.creator = wallets.value.last.publicAddress;
    return _signAndBroadcast(msgObj);
  }

  Future<void> saveTransactionRecord({required String transactionHash, required TransactionStatus transactionStatus, required LocalTransactionModel txLocalModel}) async {
    final txLocalModelWithStatus = LocalTransactionModel.fromStatus(transactionHash: transactionHash, status: transactionStatus, transactionModel: txLocalModel);
    repository.saveLocalTransaction(txLocalModelWithStatus);
  }

  @override
  Future<SdkIpcResponse<Execution>> executeRecipe(Map json) async {
  
    final networkInfo = GetIt.I.get<NetworkInfo>();

    final LocalTransactionModel localTransactionModel = createInitialLocalTransactionModel(
      transactionTypeEnum: TransactionTypeEnum.BuyNFT,
      transactionData: jsonEncode(json),
      transactionDescription: "${'bought_nft'.tr()}  ${json[kNftName] ?? ""}",
      transactionCurrency: "${json[kNftCurrency] ?? ""}",
      transactionPrice: "${json[kNftPrice] ?? ""}",
    );

    if (!await networkInfo.isConnected) {
      await saveTransactionRecord(transactionHash: "" , transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return SdkIpcResponse.failure(sender: '', error: "no_internet".tr(), errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG);
    }

    json.remove(kNftName);
    json.remove(kNftCurrency);
    json.remove(kNftPrice);
    
    final msgObj = pylons.MsgExecuteRecipe.create()..mergeFromProto3Json(json);
    msgObj.creator = wallets.value.last.publicAddress;
    final sdkResponse = await _signAndBroadcast(msgObj);
    if (!sdkResponse.success) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return SdkIpcResponse.failure(error: sdkResponse.error, sender: sdkResponse.sender, errorCode: sdkResponse.errorCode);
    }

    final executionEither = await repository.getExecutionsByRecipeId(recipeId: json["recipeId"].toString(), cookBookId: json["cookbookId"].toString());

    if (executionEither.isLeft()) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return SdkIpcResponse.failure(error: sdkResponse.error, sender: sdkResponse.sender, errorCode: sdkResponse.errorCode);
    }

    if (executionEither.toOption().toNullable()!.completedExecutions.isEmpty) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return SdkIpcResponse.failure(error: sdkResponse.error, sender: sdkResponse.sender, errorCode: sdkResponse.errorCode);
    }

    await saveTransactionRecord(transactionHash: sdkResponse.data.toString(), transactionStatus: TransactionStatus.Success, txLocalModel: localTransactionModel);
    return SdkIpcResponse.success(
        data: executionEither.toOption().toNullable()!.completedExecutions.last, sender: sdkResponse.sender, transaction: sdkResponse.data.toString());
  }

  @override
  Future<SdkIpcResponse> fulfillTrade(Map json) async {
    final msgObj = pylons.MsgFulfillTrade.create()..mergeFromProto3Json(json);
    msgObj.creator = wallets.value.last.publicAddress;
    final response = await _signAndBroadcast(msgObj);
    return response;
  }

  @override
  Future<Cookbook?> getCookbookById(String cookbookID) async {
    final recipesEither = await repository.getCookbookBasedOnId(cookBookId: cookbookID);
    return recipesEither.toOption().toNullable();
  }

  @override
  Future<List<Cookbook>> getCookbooksByCreator(String creator) async {
    final response = await repository.getCookbooksByCreator(creator: creator);

    return response.getOrElse(() => []);
  }

  @override
  Future<Item?> getItem(String cookbookID, String itemID) async {
    final response = await repository.getItem(cookBookId: cookbookID, itemId: itemID);

    if (response.isLeft()) {
      return null;
    }

    return response.toOption().toNullable();
  }

  @override
  Future<List<Item>> getItemsByOwner(String owner) async {
    final response = await repository.getListItemByOwner(owner: owner);
    return response.getOrElse(() => []);
  }

  @override
  Future<Either<Failure, pylons.Recipe>> getRecipe(String cookbookID, String recipeID) async {
    return repository.getRecipe(cookBookId: cookbookID, recipeId: recipeID);
  }

  @override
  Future<Trade?> getTradeByID(Int64 ID) async {
    final response = await repository.getTradeByID(ID);

    return response.toOption().toNullable();
  }

  @override
  Future<List<Trade>> getTrades(String creator) async {
    final response = await repository.getTradesBasedOnCreator(creator: creator);
    return response.getOrElse(() => []);
  }

  @override
  Future<TxResponse> getTxs(String txHash) async {
    return TxResponse.create();
  }

  @override
  Future<String> getAccountAddressByName(String username) async {
    final response = await repository.getAddressBasedOnUsername(username);
    return response.getOrElse(() => "");
  }

  @override
  Future<String> getAccountNameByAddress(String address) async {
    final response = await repository.getUsername(address: address);
    return response.getOrElse(() => "");
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin({String? denom}) async {
    return repository.getFaucetCoin(address: wallets.value.last.publicAddress, denom: denom);
  }

  @override
  Future<bool> isAccountExists(String username) async {
    final accountExistResult = await repository.getAddressBasedOnUsername(username);

    return accountExistResult.fold((failure) {
      return false;
    }, (value) {
      return value.isNotEmpty;
    });
  }

  @override
  Future<List<Execution>> getRecipeExecutions(String cookbookID, String recipeID) async {
    final response = await repository.getExecutionsByRecipeId(cookBookId: cookbookID, recipeId: recipeID);

    if (response.isLeft()) {
      return [];
    }

    return response.toOption().toNullable()!.completedExecutions;
  }

  @override
  Future<SdkIpcResponse> updateRecipe(Map jsonMap) async {
    final msgObj = pylons.MsgUpdateRecipe.create()..mergeFromProto3Json(jsonMap);
    msgObj.creator = wallets.value.last.publicAddress;
    return _signAndBroadcast(msgObj);
  }

  @override
  Future<SdkIpcResponse> getProfile() async {
    if (wallets.value.isEmpty) {
      return SdkIpcResponse.failure(sender: '', error: 'create_profile_before_using'.tr(), errorCode: HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST);
    }

    final publicAddress = wallets.value.last.publicAddress;

    final userNameEither = await repository.getUsername(address: publicAddress);

    if (userNameEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: userNameEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_USERNAME);
    }

    final stripeExistsInfoEither = repository.getStripeAccountExistsFromLocal();

    if (stripeExistsInfoEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: stripeExistsInfoEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_USERNAME);
    }

    final balanceResponseEither = await repository.getBalance(publicAddress);

    if (balanceResponseEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: balanceResponseEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_USERNAME);
    }

    final getItemListEither = await repository.getListItemByOwner(owner: publicAddress);

    if (getItemListEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: getItemListEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_ITEM);
    }

    final balancesList = balanceResponseEither.toOption().toNullable()!;

    final itemsList = getItemListEither.toOption().toNullable()!;

    final profileModel = Profile(
      stripeExists: stripeExistsInfoEither.getOrElse(() => false),
      username: userNameEither.getOrElse(() => ''),
      address: publicAddress,
      coins: balancesList,
      items: itemsList,
      supportedCoins: IBCCoins.values.map((e) {
        if (e == IBCCoins.weth_wei) {
          return kEthereumSymbol;
        }
        return e.name;
      }).toList(),
    );

    return SdkIpcResponse.success(data: jsonEncode(profileModel), sender: '', transaction: '');
  }

  @override
  Future<List<Recipe>> getRecipesByCookbookID(String cookbookID) async {
    final response = await repository.getRecipesBasedOnCookBookId(cookBookId: cookbookID);
    return response.getOrElse(() => []);
  }

  @override
  Future<SdkIpcResponse> getAllRecipesByCookbookId({required String cookbookId}) async {
    final recipesEither = await repository.getRecipesBasedOnCookBookId(cookBookId: cookbookId);

    if (recipesEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: recipesEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_RECIPES);
    }

    return SdkIpcResponse.success(data: recipesEither.getOrElse(() => []).map((recipe) => recipe.toProto3Json()).toList(), sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> updateCookbook(Map<dynamic, dynamic> jsonMap) async {
    final msgObj = pylons.MsgUpdateCookbook.create()..mergeFromProto3Json(jsonMap);
    msgObj.creator = wallets.value.last.publicAddress;
    return _signAndBroadcast(msgObj);
  }

  @override
  Future<SdkIpcResponse> getCookbookByIdForSDK({required String cookbookId}) async {
    final cookBookEither = await repository.getCookbookBasedOnId(cookBookId: cookbookId);

    if (cookBookEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: cookBookEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_COOKBOOK);
    }

    return SdkIpcResponse.success(data: jsonEncode(cookBookEither.toOption().toNullable()!.toProto3Json()), sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> getRecipeByIdForSDK({required String cookbookId, required String recipeId}) async {
    final recipeEither = await repository.getRecipe(cookBookId: cookbookId, recipeId: recipeId);

    if (recipeEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: recipeEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_RECIPE);
    }

    return SdkIpcResponse.success(data: jsonEncode(recipeEither.toOption().toNullable()!.toProto3Json()), sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> getExecutionByRecipeId({required String cookbookId, required String recipeId}) async {
    final recipesEither = await repository.getExecutionsByRecipeId(cookBookId: cookbookId, recipeId: recipeId);

    if (recipesEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: recipesEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_RECIPES);
    }
    final response = recipesEither.toOption().toNullable()!;

    return SdkIpcResponse.success(data: jsonEncode(response), sender: '', transaction: '');
  }

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
  Future<SdkIpcResponse> getItemByIdForSDK({required String cookBookId, required String itemId}) async {
    final getItemEither = await repository.getItem(cookBookId: cookBookId, itemId: itemId);

    if (getItemEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: getItemEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_ITEM);
    }

    final response = getItemEither.toOption().toNullable()!;

    return SdkIpcResponse.success(data: jsonEncode(response.toProto3Json()), sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> getItemListByOwner({required String owner}) async {
    final getItemListEither = await repository.getListItemByOwner(owner: owner);

    if (getItemListEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: getItemListEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_ITEM);
    }

    final response = getItemListEither.toOption().toNullable()!;

    return SdkIpcResponse.success(data: jsonEncode(response.map((item) => item.toProto3Json()).toList()), sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> getExecutionBasedOnId({required String id}) async {
    final getExecutionEither = await repository.getExecutionBasedOnId(id: id);

    if (getExecutionEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: getExecutionEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_ITEM);
    }

    final response = getExecutionEither.toOption().toNullable()!;

    return SdkIpcResponse.success(data: jsonEncode(response.toProto3Json()), sender: '', transaction: '');
  }

  @override
  Future<SdkIpcResponse> getTradesForSDK({required String creator}) async {
    final tradesEither = await repository.getTradesBasedOnCreator(creator: creator);

    if (tradesEither.isLeft()) {
      return SdkIpcResponse.failure(sender: '', error: tradesEither.swap().toOption().toNullable()!.message, errorCode: HandlerFactory.ERR_CANNOT_FETCH_TRADES);
    }

    return SdkIpcResponse.success(data: jsonEncode(tradesEither.getOrElse(() => []).map((trade) => trade.toProto3Json()).toList()), sender: '', transaction: '');
  }

  @override
  Future<Either<Failure, AccountPublicInfo>> importPylonsAccount({required String mnemonic}) async {
    final baseEnv = getBaseEnv();
    final transactionSigningGateway = getTransactionSigningGateway();

    final wallet = alan.Wallet.derive(mnemonic.split(" "), baseEnv.networkInfo);

    final getUsernameBasedOnAddress = await repository.getUsername(address: wallet.bech32Address);

    if (getUsernameBasedOnAddress.isLeft()) {
      return Left(getUsernameBasedOnAddress.swap().toOption().toNullable()!);
    }

    final userName = getUsernameBasedOnAddress.getOrElse(() => '');

    final creds = AlanPrivateAccountCredentials(
      publicInfo: AccountPublicInfo(
        chainId: baseEnv.chainId,
        name: userName,
        publicAddress: wallet.bech32Address,
        accountId: userName,
      ),
      mnemonic: mnemonic,
    );

    await transactionSigningGateway.storeAccountCredentials(
      credentials: creds,
      password: '',
    );

    wallets.value.add(creds.publicInfo);
    final String fcmToken = await getRemoteNotificationServiceToken();
    await repository.updateFcmToken(address: creds.publicInfo.publicAddress, fcmToken: fcmToken);
    await repository.setUserIdentifierInAnalytics(address: creds.publicInfo.publicAddress);
    crashlyticsHelper.setUserIdentifier(identifier: creds.publicInfo.publicAddress);

    await repository.saveMnemonic(mnemonic);
    await repository.doesStripeAccountExistsFromServer(address: creds.publicInfo.publicAddress);

    return Right(creds.publicInfo);
  }

  @override
  Future<bool> deleteAccounts() async {
    final transactionSigningGateway = getTransactionSigningGateway();
    final customTransactionSigningGateway = getCustomTransactionSigningGateway();

    final response = await transactionSigningGateway.clearAllCredentials();
    final customResponse = await customTransactionSigningGateway.clearAllCredentials();

    return response.isRight() && customResponse.isRight();
  }

  @override
  Either<Failure, bool> saveInitialLink({required String initialLink}) {
    return repository.saveInitialLink(initialLink);
  }

  @override
  Either<Failure, String> getInitialLink() {
    return repository.getInitialLink();
  }

  @override
  Future<Either<Failure, String>> sendGoogleInAppPurchaseCoinsRequest(GoogleInAppPurchaseModel googleInAppPurchaseModel) {
    return repository.sendGoogleInAppPurchaseCoinsRequest(googleInAppPurchaseModel);
  }

  @override
  Future<Either<Failure, String>> sendAppleInAppPurchaseCoinsRequest(AppleInAppPurchaseModel appleInAppPurchaseModel) {
    return repository.sendAppleInAppPurchaseCoinsRequest(appleInAppPurchaseModel);
  }

  TransactionSigningGateway getTransactionSigningGateway() {
    return sl.get<TransactionSigningGateway>();
  }

  BaseEnv getBaseEnv() {
    return sl.get<BaseEnv>();
  }

  CustomTransactionSigningGateway getCustomTransactionSigningGateway() {
    return sl.get<CustomTransactionSigningGateway>();
  }

  Future<String> getRemoteNotificationServiceToken() {
    return sl.get<RemoteNotificationsService>().getToken();
  }
  

}
