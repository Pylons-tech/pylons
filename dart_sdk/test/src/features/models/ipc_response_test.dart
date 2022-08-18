import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';

import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../mocks/mock_constants.dart';

void main() {
  test('should give success response for the encoded message', () {
    const message =
        'ewoJImFjdGlvbiI6ICJnZXRQcm9maWxlIiwKCSJzdWNjZXNzIjogdHJ1ZSwKCSJlcnJvciI6ICIiLAoJImVycm9yQ29kZSI6ICIiLAoJImRhdGEiOiAiSmF3YWQiCn0=';

    final sdkMessage = SDKIPCResponse.fromIPCMessage(message);
    expect(Strings.GET_PROFILE, sdkMessage.action);
    expect(true, sdkMessage.success);
    expect(MOCK_USERNAME, sdkMessage.data);
    expect(true, sdkMessage.errorCode.isEmpty);
    expect(true, sdkMessage.error.isEmpty);
    expect(
        'SDKIPCResponse{success: true, errorCode: , error: , data: $MOCK_USERNAME, action: ${Strings.GET_PROFILE}}',
        sdkMessage.toString());
  });

  test('should give error response for the encoded message', () {
    const message =
        'ewoJImFjdGlvbiI6ICJnZXRQcm9maWxlIiwKCSJzdWNjZXNzIjogZmFsc2UsCgkiZXJyb3IiOiAiV2FsbGV0IGRvZXNuJ3QgZXhpc3RzIiwKCSJlcnJvckNvZGUiOiAic29tZXRoaW5nV2VudFdyb25nIiwKCSJkYXRhIjogIiIKfQ==';

    final sdkMessage = SDKIPCResponse.fromIPCMessage(message);
    expect(Strings.GET_PROFILE, sdkMessage.action);
    expect(false, sdkMessage.success);
    expect(true, sdkMessage.data.isEmpty);
    expect('somethingWentWrong', sdkMessage.errorCode);
    expect('Wallet doesn\'t exists', sdkMessage.error);
    expect(
        'SDKIPCResponse{success: false, errorCode: somethingWentWrong, error: Wallet doesn\'t exists, data: , action: ${Strings.GET_PROFILE}}',
        sdkMessage.toString());
  });
}
