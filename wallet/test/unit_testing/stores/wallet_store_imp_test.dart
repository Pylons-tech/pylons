import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/providers/accounts_provider.dart';
import 'package:pylons_wallet/services/third_party_services/remote_notifications_service.dart';
import 'package:pylons_wallet/stores/wallet_store_imp.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import '../../mocks/mock_crashlytics_helper.dart';
import '../../mocks/mock_repository.dart';
import 'wallet_store_imp_test.mocks.dart';

@GenerateMocks([RemoteNotificationsProvider])
void main() {
  late WalletsStoreImp walletsStoreImp;

  setUp(() {
    dotenv.testLoad(fileInput: '''ENV=true''');
    final repository = MockRepository();
    final mockCrashlytics = MockCrashlytics();

    walletsStoreImp = WalletsStoreImp(
      repository: repository,
      crashlyticsHelper: mockCrashlytics,
      accountProvider: AccountProvider(transactionSigningGateway: TransactionSigningGateway()),
      remoteNotificationProvider: MockRemoteNotificationsProvider()
    );
  });

  group('getProfile', () {
    test('should return the create account error', () async {
      // Loading from a static string.

      final response = await walletsStoreImp.getProfile();
      expect(response.success, false);
      expect(response.errorCode, HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST);
      expect(response.error, 'create_profile_before_using');
    });
  });
}
