import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/third_party_services/analytics_helper.dart';
import 'package:pylons_wallet/services/third_party_services/crashlytics_helper.dart';
import 'package:pylons_wallet/services/third_party_services/firestore_helper.dart';
import 'package:pylons_wallet/services/third_party_services/store_payment_service.dart';

import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_crashlytics_helper.dart';
import '../../../mocks/mock_firebase_appcheck.dart';
import '../../../mocks/mock_firebase_dynamic_link.dart';
import '../../../mocks/mock_store_payment_service.dart';
import '../../../mocks/mock_analytics_helper.dart';
import '../../../mocks/mock_firestore_helper.dart';

void main() {
  test('should get account link and account id on getAccountLinkBasedOnUpdateToken', () async {
    dotenv.testLoad(fileInput: '''ENV=true''');

    final CrashlyticsHelper crashlyticsHelper = MockCrashlytics();
    final StorePaymentService storePaymentService = MockStripePaymentService();
    final MockFirebaseDynamicLinks mockFirebaseDynamicLinks = MockFirebaseDynamicLinks();
    final AnalyticsHelper analyticsHelper = MockAnalyticsHelper();
    final FirestoreHelper firestoreHelper = MockFirestoreHelper();

    GetIt.I.registerSingleton(MOCK_BASE_ENV);

    final client = MockClient(requestHandler);
    final remoteDataStore = RemoteDataStoreImp(
      httpClient: client,
      crashlyticsHelper: crashlyticsHelper,
      storePaymentService: storePaymentService,
      firebaseAppCheck: MockFirebaseAppCheck(),
      dynamicLinksGenerator: mockFirebaseDynamicLinks,
      firebaseHelper: firestoreHelper,
      analyticsHelper: analyticsHelper,
    );

    final response = await remoteDataStore.getAccountLinkBasedOnUpdateToken(req: StripeUpdateAccountRequest(Address: MOCK_ADDRESS, Token: MOCK_TOKEN, Signature: SIGNATURE));

    expect(MOCK_ACCOUNT_LINK, response.accountlink);
    expect(MOCK_ACCOUNT, response.account);
  });
}

Future<Response> requestHandler(Request request) async {
  final mapBody = jsonDecode(request.body);

  expect(mapBody["address"], MOCK_ADDRESS);
  expect(mapBody["token"], MOCK_TOKEN);
  expect(mapBody["signature"], SIGNATURE);

  return http.Response(jsonEncode({"accountlink": MOCK_ACCOUNT_LINK, "account": MOCK_ACCOUNT}), 200);
}
