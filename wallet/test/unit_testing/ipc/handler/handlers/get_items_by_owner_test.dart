import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_list_by_owner_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';

void main() {
  group("$GetItemsByOwnerHandler", () {
    setUp(() {
      final mockWalletStore = MockWalletsStore();
      GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

      when(mockWalletStore.getItemListByOwner(
        owner: anyNamed("owner"),
      )).thenAnswer(
        (_) async => SdkIpcResponse.success(
          data: jsonEncode([MOCK_ITEM.toProto3Json()]),
          sender: SENDER_APP,
          transaction: "",
        ),
      );
    });

    test('should return the array with one item', () async {
      final sdkipcMessage = SdkIpcMessage(
        action: HandlerFactory.GET_ITEMS_BY_OWNER,
        json: jsonEncode({HandlerFactory.OWNER_ADDRESS: MOCK_ADDRESS}),
        sender: SENDER_APP,
        requestResponse: true,
      );

      final handler = GetItemsByOwnerHandler(sdkipcMessage);
      final response = await handler.handle();

      expect(SENDER_APP, response.sender);
      expect(HandlerFactory.GET_ITEMS_BY_OWNER, response.action);
      expect(1, jsonDecode(response.data.toString()).length);
    });
  });
}
