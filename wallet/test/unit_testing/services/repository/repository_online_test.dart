import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/model/stripe_account_link_request.dart';
import 'package:pylons_wallet/model/stripe_account_link_response.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_request.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_response.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_response.dart';
import 'package:pylons_wallet/model/stripe_generate_payout_token_request.dart';
import 'package:pylons_wallet/model/stripe_generate_payout_token_response.dart';
import 'package:pylons_wallet/model/stripe_generate_update_token_response.dart';
import 'package:pylons_wallet/model/stripe_payout_request.dart';
import 'package:pylons_wallet/model/stripe_payout_response.dart';
import 'package:pylons_wallet/model/stripe_register_account_response.dart';
import 'package:pylons_wallet/model/stripe_register_acount_request.dart';
import 'package:pylons_wallet/model/stripe_update_account_request.dart';
import 'package:pylons_wallet/model/stripe_update_account_response.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_crashlytics_helper.dart';
import '../../../mocks/mock_google_drive_helper.dart';
import '../../../mocks/mock_http_client.dart';
import '../../../mocks/mock_icloud_drive_helper.dart';
import '../../../mocks/mock_local_auth_helper.dart';
import '../../../mocks/mock_local_data_source.dart';
import '../../../mocks/mock_network_info_online.dart';
import '../../../mocks/mock_query_helper.dart';
import '../../../mocks/mock_remote_data_store.dart';
import '../../../mocks/mock_wallet_store.dart';

