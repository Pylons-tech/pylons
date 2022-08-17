import 'dart:convert';

class SdkIpcMessage {
  /// The operation to be performed by the wallet.
  String action;

  /// The data supplied for that operation.
  String json;
  String sender;
  bool requestResponse;

  SdkIpcMessage({required this.action, required this.json, required this.sender, required this.requestResponse});

  factory SdkIpcMessage.fromIpcMessage(String base64EncodedMessage) {
    final json = utf8.decode(base64Url.decode(base64EncodedMessage));
    final jsonMap = Map<String, dynamic>.from(jsonDecode(json) as Map);

    /// This will support the old sdk
    var requestResponse = true;

    if (jsonMap.containsKey('request_response') && jsonMap['request_response'] is bool) {
      requestResponse = jsonMap['request_response'] as bool;
    }

    return SdkIpcMessage(action: jsonMap['action'].toString(), json: jsonMap['json'].toString(), sender: jsonMap['sender'].toString(), requestResponse: requestResponse);
  }

  String toJson() => jsonEncode({'sender': sender, 'json': json, 'action': action, 'request_response': requestResponse});

  String createMessage() => base64Url.encode(utf8.encode(toJson()));

  @override
  String toString() {
    return 'SDKIPCMessage{action: $action, json: $json, sender: $sender, requestResponse: $requestResponse}';
  }
}
