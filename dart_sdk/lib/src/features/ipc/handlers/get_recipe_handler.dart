import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../pylons_sdk.dart';

class GetRecipeHandler implements IPCHandler {
  @override
  void handler(SDKIPCResponse<dynamic> response) {
    print(response);
    final defaultResponse = SDKIPCResponse<Recipe>(
        success: response.success,
        action: response.action,
        data: Recipe()..createEmptyInstance(),
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = Recipe.create()
          ..mergeFromProto3Json(jsonDecode(response.data));
      }
    } on FormatException catch (_) {
      defaultResponse.error = _.message;
      defaultResponse.errorCode = Strings.ERR_MALFORMED_RECIPE;
      defaultResponse.success = false;
    }
    responseCompleters[Strings.GET_RECIPE]!.complete(defaultResponse);
  }
}
