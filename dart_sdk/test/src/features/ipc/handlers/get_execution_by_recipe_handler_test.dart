import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_execution_by_recipe_handler.dart';
import 'package:pylons_sdk/src/features/models/execution_list_by_recipe_response.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

void main() {
  test('should complete the get  execution by recipe handler future', () {
    var sdkResponse = SDKIPCResponse(success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetExecutionByRecipeHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_EXECUTION_BY_RECIPE_ID);
      expect(response.success, false);
    }));
  });

  test('should complete the get  execution by recipe handler  with data ', () async {
    var sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: jsonEncode(ExecutionListByRecipeResponse.empty()),
      errorCode: '',
      action: '',
    );

    var handler = GetExecutionByRecipeHandler();

    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_EXECUTION_BY_RECIPE_ID);
      expect(response.success, true);
      expect(response.data is ExecutionListByRecipeResponse, true);
    }));
  });
}
