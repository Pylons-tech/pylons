import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_execution_by_recipe_handler.dart';
import 'package:pylons_sdk/src/features/models/execution_list_by_recipe_response.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/pylons_wallet/response_fetcher/response_fetch.dart';

void main() {
  test('should complete the get  execution by recipe handler future', () {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_EXECUTION_BY_RECIPE_ID);
    var sdkResponse = SDKIPCResponse(success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetExecutionByRecipeHandler();
    handler.handler(sdkResponse);
    expect(
      true,
      completer.isCompleted,
    );
  });

  test('should complete the get  execution by recipe handler  with data ', () async {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_EXECUTION_BY_RECIPE_ID);
    var sdkResponse = SDKIPCResponse(
        success: true, error: '', data: jsonEncode(ExecutionListByRecipeResponse.empty()), errorCode: '', action: '');
    var handler = GetExecutionByRecipeHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, completer.isCompleted);
    });

    var response = await completer.future;

    expect(true, response.success);
    expect(true, response.data is ExecutionListByRecipeResponse);
  });
}
