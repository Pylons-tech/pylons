import 'package:fixnum/fixnum.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/model/execution_list_by_recipe_response.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/nft_ownership_history.dart';
import 'package:pylons_wallet/model/notification_message.dart';
import 'package:pylons_wallet/model/stripe_generate_registration_token_response.dart';
import 'package:pylons_wallet/model/stripe_generate_update_token_response.dart';
import 'package:pylons_wallet/model/stripe_get_login_based_address.dart';
import 'package:pylons_wallet/model/stripe_register_account_response.dart';
import 'package:pylons_wallet/model/stripe_register_acount_request.dart';
import 'package:pylons_wallet/model/stripe_update_account_request.dart';
import 'package:pylons_wallet/model/stripe_update_account_response.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/model/wallet_creation_model.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/cookbook.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/execution.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/trade.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/tx.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_trace_model.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';

import 'mock_constants.dart';

class MockRemoteDataStore extends RemoteDataStore {
  @override
  Future<bool> buyProduct(ProductDetails productDetails) {
    return Future.value(true);
  }

  @override
  Future<void> countAView({required String recipeId, required String cookBookID, required String walletAddress}) {
    // TODO: implement countAView
    throw UnimplementedError();
  }

  @override
  Future<TransactionResponse> createAccount({required AccountPublicInfo publicInfo, required WalletCreationModel walletCreationModel, required String appCheckToken, required String referralToken}) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<String> createDynamicLinkForItemNftShare({required String address, required String itemId, required String cookbookId}) {
    // TODO: implement createDynamicLinkForItemNftShare
    throw UnimplementedError();
  }

  @override
  Future<String> createDynamicLinkForRecipeNftShare({required String address, required NFT nft}) {
    return Future.value(MOCK_DYNAMIC_LINK);
  }

  @override
  Future<String> createDynamicLinkForTradeNftShare({required String address, required String tradeId}) {
    // TODO: implement createDynamicLinkForTradeNftShare
    throw UnimplementedError();
  }

  @override
  Future<String> createDynamicLinkForUserInvite({required String address}) {
    // TODO: implement createDynamicLinkForUserInvite
    throw UnimplementedError();
  }

  @override
  Future<bool> doesStripeAccountExists({required String address}) {
    // TODO: implement doesStripeAccountExists
    throw UnimplementedError();
  }

  @override
  Future<StripeGenerateRegistrationTokenResponse> generateStripeRegistrationToken({required String address}) {
    // TODO: implement generateStripeRegistrationToken
    throw UnimplementedError();
  }

  @override
  Future<StripeGenerateUpdateTokenResponse> generateUpdateToken({required String address}) {
    // TODO: implement generateUpdateToken
    throw UnimplementedError();
  }

  @override
  Future<StripeUpdateAccountResponse> getAccountLinkBasedOnUpdateToken({required StripeUpdateAccountRequest req}) {
    // TODO: implement getAccountLinkBasedOnUpdateToken
    throw UnimplementedError();
  }

  @override
  Future<String> getAddressBasedOnUsername(String username) {
    return Future.value(MOCK_ADDRESS);
  }

  @override
  Future<List<NotificationMessage>> getAllNotificationMessages({required String walletAddress, required int limit, required int offset}) {
    // TODO: implement getAllNotificationMessages
    throw UnimplementedError();
  }

  @override
  Future<String> getAppCheckToken() {
    // TODO: implement getAppCheckToken
    throw UnimplementedError();
  }

  @override
  Future<List<Balance>> getBalance(String walletAddress) {
    return Future.value(MOCK_BALANCE);
  }

  @override
  Future<Cookbook> getCookbookBasedOnId({required String cookBookId}) {
    return Future.value(MOCK_COOKBOOK_MODEL);
  }

  @override
  Future<List<Cookbook>> getCookbooksByCreator({required String address}) {
    // TODO: implement getCookbooksByCreator
    throw UnimplementedError();
  }

  @override
  Future<Execution> getExecutionBasedOnId({required String id}) {
    return Future.value(MOCK_EXECUTION);
  }

  @override
  Future<ExecutionListByRecipeResponse> getExecutionsByRecipeId({required String cookBookId, required String recipeId}) {
    return Future.value(MOCK_EXECUTION_LIST_BY_RECIPE_RESPONSE);
  }

  @override
  Future<IBCTraceModel> getIBCHashTrace({required String ibcHash}) {
    // TODO: implement getIBCHashTrace
    throw UnimplementedError();
  }

