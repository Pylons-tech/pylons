import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_item_by_id_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get item by id handler future', () {
    initResponseCompleter(Strings.GET_ITEM_BY_ID);
    var sdkResponse = SDKIPCResponse(
        success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetItemByIdHandler();
    handler.handler(sdkResponse);
    expect(true, responseCompleters[Strings.GET_ITEM_BY_ID]!.isCompleted);
  });

  test('should complete the get item by id with data ', () async {
    initResponseCompleter(Strings.GET_ITEM_BY_ID);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: jsonEncode(MOCK_ITEM.toProto3Json()),
        errorCode: '',
        action: '');
    var handler = GetItemByIdHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_ITEM_BY_ID]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_ITEM_BY_ID]!.future;

    expect(true, response.success);
    expect(true, response.data is Item);
  });
}
