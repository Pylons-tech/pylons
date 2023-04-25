import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_trades_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';

void main() {
  group("$GetTradesHandler", () {
    setUp(() {
      final mockWalletStore = MockWalletsStore();
      GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

      when(mockWalletStore.getTradesForSDK(
        creator: anyNamed("creator"),
      )).thenAnswer(
        (_) async => SdkIpcResponse.success(
          data: [],
          sender: SENDER_APP,
          transaction: "",
        ),
      );
    });
    
    test('should return an empty array of trades from ', () async {
      final sdkipcMessage = SdkIpcMessage(
        action: HandlerFactory.GET_TRADES,
        json: jsonEncode({HandlerFactory.CREATOR: MOCK_ADDRESS}),
        sender: SENDER_APP,
        requestResponse: true,
      );

      final handler = GetTradesHandler(sdkipcMessage);
      final response = await handler.handle();

      expect(SENDER_APP, response.sender);
      expect(HandlerFactory.GET_TRADES, response.action);
    });
  });
}
