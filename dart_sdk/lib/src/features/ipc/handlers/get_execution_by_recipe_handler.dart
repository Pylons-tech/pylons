import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/models/execution_list_by_recipe_response.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../pylons_wallet/response_fetcher/response_fetch.dart';

class GetExecutionByRecipeHandler implements IPCHandler {
  @override
  void handler(SDKIPCResponse<dynamic> response) {
    final defaultResponse = SDKIPCResponse<ExecutionListByRecipeResponse>(
        success: response.success,
        action: response.action,
        data: ExecutionListByRecipeResponse.empty(),
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data =
            ExecutionListByRecipeResponse.fromJson(jsonDecode(response.data));
      }
    } on FormatException catch (_) {
      defaultResponse.error = _.message;
      defaultResponse.errorCode = Strings.ERR_MALFORMED_EXECUTION;
      defaultResponse.success = false;
    }

    getResponseFetch().complete(key: Strings.GET_EXECUTION_BY_RECIPE_ID, sdkipcResponse: defaultResponse);
  }
}
