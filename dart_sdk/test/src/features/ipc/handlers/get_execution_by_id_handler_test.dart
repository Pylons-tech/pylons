import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_execution_by_id_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get  execution based on id handler future', () {
    var sdkResponse = SDKIPCResponse(success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetExecutionByIdHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_EXECUTION_BY_ID);
      expect(response.success, false);
    }));
  });

  test('should complete the get  execution by id  with data ', () async {
    var sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: jsonEncode(MOCK_EXECUTION.toProto3Json()),
      errorCode: '',
      action: '',
    );

    var handler = GetExecutionByIdHandler();

    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_EXECUTION_BY_ID);
      expect(response.success, true);
      expect(response.data, MOCK_EXECUTION);
    }));
  });
}
