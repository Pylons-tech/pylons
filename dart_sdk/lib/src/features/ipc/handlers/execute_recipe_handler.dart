import 'dart:convert';

import 'package:pylons_sdk/low_level.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';

class ExecuteRecipeHandler implements IPCHandler<Execution> {
  @override
  void handler(
    SDKIPCResponse<dynamic> response,
    void Function(String key, SDKIPCResponse<Execution> response) onHandlingComplete,
  ) {
    final defaultResponse = SDKIPCResponse<Execution>(
      success: response.success,
      action: response.action,
      data: null,
      error: response.error,
      errorCode: response.errorCode,
    );
    try {
      if (response.success) {
        defaultResponse.data = Execution.create()..mergeFromProto3Json(jsonDecode(response.data));
      } else {
        defaultResponse.error = response.error;
      }
    } on Exception catch (_) {
      defaultResponse.success = false;
      defaultResponse.error = 'TX response parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_EXECUTION;
    }

    return onHandlingComplete(Strings.TX_EXECUTE_RECIPE, defaultResponse);
  }
}
