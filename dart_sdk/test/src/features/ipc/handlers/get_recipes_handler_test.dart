import 'package:flutter_test/flutter_test.dart';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_recipes_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/recipe.pb.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get All recipe future', () {
    var sdkResponse = SDKIPCResponse(
      success: false,
      error: '',
      data: '',
      errorCode: '',
      action: '',
    );
    var handler = GetRecipesHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_RECIPES);
      expect(response.success, false);
    }));
  });

  test('should complete the get All recipe future with data ', () async {
    var sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: [MOCK_RECIPE.toProto3Json()],
      errorCode: '',
      action: '',
    );
    var handler = GetRecipesHandler();

    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_RECIPES);
      expect(response.success, true);
      expect(true, response.data is List<Recipe>);
      expect(List<Recipe>.from(response.data!).length, 1);
    }));
  });

  test('should complete the get All recipe future with error ', () async {
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: [
          // Will throw parsing error
          Recipe()
            ..createEmptyInstance()
            ..toProto3Json()
        ],
        errorCode: '',
        action: '');
    var handler = GetRecipesHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_RECIPES);
      expect(response.success, false);
      expect(Strings.ERR_MALFORMED_RECIPES, response.errorCode);
    }));
  });
}
