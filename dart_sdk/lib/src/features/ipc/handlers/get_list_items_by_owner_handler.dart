import 'dart:convert';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/item.pb.dart';


class GetListItemsByOwnerHandler implements IPCHandler {
  @override
  void handler(
    SDKIPCResponse<dynamic> response,
    void Function(String key, SDKIPCResponse response) onHandlingComplete,
  ) {
    final defaultResponse = SDKIPCResponse<List<Item>>(
        success: response.success,
        action: response.action,
        data: [],
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = [
          ...List.from(jsonDecode(response.data)).map((item) => Item.create()..mergeFromProto3Json(item)).toList()
        ];
      }
    } on Exception catch (_) {
      defaultResponse.success = false;
      defaultResponse.error = 'Items list parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_ITEMS_LIST;
    }

    return onHandlingComplete(Strings.GET_ITEMS_BY_OWNER, defaultResponse);
  }
}
