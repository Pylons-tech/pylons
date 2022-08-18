import 'dart:convert';

class SdkIpcResponse {
  bool success;
  String errorCode;
  String error;
  dynamic data;
  String sender;
  String action;

  SdkIpcResponse(
      {required this.success,
      required this.error,
      required this.data,
      required this.sender,
      required this.errorCode,
      required this.action});

  factory SdkIpcResponse.success(
      {required dynamic data,
      required String sender,
      required String transaction}) {
    return SdkIpcResponse(
        sender: sender,
        data: data,
        success: true,
        error: '',
        errorCode: '',
        action: transaction);
  }

  factory SdkIpcResponse.failure(
      {required String error,
      required String sender,
      required String errorCode}) {
    return SdkIpcResponse(
        sender: sender,
        data: '',
        success: false,
        error: error,
        errorCode: errorCode,
        action: '');
  }

  String toBas64Hash() => base64Url.encode(utf8.encode(toJson()));

  String toJson() => jsonEncode({
        'success': success,
        'error': error,
        'data': data,
        'action': action,
        'errorCode': errorCode
      });

  String createMessageLink({required bool isAndroid}) {
    if (isAndroid) {
      return 'pylons://$sender/${toBas64Hash()}';
    }
    return '$sender://${toBas64Hash()}';
  }

  @override
  String toString() {
    return 'SdkIpcResponse{success: $success, errorCode: $errorCode, error: $error, data: $data, sender: $sender, action: $action}';
  }
}
