import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_trades_handler.dart';
import 'package:pylons_sdk/src/features/ipc/responseCompleters.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get trades future', () {
    initResponseCompleter(Strings.GET_TRADES);
    var sdkResponse = SDKIPCResponse(
        success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetTradesHandler();
    handler.handler(sdkResponse);
    expect(true, responseCompleters[Strings.GET_TRADES]!.isCompleted);
  });

  test('should complete the get trades future with data ', () async {
    initResponseCompleter(Strings.GET_TRADES);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: [MOCK_TRADE.toProto3Json()],
        errorCode: '',
        action: '');
    var handler = GetTradesHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_TRADES]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_TRADES]!.future;
    expect(true, response.success);
    expect(true, response.data is List<Trade>);
    expect(1, List<Trade>.from(response.data).length);
  });

  test('should complete the get trades future with error ', () async {
    initResponseCompleter(Strings.GET_TRADES);
    var sdkResponse = SDKIPCResponse(
        success: true,
        error: '',
        data: [
          // Will throw parsing error
          Trade()
            ..createEmptyInstance()
            ..toProto3Json()
        ],
        errorCode: '',
        action: '');
    var handler = GetTradesHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, responseCompleters[Strings.GET_TRADES]!.isCompleted);
    });

    var response = await responseCompleters[Strings.GET_TRADES]!.future;
    expect(false, response.success);
    expect(Strings.ERR_MALFORMED_TRADES, response.errorCode);
  });
}
