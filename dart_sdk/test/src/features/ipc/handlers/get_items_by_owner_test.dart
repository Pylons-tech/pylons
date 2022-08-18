import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_list_items_by_owner_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get item by owner handler future', () {
    initResponseCompleter(Strings.GET_ITEMS_BY_OWNER);
    var sdkResponse = SDKIPCResponse(
        success: false,
        error: '',
        data: [MOCK_ITEM..toProto3Json()],
        errorCode: '',
        action: '');
    var handler = GetListItemsByOwnerHandler();
    handler.handler(sdkResponse);
    expect(true, responseCompleters[Strings.GET_ITEMS_BY_OWNER]!.isCompleted);
  });

  test('should complete the get item by owner with data ', () async {
    initResponseCompleter(Strings.GET_ITEMS_BY_OWNER);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: jsonEncode([MOCK_ITEM.toProto3Json()]),
        errorCode: '',
        action: '');
    var handler = GetListItemsByOwnerHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_ITEMS_BY_OWNER]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_ITEMS_BY_OWNER]!.future;

    expect(true, response.success);
    expect(true, response.data is List<Item>);
  });
}
