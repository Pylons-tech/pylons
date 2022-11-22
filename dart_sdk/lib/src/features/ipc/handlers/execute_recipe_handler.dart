import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/execution.pb.dart';
import '../../../generated/cosmos/base/abci/v1beta1/abci.pb.dart';

class ExecuteRecipeHandler implements IPCHandler {
  @override
  void handler(SDKIPCResponse<dynamic> response) {
    final defaultResponse = SDKIPCResponse<TxResponse>(
        success: response.success,
        action: response.action,
        data: TxResponse.create(),
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = TxResponse.create()
          ..mergeFromProto3Json(jsonDecode(response.data));
      }
    } on Exception catch (_) {
      defaultResponse.success = false;
      defaultResponse.error = 'TX response parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_EXECUTION;
    }
    responseCompleters[Strings.TX_EXECUTE_RECIPE]!.complete(defaultResponse);
  }
}
