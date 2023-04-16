import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_recipe_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../../test_utils/flutter_test_extender.dart';

void main() {
  group("$CreateRecipeHandler", () {
    late SdkIpcResponse response;
    final mockWalletStore = MockWalletsStore();
    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

    setUpWidgets((tester) async {
    
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(),
      ));
      final sdkipcMessage = SdkIpcMessage(
        action: HandlerFactory.TX_CREATE_RECIPE,
        json: MOCK_RECIPE,
        sender: SENDER_APP,
        requestResponse: true,
      );

      when(mockWalletStore.createRecipe(any)).thenAnswer((realInvocation) async => SdkIpcResponse.success(
            data: MOCK_TRANSACTION.hash,
            sender: "",
            transaction: "",
          ));

      final handler = CreateRecipeHandler(sdkipcMessage);
      response = await handler.handle();
    });

    testWidgets('should call createRecipe method ', (tester) async {
      verify(mockWalletStore.createRecipe(any)).called(1);
    });

    testWidgets('should create a transaction hash', (tester) async {
      expect(MOCK_TRANSACTION.hash, response.data);
    });
  });
}
