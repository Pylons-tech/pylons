
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_list_by_owner_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../../../../mocks/mock_constants.dart';
import '../../../../mocks/mock_wallet_store.dart';

void main() {
  test('should return the empty array from ', () async {
    final mockWalletStore = MockWalletStore();

    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

    final sdkipcMessage = SdkIpcMessage(action: HandlerFactory.GET_ITEMS_BY_OWNER, json: jsonEncode({
      HandlerFactory.OWNER_ADDRESS : MOCK_ADDRESS
    }), sender: SENDER_APP, requestResponse: true);

    final handler = GetItemsByOwnerHandler(sdkipcMessage);
    final response = await handler.handle();



    expect(SENDER_APP, response.sender);
    expect(HandlerFactory.GET_ITEMS_BY_OWNER, response.action);
    expect(1, jsonDecode(response.data.toString()).length);
  });
}
