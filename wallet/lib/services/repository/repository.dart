import 'dart:convert';

import 'package:alan/alan.dart' as alan;
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/model/execution_list_by_recipe_response.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/nft_ownership_history.dart';
import 'package:pylons_wallet/model/notification_message.dart';
import 'package:pylons_wallet/model/pick_image_model.dart';
import 'package:pylons_wallet/model/stripe_get_login_based_address.dart';
import 'package:pylons_wallet/model/stripe_loginlink_request.dart';
import 'package:pylons_wallet/model/stripe_loginlink_response.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/model/wallet_creation_model.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/tx.pbgrpc.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_trace_model.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/third_party_services/crashlytics_helper.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/utils/backup/common/backup_model.dart';
import 'package:pylons_wallet/utils/backup/google_drive_helper.dart';
import 'package:pylons_wallet/utils/backup/icloud_driver_helper.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/local_auth_helper.dart';
import 'package:pylons_wallet/utils/query_helper.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

abstract class Repository {
  /// This method returns the recipe based on cookbook id and recipe Id
  /// Input : [cookBookId] id of the cookbook that contains recipe, [recipeId] id of the recipe
  /// Output: if successful the output will be [pylons.Recipe] recipe else
  /// will return error in the form of failure
  Future<Either<Failure, pylons.Recipe>> getRecipe({required String cookBookId, required String recipeId});

  /// This method returns the user name associated with the id
  /// Input : [address] address of the user
  /// Output: if successful the output will be [String] username of the user
  /// will return error in the form of failure
  Future<Either<Failure, String>> getUsername({required String address});

