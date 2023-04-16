import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_execution_by_recipe_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/execution_list_by_recipe_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../../../../mocks/main_mock.mocks.dart';
import '../../../../mocks/mock_constants.dart';

void main() {
  group("$GetExecutionByRecipe", () {
    setUp(() {
      final mockWalletStore = MockWalletsStore();
      GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

      when(mockWalletStore.getExecutionByRecipeId(
        cookbookId: anyNamed("cookbookId"),
        recipeId: anyNamed("recipeId"),
      )).thenAnswer(
        (_) async => SdkIpcResponse.success(
          data: ExecutionListByRecipeResponse.empty(),
          sender: SENDER_APP,
          transaction: "",
        ),
      );
    });

    test('should return the GetExecutionByRecipe from the wallet store', () async {
      final sdkipcMessage = SdkIpcMessage(
        action: HandlerFactory.GET_EXECUTION_BY_RECIPE_ID,
        json: jsonEncode({HandlerFactory.COOKBOOK_ID: MOCK_COOKBOOK_ID, HandlerFactory.RECIPE_ID: MOCK_RECIPE_ID}),
        sender: SENDER_APP,
        requestResponse: true,
      );

      final handler = GetExecutionByRecipe(sdkipcMessage);
      final response = await handler.handle();

      expect(SENDER_APP, response.sender);
      expect(HandlerFactory.GET_EXECUTION_BY_RECIPE_ID, response.action);
      expect(true, response.data is ExecutionListByRecipeResponse);
    });
  });
}
