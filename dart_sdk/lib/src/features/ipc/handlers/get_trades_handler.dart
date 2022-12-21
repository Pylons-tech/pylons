import 'package:pylons_sdk/src/core/constants/strings.dart';
import 'package:pylons_sdk/src/features/ipc/base/ipc_handler.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';
import 'package:pylons_sdk/src/generated/pylons/trade.pb.dart';



class GetTradesHandler implements IPCHandler {
  @override
  void handler(
    SDKIPCResponse<dynamic> response,
    void Function(String key, SDKIPCResponse response) onHandlingComplete,
  ) {
    final defaultResponse = SDKIPCResponse<List<Trade>>(
        success: response.success,
        action: response.action,
        data: [],
        error: response.error,
        errorCode: response.errorCode);
    try {
      if (response.success) {
        defaultResponse.data = List.from(response.data).map((e) {
          return Trade.create()..mergeFromProto3Json(e);
        }).toList();
      }
    } on Exception catch (_) {
      defaultResponse.error = 'Trades parsing failed';
      defaultResponse.errorCode = Strings.ERR_MALFORMED_TRADES;
      defaultResponse.success = false;
    }
    
    return onHandlingComplete(Strings.GET_TRADES, defaultResponse);
  }
}
