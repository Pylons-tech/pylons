import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/low_level.dart' as ll;
import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/handlers/get_trades_handler.dart';

import '../../../../mocks/mock_constants.dart';

void main() {
  test('should complete the get trades future', () {
    var sdkResponse = ll.SDKIPCResponse(success: false, error: '', data: '', errorCode: '', action: '');
    var handler = GetTradesHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_TRADES);
      expect(response.success, false);
    }));
  });

  test('should complete the get trades future with data ', () async {
    var sdkResponse = ll.SDKIPCResponse(
      success: true,
      error: '',
      data: [MOCK_TRADE.toProto3Json()],
      errorCode: '',
      action: '',
    );
    var handler = GetTradesHandler();

    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_TRADES);
      expect(response.success, true);
      expect(true, response.data is List<ll.Trade>);
      expect(1, List<ll.Trade>.from(response.data).length);
    }));
  });

  test('should complete the get trades future with error ', () async {
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
      action: '',
    );
    var handler = GetTradesHandler();
    handler.handler(sdkResponse, ((key, response) {
      expect(key, Strings.GET_TRADES);
      expect(response.success, false);
      expect(Strings.ERR_MALFORMED_TRADES, response.errorCode);
    }));
  });
}
