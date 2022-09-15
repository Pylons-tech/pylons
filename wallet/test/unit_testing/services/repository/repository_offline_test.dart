import 'package:fixnum/fixnum.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pylons_wallet/model/stripe_account_link_request.dart';
import 'package:pylons_wallet/model/stripe_account_link_response.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_request.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_response.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_response.dart';
import 'package:pylons_wallet/model/stripe_generate_payout_token_request.dart';
import 'package:pylons_wallet/model/stripe_generate_payout_token_response.dart';
import 'package:pylons_wallet/model/stripe_generate_registration_token_response.dart';
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
import '../../../mocks/mock_network_info_offline.dart';
import '../../../mocks/mock_query_helper.dart';
import '../../../mocks/mock_remote_data_store.dart';
import '../../../mocks/mock_wallet_store.dart';

void main() async {
  dotenv.testLoad(fileInput: '''ENV=true''');
  late http.Client client;
  final mockWalletStore = MockWalletStore();
  final localdataSource = MockLocalDataSource();
  client = MockClient();
  GetIt.I.registerSingleton(MOCK_BASE_ENV);
  GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);
  GetIt.I.registerLazySingleton<MockClient>(() => MockClient());
  final repository = RepositoryImp(
    networkInfo: MockNetworkInfoOffline(),
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
    expect(true, response.isLeft());
    expect(false, result);
  });

  test('test CreatePaymentIntent', () async {
    final req = StripeCreatePaymentIntentRequest(address: MOCK_ADDRESS, coinInputIndex: 0, productID: 'recipe/cookbook_for_test_stripe_5/cookbook_for_test_stripe_5');
    final response = await repository.CreatePaymentIntent(req);
    expect(true, response.getOrElse(() => StripeCreatePaymentIntentResponse()).success);
  });

  test('test GeneratePaymentReceipt', () async {
    final req = StripeGeneratePaymentReceiptRequest(clientSecret: '', paymentIntentID: '');
    final response = await repository.GeneratePaymentReceipt(req);
    expect(true, response.getOrElse(() => StripeGeneratePaymentReceiptResponse()).success);
  });

  test('test GenerateRegistrationToken', () async {
    const address = MOCK_ADDRESS;

    final response = await repository.GenerateRegistrationToken(address);
    expect(true, response.getOrElse(() => StripeGenerateRegistrationTokenResponse()).success);
  });

  test('test RegisterAccount', () async {
    final req = StripeRegisterAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');
    final response = await repository.RegisterAccount(req);
    expect(true, response.getOrElse(() => StripeRegisterAccountResponse()).success);
  });

  test('test GenerateUpdateToken', () async {
    final response = await repository.GenerateUpdateToken(MOCK_ADDRESS);
    expect(true, response.getOrElse(() => StripeGenerateUpdateTokenResponse()).success);
  });

  test('test UpdateAccount', () async {
    final req = StripeUpdateAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');
    final response = await repository.UpdateAccount(req);
    expect(true, response.getOrElse(() => StripeUpdateAccountResponse()).success);
  });

  test('test GeneratePayoutToken', () async {
    final req = StripeGeneratePayoutTokenRequest(address: '', amount: Int64.ONE);
    final response = await repository.GeneratePayoutToken(req);
    expect(true, response.getOrElse(() => StripeGeneratePayoutTokenResponse()).success);
  });

  test('test Payout', () async {
    final req = StripePayoutRequest(
      amount: Int64.ONE,
    );
    final response = await repository.Payout(req);
    expect(true, response.getOrElse(() => StripePayoutResponse()).success);
  });

  test('test GetAccountLink', () async {
    final req = StripeAccountLinkRequest(Signature: '', Account: '');
    final response = await repository.GetAccountLink(req);
    expect(false, response.getOrElse(() => StripeAccountLinkResponse()).success);
  });

  test('should get account link and account on  getAccountLinkBasedOnUpdateToken', () async {
    final response = await repository.getAccountLinkBasedOnUpdateToken(MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST);

    expect(true, response.isRight());
    expect(true, response.toOption().toNullable()!.success);
    expect(MOCK_ACCOUNT_LINK, response.toOption().toNullable()!.accountlink);
    expect(MOCK_ACCOUNT, response.toOption().toNullable()!.account);
  });

  test('should get account link and account on  getLoginLinkBasedOnAddress', () async {
    final response = await repository.getLoginLinkBasedOnAddress(MOCK_STRIPE_LOGIN_BASED_ADDRESS_REQUEST);

    expect(true, response.isRight());
    expect(true, response.toOption().toNullable()!.success);
    expect(MOCK_ACCOUNT_LINK, response.toOption().toNullable()!.accountlink);
    expect(MOCK_ACCOUNT, response.toOption().toNullable()!.account);
  });
}
