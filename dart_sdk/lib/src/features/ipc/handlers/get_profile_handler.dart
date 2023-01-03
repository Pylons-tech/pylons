import 'dart:convert';
import 'dart:developer';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/data/models/profile.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';


class GetProfileHandler implements IPCHandler {
  @override
  void handler(
    SDKIPCResponse<dynamic> response,
    void Function(String key, SDKIPCResponse response) onHandlingComplete,
  ) {
    log(response.toString(), name: 'GetProfileHandler');

    final defaultResponse = SDKIPCResponse<Profile>(
        success: response.success,
        action: response.action,
        data: Profile.initial(),
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = Profile.fromJson(jsonDecode(response.data));
      }
    } on FormatException catch (_) {
      defaultResponse.error = _.message;
      defaultResponse.errorCode = Strings.ERR_MALFORMED_USER_INFO;
      defaultResponse.success = false;
    }

    return onHandlingComplete(Strings.GET_PROFILE, defaultResponse);
  }
}
