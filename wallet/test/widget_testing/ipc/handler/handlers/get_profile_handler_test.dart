import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_profile_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../../test_utils/flutter_test_extender.dart';

void main() {
  group("GetProfileHandler", () {
    late SdkIpcResponse response;
    final mockWalletStore = MockWalletsStore();
    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

    setUpWidgets((tester) async {
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(),
      ));

      final sdkipcMessage =
          SdkIpcMessage(action: HandlerFactory.GET_PROFILE, json: '', sender: SENDER_APP, requestResponse: true);

      when(mockWalletStore.getProfile()).thenAnswer((realInvocation) async => SdkIpcResponse.success(
            data: {
              "username" : MOCK_USERNAME,
            },
            sender: SENDER_APP,
            transaction: "",
          ));

      final handler = GetProfileHandler(sdkipcMessage);
      response = await handler.handle();
    });

    testWidgets('should return the user name from get profile', (tester) async {
      expect(MOCK_USERNAME, response.data['username']);
      expect(SENDER_APP, response.sender);
      expect(HandlerFactory.GET_PROFILE, response.action);
    });
  });
}