void main() async {
  dotenv.testLoad(fileInput: '''ENV=true''');
  late http.Client client;
  final mockWalletStore = MockWalletStore();
  final localdataSource = MockLocalDataSource();
  client = MockClient();
  GetIt.I.registerLazySingleton(() => MOCK_BASE_ENV);
  GetIt.I.registerLazySingleton<WalletsStore>(() => mockWalletStore);

  final repository = RepositoryImp(
    networkInfo: MockNetworkInfoOnline(),
    queryHelper: MockQueryHelper(httpClient: client),
    localAuthHelper: MockLocalAuthHelper(),
    remoteDataStore: MockRemoteDataStore(),
    googleDriveApi: MockGoogleDriveHelper(),
    iCloudDriverApi: MockICloudDriveHelper(),
    crashlyticsHelper: MockCrashlytics(),
    localDataSource: localdataSource,
  );
  GetIt.I.registerSingleton<Repository>(repository);

  test("test for adding pylons coins", () async {
    final response = await repository.buyProduct(DUMMY_PRODUCT_DETAILS);
    final result = response.getOrElse(() => false);
    expect(true, result);
  });

  test("test for get username", () async {
    final response = await repository.getUsername(address: MOCK_ADDRESS);
    final result = response.getOrElse(() => '');
    expect(true, response.isRight());
    expect(MOCK_USERNAME, result);
  });

  test("test for get recipe ", () async {
    final response = await repository.getRecipe(cookBookId: MOCK_COOKBOOK_ID, recipeId: MOCK_RECIPE_ID);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_RECIPE_MODEL, r));
  });

  test("test for get cookbook ", () async {
    final response = await repository.getCookbookBasedOnId(cookBookId: MOCK_COOKBOOK_ID);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_COOKBOOK_MODEL, r));
  });

  test("test for get address based on username ", () async {
    final response = await repository.getAddressBasedOnUsername(MOCK_USERNAME);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_ADDRESS, r));
  });

  test("test for get list of balances", () async {
    final response = await repository.getBalance(MOCK_ADDRESS);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_BALANCE, r));
  });

  test("test for createDynamicLinkForRecipeNftShare", () async {
    final response = await repository.createDynamicLinkForRecipeNftShare(address: MOCK_ADDRESS, nft: MOCK_NFT_FREE);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_DYNAMIC_LINK, r));
  });

  test("test for get executions for recipe", () async {
    final response = await repository.getExecutionsByRecipeId(cookBookId: MOCK_COOKBOOK_ID, recipeId: MOCK_RECIPE_ID);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_EXECUTION_LIST_BY_RECIPE_RESPONSE, r));
  });
  test("test for get executions for recipe", () async {
    final response = await repository.getExecutionsByRecipeId(cookBookId: MOCK_COOKBOOK_ID, recipeId: MOCK_RECIPE_ID);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_EXECUTION_LIST_BY_RECIPE_RESPONSE, r));
  });

  test("test for get item", () async {
    final response = await repository.getItem(cookBookId: MOCK_COOKBOOK_ID, itemId: MOCK_ITEM_ID);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_ITEM, r));
  });

  test("test for get list item by owner", () async {
    final response = await repository.getListItemByOwner(owner: MOCK_USERNAME);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect([MOCK_ITEM], r));
  });

  test("test for get execution based on id", () async {
    final response = await repository.getExecutionBasedOnId(id: MOCK_ID);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_EXECUTION, r));
  });

  test("test for get trade based on creator", () async {
    final response = await repository.getTradesBasedOnCreator(creator: MOCK_USERNAME);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect([MOCK_TRADE], r));
  });

  test("test for getStripeAccountExistsFromLocal", () async {
    final response = repository.getStripeAccountExistsFromLocal();
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(MOCK_STRIPE_ACCOUNT_EXISTS, r));
  });

  test('test GenerateRegistrationToken', () async {
    const address = MOCK_ADDRESS;
    final response = await repository.GenerateRegistrationToken(address);
    expect(true, response.isRight());
    response.fold((l) => throw MOCK_SOMETHING_WENT_WRONG, (r) => expect(true, r.success));
  });

  test('should get account link and account on  getLoginLinkBasedOnAddress', () async {
    final response = await repository.getLoginLinkBasedOnAddress(MOCK_STRIPE_LOGIN_BASED_ADDRESS_REQUEST);

    expect(true, response.isRight());
    expect(false, response.toOption().toNullable()!.success);
    expect(MOCK_ACCOUNT_LINK, response.toOption().toNullable()!.accountlink);
    expect(MOCK_ACCOUNT, response.toOption().toNullable()!.account);
  });

  test('should get account link and account on  getAccountLinkBasedOnUpdateToken', () async {
    final response = await repository.getAccountLinkBasedOnUpdateToken(MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST);
    expect(true, response.isRight());
    expect(false, response.toOption().toNullable()!.success);
    expect(MOCK_ACCOUNT_LINK, response.toOption().toNullable()!.accountlink);
    expect(MOCK_ACCOUNT, response.toOption().toNullable()!.account);
  });

  test('test UpdateAccount', () async {
    final req = StripeUpdateAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');
    final response = await repository.UpdateAccount(req);
    expect(false, response.getOrElse(() => StripeUpdateAccountResponse()).success);
    expect(MOCK_ACCOUNT, response.getOrElse(() => StripeUpdateAccountResponse()).account);
    expect(MOCK_ACCOUNT_LINK, response.getOrElse(() => StripeUpdateAccountResponse()).accountlink);
  });

  test('test GenerateUpdateToken', () async {
    final response = await repository.GenerateUpdateToken(MOCK_ADDRESS);
    expect(true, response.getOrElse(() => StripeGenerateUpdateTokenResponse()).success);
    expect(MOCK_TOKEN, response.getOrElse(() => StripeGenerateUpdateTokenResponse()).token);
  });

  test('test RegisterAccount', () async {
    final req = StripeRegisterAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');
    final response = await repository.RegisterAccount(req);
    expect(true, response.getOrElse(() => StripeRegisterAccountResponse()).success);
    expect(MOCK_ACCOUNT_LINK, response.getOrElse(() => StripeRegisterAccountResponse()).accountlink);
    expect(MOCK_ACCOUNT, response.getOrElse(() => StripeRegisterAccountResponse()).account);
  });

  test('test CreatePaymentIntent', () async {
    final req = StripeCreatePaymentIntentRequest(address: MOCK_ADDRESS, coinInputIndex: 0, productID: MOCK_PRODUCT_ID);
    when(client.post(Uri.parse("$MOCK_BASE_URL/create-payment-intent"), body: jsonEncode(req), headers: {"Content-type": "application/json"})).thenAnswer(
      (realInvocation) async => http.Response(
        jsonEncode({"clientSecret": MOCK_CLIENT_SECRET}),
        200,
      ),
    );
    final response = await repository.CreatePaymentIntent(req);
    expect(MOCK_CLIENT_SECRET, response.getOrElse(() => StripeCreatePaymentIntentResponse()).clientsecret);
  });

  test('test GeneratePaymentReceipt', () async {
    final req = StripeGeneratePaymentReceiptRequest(clientSecret: MOCK_CLIENT_SECRET, paymentIntentID: MOCK_PAYMENT_INTENT_ID);
    when(client.post(Uri.parse("$MOCK_BASE_URL/generate-payment-receipt"), body: jsonEncode(req), headers: {"Content-type": "application/json"})).thenAnswer(
      (realInvocation) async => http.Response(
        jsonEncode(
            {"purchaseID": MOCK_PURCHASE_ID, "processorName": MOCK_PROCESSOR_NAME, "payerAddr": MOCK_PAYER_ADDR, "amount": MOCK_AMOUNT, "productID": MOCK_PRODUCT_ID, "signature": MOCK_SIGNATURE}),
        200,
      ),
    );
    final response = await repository.GeneratePaymentReceipt(req);
    expect(true, response.getOrElse(() => StripeGeneratePaymentReceiptResponse()).success);
    expect(MOCK_PURCHASE_ID, response.getOrElse(() => StripeGeneratePaymentReceiptResponse()).purchaseID);
  });

  test('test GeneratePayoutToken', () async {
    final req = StripeGeneratePayoutTokenRequest(address: MOCK_ADDRESS, amount: Int64.ONE);
    when(client.get(Uri.parse("$MOCK_BASE_URL/generate-payout-token?address=${req.address}&amount=${req.amount}"), headers: {"Content-type": "application/json"})).thenAnswer(
      (realInvocation) async => http.Response(
        jsonEncode({"token": MOCK_TOKEN}),
        200,
      ),
    );
    final response = await repository.GeneratePayoutToken(req);
    expect(true, response.getOrElse(() => StripeGeneratePayoutTokenResponse()).success);
  });

  test('test Payout', () async {
    final req = StripePayoutRequest(
      amount: Int64.ONE,
    );
    when(client.post(Uri.parse("$MOCK_BASE_URL/payout"), body: jsonEncode(req), headers: {"Content-type": "application/json"})).thenAnswer(
      (realInvocation) async => http.Response(
        jsonEncode({"transfer_id": MOCK_TRANSFER}),
        200,
      ),
    );
    final response = await repository.Payout(req);
    expect(true, response.getOrElse(() => StripePayoutResponse()).success);
    expect(MOCK_TRANSFER, response.getOrElse(() => StripePayoutResponse()).transfer_id);
  });

  test('test GetAccountLink', () async {
    final req = StripeAccountLinkRequest(Signature: MOCK_SIGNATURE, Account: MOCK_ACCOUNT);
    when(client.post(Uri.parse("$MOCK_BASE_URL/accountlink"), body: jsonEncode(req), headers: {"Content-type": "application/json"})).thenAnswer(
      (realInvocation) async => http.Response(
        jsonEncode({"accountlink": MOCK_ACCOUNT_LINK, "account": MOCK_ACCOUNT}),
        200,
      ),
    );
    final response = await repository.GetAccountLink(req);
    expect(true, response.getOrElse(() => StripeAccountLinkResponse()).success);
    expect(MOCK_ACCOUNT, response.getOrElse(() => StripeAccountLinkResponse()).account);
    expect(MOCK_ACCOUNT_LINK, response.getOrElse(() => StripeAccountLinkResponse()).accountlink);
  });
}
