import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_item_by_id_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/item.pb.dart';
import 'package:pylons_sdk/src/pylons_wallet/response_fetcher/response_fetch.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get item by id handler future', () {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_ITEM_BY_ID);
    var sdkResponse = SDKIPCResponse(
        success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetItemByIdHandler();
    handler.handler(sdkResponse);
    expect(true, completer.isCompleted);
  });

  test('should complete the get item by id with data ', () async {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_ITEM_BY_ID);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: jsonEncode(MOCK_ITEM.toProto3Json()),
        errorCode: '',
        action: '');
    var handler = GetItemByIdHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, completer.isCompleted);
    });

    var response = await completer.future;

    expect(true, response.success);
    expect(true, response.data is Item);
  });
}