  /// This method returns the recipe list
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be the list of [pylons.Recipe]
  /// will return error in the form of failure
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId});

  /// This method returns the cookbook
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be  [pylons.Cookbook]
  /// will return error in the form of failure
  Future<Either<Failure, pylons.Cookbook>> getCookbookBasedOnId({required String cookBookId});

  /// check if account with username exists
  /// Input:[String] username
  /// Output: [String] if exists returns the address
  /// will return error in form of failure
  Future<Either<Failure, String>> getAddressBasedOnUsername(String username);

  /// THis method returns list of balances against an address
  /// Input:[address] public address of the user
  /// Output : returns the list of [Balance] els throws an error
  Future<Either<Failure, List<Balance>>> getBalance(String address);

  /// THis method returns execution based on the recipe id
  /// Input:[cookBookId] the id of the cookbook that contains recipe, [recipeId] the id of the recipe whose list of execution you want
  /// Output : returns the [ExecutionListByRecipeResponse] else throws an error
  Future<Either<Failure, ExecutionListByRecipeResponse>> getExecutionsByRecipeId({required String cookBookId, required String recipeId});

  /// This method returns list of balances against an address
  /// Input:[address] to which amount is to sent, [denom] tells denomination of the fetch coins
  /// Output : returns new balance in case of success else failure
  Future<Either<Failure, int>> getFaucetCoin({required String address, String? denom});

  /// This method returns the Item based on id
  /// Input : [cookBookId] the id of the cookbook which contains the cookbook, [itemId] the id of the item
  /// Output: [pylons.Item] returns the item
  Future<Either<Failure, pylons.Item>> getItem({required String cookBookId, required String itemId});

  /// This method returns the list of items based on id
  /// Input : [owner] the id of the owner
  /// Output: [List][pylons.Item] returns the item list
  Future<Either<Failure, List<pylons.Item>>> getListItemByOwner({required String owner});

  /// This method returns the execution based on id
  /// Input : [id] the id of the execution
  /// Output: [pylons.Execution] returns execution
  Future<Either<Failure, pylons.Execution>> getExecutionBasedOnId({required String id});

  /// Get all current trades against the given creator
  /// Input : [creator] the id of the creator
  /// Output: [List<pylons.Trade>] returns a list of trades
  Future<Either<Failure, List<pylons.Trade>>> getTradesBasedOnCreator({required String creator});

  /// This method returns the private credentials based on the mnemonics
  /// Input : [mnemonic] mnemonics of the imported account, [username] user name of the user
  /// Output: [PrivateAccountCredentials] of the user account
  /// else will give [Failure]
  Future<Either<Failure, PrivateAccountCredentials>> getPrivateCredentials({required String mnemonic, required String username});

  /// Stripe Backend API to Create PaymentIntent
  /// Input: [StripeCreatePaymentIntentRequest]
  /// return [StripeCreatePaymentIntentResponse]
  Future<Either<Failure, StripeCreatePaymentIntentResponse>> CreatePaymentIntent(StripeCreatePaymentIntentRequest req);

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [StripeGeneratePaymentReceiptRequest]
  /// return [StripeGeneratePaymentReceiptResponse]
  Future<Either<Failure, StripeGeneratePaymentReceiptResponse>> GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest req);

  /// Stripe Backend API to Generate Registration Token
  /// Input: [address]
  /// return [StripeGenerateRegistrationTokenResponse]
  Future<Either<Failure, StripeGenerateRegistrationTokenResponse>> GenerateRegistrationToken(String address);

  /// Stripe Backend API to Register Stripe connected Account
  /// Input: [StripeRegisterAccountRequest]
  /// return [StripeRegisterAccountResponse]
  Future<Either<Failure, StripeRegisterAccountResponse>> RegisterAccount(StripeRegisterAccountRequest req);

  /// Stripe Backend API to Generate Updated Token for Connected Account
  /// Input: [address]
  /// return [StripeGenerateUpdateTokenResponse]
  Future<Either<Failure, StripeGenerateUpdateTokenResponse>> GenerateUpdateToken(String address);

  /// Stripe Backend API to Update Stripe Connected Account
  /// Input: [req]
  /// return [StripeGenerateUpdateTokenResponse]
  Future<Either<Failure, StripeUpdateAccountResponse>> UpdateAccount(StripeUpdateAccountRequest req);

  /// Stripe Backend API to Get account id and account link based on update token
  /// Input: [StripeUpdateAccountRequest] contains stripe update account token
  /// return [StripeGenerateUpdateTokenResponse] contains the account id and account link
  Future<Either<Failure, StripeUpdateAccountResponse>> getAccountLinkBasedOnUpdateToken(StripeUpdateAccountRequest req);

  /// Stripe Backend API to Generate Payout Token
  /// Input: [StripeGeneratePayoutTokenRequest]
  /// return [StripeGeneratePayoutTokenResponse]
  Future<Either<Failure, StripeGeneratePayoutTokenResponse>> GeneratePayoutToken(StripeGeneratePayoutTokenRequest req);

  /// Stripe Backend API to Get Connected Account Link matched to the wallet address
  /// Input: [StripeAccountLinkRequest] wallet account
  /// return [StripeAccountLinkResponse] accountLink matched to wallet account
  Future<Either<Failure, StripeAccountLinkResponse>> GetAccountLink(StripeAccountLinkRequest req);

  /// Stripe Backend API to Get Stripe Connected Account Login Link
  /// Input: [StripeLoginLinkRequest]
  /// return [StripeLoginLinkResponse]
  Future<Either<Failure, StripeLoginLinkResponse>> stripeGetLoginLink(StripeLoginLinkRequest req);

  /// Stripe Backend API to Get Stripe Connected Account Login Link
  /// Input: [StripeGetLoginBasedOnAddressRequest]
  /// return [StripeGetLoginBasedOnAddressResponse] contains the response for the get login link based on address
  Future<Either<Failure, StripeGetLoginBasedOnAddressResponse>> getLoginLinkBasedOnAddress(StripeGetLoginBasedOnAddressRequest req);

  /// This method will return the ibc coin info
  /// Input: [ibcHash] hash of the ibc coin
  /// Output: if successful will return [IBCTraceModel] which contains info regarding the hash else this will give [Failure]
  Future<Either<Failure, IBCTraceModel>> getIBCHashTrace({required String ibcHash});

  /// This method will return whether the stripe account exists are not. It will be used during import account and during stripe account creation
  /// Input: [address] The address of the account
  /// Output: if successful will return [bool] which tells whether there is a registered account against user or not else this will give [Failure]
  Future<Either<Failure, bool>> doesStripeAccountExistsFromServer({required String address});

  /// This method will tell whether the user stripe account exists or not it will be used in the cases of ipc requests
  /// Output: if successful will return [bool] which tells whether there is a registered account against user or not else this will give [Failure]
  Either<Failure, bool> getStripeAccountExistsFromLocal();

  /// This method will save the stripe exists or not
  /// Input : [isExists] tells whether the stripe exists or not
  Future saveStripeAccountExistsLocal({required bool isExist});

  /// This method will pick image from the gallery
  /// Input : [pickImageModel] contains info regarding the image to be picked
  /// Output: if successful will return [String] which is the path of the image else this will give [Failure]
  Future<Either<Failure, String>> pickImageFromGallery(PickImageModel pickImageModel);

  /// This method will save image in the local data base
  /// Input : [imagePath] contains the path of the image, [key] the key againts which it will be saved
  /// Output: if successful will return [bool] which tells whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveImage({required String key, required String imagePath});

  /// This method will return the path of the image
  /// Input : [uri] key of the saved image
  /// Output: if successful will return [String] which is the path of the image else this will give [Failure]
  Either<Failure, String> getImagePath(String uri);

  /// This method saves the boolean value that indicates whether the banner has a dark or light brightness value
  /// Input: [isBannerDark] contains the boolean value that was determine from the images brightness
  /// Output: if successful will return [bool] which tells whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveIsBannerDark({required bool isBannerDark});

  /// This method gets the boolean value that indicates whether the banner has a dark or light brightness value
  /// Output: if successful will return [bool] indicating whether the banner is dark or light else this will give [Failure]
  Either<Failure, bool> getIsBannerDark();

  /// This method will save image in the local data base
  /// Input : [value] contains the email
  /// Output: if successful will return [bool] which tells whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveEmail({required String value});

  /// This method will return the email
  /// Output: if successful will return [String] email else this will give [Failure]
  Either<Failure, String> getSavedEmail();

  /// This method will save the initial link in the local data store.
  /// Input: [link] the initialLink to be saved in the local data store
  /// Output: if successful will return [bool] which tells whether the operation is successful or not else this will give [Failure]
  Either<Failure, bool> saveInitialLink(String initialLink);

  /// This method will get the initial link
  /// Output: if successful will return [String] link else this will give [Failure]
  Either<Failure, String> getInitialLink();

  /// This method will save description in the local database
  /// Input : [description] contains the description
  /// Output: if successful will return [bool] which tells whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveDescription({required String description});

  /// This method will return the description
  /// Output: if successful will return [String] email else this will give [Failure]
  Either<Failure, String> getDescription();

  /// This method will save description in the local database
  /// Input : [notificationStatus] is the notification preference of the user
  /// Output: if successful will return [bool] which tells whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveNotificationsPreference({required bool notificationStatus});

  /// This method will return the description
  /// Output: if successful will return [bool] notification preference else this will give [Failure]
  Either<Failure, bool> getNotificationsPreference();

  /// This method will save NetworkEnvironmentPreference in the local database
  /// Input : [networkEnvironment] is the network Environment preference of the user
  /// Output: if successful will return [String] which tells which network is selected else this will give [Failure]
  Future<Either<Failure, bool>> saveNetworkEnvironmentPreference({required String networkEnvironment});

  /// This method will return the selected network environment
  /// Output: if successful will return [String] NetworkEnvironment preference else this will give [Failure]
  Either<Failure, String> getNetworkEnvironmentPreference();

  /// This method will save file in user local directory
  /// Input: [imagePath] the path of the image that we need to save.
  /// Output: if successful will return [String] which is the path of the local store image else this will give [Failure]
  Future<Either<Failure, String>> saveImageInLocalDirectory(String imagePath);

  /// This method will save the mnemonic in the local data store.
  /// Input: [mnemonic] the mnemonic to be saved in the local data store
  /// Output: if successful will return [bool] which tells whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveMnemonic(String mnemonics);

  /// This method will get the mnemonic from local data store
  /// Output: if successful will return [String] which is the mnemonic saved in the local datastore else this will give [Failure]
  Future<Either<Failure, String>> getMnemonic();

  /// This method checks whether biometric is available or not
  /// Output : if successful will return [BiometricType] the type of authentication else this will give [Failure]
  Future<Either<Failure, BiometricType>> isBiometricAvailable();

  /// This method authenticates the user based on biometric
  /// Output : if successful will return [bool] shows whether the authentication is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> authenticate();

  /// This method will set the application directory on runtime
  /// Output: if successful will setApplicationDirectory else this will give [Failure]
  Future<Either<Failure, void>> setApplicationDirectory();

  /// This method will set the default security biometric
  /// Input: [biometricEnabled] tells whether the biometric security feature should be enabled or not
  /// Output : if successful will return [bool] shows whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveDefaultSecurityBiometric({required bool biometricEnabled});

  /// This method will get the default security biometric
  /// Input: [bool] tells whether the biometric security is enabled or not else this will give [Failure]
  Either<Failure, bool> getSecurityBiometric();

  /// This method will set the biometric for login
  /// Input: [biometricEnabled] tells whether the biometric security feature should be enabled or not
  /// Output : if successful will return [bool] shows whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveBiometricLogin({required bool biometricEnabled});

  /// This method will get the biometric for login
  /// Input: [bool] tells whether the biometric security is enabled or not else this will give [Failure]
  Either<Failure, bool> getBiometricLogin();

  /// This method will set the biometric for transaction
  /// Input: [biometricEnabled] tells whether the biometric security feature should be enabled or not
  /// Output : if successful will return [bool] shows whether the operation is successful or not else this will give [Failure]
  Future<Either<Failure, bool>> saveBiometricTransaction({required bool biometricEnabled});

  /// This method will get the biometric for transaction
  /// Input: [bool] tells whether the biometric security is enabled or not else this will give [Failure]
  Either<Failure, bool> getBiometricTransaction();

  /// This method will get the nft history
  /// Input: [itemId] and [cookBookId] of the nft
  /// Output: returns [List][NftOwnershipHistory] if success else this will give [Failure]
  Future<Either<Failure, List<NftOwnershipHistory>>> getNftOwnershipHistory({required String itemId, required String cookBookId});

  /// This method will get the transaction history from the chain
  /// Input: [address] of the user
  /// Output: returns [List][TransactionHistory] if success else this will give [Failure]
  Future<Either<Failure, List<TransactionHistory>>> getTransactionHistory({required String address});

  /// This method will update the recipe in the chain
  /// Input: [MsgUpdateRecipe] contains the info regarding the recipe update
  /// Output: if successful will return [String] the hash of the transaction else this will give [Failure]
  Future<Either<Failure, String>> updateRecipe({required MsgUpdateRecipe msgUpdateRecipe});

  /// This method will upload the mnemonic on the google drive
  /// Input: [mnemonic] the mnemonic of the user, [username] the username of the user
  /// Output: [bool] tells whether the operation is successful else this will give [Failure]
  Future<Either<Failure, bool>> uploadMnemonicGoogleDrive({required String mnemonic, required String username});

  /// This method will get backup data from google drive
  /// Output: if successful will return [BackupData] else this will give [Failure]
  Future<Either<Failure, BackupData>> getGoogleDriveMnemonic();

  /// This method will upload the mnemonic on the icloud
  /// Input: [mnemonic] the mnemonic of the user, [username] the username of the user
  /// Output: [bool] tells whether the operation is successful else this will give [Failure]
  Future<Either<Failure, bool>> uploadMnemonicICloud({required String mnemonic, required String username});

  /// This method will get backup data from the icloud drive
  /// Output: if successful will return [BackupData] else this will give [Failure]
  Future<Either<Failure, BackupData>> getICloudMnemonic();

  /// This method will get cookbooks based on creator
  /// Input: [creator] the address of the user
  /// Output: if successful will return [List][pylons.Cookbook] else this will give [Failure]
  Future<Either<Failure, List<pylons.Cookbook>>> getCookbooksByCreator({required String creator});

  /// This method will get trade based on id
  /// Input: [id] the id of the trade
  /// Output: if successful will return [pylons.Trade] else this will give [Failure]
  Future<Either<Failure, pylons.Trade>> getTradeByID(Int64 id);

  /// This method will get current internet connectivity status
  /// Output: it will return [bool], [True] if mobile has active internet connection & [False] is mobile don't have
  Future<bool> isInternetConnected();

  /// This method will actively listen to the changes of mobile internet connectivity
  /// Output: It will return [Stream] of [InternetConnectionStatus] to check weather mobile has active connectivity status or not
  Stream<InternetConnectionStatus> getInternetStatus();

  /// This method is used to get likes count of NFT
  /// Input: [recipeId],[cookBookID] and [walletAddress] of the given NFT
  /// Output : [int] will contain the likes count of the NFT else this will give [Failure]
  Future<Either<Failure, int>> getLikesCount({required String recipeId, required String cookBookID});

  /// This method is used to get views count of NFT
  /// Input: [recipeId],[cookBookID] and [walletAddress] of the given NFT
  /// Output : [int] will contain the views count of the NFT else this will give [Failure]
  Future<Either<Failure, int>> getViewsCount({required String recipeId, required String cookBookID});

  /// This method is used to increment a view for an NFT when a user view an NFT
  /// Input: [recipeId],[cookBookID] and [walletAddress] of the given NFT else this will give [Failure]
  Future<Either<Failure, void>> countAView({required String recipeId, required String cookBookID, required String walletAddress});

  /// This method is used get the like status of the NFT ; if it is Liked by me or not
  /// Input: [recipeId],[cookBookID] and [walletAddress] of the given NFT
  /// Output : [bool] will be the status for NFT if it is Liked or not
  Future<Either<Failure, bool>> ifLikedByMe({required String recipeId, required String cookBookID, required String walletAddress});

  /// This method is used to update the like status of an NFT; it will toggle the like button
  /// Input: [recipeId],[cookBookID] and [walletAddress] of the given NFT
  Future<Either<Failure, void>> updateLikeStatus({required String recipeId, required String cookBookID, required String walletAddress});

  /// This method is used to save user's feedback into Firebase
  /// Input: [subject],[feedback] and [walletAddress] of the given Account
  /// Output: [bool] This will return true if its success otherwise false
  Future<Either<Failure, bool>> saveUserFeedback({required String walletAddress, required String subject, required String feedback});

  ///This method is used to send apple in app purchase coins
  /// Input: [AppleInAppPurchaseModel] will be given
  /// Output: return [String] if succeed else this will give [Failure]
  Future<Either<Failure, String>> sendAppleInAppPurchaseCoinsRequest(AppleInAppPurchaseModel appleInAppPurchaseModel);

  ///This method is used to send google in app purchase coins
  /// Input: [GoogleInAppPurchaseModel] will be given
  /// Output: return [String] if succeed else this will give [Failure]
  Future<Either<Failure, String>> sendGoogleInAppPurchaseCoinsRequest(GoogleInAppPurchaseModel msgGoogleInAPPPurchase);

  /// This method will get the products For Sale from the underling store
  /// Input: [itemId] the id of the product to be bought
  /// Output: if successful will return [ProductDetails] the details of the product else this will give [Failure]
  Future<Either<Failure, ProductDetails>> getProductsForSale({required String itemId});

  /// This method will buy the product based on its detail
  /// Input: [productDetails] the details of item to bought
  /// Output: if successful will return [bool] tells whether the operation initiated the dialog or not else this will give [Failure]
  Future<Either<Failure, bool>> buyProduct(ProductDetails productDetails);

  /// This method will initializes the in app purchase
  /// Output: if successful will return [bool] tells whether device support in app purchase or not else this will give [Failure]
  Future<Either<Failure, bool>> isInAppPurchaseAvailable();

  /// This method will update the fcm token against the user
  /// Input: [address] the address of the user whose fcm needs to be updated, [fcmToken] the fcm token
  /// Output: if successful will return [bool] tells whether fcm updated or not else this will give [Failure]
  Future<Either<Failure, bool>> updateFcmToken({required String address, required String fcmToken});

  /// This method will mark notification as read.
  /// Input: [List][ids] the list containing ids of notifications which needed to be mark as read
  /// Output: [bool] returns true if successful else will throw error else this will give [Failure]
  Future<Either<Failure, bool>> markNotificationAsRead({required List<String> idsList});

  /// This method will get the firebase app check token
  /// Output: if successful will return [String] appcheck token else this will give [Failure]
  Future<Either<Failure, String>> getAppCheckToken();

  /// This method will get list of notification messages
  /// Input: [walletAddress] of the user ,[limit] the maximum number of records to show at a time
  /// and [offset] is the last item's position
  /// Output: if successful will return [List][NotificationMessage] the list of the NotificationMessage else this will give [Failure]
  Future<Either<Failure, List<NotificationMessage>>> getAllNotificationsMessages({required String walletAddress, required int limit, required int offset});

  /// This method will save the invitee address
  /// Input: [dynamicLink] the address of the user who had invited this user
  /// Output: [bool] tells whether ths operation is successful or not
  /// else will throw error
  Future<Either<Failure, bool>> saveInviteeAddressFromDynamicLink({required String dynamicLink});

  /// This method will create dynamic link for the user invite
  /// Input : [address] the address against which the invite link to be generated
  /// Output: [String] return the generated dynamic link else will return [Failure]
  Future<Either<Failure, String>> createDynamicLinkForUserInvite({required String address});

  /// This method will create dynamic link for the nft share recipe
  /// Input : [address] the address against which the invite link to be generated, [nft] the nft whose link to be created
  /// Output: [String] return the generated dynamic link else will return [Failure]
  Future<Either<Failure, String>> createDynamicLinkForRecipeNftShare({required String address, required NFT nft});

  /// This method will create User account based on account public info
  /// Input: [publicInfo] contains info related to user chain address, [walletCreationModel] contains user entered data
  /// Output: if successful will give [TransactionResponse] else will  return [Failure]
  Future<Either<Failure, TransactionResponse>> createAccount({required AccountPublicInfo publicInfo, required WalletCreationModel walletCreationModel});

  /// This method will save the Transaction Failure data to local DB
  /// Input: [LocalTransactionModel] the Transaction Input needs to retry the retry the transaction
  /// Output: [int] returns id of the inserted document
  Future<Either<Failure, int>> saveLocalTransaction(LocalTransactionModel txManager);

  /// This method will get you all the transactionFailures from the DB
  /// Output: This method will return the List of [LocalTransactionModel] failures
  Future<Either<Failure, List<LocalTransactionModel>>> getAllTransactionFailures();

  /// This method will remove the Transaction failure record from the DB
  /// Input: [id] This method will take id of the transaction record to be removed
  /// Output: [bool] status of the process is successful or not
  Future<Either<Failure, bool>> deleteTransactionFailureRecord(int id);

  /// This method will set user app level identifier in the analytics
  /// Input: [address] the address of the user
  /// Output: [bool] tells whether the operation is successful or else will return [Failure]
  Future<Either<Failure, bool>> setUserIdentifierInAnalytics({required String address});

  /// Output: [bool] tells whether the operation is successful or else will return [Failure]
  Future<Either<Failure, bool>> logPurchaseItem({required String recipeId, required String recipeName, required String author, required double purchasePrice});

  /// Output: [bool] tells whether the operation is successful or else will return [Failure]
  Future<Either<Failure, bool>> logAddToCart({
    required String recipeId,
    required String recipeName,
    required String author,
    required double purchasePrice,
    required String currency,
  });

  Future<Either<Failure, void>> logUserJourney({required String screenName});
}

