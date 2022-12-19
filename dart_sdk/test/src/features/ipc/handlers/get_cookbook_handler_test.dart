import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_cookbooks_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the getCookBook Future ', () async {
    final sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: MOCK_COOKBOOK,
      errorCode: '',
      action: Strings.GET_COOKBOOK,
    );
    final handler = GetCookbooksHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(Strings.GET_COOKBOOK, key);
      expect(Strings.GET_COOKBOOK, response.action);
    }));
  });
}
