import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_cookbooks_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_execution_by_id_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_list_items_by_owner_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_item_by_id_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_profile_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_recipe_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_recipes_handler.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_trades_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import 'handlers/get_execution_by_recipe_handler.dart';

class IPCHandlerFactory {
  static final Map<String, IPCHandler> handlers = {
    Strings.GET_COOKBOOK: GetCookbooksHandler(),
    Strings.GET_RECIPES: GetRecipesHandler(),
    Strings.GET_RECIPE: GetRecipeHandler(),
    Strings.GET_EXECUTION_BY_RECIPE_ID: GetExecutionByRecipeHandler(),
    Strings.GET_ITEMS_BY_OWNER: GetListItemsByOwnerHandler(),
    Strings.GET_ITEM_BY_ID: GetItemByIdHandler(),
    Strings.GET_EXECUTION_BY_ID: GetExecutionByIdHandler(),
    Strings.GET_TRADES: GetTradesHandler(),
    Strings.GET_PROFILE: GetProfileHandler(),
  };

  /// Fetches and resolves appropriate [IPCHandler] instance for [sdkIpcResponse], or completes
  /// the completer if no specific handler is set.
  static void getHandler(SDKIPCResponse sdkipcResponse) {
    print(sdkipcResponse);
    if (!responseCompleters.containsKey(sdkipcResponse.action)) {
      throw Exception(
          'Unexpected response for unsent message of type ${sdkipcResponse.action}');
    }
    if (handlers.containsKey(sdkipcResponse.action)) {
      handlers[sdkipcResponse.action]!.handler(sdkipcResponse);
    } else {
      responseCompleters[sdkipcResponse.action]!.complete(sdkipcResponse);
    }
    return;
  }
}
