import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/execution.pb.dart';

class GetExecutionByIdHandler implements IPCHandler {
  @override
  void handler(SDKIPCResponse<dynamic> response) {
    final defaultResponse = SDKIPCResponse<Execution>(
        success: response.success,
        action: response.action,
        data: Execution()..createEmptyInstance(),
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = Execution.create()
          ..mergeFromProto3Json(jsonDecode(response.data));
      }
    } on FormatException catch (_) {
      defaultResponse.error = _.message;
      defaultResponse.errorCode = Strings.ERR_MALFORMED_EXECUTION;
      defaultResponse.success = false;
    }
    responseCompleters[Strings.GET_EXECUTION_BY_ID]!.complete(defaultResponse);
  }
}
