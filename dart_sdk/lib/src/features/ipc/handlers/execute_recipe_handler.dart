import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../pylons_wallet/response_fetcher/response_fetch.dart';

class ExecuteRecipeHandler implements IPCHandler {
  @override
  void handler(SDKIPCResponse<dynamic> response) {
    final defaultResponse = SDKIPCResponse<String>(
        success: response.success,
        action: response.action,
        data: '',
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = response.data;
      }
    } on Exception catch (_) {
      defaultResponse.success = false;
      defaultResponse.error = 'TX response parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_EXECUTION;
    }
    getResponseFetch().complete(key: Strings.TX_EXECUTE_RECIPE, sdkipcResponse: defaultResponse);
  }
}
