import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_item_by_id_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';

void main() {
  group("$GetItemByIdHandler", () {
    setUp(() {
      final mockWalletStore = MockWalletsStore();
      GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

      when(mockWalletStore.getItemByIdForSDK(
        cookBookId: anyNamed("cookBookId"),
        itemId: anyNamed("itemId"),
      )).thenAnswer(
        (_) async => SdkIpcResponse.success(
          data: jsonEncode(MOCK_ITEM.toProto3Json()),
          sender: SENDER_APP,
          transaction: "",
        ),
      );
    });
    
    test('should return the item from the handler based on id ', () async {
      final sdkipcMessage = SdkIpcMessage(
        action: HandlerFactory.GET_ITEM_BY_ID,
        json: jsonEncode({
          HandlerFactory.COOKBOOK_ID: MOCK_COOKBOOK_ID,
          HandlerFactory.ITEM_ID: MOCK_ITEM_ID,
        }),
        sender: SENDER_APP,
        requestResponse: true,
      );

      final handler = GetItemByIdHandler(sdkipcMessage);
      final response = await handler.handle();

      expect(SENDER_APP, response.sender);
      expect(HandlerFactory.GET_ITEM_BY_ID, response.action);
      expect(jsonEncode(MOCK_ITEM.toProto3Json()), response.data);
    });
  });
}
