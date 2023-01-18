import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/recipe.pb.dart';

class GetRecipesHandler implements IPCHandler<List<Recipe>> {
  @override
  void handler(
    SDKIPCResponse<dynamic> response,
    void Function(String key, SDKIPCResponse<List<Recipe>> response) onHandlingComplete,
  ) {
    final defaultResponse = SDKIPCResponse<List<Recipe>>(
        success: response.success,
        action: response.action,
        data: [],
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = List.from(response.data).map((e) {
          return Recipe.create()..mergeFromProto3Json(e);
        }).toList();
      } else {
        defaultResponse.error = response.error;
      }
    } on Exception catch (_) {
      defaultResponse.error = 'Recipe parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_RECIPES;
      defaultResponse.success = false;
    }

    return onHandlingComplete(Strings.GET_RECIPES, defaultResponse);
  }
}
