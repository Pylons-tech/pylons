import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_recipes_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get All recipe future', () {
    initResponseCompleter(Strings.GET_RECIPES);
    var sdkResponse = SDKIPCResponse(
        success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetRecipesHandler();
    handler.handler(sdkResponse);
    expect(true, responseCompleters[Strings.GET_RECIPES]!.isCompleted);
  });

  test('should complete the get All recipe future with data ', () async {
    initResponseCompleter(Strings.GET_RECIPES);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: [MOCK_RECIPE.toProto3Json()],
        errorCode: '',
        action: '');
    var handler = GetRecipesHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_RECIPES]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_RECIPES]!.future;
    expect(true, response.success);
    expect(true, response.data is List<Recipe>);
    expect(1, List<Recipe>.from(response.data).length);
  });

  test('should complete the get All recipe future with error ', () async {
    initResponseCompleter(Strings.GET_RECIPES);
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

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_RECIPES]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_RECIPES]!.future;
    expect(false, response.success);
    expect(Strings.ERR_MALFORMED_RECIPES, response.errorCode);
  });
}
