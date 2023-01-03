import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_list_items_by_owner_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/item.pb.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get item by owner handler future', () {
    var sdkResponse = SDKIPCResponse(
      success: false,
      error: '',
      data: null,
      errorCode: '',
      action: '',
    );
    var handler = GetListItemsByOwnerHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_ITEMS_BY_OWNER);
      expect(response.success, false);
    }));
  });

  test('should complete the get item by owner with data ', () async {
    var sdkResponse = SDKIPCResponse(
      success: true,
      error: '',
      data: jsonEncode([MOCK_ITEM.toProto3Json()]),
      errorCode: '',
      action: '',
    );

    var handler = GetListItemsByOwnerHandler();

    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_ITEMS_BY_OWNER);
      expect(response.success, true);
      expect(true, response.data is List<Item>);
    }));
  });
}
