import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../../mocks/mock_wallet_store.dart';



void main() {
  testWidgets('test createCookBook handler', (tester) async {




    await tester.pumpWidget( MaterialApp(
      navigatorKey: navigatorKey,
      home: const Scaffold(),
    ));



    final mockWalletStore = MockWalletStore();

    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);



    final  sdkipcMessage = SdkIpcMessage(action: HandlerFactory.TX_CREATE_COOKBOOK, json: MOCK_COOKBOOK , sender: 'Sending app', requestResponse: true);


    final handler = CreateCookbookHandler(sdkipcMessage);
    final response = await handler.handle();
    expect(MOCK_TRANSACTION.hash, response.data);

  });
}
