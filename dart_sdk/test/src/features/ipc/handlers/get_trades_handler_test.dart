import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/low_level.dart' as ll;
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_trades_handler.dart';
import 'package:pylons_sdk/src/pylons_wallet/response_fetcher/response_fetch.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get trades future', () {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_TRADES);
    var sdkResponse = ll.SDKIPCResponse(
        success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetTradesHandler();
    handler.handler(sdkResponse);
    expect(true, completer.isCompleted);
  });

  test('should complete the get trades future with data ', () async {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_TRADES);
    var sdkResponse = ll.SDKIPCResponse(
        success: true,
        error: '',
        data: [MOCK_TRADE.toProto3Json()],
        errorCode: '',
        action: '');
    var handler = GetTradesHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, completer.isCompleted);
    });

    var response = await completer.future;
    expect(true, response.success);
    expect(true, response.data is List<ll.Trade>);
    expect(1, List<ll.Trade>.from(response.data).length);
  });

  test('should complete the get trades future with error ', () async {
    final completer = getResponseFetch().initResponseCompleter(Strings.GET_TRADES);
    var sdkResponse = ll.SDKIPCResponse(
        success: true,
        error: '',
        data: [
          // Will throw parsing error
          ll.Trade()
            ..createEmptyInstance()
            ..toProto3Json()
        ],
        errorCode: '',
        action: '');
    var handler = GetTradesHandler();

    Future.delayed(Duration(seconds: 1), () {
      handler.handler(sdkResponse);
      expect(true, completer.isCompleted);
    });

    var response = await completer.future;
    expect(false, response.success);
    expect(Strings.ERR_MALFORMED_TRADES, response.errorCode);
  });
}
