import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/execution.pb.dart';

class ExecuteRecipeHandler implements IPCHandler {
  @override
  void handler(SDKIPCResponse<dynamic> response) {
    final defaultResponse = SDKIPCResponse<Execution>(
        success: response.success,
        action: response.action,
        data: Execution.create(),
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = Execution.create()
          ..mergeFromProto3Json(jsonDecode(response.data));
      }
    } on Exception catch (_) {
      defaultResponse.success = false;
      defaultResponse.error = 'Execution parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_EXECUTION;
    }
    responseCompleters[Strings.TX_EXECUTE_RECIPE]!.complete(defaultResponse);
  }
}
