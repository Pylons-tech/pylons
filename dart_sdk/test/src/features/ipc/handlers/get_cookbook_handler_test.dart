import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_cookbooks_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/pylons_wallet/response_fetcher/response_fetch.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the getCookBook Future ', () async {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_COOKBOOK);
    final sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: MOCK_COOKBOOK,
        errorCode: '',
        action: Strings.GET_COOKBOOK);
    final handler = GetCookbooksHandler();
    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
    });

    
    final response = await completer.future;
    expect(true, completer.isCompleted);
    expect(true, response.success);
    expect(Strings.GET_COOKBOOK, response.action);
  });
}