class RepositoryImp implements Repository {
  final NetworkInfo networkInfo;

  final QueryHelper queryHelper;

  final RemoteDataStore remoteDataStore;

  final LocalDataSource localDataSource;

  final LocalAuthHelper localAuthHelper;

  final GoogleDriveApiImpl googleDriveApi;

  final ICloudDriverApiImpl iCloudDriverApi;

  final CrashlyticsHelper crashlyticsHelper;

  RepositoryImp(
      {required this.networkInfo,
      required this.queryHelper,
      required this.localAuthHelper,
      required this.remoteDataStore,
      required this.googleDriveApi,
      required this.iCloudDriverApi,
      required this.crashlyticsHelper,
      required this.localDataSource});

  @override
  Future<Either<Failure, pylons.Recipe>> getRecipe({required String cookBookId, required String recipeId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getRecipe(cookBookId: cookBookId, recipeId: recipeId));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(RecipeNotFoundFailure("recipe_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, String>> getUsername({required String address}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getUsername(address: address));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(RecipeNotFoundFailure("username_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final response = await remoteDataStore.getRecipesBasedOnCookBookId(cookBookId: cookBookId);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CookBookNotFoundFailure("cookbook_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, pylons.Cookbook>> getCookbookBasedOnId({required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getCookbookBasedOnId(cookBookId: cookBookId));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CookBookNotFoundFailure("cookbook_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressBasedOnUsername(String username) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getAddressBasedOnUsername(username));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      return Left(RecipeNotFoundFailure("username_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, List<Balance>>> getBalance(String walletAddress) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.getBalance(walletAddress);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(StripeFailure("get_balance_failed".tr()));
    }
  }

  @override
  Future<Either<Failure, ExecutionListByRecipeResponse>> getExecutionsByRecipeId({required String cookBookId, required String recipeId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getExecutionsByRecipeId(cookBookId: cookBookId, recipeId: recipeId));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return const Left(RecipeNotFoundFailure(SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin({required String address, String? denom}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    // final faucetUrl = "${baseEnv.faucetUrl}/coins?address=$address";
    //
    // final result = await queryHelper.queryGet(faucetUrl);
    //
    // if (!result.isSuccessful) {
    //   return Left(FaucetServerFailure(result.error ?? ''));
    // }
    //
    // if (result.value!['success'] == false) {
    //   return Left(FaucetServerFailure(result.value!['error'] as String));
    // }

    const amount = 1000000;
    return const Right(amount);
  }

  @override
  Future<Either<Failure, pylons.Item>> getItem({required String cookBookId, required String itemId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getItem(cookBookId: cookBookId, itemId: itemId));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(ItemNotFoundFailure("item_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, List<pylons.Item>>> getListItemByOwner({required String owner}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getListItemByOwner(owner: owner));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(ItemNotFoundFailure("item_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, pylons.Execution>> getExecutionBasedOnId({required String id}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getExecutionBasedOnId(id: id));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());

      return Left(ItemNotFoundFailure("execution_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, List<pylons.Trade>>> getTradesBasedOnCreator({required String creator}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getTradesBasedOnCreator(creator: creator));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(TradeNotFoundFailure("trade_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, PrivateAccountCredentials>> getPrivateCredentials({required String mnemonic, required String username}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final baseEnv = getBaseEnv();
      final wallet = alan.Wallet.derive(mnemonic.split(" "), baseEnv.networkInfo);
      final creds = AlanPrivateAccountCredentials(
        publicInfo: AccountPublicInfo(
          chainId: baseEnv.chainId,
          name: username,
          publicAddress: wallet.bech32Address,
          accountId: username,
        ),
        mnemonic: mnemonic,
      );

      return Right(creds);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(TradeNotFoundFailure("trade_not_found".tr()));
    }
  }

  /// Stripe Backend API to Payout request
  /// Input: [StripeCreatePaymentIntentRequest] {address:, productID:, coin_inputs_index:}
  /// return [StripeCreatePaymentIntentResponse] {client_secret}
  @override
  Future<Either<Failure, StripeCreatePaymentIntentResponse>> CreatePaymentIntent(StripeCreatePaymentIntentRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final baseEnv = getBaseEnv();
      final result = await queryHelper.queryPost("${baseEnv.baseStripeUrl}/create-payment-intent", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? CREATE_PAYMENTINTENT_FAILED));
      }
      return Right(StripeCreatePaymentIntentResponse.from(result));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(CREATE_PAYMENTINTENT_FAILED));
    }
  }

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [StripeGeneratePaymentReceiptRequest] {pament_intent_id:, client_secret}
  /// return [StripeGeneratePaymentReceiptResponse]
  /// response: {
  ///    purchaseID: String,
  ///    processorName: String
  ///    payerAddr: String
  ///    amount: String
  ///    productID: String,
  ///    signature: String
  /// }
  @override
  Future<Either<Failure, StripeGeneratePaymentReceiptResponse>> GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest req) async {
    final localTransactionModel = createInitialLocalTransactionModel(
      transactionTypeEnum: TransactionTypeEnum.GeneratePaymentReceipt,
      transactionData: jsonEncode(req.toJson()),
      transactionDescription: 'Generate Payment Receipt',
      transactionPrice: '',
      transactionCurrency: '',
    );

    if (!await networkInfo.isConnected) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final baseEnv = getBaseEnv();
      final result = await queryHelper.queryPost("${baseEnv.baseStripeUrl}/generate-payment-receipt", req.toJson());
      if (!result.isSuccessful) {
        await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
        return Left(StripeFailure(result.error ?? GEN_PAYMENTRECEIPT_FAILED));
      }
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Success, txLocalModel: localTransactionModel);
      return Right(StripeGeneratePaymentReceiptResponse.from(result));
    } on Exception catch (_) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(GEN_PAYMENTRECEIPT_FAILED));
    }
  }

