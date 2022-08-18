import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_profile_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the getProfile Future ', () async {
    initResponseCompleter(Strings.GET_PROFILE);
    final sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: jsonEncode(MOCK_USER_INFO_MODEL.toJson()),
        errorCode: '',
        action: Strings.GET_PROFILE);
    final handler = GetProfileHandler();
    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
    });
    final response = await responseCompleters[Strings.GET_PROFILE]!.future;
    expect(true, responseCompleters[Strings.GET_PROFILE]!.isCompleted);
    expect(true, response.success);
    expect(Strings.GET_PROFILE, response.action);
  });
}
