import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';

void main() {
  group("$GetCookbookHandler", () {
    setUp(() {
      final mockWalletStore = MockWalletsStore();
      GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

      when(mockWalletStore.getCookbookByIdForSDK(cookbookId: anyNamed("cookbookId"))).thenAnswer(
        (_) async => SdkIpcResponse.success(
          data: MOCK_COOKBOOK,
          sender: SENDER_APP,
          transaction: "",
        ),
      );
    });
    test('should return the cookbook from the wallet store', () async {
      final sdkipcMessage = SdkIpcMessage(
        action: HandlerFactory.GET_COOKBOOK,
        json: jsonEncode({HandlerFactory.GET_COOKBOOK: ''}),
        sender: SENDER_APP,
        requestResponse: true,
      );

      final handler = GetCookbookHandler(sdkipcMessage);
      final response = await handler.handle();

      expect(SENDER_APP, response.sender);
      expect(HandlerFactory.GET_COOKBOOK, response.action);
      expect(MOCK_COOKBOOK, response.data);
    });
  });
}
