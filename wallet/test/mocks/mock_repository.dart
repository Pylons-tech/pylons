import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
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
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/cookbook.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/execution.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/trade.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/tx.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_trace_model.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/utils/backup/common/backup_model.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';

import 'mock_constants.dart';

class MockRepository extends Repository {
  @override
  Future<Either<Failure, StripeCreatePaymentIntentResponse>> CreatePaymentIntent(StripeCreatePaymentIntentRequest req) async {
    return Right(StripeCreatePaymentIntentResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeGeneratePaymentReceiptResponse>> GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest req) async {
    return Right(StripeGeneratePaymentReceiptResponse(
      success: true,
    ));
  }

  @override
  Future<Either<Failure, StripeGeneratePayoutTokenResponse>> GeneratePayoutToken(StripeGeneratePayoutTokenRequest req) async {
    return Right(StripeGeneratePayoutTokenResponse(success: true, RedeemAmount: Int64.ONE));
  }

  @override
  Future<Either<Failure, StripeGenerateRegistrationTokenResponse>> GenerateRegistrationToken(String address) async {
    return Right(StripeGenerateRegistrationTokenResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeGenerateUpdateTokenResponse>> GenerateUpdateToken(String address) async {
    return Right(StripeGenerateUpdateTokenResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeAccountLinkResponse>> GetAccountLink(StripeAccountLinkRequest req) async {
    return Right(StripeAccountLinkResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeRegisterAccountResponse>> RegisterAccount(StripeRegisterAccountRequest req) async {
    return Right(StripeRegisterAccountResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeUpdateAccountResponse>> UpdateAccount(StripeUpdateAccountRequest req) async {
    return Right(StripeUpdateAccountResponse(success: true));
  }

  @override
  Future<Either<Failure, String>> getAddressBasedOnUsername(String username) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Balance>>> getBalance(String address) {
    // TODO: implement getBalance
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Cookbook>> getCookbookBasedOnId({required String cookBookId}) {
    // TODO: implement getCookbookBasedOnId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Execution>> getExecutionBasedOnId({required String id}) {
    // TODO: implement getExecutionBasedOnId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ExecutionListByRecipeResponse>> getExecutionsByRecipeId({required String cookBookId, required String recipeId}) {
    // TODO: implement getExecutionsByRecipeId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin({required String address, String? denom}) {
    // TODO: implement getFaucetCoin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Item>> getItem({required String cookBookId, required String itemId}) {
    // TODO: implement getItem
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Item>>> getListItemByOwner({required String owner}) {
    // TODO: implement getListItemByOwner
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PrivateAccountCredentials>> getPrivateCredentials({required String mnemonic, required String username}) {
    // TODO: implement getPrivateCredentials
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, pylons.Recipe>> getRecipe({required String cookBookId, required String recipeId}) {
    // TODO: implement getRecipe
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) {
    // TODO: implement getRecipesBasedOnCookBookId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Trade>>> getTradesBasedOnCreator({required String creator}) {
    // TODO: implement getTradesBasedOnCreator
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getUsername({required String address}) {
    // TODO: implement getUsername
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, StripeLoginLinkResponse>> stripeGetLoginLink(StripeLoginLinkRequest req) {
    // TODO: implement StripeGetLoginLink
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, StripeUpdateAccountResponse>> getAccountLinkBasedOnUpdateToken(StripeUpdateAccountRequest req) async {
    return Right(StripeUpdateAccountResponse(accountlink: MOCK_ACCOUNT_LINK, account: MOCK_ACCOUNT, success: true));
  }

  @override
  Future<Either<Failure, StripeGetLoginBasedOnAddressResponse>> getLoginLinkBasedOnAddress(StripeGetLoginBasedOnAddressRequest req) async {
    return Right(StripeGetLoginBasedOnAddressResponse(accountlink: MOCK_ACCOUNT_LINK, account: MOCK_ACCOUNT, success: true));
  }

  @override
  Future<Either<Failure, IBCTraceModel>> getIBCHashTrace({required String ibcHash}) async {
    return Right(MOCK_IBC_TRACE_MODEL);
  }

  @override
  Future<Either<Failure, bool>> doesStripeAccountExistsFromServer({required String address}) async {
    return const Right(MOCK_STRIPE_ACCOUNT_EXISTS);
  }

  @override
  Either<Failure, bool> getStripeAccountExistsFromLocal() {
    return const Right(MOCK_STRIPE_ACCOUNT_EXISTS);
  }

  @override
  Future saveStripeAccountExistsLocal({required bool isExist}) async {
    return MOCK_STRIPE_ACCOUNT_EXISTS;
  }

  @override
  Either<Failure, String> getDescription() {
    throw UnimplementedError();
  }

  @override
  Either<Failure, String> getImagePath(String uri) {
    throw UnimplementedError();
  }

  @override
  Either<Failure, bool> getIsBannerDark() {
    throw UnimplementedError();
  }

  @override
  Either<Failure, String> getSavedEmail() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> pickImageFromGallery(PickImageModel pickImageModel) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveDescription({required String description}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveEmail({required String value}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveImage({required String key, required String imagePath}) {
    // TODO: implement saveImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveIsBannerDark({required bool isBannerDark}) {
    throw UnimplementedError();
  }

  @override
  Either<Failure, bool> getNotificationsPreference() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> saveImageInLocalDirectory(String imagePath) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveNotificationsPreference({required bool notificationStatus}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> authenticate() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getMnemonic() async {
    return const Right(MOCK_MNEMONIC);
  }

  @override
  Future<Either<Failure, BiometricType>> isBiometricAvailable() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveMnemonic(String mnemonics) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setApplicationDirectory() {
    throw UnimplementedError();
  }

  @override
  Either<Failure, bool> getBiometricLogin() {
    // TODO: implement getBiometricLogin
    throw UnimplementedError();
  }

  @override
  Either<Failure, bool> getBiometricTransaction() {
    // TODO: implement getBiometricTransaction
    throw UnimplementedError();
  }

  @override
  Either<Failure, bool> getSecurityBiometric() {
    // TODO: implement getSecurityBiometric
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveBiometricLogin({required bool biometricEnabled}) {
    // TODO: implement saveBiometricLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveBiometricTransaction({required bool biometricEnabled}) {
    // TODO: implement saveBiometricTransaction
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveDefaultSecurityBiometric({required bool biometricEnabled}) {
    // TODO: implement saveDefaultSecurityBiometric
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TransactionHistory>>> getTransactionHistory({required String address}) {
    // TODO: implement getTransactionHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> updateRecipe({required MsgUpdateRecipe msgUpdateRecipe}) {
    // TODO: implement updateRecipe
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BackupData>> getGoogleDriveMnemonic() {
    // TODO: implement getGoogleDriveMnemonic
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BackupData>> getICloudMnemonic() {
    // TODO: implement getICloudMnemonic
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> uploadMnemonicGoogleDrive({required String mnemonic, required String username}) {
    // TODO: implement uploadMnemonicGoogleDrive
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> uploadMnemonicICloud({required String mnemonic, required String username}) {
    // TODO: implement uploadMnemonicICloud
    throw UnimplementedError();
  }

  @override
  Either<Failure, String> getInitialLink() {
    // TODO: implement getInitialLink
    throw UnimplementedError();
  }

  @override
  Either<Failure, bool> saveInitialLink(String initialLink) {
    // TODO: implement saveInitialLink
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Cookbook>>> getCookbooksByCreator({required String creator}) {
    // TODO: implement getCookbooksByCreator
    throw UnimplementedError();
  }

  @override
  Either<Failure, String> getNetworkEnvironmentPreference() {
    // TODO: implement getNetworkEnvironmentPreference
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Trade>> getTradeByID(Int64 id) {
    // TODO: implement getTradeByID
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveNetworkEnvironmentPreference({required String networkEnvironment}) {
    // TODO: implement saveNetworkEnvironmentPreference
    throw UnimplementedError();
  }

  @override
  Stream<InternetConnectionStatus> getInternetStatus() {
    // TODO: implement getInternetStatus
    throw UnimplementedError();
  }

  @override
  Future<bool> isInternetConnected() {
    // TODO: implement isInternetConnected
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> countAView({required String recipeId, required String cookBookID, required String walletAddress}) {
    return Future.value(const Right(null));
  }

  @override
  Future<Either<Failure, int>> getLikesCount({required String recipeId, required String cookBookID}) {
    return Future.value(const Right(4));
  }

  @override
  Future<Either<Failure, int>> getViewsCount({required String recipeId, required String cookBookID}) {
    return Future.value(const Right(6));
  }

  @override
  Future<Either<Failure, bool>> ifLikedByMe({required String recipeId, required String cookBookID, required String walletAddress}) {
    return Future.value(const Right(true));
  }

  @override
  Future<Either<Failure, void>> updateLikeStatus({required String recipeId, required String cookBookID, required String walletAddress}) {
    // TODO: implement updateLikeStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> sendAppleInAppPurchaseCoinsRequest(AppleInAppPurchaseModel appleInAppPurchaseModel) {
    // TODO: implement isInternetConnected
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> sendGoogleInAppPurchaseCoinsRequest(GoogleInAppPurchaseModel msgGoogleInAPPPurchase) {
    // TODO: implement sendGoogleInAppPurchaseCoinsRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProductDetails>> getProductsForSale({required String itemId}) {
    // TODO: implement getProductsForSale
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> buyProduct(ProductDetails productDetails) {
    // TODO: implement buyProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isInAppPurchaseAvailable() {
    // TODO: implement isInAppPurchaseAvailable
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<NftOwnershipHistory>>> getNftOwnershipHistory({required String itemId, required String cookBookId}) {
    return Future.value(
      Right(
        [MOCK_NFT_OWNERSHIP_HISTORY],
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> updateFcmToken({required String address, required String fcmToken}) {
    // TODO: implement updateFcmToken
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<NotificationMessage>>> getAllNotificationsMessages({required String walletAddress, required int limit, required int offset}) {
    // TODO: implement getAllNotificationsMessages
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getAppCheckToken() {
    // TODO: implement getAppCheckToken
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveInviteeAddressFromDynamicLink({required String dynamicLink}) {
    // TODO: implement saveInviteeAddress
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TransactionResponse>> createAccount({required AccountPublicInfo publicInfo, required WalletCreationModel walletCreationModel}) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> createDynamicLinkForUserInvite({required String address}) {
    // TODO: implement createDynamicLinkForUserInvite
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> createDynamicLinkForRecipeNftShare({required String address, required NFT nft}) {
    // TODO: implement createDynamicLinkForUserInvite
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> markNotificationAsRead({required List<String> idsList}) {
    // TODO: implement markNotificationAsRead
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveUserFeedback({required String walletAddress, required String subject, required String feedback}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> setUserIdentifierInAnalytics({required String address}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteTransactionFailureRecord(int id) {
    // TODO: implement deleteTransactionFailureRecord
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<LocalTransactionModel>>> getAllTransactionFailures() {
    // TODO: implement getAllTransactionFailures
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> saveLocalTransaction(LocalTransactionModel txManager) {
    // TODO: implement saveTransactionFailure
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> logPurchaseItem({required String recipeId, required String recipeName, required String author, required double purchasePrice}) {
    // TODO: implement logPurchaseItem
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> logAddToCart({required String recipeId, required String recipeName, required String author, required double purchasePrice, required String currency}) {
    // TODO: implement logAddToCart
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logUserJourney({required String screenName}) async {
    return const Right(null);
  }
}
