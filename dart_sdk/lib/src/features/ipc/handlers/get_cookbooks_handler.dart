import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/cookbook.pb.dart';

import '../../../pylons_wallet/response_fetcher/response_fetch.dart';

class GetCookbooksHandler implements IPCHandler {
  @override
  void handler(SDKIPCResponse<dynamic> response) {
    final defaultResponse = SDKIPCResponse<Cookbook>(
        success: response.success,
        action: response.action,
        data: Cookbook.create(),
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = Cookbook.create()..mergeFromProto3Json(jsonDecode(response.data));
      }
    } on Exception catch (_) {
      defaultResponse.success = false;
      defaultResponse.error = 'Cookbook parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_COOKBOOK;
    }

    getResponseFetch().complete(key: Strings.GET_COOKBOOK, sdkipcResponse: defaultResponse);
  }
}
