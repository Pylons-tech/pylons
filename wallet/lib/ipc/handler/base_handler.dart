import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';

abstract class BaseHandler {
  late SdkIpcMessage sdkIpcMessage;

  Future<SdkIpcResponse> handle();
}
