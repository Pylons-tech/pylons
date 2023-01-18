import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

abstract class IPCHandler<T> {
  void handler(SDKIPCResponse response, void Function(String key, SDKIPCResponse<T> response) onHandlingComplete);
}
