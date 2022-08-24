import 'dart:convert';

class SDKIPCResponse<T> {
  bool success;
  String errorCode;
  String error;
  T data;
  String action;

  SDKIPCResponse(
      {required this.success,
      required this.error,
      required this.data,
      required this.errorCode,
      required this.action});

  factory SDKIPCResponse.fromIPCMessage(String base64EncodedMessage) {
    final json = utf8.decode(base64Url.decode(base64EncodedMessage));
    final jsonMap = jsonDecode(json);

    return SDKIPCResponse(
        error: jsonMap['error'],
        action: jsonMap['action'],
        errorCode: jsonMap['errorCode'],
        data: jsonMap['data'],
        success: jsonMap['success']);
  }

  factory SDKIPCResponse.success(T data) {
    return SDKIPCResponse(
        error: '', errorCode: '', action: '', data: data, success: true);
  }

  String toBas64Hash() => base64Url.encode(utf8.encode(toJson()));

  String toJson() => jsonEncode({
        'success': success,
        'error': error,
        'data': data,
        'transaction': action
      });

  @override
  String toString() {
    return 'SDKIPCResponse{success: $success, errorCode: $errorCode, error: $error, data: $data, action: $action}';
  }
}