  /// Stripe Backend API to Generate payout token
  /// Input: [StripeGeneratePayoutTokenRequest] {address: String, amount: int}
  /// return [StripeGeneratePayoutTokenResponse] {token: String, RedeemAmount: int64}
  @override
  Future<Either<Failure, StripeGeneratePayoutTokenResponse>> GeneratePayoutToken(StripeGeneratePayoutTokenRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final baseEnv = getBaseEnv();
      final result = await queryHelper.queryGet("${baseEnv.baseStripeUrl}/generate-payout-token?address=${req.address}&amount=${req.amount}");
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GEN_PAYOUTTOKEN_FAILED));
      }
      return Right(StripeGeneratePayoutTokenResponse.from(result));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(GEN_PAYOUTTOKEN_FAILED));
    }
  }

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [address] wallet address
  /// return [StripeGenerateRegistrationTokenResponse]
  @override
  Future<Either<Failure, StripeGenerateRegistrationTokenResponse>> GenerateRegistrationToken(String address) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final response = await remoteDataStore.generateStripeRegistrationToken(address: address);
      return Right(response);
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return const Left(StripeFailure(GEN_REGISTRATIONTOKEN_FAILED));
    }
  }

  /// Stripe Backend API to Generate UpdatedToken for ConnectedAccount
  /// Input: [address] wallet address
  /// return [StripeGenerateUpdateTokenResponse]
  @override
  Future<Either<Failure, StripeGenerateUpdateTokenResponse>> GenerateUpdateToken(String address) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final generateUpdateToken = await remoteDataStore.generateUpdateToken(address: address);
      return Right(generateUpdateToken);
    } on String catch (_) {
      return const Left(StripeFailure(GEN_UPDATETOKEN_FAILED));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(GEN_UPDATETOKEN_FAILED));
    }
  }

  /// Stripe Backend API to Get Stripe Connected Account Link
  /// Input: [StripeAccountLinkRequest]
  /// return [StripeAccountLinkResponse]
  @override
  Future<Either<Failure, StripeAccountLinkResponse>> GetAccountLink(StripeAccountLinkRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      final baseEnv = getBaseEnv();
      final result = await queryHelper.queryPost("${baseEnv.baseStripeUrl}/accountlink", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GET_ACCOUNTLINK_FAILED));
      }
      return Right(StripeAccountLinkResponse.from(result));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(GET_ACCOUNTLINK_FAILED));
    }
  }

  /// Stripe Backend API to Register Stripe connected account
  /// Input: [StripeRegisterAccountRequest]
  /// return [StripeRegisterAccountResponse]
  @override
  Future<Either<Failure, StripeRegisterAccountResponse>> RegisterAccount(StripeRegisterAccountRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.registerAccount(req: req);
      return Right(result);
    } on String catch (_) {
      return const Left(StripeFailure(REGISTERACCOUNT_FAILED));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(REGISTERACCOUNT_FAILED));
    }
  }

  /// Stripe Backend API to Update Stripe update account
  /// Input: [StripeUpdateAccountRequest] {address:String, token: String, signature: String}
  /// return [StripeUpdateAccountResponse] redirectURL
  @override
  Future<Either<Failure, StripeUpdateAccountResponse>> UpdateAccount(StripeUpdateAccountRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.updateStripeAccount(req: req);
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(UPDATEACCOUNT_FAILED));
    }
  }

  /// Stripe Backend API to Get Stripe Connected Account Login Link
  /// Input: [StripeLoginLinkRequest]
  /// return [StripeLoginLinkResponse]
  @override
  Future<Either<Failure, StripeLoginLinkResponse>> stripeGetLoginLink(StripeLoginLinkRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      final baseEnv = getBaseEnv();
      final result = await queryHelper.queryPost("${baseEnv.baseStripeUrl}/loginlink", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GET_LOGINLINK_FAILED));
      }
      return Right(StripeLoginLinkResponse.from(result));
    } on String catch (_) {
      return const Left(StripeFailure(GET_LOGINLINK_FAILED));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(GET_LOGINLINK_FAILED));
    }
  }

  @override
  Future<Either<Failure, StripeUpdateAccountResponse>> getAccountLinkBasedOnUpdateToken(StripeUpdateAccountRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.getAccountLinkBasedOnUpdateToken(req: req);
      return Right(result);
    } on String catch (_) {
      return const Left(StripeFailure(UPDATEACCOUNT_FAILED));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());

      return const Left(StripeFailure(UPDATEACCOUNT_FAILED));
    }
  }

  @override
  Future<Either<Failure, StripeGetLoginBasedOnAddressResponse>> getLoginLinkBasedOnAddress(StripeGetLoginBasedOnAddressRequest req) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.getLoginLinkBasedOnAddress(req: req);
      return Right(result);
    } on String catch (_) {
      return const Left(StripeFailure(UPDATEACCOUNT_FAILED));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());

      return const Left(StripeFailure(UPDATEACCOUNT_FAILED));
    }
  }

  @override
  Future<Either<Failure, IBCTraceModel>> getIBCHashTrace({required String ibcHash}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.getIBCHashTrace(ibcHash: ibcHash);
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(IBC_HASH_UPDATE_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> doesStripeAccountExistsFromServer({required String address}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.doesStripeAccountExists(address: address);
      localDataSource.saveStripeExistsOrNot(isExists: result);
      return Right(result);
    } on String catch (_) {
      localDataSource.saveStripeExistsOrNot(isExists: false);
      return const Left(StripeFailure(SOMETHING_WENT_WRONG));
    } on Failure catch (_) {
      localDataSource.saveStripeExistsOrNot(isExists: false);
      return Left(_);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      localDataSource.saveStripeExistsOrNot(isExists: false);
      return const Left(StripeFailure(SOMETHING_WENT_WRONG));
    }
  }

  @override
  Either<Failure, bool> getStripeAccountExistsFromLocal() {
    try {
      return Right(localDataSource.getStripeExistsOrNot());
    } on Exception catch (_) {
      return const Left(CacheFailure(IBC_HASH_UPDATE_FAILED));
    }
  }

  @override
  Future saveStripeAccountExistsLocal({required bool isExist}) async {
    try {
      return Right(await localDataSource.saveStripeExistsOrNot(isExists: isExist));
    } on Exception catch (_) {
      return const Left(CacheFailure(IBC_HASH_UPDATE_FAILED));
    }
  }

  @override
  Future<Either<Failure, String>> pickImageFromGallery(PickImageModel pickImageModel) async {
    try {
      return Right(await localDataSource.pickImageFromGallery(pickImageModel));
    } on Exception catch (_) {
      return const Left(PlatformFailure(PLATFORM_FAILED));
    } on String catch (_) {
      return Left(PlatformFailure(_));
    }
  }

  @override
  Future<Either<Failure, bool>> saveImage({required String key, required String imagePath}) async {
    try {
      return Right(await localDataSource.saveImage(key: key, imagePath: imagePath));
    } on Exception catch (_) {
      return const Left(PlatformFailure(PLATFORM_FAILED));
    } on String catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, String> getImagePath(String uri) {
    try {
      return Right(localDataSource.getImagePath(uri));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    } on String catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveIsBannerDark({required bool isBannerDark}) async {
    try {
      return Right(await localDataSource.saveIsBannerDark(isBannerDark: isBannerDark));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, bool> getIsBannerDark() {
    try {
      return Right(localDataSource.getIsBannerDark());
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveEmail({required String value}) async {
    try {
      return Right(await localDataSource.saveEmail(value));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, String> getSavedEmail() {
    try {
      return Right(localDataSource.getEmail());
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, bool> saveInitialLink(String initialLink) {
    try {
      return Right(localDataSource.saveInitialLink(initialLink));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, String> getInitialLink() {
    try {
      return Right(localDataSource.getInitialLink());
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, String> getDescription() {
    try {
      return Right(localDataSource.getDescription());
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveDescription({required String description}) async {
    try {
      return Right(await localDataSource.saveDescription(description));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, bool> getNotificationsPreference() {
    try {
      return Right(localDataSource.getNotificationPreference());
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveNotificationsPreference({required bool notificationStatus}) async {
    try {
      return Right(await localDataSource.saveNotificationsPreference(notificationStatus: notificationStatus));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, String> getNetworkEnvironmentPreference() {
    try {
      return Right(localDataSource.getNetworkEnvironmentPreference());
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveNetworkEnvironmentPreference({required String networkEnvironment}) async {
    try {
      return Right(await localDataSource.saveNetworkEnvironmentPreference(
        networkEnvironment: networkEnvironment,
      ));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, String>> saveImageInLocalDirectory(String imagePath) async {
    try {
      return Right(await localDataSource.saveImageInLocalDirectory(imagePath));
    } on String catch (_) {
      return Left(CacheFailure(_));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveMnemonic(String mnemonics) async {
    try {
      return Right(await localDataSource.saveMnemonics(mnemonics));
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, String>> getMnemonic() async {
    try {
      return Right(await localDataSource.getMnemonics());
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, BiometricType>> isBiometricAvailable() async {
    try {
      return Right(await localAuthHelper.isBiometricAvailable());
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(PlatformFailure(_));
    } on Exception catch (_) {
      return const Left(PlatformFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticate() async {
    try {
      return Right(await localAuthHelper.authenticate());
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      if (_ is PlatformException) {
        return Left(PlatformFailure(_.message ?? ''));
      }

      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, void>> setApplicationDirectory() async {
    try {
      return Right(await localDataSource.setApplicationDirectory());
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveDefaultSecurityBiometric({required bool biometricEnabled}) async {
    try {
      return Right(await localDataSource.saveDefaultSecurityBiometric(biometricEnabled: biometricEnabled));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, bool> getSecurityBiometric() {
    try {
      return Right(localDataSource.getSecurityBiometric());
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, bool> getBiometricLogin() {
    try {
      return Right(localDataSource.getLoginBiometric());
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveBiometricLogin({required bool biometricEnabled}) async {
    try {
      return Right(await localDataSource.saveLoginBiometric(biometricEnabled: biometricEnabled));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Either<Failure, bool> getBiometricTransaction() {
    try {
      return Right(localDataSource.getTransactionBiometric());
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, bool>> saveBiometricTransaction({required bool biometricEnabled}) async {
    try {
      return Right(await localDataSource.saveTransactionBiometric(biometricEnabled: biometricEnabled));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      return const Left(CacheFailure(PLATFORM_FAILED));
    }
  }

  @override
  Future<Either<Failure, List<TransactionHistory>>> getTransactionHistory({required String address}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.getTransactionHistory(address: address);

      return Right(result);
    } on String catch (_) {
      return const Left(StripeFailure(SOMETHING_WENT_WRONG));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, String>> updateRecipe({required MsgUpdateRecipe msgUpdateRecipe}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.updateRecipe(msgUpdateRecipe: msgUpdateRecipe);

      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return const Left(StripeFailure(SOMETHING_WENT_WRONG));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(StripeFailure(SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, bool>> uploadMnemonicGoogleDrive({required String mnemonic, required String username}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await googleDriveApi.uploadMnemonic(username: username, mnemonic: mnemonic);

      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(UploadFailedFailure(message: _));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(UploadFailedFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, BackupData>> getGoogleDriveMnemonic() async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await googleDriveApi.getBackupData();
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(UploadFailedFailure(message: _));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(UploadFailedFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, bool>> uploadMnemonicICloud({required String mnemonic, required String username}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await iCloudDriverApi.uploadMnemonic(username: username, mnemonic: mnemonic);
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(UploadFailedFailure(message: _));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());

      return const Left(UploadFailedFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, BackupData>> getICloudMnemonic() async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await iCloudDriverApi.getBackupData();
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(UploadFailedFailure(message: _));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return const Left(UploadFailedFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, List<pylons.Cookbook>>> getCookbooksByCreator({required String creator}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getCookbooksByCreator(address: creator));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CookBookNotFoundFailure("cookbook_not_found".tr()));
    }
  }

  @override
  Future<Either<Failure, pylons.Trade>> getTradeByID(Int64 id) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      return Right(await remoteDataStore.getTradeByID(id: id));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(TradeNotFoundFailure("trade_not_found".tr()));
    }
  }

  BaseEnv getBaseEnv() {
    return sl.get<BaseEnv>();
  }

  @override
  Stream<InternetConnectionStatus> getInternetStatus() {
    return networkInfo.onStatusChange();
  }

  @override
  Future<bool> isInternetConnected() {
    return networkInfo.isConnected;
  }

  @override
  Future<Either<Failure, void>> countAView({required String recipeId, required String cookBookID, required String walletAddress}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.countAView(recipeId: recipeId, cookBookID: cookBookID, walletAddress: walletAddress));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  void recordErrorInCrashlytics(Exception e) {
    crashlyticsHelper.recordFatalError(error: e.toString());
  }

  @override
  Future<Either<Failure, int>> getLikesCount({required String recipeId, required String cookBookID}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.getLikesCount(recipeId: recipeId, cookBookID: cookBookID));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getViewsCount({required String recipeId, required String cookBookID}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.getViewsCount(recipeId: recipeId, cookBookID: cookBookID));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> ifLikedByMe({required String recipeId, required String cookBookID, required String walletAddress}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.ifLikedByMe(recipeId: recipeId, cookBookID: cookBookID, walletAddress: walletAddress));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLikeStatus({required String recipeId, required String cookBookID, required String walletAddress}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.updateLikeStatus(recipeId: recipeId, cookBookID: cookBookID, walletAddress: walletAddress));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendAppleInAppPurchaseCoinsRequest(AppleInAppPurchaseModel appleInAppPurchaseModel) async {
    final price = getInAppPrice(appleInAppPurchaseModel.productID);

    final LocalTransactionModel localTransactionModel = createInitialLocalTransactionModel(
        transactionTypeEnum: TransactionTypeEnum.AppleInAppCoinsRequest,
        transactionData: jsonEncode(appleInAppPurchaseModel.toJson()),
        transactionDescription: 'buying_pylon_points'.tr(),
        transactionCurrency: kStripeUSD_ABR,
        transactionPrice: price);

    if (!await networkInfo.isConnected) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.sendAppleInAppPurchaseCoinsRequest(appleInAppPurchaseModel);
      await saveTransactionRecord(transactionHash: result, transactionStatus: TransactionStatus.Success, txLocalModel: localTransactionModel);
      return Right(result);
    } on Failure catch (_) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      "something_wrong".tr().show();
      return Left(_);
    } on String catch (_) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return Left(InAppPurchaseFailure(message: _));
    } on Exception catch (_) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      recordErrorInCrashlytics(_);
      return const Left(InAppPurchaseFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  String getInAppPrice(String productId) {
    final baseEnv = getBaseEnv();
    for (final value in baseEnv.skus) {
      if (value.id == productId) {
        return value.subtitle;
      }
    }
    return "";
  }

  @override
  Future<Either<Failure, String>> sendGoogleInAppPurchaseCoinsRequest(GoogleInAppPurchaseModel msgGoogleInAPPPurchase) async {
    final price = getInAppPrice(msgGoogleInAPPPurchase.productID);

    final LocalTransactionModel localTransactionModel = createInitialLocalTransactionModel(
      transactionTypeEnum: TransactionTypeEnum.GoogleInAppCoinsRequest,
      transactionData: jsonEncode(msgGoogleInAPPPurchase.toJsonLocalRetry()),
      transactionDescription: 'buying_pylon_points'.tr(),
      transactionCurrency: kStripeUSD_ABR,
      transactionPrice: price,
    );

    if (!await networkInfo.isConnected) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.sendGoogleInAppPurchaseCoinsRequest(msgGoogleInAPPPurchase);
      await saveTransactionRecord(transactionHash: result, transactionStatus: TransactionStatus.Success, txLocalModel: localTransactionModel);
      return Right(result);
    } on Failure catch (e) {
      if (e.message.ifDuplicateReceipt()) {
        await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Success, txLocalModel: localTransactionModel);
        return const Right("");
      }
      "something_wrong".tr().show();
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return Left(e);
    } on String catch (_) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      return Left(InAppPurchaseFailure(message: _));
    } on Exception catch (_) {
      await saveTransactionRecord(transactionHash: "", transactionStatus: TransactionStatus.Failed, txLocalModel: localTransactionModel);
      recordErrorInCrashlytics(_);
      return const Left(InAppPurchaseFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  LocalTransactionModel createInitialLocalTransactionModel({
    required TransactionTypeEnum transactionTypeEnum,
    required String transactionData,
    required String transactionDescription,
    required String transactionCurrency,
    required String transactionPrice,
  }) {
    final LocalTransactionModel txManager = LocalTransactionModel(
      transactionType: transactionTypeEnum.name,
      transactionData: transactionData,
      transactionDescription: transactionDescription,
      dateTime: DateTime.now().millisecondsSinceEpoch,
      status: TransactionStatus.Undefined.name,
      transactionCurrency: transactionCurrency,
      transactionHash: "",
      transactionPrice: transactionPrice,
    );
    return txManager;
  }

  @override
  Future<Either<Failure, ProductDetails>> getProductsForSale({required String itemId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.getProductsForSale(itemId: itemId);
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(InAppPurchaseFailure(message: _));
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return const Left(InAppPurchaseFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, bool>> buyProduct(ProductDetails productDetails) async {
    final Map<String, dynamic> data = {};
    createJsonFormOfProductDetails(data, productDetails);

    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.buyProduct(productDetails);
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(InAppPurchaseFailure(message: _));
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return const Left(InAppPurchaseFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  Future<void> saveTransactionRecord({required String transactionHash, required TransactionStatus transactionStatus, required LocalTransactionModel txLocalModel}) async {
    final txLocalModelWithStatus = LocalTransactionModel.fromStatus(transactionHash: transactionHash, status: transactionStatus, transactionModel: txLocalModel);
    await saveLocalTransaction(txLocalModelWithStatus);
  }

  void createJsonFormOfProductDetails(Map<String, dynamic> data, ProductDetails productDetails) {
    data.addAll({
      'id': productDetails.id,
      'title': productDetails.title,
      'description': productDetails.description,
      'price': productDetails.price,
      'rawPrice': productDetails.rawPrice,
      'currencyCode': productDetails.currencyCode,
      'currencySymbol': productDetails.currencySymbol
    });
  }

  @override
  Future<Either<Failure, bool>> isInAppPurchaseAvailable() async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.isInAppPurchaseAvailable();
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(InAppPurchaseFailure(message: _));
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return const Left(InAppPurchaseFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, bool>> updateFcmToken({required String address, required String fcmToken}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final token = await remoteDataStore.getAppCheckToken();
      final result = await remoteDataStore.updateFcmToken(address: address, fcmToken: fcmToken, appCheckToken: token);
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(UpdateFcmTokenFailure(message: _));
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return const Left(UpdateFcmTokenFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<Either<Failure, bool>> markNotificationAsRead({
    required List<String> idsList,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      final token = await remoteDataStore.getAppCheckToken();
      final result = await remoteDataStore.markNotificationAsRead(idsList: idsList, appCheckToken: token);
      return Right(result);
    } on Failure catch (_) {
      return Left(_);
    } on String catch (_) {
      return Left(MarkReadNotificationFailure(message: 'something_wrong'.tr()));
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(MarkReadNotificationFailure(message: 'something_wrong'.tr()));
    }
  }

  @override
  Future<Either<Failure, List<NftOwnershipHistory>>> getNftOwnershipHistory({required String itemId, required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      final result = await remoteDataStore.getNftOwnershipHistory(itemId: itemId, cookBookId: cookBookId);

      return Right(result);
    } on String catch (_) {
      return Left(FetchNftOwnershipHistoryFailure(message: "something_wrong".tr()));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return Left(FetchNftOwnershipHistoryFailure(message: "something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationMessage>>> getAllNotificationsMessages({required String walletAddress, required int limit, required int offset}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      final result = await remoteDataStore.getAllNotificationMessages(walletAddress: walletAddress, limit: limit, offset: offset);

      return Right(result);
    } on String catch (_) {
      return Left(FetchAllNotificationFailure(message: 'something_wrong'.tr()));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return Left(FetchAllNotificationFailure(message: 'something_wrong'.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> getAppCheckToken() async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      final result = await remoteDataStore.getAppCheckToken();

      return Right(result);
    } on String catch (_) {
      return Left(AppCheckTokenCreationFailure(message: 'something_wrong'.tr()));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return Left(AppCheckTokenCreationFailure(message: 'something_wrong'.tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveInviteeAddressFromDynamicLink({required String dynamicLink}) async {
    try {
      return Right(await localDataSource.saveInviteeAddress(address: dynamicLink));
    } on Exception catch (_) {
      return const Left(CacheFailure(IBC_HASH_UPDATE_FAILED));
    }
  }

  @override
  Future<Either<Failure, TransactionResponse>> createAccount({required AccountPublicInfo publicInfo, required WalletCreationModel walletCreationModel}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      final String appCheckToken = await remoteDataStore.getAppCheckToken();
      final String inviteAddress = localDataSource.getInviteeAddress();
      final result = await remoteDataStore.createAccount(publicInfo: publicInfo, walletCreationModel: walletCreationModel, appCheckToken: appCheckToken, referralToken: inviteAddress);

      return Right(result);
    } on String catch (_) {
      return Left(AccountCreationFailure(_));
    } on Failure catch (_) {
      return Left(_);
    } on Exception catch (_) {
      recordErrorInCrashlytics(_);
      return Left(AccountCreationFailure('something_wrong'.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> createDynamicLinkForUserInvite({required String address}) async {
    try {
      return Right(await remoteDataStore.createDynamicLinkForUserInvite(address: address));
    } on Exception catch (_) {
      return Left(FirebaseDynamicLinkFailure("dynamic_link_failure".tr()));
    }
  }

  @override
  Future<Either<Failure, String>> createDynamicLinkForRecipeNftShare({required String address, required NFT nft}) async {
    try {
      return Right(await remoteDataStore.createDynamicLinkForRecipeNftShare(address: address, nft: nft));
    } on Exception catch (_) {
      return Left(FirebaseDynamicLinkFailure("dynamic_link_failure".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveUserFeedback({required String walletAddress, required String subject, required String feedback}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.saveUserFeedback(walletAddress: walletAddress, subject: subject, feedback: feedback));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> setUserIdentifierInAnalytics({required String address}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.setUpUserIdentifierInAnalytics(address: address));
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logPurchaseItem({required String recipeId, required String recipeName, required String author, required double purchasePrice}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.logPurchaseItem(recipeId: recipeId, recipeName: recipeName, author: author, purchasePrice: purchasePrice));
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logAddToCart({
    required String recipeId,
    required String recipeName,
    required String author,
    required double purchasePrice,
    required String currency,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.logAddToCart(recipeId: recipeId, recipeName: recipeName, author: author, purchasePrice: purchasePrice, currency: currency));
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTransactionFailureRecord(int id) async {
    try {
      final result = await localDataSource.deleteTransactionFailureRecord(id);
      return Right(result);
    } on Exception catch (_) {
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, List<LocalTransactionModel>>> getAllTransactionFailures() async {
    try {
      final result = await localDataSource.getAllTransactionFailures();
      return Right(result);
    } on Exception catch (_) {
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, int>> saveLocalTransaction(LocalTransactionModel txManager) async {
    try {
      final result = await localDataSource.saveTransactionFailure(txManager);
      return Right(result);
    } on Exception catch (_) {
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, void>> logUserJourney({required String screenName}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }
    try {
      return Right(await remoteDataStore.logUserJourney(screenName: screenName));
    } on Exception catch (e) {
      recordErrorInCrashlytics(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
