import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
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
  late http.Client client;
  dotenv.testLoad(fileInput: '''ENV=true''');
  final mockWalletStore = MockWalletStore();
  final localdataSource = MockLocalDataSource();
  client = MockClient();
  GetIt.I.registerSingleton(MOCK_BASE_ENV);
  GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

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

  //TODO: HAVE TO REFACTOR THESE CASES LATER
  //
  // test('test CreatePaymentIntent', () async {
  //   final req = StripeCreatePaymentIntentRequest(address: MOCK_ADDRESS, coinInputIndex: 0, productID: 'recipe/cookbook_for_test_stripe_5/cookbook_for_test_stripe_5');
  //
  //   // when(client.post(Uri.parse("$MOCK_BASE_URL/create-payment-intent"), body: jsonEncode(req))).thenAnswer(
  //   //   (realInvocation) async => http.Response(
  //   //     jsonEncode({
  //   //       'result': true,
  //   //       'message': 'Create payment intent',
  //   //       'data': {"success": true}
  //   //     }),
  //   //     200,
  //   //   ),
  //   // );
  //   final response = await repository.CreatePaymentIntent(req);
  //   expect(true, response.getOrElse(() => StripeCreatePaymentIntentResponse()).success);
  // });
  //
  // test('test GeneratePaymentReceipt', () async {
  //   final req = StripeGeneratePaymentReceiptRequest(clientSecret: '', paymentIntentID: '');
  //   final response = await repository.GeneratePaymentReceipt(req);
  //   expect(true, response.getOrElse(() => StripeGeneratePaymentReceiptResponse()).success);
  // });
  //
  // test('test GenerateRegistrationToken', () async {
  //   const address = MOCK_ADDRESS;
  //
  //   final response = await repository.GenerateRegistrationToken(address);
  //   expect(true, response.getOrElse(() => StripeGenerateRegistrationTokenResponse()).success);
  // });
  //
  // test('test RegisterAccount', () async {
  //   // when(client.post(Uri.parse("$MOCK_BASE_URL/register-account"), body: jsonEncode(req))).thenAnswer(
  //   //   (realInvocation) async => http.Response(
  //   //     jsonEncode({
  //   //       'result': true,
  //   //       'message': 'Create payment intent',
  //   //       'data': {"accountlink": "https://connect.stripe.com/setup/e/acct_1LjyYMQbO6Fk1HCk/8dhWlWts0BbN", "account": "acct_1LjyYMQbO6Fk1HCk"}
  //   //     }),
  //   //     200,
  //   //   ),
  //   // );
  //   final req = StripeRegisterAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');
  //   final response = await repository.RegisterAccount(req);
  //   expect(true, response.getOrElse(() => StripeRegisterAccountResponse()).success);
  // });
  //
  // test('test GenerateUpdateToken', () async {
  //   final response = await repository.GenerateUpdateToken(MOCK_ADDRESS);
  //   expect(true, response.getOrElse(() => StripeGenerateUpdateTokenResponse()).success);
  // });
  //
  // test('test UpdateAccount', () async {
  //   final req = StripeUpdateAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');
  //   final response = await repository.UpdateAccount(req);
  //   expect(true, response.getOrElse(() => StripeUpdateAccountResponse()).success);
  // });
  //
  // test('test GeneratePayoutToken', () async {
  //   final req = StripeGeneratePayoutTokenRequest(address: '', amount: Int64.ONE);
  //   final response = await repository.GeneratePayoutToken(req);
  //   expect(true, response.getOrElse(() => StripeGeneratePayoutTokenResponse()).success);
  // });
  //
  // test('test Payout', () async {
  //   final req = StripePayoutRequest(
  //     amount: Int64.ONE,
  //   );
  //   final response = await repository.Payout(req);
  //   expect(true, response.getOrElse(() => StripePayoutResponse()).success);
  // });
  //
  // test('test GetAccountLink', () async {
  //   final req = StripeAccountLinkRequest(Signature: '', Account: '');
  //   final response = await repository.GetAccountLink(req);
  //   expect(true, response.getOrElse(() => StripeAccountLinkResponse()).success);
  // });
  //
  // test('should get account link and account on  getAccountLinkBasedOnUpdateToken', () async {
  //   final response = await repository.getAccountLinkBasedOnUpdateToken(MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST);
  //
  //   expect(true, response.isRight());
  //   expect(true, response.toOption().toNullable()!.success);
  //   expect(MOCK_ACCOUNT_LINK, response.toOption().toNullable()!.accountlink);
  //   expect(MOCK_ACCOUNT, response.toOption().toNullable()!.account);
  // });
  //
  // test('should get account link and account on  getLoginLinkBasedOnAddress', () async {
  //   final response = await repository.getLoginLinkBasedOnAddress(MOCK_STRIPE_LOGIN_BASED_ADDRESS_REQUEST);
  //
  //   expect(true, response.isRight());
  //   expect(true, response.toOption().toNullable()!.success);
  //   expect(MOCK_ACCOUNT_LINK, response.toOption().toNullable()!.accountlink);
  //   expect(MOCK_ACCOUNT, response.toOption().toNullable()!.account);
  // });
}
