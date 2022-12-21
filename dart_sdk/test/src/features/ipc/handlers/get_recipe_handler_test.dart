import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_recipe_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get  recipe future', () {
    var sdkResponse = SDKIPCResponse(
      success: false,
      error: '',
      data: null,
      errorCode: '',
      action: '',
    );
    var handler = GetRecipeHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_RECIPE);
      expect(response.success, false);
    }));
  });

  test('should complete the get  recipe future with data ', () async {
    var sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: jsonEncode(MOCK_RECIPE.toProto3Json()),
      errorCode: '',
      action: '',
    );
    var handler = GetRecipeHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_RECIPE);
      expect(response.success, true);
    }));
  });

  test('should complete the get  recipe future with error ', () async {
    var sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: '', // Will throw parsing error
      errorCode: '',
      action: '',
    );
    var handler = GetRecipeHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_RECIPE);
      expect(response.success, false);
      expect(Strings.ERR_MALFORMED_RECIPE, response.errorCode);
    }));
  });
}
