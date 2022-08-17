
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../../../../mocks/mock_constants.dart';
import '../../../../mocks/mock_wallet_store.dart';

void main() {
  test('should return the user name from get profile', () async {
    final mockWalletStore = MockWalletStore();

    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

    final sdkipcMessage = SdkIpcMessage(action: HandlerFactory.TX_UPDATE_COOKBOOK, json: """
    {
    "ID": "LOUD-v0.1.0-1589853709",
    "Name": "Legend of Undead Dragon v0.1.0-1589853709",
    "Description": "This is prototype game built to run on pylons eco system.",
    "Developer": "Pylons/LOUD Team",
        "Level": "0",
        "Sender": "account1",
        "SupportEmail": "stalepresh121@outlook.com",
        "Version": "1.0.0",
        "CostPerBlock": "50"
        }""", sender: SENDER_APP, requestResponse: true);

    final handler = UpdateCookbookHandler(sdkipcMessage);
    final response = await handler.handle();



    expect(SENDER_APP, response.sender);
    expect(HandlerFactory.TX_UPDATE_COOKBOOK, response.action);
    expect(response.data, MOCK_TRANSACTION.hash);
  });
}
