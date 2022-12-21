import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

abstract class IPCHandler {
  void handler(SDKIPCResponse response, void Function(String key, SDKIPCResponse response) onHandlingComplete);
}
