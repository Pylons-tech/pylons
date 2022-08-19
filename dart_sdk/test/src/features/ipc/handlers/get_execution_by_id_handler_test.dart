import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_execution_by_id_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get  execution based on id handler future', () {
    initResponseCompleter(Strings.GET_EXECUTION_BY_ID);
    var sdkResponse = SDKIPCResponse(
        success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetExecutionByIdHandler();
    handler.handler(sdkResponse);
    expect(true, responseCompleters[Strings.GET_EXECUTION_BY_ID]!.isCompleted);
  });

  test('should complete the get  execution by id   with data ', () async {
    initResponseCompleter(Strings.GET_EXECUTION_BY_ID);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: jsonEncode(MOCK_EXECUTION.toProto3Json()),
        errorCode: '',
        action: '');
    var handler = GetExecutionByIdHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(
          true, responseCompleters[Strings.GET_EXECUTION_BY_ID]!.isCompleted);
    });

    var response =
        await responseCompleters[Strings.GET_EXECUTION_BY_ID]!.future;

    expect(true, response.success);
    expect(MOCK_EXECUTION, response.data);
  });
}
