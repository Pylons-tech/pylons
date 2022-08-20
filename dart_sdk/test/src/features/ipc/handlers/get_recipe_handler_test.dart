import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_recipe_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get  recipe future', () {
    initResponseCompleter(Strings.GET_RECIPE);
    var sdkResponse = SDKIPCResponse(
        success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetRecipeHandler();
    handler.handler(sdkResponse);
    expect(true, responseCompleters[Strings.GET_RECIPE]!.isCompleted);
  });

  test('should complete the get  recipe future with data ', () async {
    initResponseCompleter(Strings.GET_RECIPE);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: jsonEncode(MOCK_RECIPE.toProto3Json()),
        errorCode: '',
        action: '');
    var handler = GetRecipeHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_RECIPE]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_RECIPE]!.future;

    expect(true, response.success);
    expect(true, response.data is Recipe);
  });

  test('should complete the get  recipe future with error ', () async {
    initResponseCompleter(Strings.GET_RECIPE);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: '', // Will throw parsing error
        errorCode: '',
        action: '');
    var handler = GetRecipeHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_RECIPE]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_RECIPE]!.future;
    expect(false, response.success);
    expect(Strings.ERR_MALFORMED_RECIPE, response.errorCode);
  });
}