  @override
  Future<Item> getItem({required String cookBookId, required String itemId}) {
    return Future.value(MOCK_ITEM);
  }

  @override
  Future<int> getLikesCount({required String recipeId, required String cookBookID}) {
    // TODO: implement getLikesCount
    throw UnimplementedError();
  }

  @override
  Future<List<Item>> getListItemByOwner({required String owner}) {
    return Future.value([MOCK_ITEM]);
  }

  @override
  Future<StripeGetLoginBasedOnAddressResponse> getLoginLinkBasedOnAddress({required StripeGetLoginBasedOnAddressRequest req}) {
    // TODO: implement getLoginLinkBasedOnAddress
    throw UnimplementedError();
  }

  @override
  Future<List<NftOwnershipHistory>> getNftOwnershipHistory({required String itemId, required String cookBookId}) {
    // TODO: implement getNftOwnershipHistory
    throw UnimplementedError();
  }

  @override
  Future<ProductDetails> getProductsForSale({required String itemId}) {
    // TODO: implement getProductsForSale
    throw UnimplementedError();
  }

  @override
  Future<pylons.Recipe> getRecipe({required String cookBookId, required String recipeId}) {
    return Future.value(MOCK_RECIPE_MODEL);
  }

  @override
  Future<List<Recipe>> getRecipesBasedOnCookBookId({required String cookBookId}) {
    // TODO: implement getRecipesBasedOnCookBookId
    throw UnimplementedError();
  }

  @override
  Future<Trade> getTradeByID({required Int64 id}) {
    // TODO: implement getTradeByID
    throw UnimplementedError();
  }

  @override
  Future<List<Trade>> getTradesBasedOnCreator({required String creator}) {
    return Future.value([MOCK_TRADE]);
  }

  @override
  Future<List<TransactionHistory>> getTransactionHistory({required String address}) {
    // TODO: implement getTransactionHistory
    throw UnimplementedError();
  }

  @override
  Future<String> getUsername({required String address}) {
    return Future.value(MOCK_USERNAME);
  }

  @override
  Future<int> getViewsCount({required String recipeId, required String cookBookID}) {
    // TODO: implement getViewsCount
    throw UnimplementedError();
  }

  @override
  Future<bool> ifLikedByMe({required String recipeId, required String cookBookID, required String walletAddress}) {
    // TODO: implement ifLikedByMe
    throw UnimplementedError();
  }

  @override
  Future<bool> isInAppPurchaseAvailable() {
    return Future.value(true);
  }

  @override
  Future<bool> markNotificationAsRead({required List<String> idsList, required String appCheckToken}) {
    // TODO: implement markNotificationAsRead
    throw UnimplementedError();
  }

  @override
  Future<StripeRegisterAccountResponse> registerAccount({required StripeRegisterAccountRequest req}) {
    // TODO: implement registerAccount
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUserFeedback({required String walletAddress, required String subject, required String feedback}) {
    // TODO: implement saveUserFeedback
    throw UnimplementedError();
  }

  @override
  Future<String> sendAppleInAppPurchaseCoinsRequest(AppleInAppPurchaseModel googleInAppPurchaseModel) {
    // TODO: implement sendAppleInAppPurchaseCoinsRequest
    throw UnimplementedError();
  }

  @override
  Future<String> sendGoogleInAppPurchaseCoinsRequest(GoogleInAppPurchaseModel googleInAppPurchaseModel) {
    // TODO: implement sendGoogleInAppPurchaseCoinsRequest
    throw UnimplementedError();
  }

  @override
  Future<bool> setUpUserIdentifierInAnalytics({required String address}) {
    // TODO: implement setUpUserIdentifierInAnalytics
    throw UnimplementedError();
  }

  @override
  Future<bool> updateFcmToken({required String address, required String fcmToken, required String appCheckToken}) {
    // TODO: implement updateFcmToken
    throw UnimplementedError();
  }

  @override
  Future<void> updateLikeStatus({required String recipeId, required String cookBookID, required String walletAddress}) {
    // TODO: implement updateLikeStatus
    throw UnimplementedError();
  }

  @override
  Future<String> updateRecipe({required MsgUpdateRecipe msgUpdateRecipe}) {
    // TODO: implement updateRecipe
    throw UnimplementedError();
  }

  @override
  Future<StripeUpdateAccountResponse> updateStripeAccount({required StripeUpdateAccountRequest req}) {
    // TODO: implement updateStripeAccount
    throw UnimplementedError();
  }
}
