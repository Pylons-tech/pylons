import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/model/stripe_get_login_based_address.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/connectivity_info.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/query_helper.dart';

import '../../../mocks/main_mock.mocks.dart';
import '../../../mocks/mock_constants.dart';

void main() {
  group("$RepositoryImp", () {
    late ConnectivityInfoImpl networkInfo;
    late Repository repository;
    late MockQueryHelper mockQueryHelper;
    late MockRemoteDataStore mockRemoteDataStore;
    late MockLocalDataSource mockLocalDataSource;

    final baseEnv = BaseEnv()
      ..setEnv(
        lcdUrl: "",
        grpcUrl: "",
        lcdPort: "8000",
        grpcPort: "8000",
        ethUrl: "",
        chainId: "",
        faucetUrl: "",
        ibcTraceUrl: "",
        mongoUrl: "",
        skus: "[]",
        stripeUrl: "stripe",
      );

    setUp(() {
      mockRemoteDataStore = MockRemoteDataStore();
      networkInfo = MockConnectivityInfoImpl();
      mockQueryHelper = MockQueryHelper();
      mockLocalDataSource = MockLocalDataSource();
      repository = RepositoryImp(
        googleDriveApi: MockGoogleDriveApiImpl(),
        iCloudDriverApi: MockICloudDriverApiImpl(),
        localAuthHelper: MockLocalAuthHelper(),
        localDataSource: mockLocalDataSource,
        onLogError: (exception, {bool fatal = false, StackTrace? stack}) {},
        networkInfo: networkInfo,
        remoteDataStore: mockRemoteDataStore,
        queryHelper: mockQueryHelper,
        getBaseEnv: () => baseEnv,
      );

      when(networkInfo.isConnected).thenAnswer((realInvocation) async => true);
    });

    group("CreatePaymentIntent", () {
      late Either<Failure, StripeCreatePaymentIntentResponse> response;
      late StripeCreatePaymentIntentRequest request;

      group("when the call is successful", () {
        setUp(() async {
          when(mockQueryHelper.queryPost(any, any)).thenAnswer(
            (_) async => const RequestResult<Map<String, dynamic>>(value: {
              "success": true,
              "clientsecret": "",
            }),
          );

          request = StripeCreatePaymentIntentRequest(
            address: MOCK_ADDRESS,
            coinInputIndex: 0,
            productID: 'recipe/cookbook_for_test_stripe_5/cookbook_for_test_stripe_5',
          );
          response = await repository.CreatePaymentIntent(request);
        });

        test("then the queryPost method is called", () async {
          verify(mockQueryHelper.queryPost("${baseEnv.baseStripeUrl}/create-payment-intent", request.toJson()))
              .called(1);
        });

        test("then the response is successful", () async {
          expect(true, response.getOrElse(() => StripeCreatePaymentIntentResponse()).success);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockQueryHelper.queryPost(any, any)).thenThrow(
            Exception(""),
          );

          request = StripeCreatePaymentIntentRequest(
            address: MOCK_ADDRESS,
            coinInputIndex: 0,
            productID: 'recipe/cookbook_for_test_stripe_5/cookbook_for_test_stripe_5',
          );
          response = await repository.CreatePaymentIntent(request);
        });

        test("then the queryPost method is called", () async {
          verify(mockQueryHelper.queryPost("${baseEnv.baseStripeUrl}/create-payment-intent", request.toJson()))
              .called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("GeneratePaymentReceipt", () {
      late Either<Failure, StripeGeneratePaymentReceiptResponse> response;
      late StripeGeneratePaymentReceiptRequest request;

      group("when the call is successful", () {
        setUp(() async {
          when(mockLocalDataSource.saveTransactionFailure(any)).thenAnswer((_) async => 0);
          when(mockQueryHelper.queryPost(any, any)).thenAnswer(
            (_) async => const RequestResult<Map<String, dynamic>>(value: {
              "success": true,
            }),
          );

          request = request = StripeGeneratePaymentReceiptRequest(clientSecret: '', paymentIntentID: '');
          response = await repository.GeneratePaymentReceipt(request);
        });

        test("then the queryPost method is called", () async {
          verify(mockQueryHelper.queryPost("${baseEnv.baseStripeUrl}/generate-payment-receipt", request.toJson()))
              .called(1);
        });

        test("then the response is successful", () async {
          expect(true, response.getOrElse(() => StripeGeneratePaymentReceiptResponse()).success);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockLocalDataSource.saveTransactionFailure(any)).thenAnswer((_) async => 0);

          when(mockQueryHelper.queryPost(any, any)).thenThrow(
            Exception(""),
          );

          request = StripeGeneratePaymentReceiptRequest(clientSecret: '', paymentIntentID: '');
          response = await repository.GeneratePaymentReceipt(request);
        });

        test("then the queryPost method is called", () async {
          verify(mockQueryHelper.queryPost("${baseEnv.baseStripeUrl}/generate-payment-receipt", request.toJson()))
              .called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("GenerateRegistrationToken", () {
      late Either<Failure, StripeGenerateRegistrationTokenResponse> response;

      group("when the call is successful", () {
        setUp(() async {
          when(mockRemoteDataStore.generateStripeRegistrationToken(address: anyNamed("address")))
              .thenAnswer((_) async => StripeGenerateRegistrationTokenResponse(success: true));

          response = await repository.GenerateRegistrationToken(MOCK_ADDRESS);
        });

        test("then the remote data store generateStripeRegistrationToken method is called", () async {
          verify(mockRemoteDataStore.generateStripeRegistrationToken(address: MOCK_ADDRESS)).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockRemoteDataStore.generateStripeRegistrationToken(address: anyNamed("address"))).thenThrow(
            Exception(""),
          );

          response = await repository.GenerateRegistrationToken(MOCK_ADDRESS);
        });

        test("then the remote data store generateStripeRegistrationToken method is called", () async {
          verify(mockRemoteDataStore.generateStripeRegistrationToken(address: MOCK_ADDRESS)).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("RegisterAccount", () {
      late Either<Failure, StripeRegisterAccountResponse> response;
      late StripeRegisterAccountRequest stripeRegisterAccountRequest;

      group("when the call is successful", () {
        setUp(() async {
          when(mockRemoteDataStore.registerAccount(req: anyNamed("req")))
              .thenAnswer((_) async => StripeRegisterAccountResponse(success: true));

          stripeRegisterAccountRequest = StripeRegisterAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');

          response = await repository.RegisterAccount(stripeRegisterAccountRequest);
        });

        test("then the remote data store RegisterAccount method is called", () async {
          verify(mockRemoteDataStore.registerAccount(req: stripeRegisterAccountRequest)).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockRemoteDataStore.registerAccount(req: anyNamed("req"))).thenThrow(
            Exception(""),
          );

          response = await repository.RegisterAccount(stripeRegisterAccountRequest);
        });

        test("then the remote data store RegisterAccount method is called", () async {
          verify(mockRemoteDataStore.registerAccount(req: stripeRegisterAccountRequest)).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("GenerateUpdateToken", () {
      late Either<Failure, StripeGenerateUpdateTokenResponse> response;

      group("when the call is successful", () {
        setUp(() async {
          when(mockRemoteDataStore.generateUpdateToken(address: anyNamed("address")))
              .thenAnswer((_) async => StripeGenerateUpdateTokenResponse(success: true));

          response = await repository.GenerateUpdateToken(MOCK_ADDRESS);
        });

        test("then the remote data store generateUpdateToken method is called", () async {
          verify(mockRemoteDataStore.generateUpdateToken(address: MOCK_ADDRESS)).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockRemoteDataStore.generateUpdateToken(address: anyNamed("address"))).thenThrow(
            Exception(""),
          );

          response = await repository.GenerateUpdateToken(MOCK_ADDRESS);
        });

        test("then the remote data store generateUpdateToken method is called", () async {
          verify(mockRemoteDataStore.generateUpdateToken(address: MOCK_ADDRESS)).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("UpdateAccount", () {
      late Either<Failure, StripeUpdateAccountResponse> response;
      late StripeUpdateAccountRequest request;

      group("when the call is successful", () {
        setUp(() async {
          when(mockRemoteDataStore.updateStripeAccount(req: anyNamed("req")))
              .thenAnswer((_) async => StripeUpdateAccountResponse(success: true));

          request = StripeUpdateAccountRequest(Signature: '', Address: MOCK_ADDRESS, Token: '');

          response = await repository.UpdateAccount(request);
        });

        test("then the remote data store generateUpdateToken method is called", () async {
          verify(mockRemoteDataStore.updateStripeAccount(req: request)).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockRemoteDataStore.updateStripeAccount(req: anyNamed("req"))).thenThrow(
            Exception(""),
          );

          response = await repository.UpdateAccount(request);
        });

        test("then the remote data store updateStripeAccount method is called", () async {
          verify(mockRemoteDataStore.updateStripeAccount(req: request)).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("GeneratePayoutToken", () {
      late Either<Failure, StripeGeneratePayoutTokenResponse> response;
      late StripeGeneratePayoutTokenRequest request;

      group("when the call is successful", () {
        setUp(() async {
          when(mockQueryHelper.queryGet(any)).thenAnswer(
            (_) async => const RequestResult<Map<String, dynamic>>(value: {
              "success": true,
            }),
          );

          request = StripeGeneratePayoutTokenRequest(address: MOCK_ADDRESS, amount: Int64());

          response = await repository.GeneratePayoutToken(request);
        });

        test("then the queryGet method is called", () async {
          verify(mockQueryHelper.queryGet(any)).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockQueryHelper.queryGet(any)).thenThrow(
            Exception(""),
          );

          response = await repository.GeneratePayoutToken(request);
        });

        test("then the queryGet method is called", () async {
          verify(mockQueryHelper.queryGet(any)).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("GetAccountLink", () {
      late Either<Failure, StripeAccountLinkResponse> response;
      late StripeAccountLinkRequest request;

      group("when the call is successful", () {
        setUp(() async {
          when(mockQueryHelper.queryPost(any, any)).thenAnswer(
            (_) async => const RequestResult<Map<String, dynamic>>(value: {
              "success": true,
            }),
          );

          request = StripeAccountLinkRequest(Signature: '', Account: '');

          response = await repository.GetAccountLink(request);
        });

        test("then the queryPost method is called", () async {
          verify(mockQueryHelper.queryPost(any, any)).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockQueryHelper.queryPost(any, any)).thenThrow(
            Exception(""),
          );

          response = await repository.GetAccountLink(request);
        });

        test("then the queryPost method is called", () async {
          verify(mockQueryHelper.queryPost(any, any)).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("getAccountLinkBasedOnUpdateToken", () {
      late Either<Failure, StripeUpdateAccountResponse> response;

      group("when the call is successful", () {
        setUp(() async {
          when(mockRemoteDataStore.getAccountLinkBasedOnUpdateToken(req: anyNamed("req")))
              .thenAnswer((_) async => StripeUpdateAccountResponse(success: true));

          response = await repository.getAccountLinkBasedOnUpdateToken(MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST);
        });

        test("then the getAccountLinkBasedOnUpdateToken method is called", () async {
          verify(mockRemoteDataStore.getAccountLinkBasedOnUpdateToken(req: MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST))
              .called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockRemoteDataStore.getAccountLinkBasedOnUpdateToken(req: anyNamed("req"))).thenThrow(
            Exception(""),
          );

          response = await repository.getAccountLinkBasedOnUpdateToken(MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST);
        });

        test("then the getAccountLinkBasedOnUpdateToken method is called", () async {
          verify(mockRemoteDataStore.getAccountLinkBasedOnUpdateToken(req: MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST))
              .called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("getLoginLinkBasedOnAddress", () {
      late Either<Failure, StripeGetLoginBasedOnAddressResponse> response;
      late StripeGetLoginBasedOnAddressRequest request;

      group("when the call is successful", () {
        setUp(() async {
          when(mockRemoteDataStore.getLoginLinkBasedOnAddress(req: anyNamed("req")))
              .thenAnswer((_) async => StripeGetLoginBasedOnAddressResponse(success: true));

          request = StripeGetLoginBasedOnAddressRequest("");

          response = await repository.getLoginLinkBasedOnAddress(request);
        });

        test("then the getLoginLinkBasedOnAddress method is called", () async {
          verify(mockRemoteDataStore.getLoginLinkBasedOnAddress(req: request)).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockRemoteDataStore.getLoginLinkBasedOnAddress(req: anyNamed("req"))).thenThrow(
            Exception(""),
          );

          response = await repository.getLoginLinkBasedOnAddress(request);
        });

        test("then the getLoginLinkBasedOnAddress method is called", () async {
          verify(mockRemoteDataStore.getLoginLinkBasedOnAddress(req: request)).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("getLoginLinkBasedOnAddress", () {
      late Either<Failure, bool> response;

      group("when the call is successful", () {
        setUp(() async {
          when(mockLocalDataSource.getUserAcceptPolicies()).thenAnswer((_) => true);

          response = repository.getUserAcceptPolicies();
        });

        test("then the getUserAcceptPolicies method is called", () async {
          verify(mockLocalDataSource.getUserAcceptPolicies()).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockLocalDataSource.getUserAcceptPolicies()).thenThrow(
            Exception(""),
          );

          response = repository.getUserAcceptPolicies();
        });

        test("then the getUserAcceptPolicies method is called", () async {
          verify(mockLocalDataSource.getUserAcceptPolicies()).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });

    group("saveUserAcceptPolicies", () {
      late Either<Failure, bool> response;

      group("when the call is successful", () {
        setUp(() async {
          when(mockLocalDataSource.saveUserAcceptPolicies()).thenAnswer((_) async => true);

          response = await repository.saveUserAcceptPolicies();
        });

        test("then the saveUserAcceptPolicies method is called", () async {
          verify(mockLocalDataSource.saveUserAcceptPolicies()).called(1);
        });

        test("then the response is successful", () async {
          expect(response.isRight(), true);
        });
      });

      group("when the call is unsuccesful", () {
        setUp(() async {
          when(mockLocalDataSource.saveUserAcceptPolicies()).thenThrow(
            Exception(""),
          );

          response = await repository.saveUserAcceptPolicies();
        });

        test("then the saveUserAcceptPolicies method is called", () async {
          verify(mockLocalDataSource.saveUserAcceptPolicies()).called(1);
        });

        test("then the response is unsuccessful", () async {
          expect(true, response.isLeft());
        });
      });
    });
  });
}
