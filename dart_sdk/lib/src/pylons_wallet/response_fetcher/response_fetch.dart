import 'dart:async';
import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';

import '../../../low_level.dart';
import '../../features/ipc/ipc_constants.dart';
import '../../features/ipc/ipc_handler_factory.dart';
import '../../features/models/sdk_ipc_message.dart';
import 'package:http/http.dart' as http;

abstract class ResponseFetch {
  void complete({required String key, required SDKIPCResponse sdkipcResponse});
  Completer<SDKIPCResponse> initResponseCompleter(String key);

  bool listenerExists({required String key});

  Future<SDKIPCResponse> sendMessage(SDKIPCMessage sdkipcMessage, Completer<SDKIPCResponse> completer);
}

ResponseFetch getResponseFetch() {
  if (Platform.isIOS) {
    return IOSResponseFetch.instance;
  } else {
    return AndroidResponseFetchV2.instance;
  }
}

class IOSResponseFetch implements ResponseFetch {
  IOSResponseFetch._();

  static final IOSResponseFetch instance = IOSResponseFetch._();

  final Map<String, Completer<SDKIPCResponse>> responseCompleters = {
    // since initResponseCompleter is always called for any given key before a valid response can be handled,
    // we don't need to set them up individually here. either it'll be in the map when you look,
    // or you're doing something wrong and should expect a crash regardless.
  };

  @override
  Completer<SDKIPCResponse> initResponseCompleter(String key) {
    responseCompleters[key] = Completer();
    return responseCompleters[key]!;
  }

  @override
  void complete({required String key, required SDKIPCResponse sdkipcResponse}) {
    if (responseCompleters.containsKey(key)) {
      responseCompleters[key]!.complete(sdkipcResponse);
    }
  }

  @override
  bool listenerExists({required String key}) {
    return responseCompleters.containsKey(key);
  }

  @override
  Future<SDKIPCResponse> sendMessage(SDKIPCMessage sdkipcMessage, Completer<SDKIPCResponse> completer) {
    final encodedMessage = sdkipcMessage.createMessage();
    final universalLink = createLink(encodedMessage: encodedMessage);
    dispatchUniLink(universalLink);
    return completer.future;
  }

  String createLink({required String encodedMessage}) {
    return '$BASE_UNI_LINK_IOS$encodedMessage';
  }

  void dispatchUniLink(String uniLink) async {
    await canLaunchUrlString(uniLink) ? await launchUrlString(uniLink) : throw NoWalletException();
  }
}

class AndroidResponseFetch implements ResponseFetch {
  AndroidResponseFetch._();

  static final AndroidResponseFetch instance = AndroidResponseFetch._();

  /// Map of message/response keys to completer references.
  ///
  /// NOTES ON DESIGN/USAGE OF THESE COMPLETERS:
  ///
  /// a) This is a simple persistence mechanism to enable the response-handler layer to grab
  ///    references to the Completer instances used in the initial API calls. Each of these is
  ///    a completer "slot" that's populated w/ a new completer when the appropriate API call fires.
  ///    The next response matching that key will grab the completer in that slot and complete it.
  ///    Because of this, there are a few gotchas that future maintainers of this codebase should
  ///    be aware of.
  ///
  /// b) This means that each SDK call _must_ re-initialize the completer when it is called. If
  ///    the completer is not initialized by the method body, it'll contain a reference to an old
  ///    (completed) completer when the response grabs it, and bad things will happen.
  ///
  /// c) So, don't create these manually. Use the [initResponseCompleter] helper function instead to
  ///    minimize the chance for dumb bugs to creep in.

  final Map<String, Completer<SDKIPCResponse>> responseCompleters = {
    // since initResponseCompleter is always called for any given key before a valid response can be handled,
    // we don't need to set them up individually here. either it'll be in the map when you look,
    // or you're doing something wrong and should expect a crash regardless.
  };

  @override
  Completer<SDKIPCResponse> initResponseCompleter(String key) {
    responseCompleters[key] = Completer();
    return responseCompleters[key]!;
  }

  @override
  void complete({required String key, required SDKIPCResponse sdkipcResponse}) {
    if (responseCompleters.containsKey(key)) {
      responseCompleters[key]!.complete(sdkipcResponse);
    }
  }

  @override
  bool listenerExists({required String key}) {
    return responseCompleters.containsKey(key);
  }

  @override
  Future<SDKIPCResponse> sendMessage(SDKIPCMessage sdkipcMessage, Completer<SDKIPCResponse> completer) {
    final encodedMessage = sdkipcMessage.createMessage();
    final universalLink = createLink(encodedMessage: encodedMessage);
    dispatchUniLink(universalLink);
    return completer.future;
  }

  String createLink({required String encodedMessage}) {
    return '$BASE_UNI_LINK/$encodedMessage';
  }

  void dispatchUniLink(String uniLink) async {
    await canLaunchUrlString(uniLink) ? await launchUrlString(uniLink) : throw NoWalletException();
  }
}

class AndroidResponseFetchV2 implements ResponseFetch {
  AndroidResponseFetchV2._();

  static final AndroidResponseFetchV2 instance = AndroidResponseFetchV2._();
  @override
  void complete({required String key, required SDKIPCResponse sdkipcResponse}) {}

  @override
  Completer<SDKIPCResponse> initResponseCompleter(String key) {
    return Completer();
  }

  @override
  bool listenerExists({required String key}) {
    throw UnimplementedError();
  }

  @override
  Future<SDKIPCResponse> sendMessage(SDKIPCMessage sdkipcMessage, Completer<SDKIPCResponse> _) async {
    final completer = Completer<SDKIPCResponse>();

    try {
      final encodedMessage = sdkipcMessage.createMessage();

      final response = await http.get(Uri.parse('http://127.0.0.1:3333/$encodedMessage'));

      if (response.statusCode == 200) {
        final message = response.body.split('/').last;

        final sdkipcResponse = SDKIPCResponse.fromIPCMessage(message);

        IPCHandlerFactory.handlers[sdkipcResponse.action]!.handler(
          sdkipcResponse,
          ((key, response) async {
            completer.complete(response);
          }),
        );
      }
    } on http.ClientException catch (e) {
      if (e.message == 'Connection refused') {
        completer.completeError(Exception('Wallet App is not in background'));
      } else {
        completer.completeError(e);
      }
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
