import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_execution_by_id_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';

void main() {
  group("$GetExecutionByIdHandler", () {
    setUp(() {
      final mockWalletStore = MockWalletsStore();
      GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

      when(mockWalletStore.getExecutionBasedOnId(id: anyNamed("id"))).thenAnswer(
        (_) async => SdkIpcResponse.success(
          data: jsonEncode(MOCK_EXECUTION.toProto3Json()),
          sender: SENDER_APP,
          transaction: "",
        ),
      );
    });

    test('should return the GetExecutionBasedOnIdHandler from the wallet store', () async {
      final sdkipcMessage = SdkIpcMessage(
        action: HandlerFactory.GET_EXECUTION_BY_ID,
        json: jsonEncode({
          HandlerFactory.EXECUTION_ID: MOCK_EXECUTION_ID,
        }),
        sender: SENDER_APP,
        requestResponse: true,
      );

      final handler = GetExecutionByIdHandler(sdkipcMessage);
      final response = await handler.handle();

      expect(SENDER_APP, response.sender);
      expect(HandlerFactory.GET_EXECUTION_BY_ID, response.action);
      expect(jsonEncode(MOCK_EXECUTION.toProto3Json()), response.data);
    });
  });
}
