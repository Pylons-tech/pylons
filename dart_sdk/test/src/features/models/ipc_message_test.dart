import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_message.dart';

import '../../../mocks/mock_constants.dart';

void main() {
  test('should give SDKIPCMessage from Json', () {
    const message =
        'ewoJImFjdGlvbiI6ICJnZXRQcm9maWxlIiwKCSJqc29uIjogIkphd2FkIiwKCSJyZXF1ZXN0X3Jlc3BvbnNlIiA6IHRydWUsCgkic2VuZGVyIjogImV4YW1wbGUiCgp9';

    final sdkMessage = SDKIPCMessage.fromIPCMessage(message);
    expect(Strings.GET_PROFILE, sdkMessage.action);
    expect(MOCK_USERNAME, sdkMessage.json);
    expect(MOCK_HOST, sdkMessage.sender);
    print(sdkMessage.toString());
    expect(
        'SDKIPCMessage{action: ${Strings.GET_PROFILE}, json: $MOCK_USERNAME, sender: $MOCK_HOST, requestResponse: ${true}}',
        sdkMessage.toString());
  });
}
