import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_item_by_id_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get item by id handler future', () {
    var sdkResponse = SDKIPCResponse(success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetItemByIdHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_ITEM_BY_ID);
      expect(response.success, false);
    }));
  });

  test('should complete the get  item by id handler  with data ', () async {
    var sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: jsonEncode(MOCK_ITEM.toProto3Json()),
      errorCode: '',
      action: '',
    );

    var handler = GetItemByIdHandler();

    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_ITEM_BY_ID);
      expect(response.success, true);
    }));
  });
}
