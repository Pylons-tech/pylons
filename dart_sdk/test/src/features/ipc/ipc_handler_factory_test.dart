import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/ipc_handler_factory.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/pylons_wallet/response_fetcher/response_fetch.dart';

import '../../../mocks/mock_constants.dart';

void main() {
  test('Should complete completers when appropriate response arrives', () {
    _genericResponseTestFlow(Strings.TX_CREATE_COOKBOOK);
    _genericResponseTestFlow(Strings.TX_UPDATE_COOKBOOK);
    _genericResponseTestFlow(Strings.TX_CREATE_RECIPE);
    _genericResponseTestFlow(Strings.TX_UPDATE_RECIPE);
    _genericResponseTestFlow(Strings.TX_EXECUTE_RECIPE);
    _genericResponseTestFlow(Strings.GET_PROFILE);
    _genericResponseTestFlow(Strings.GET_EXECUTION_BY_ID);
    _genericResponseTestFlow(Strings.GET_ITEMS_BY_OWNER);
  });

  test('should complete completer that needs handler', () {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_RECIPES);
    expect(false, completer.isCompleted);
    var sdkResponse = SDKIPCResponse(
        success: true, error: '', data: [MOCK_RECIPE.toProto3Json()], errorCode: '', action: Strings.GET_RECIPES);
    IPCHandlerFactory.getHandler(sdkResponse);
    expect(true, completer.isCompleted);
  });

  test('should throw error if unknown key is found', () {
    var sdkResponse = SDKIPCResponse(
        success: true, error: '', data: [MOCK_RECIPE.toProto3Json()], errorCode: '', action: MOCK_USERNAME);
    expect(() => IPCHandlerFactory.getHandler(sdkResponse), throwsA(isA<Exception>()));
  });
}

void _genericResponseTestFlow(String key) {
  final completer = getResponseFetch().initResponseCompleter(key);
  expect(false, completer.isCompleted);
  var sdkResponse = SDKIPCResponse(success: true, error: '', data: '', errorCode: '', action: key);
  IPCHandlerFactory.getHandler(sdkResponse);
  expect(true, completer.isCompleted);
}
