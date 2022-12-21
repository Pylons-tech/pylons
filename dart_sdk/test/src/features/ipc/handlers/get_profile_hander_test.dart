import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_profile_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the getProfile Future ', () async {
    final sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: jsonEncode(MOCK_USER_INFO_MODEL.toJson()),
        errorCode: '',
        action: Strings.GET_PROFILE);
    final handler = GetProfileHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_PROFILE);
      expect(response.success, true);
    }));
  });
}
