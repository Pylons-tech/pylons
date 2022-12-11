import 'dart:async';
import 'dart:io';

import '../../../low_level.dart';

abstract class ResponseFetch {
  void complete({required String key, required SDKIPCResponse sdkipcResponse});
  Completer<SDKIPCResponse> initResponseCompleter(String key);
  
  bool listenerExists({required String key});
}

ResponseFetch getResponseFetch() {
  if (Platform.isIOS) {
    return IOSResponseFetch.instance;
  } else {
    return AndroidResponseFetch.instance;
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
}

class AndroidResponseFetch implements ResponseFetch {
  AndroidResponseFetch._();

  static final IOSResponseFetch instance = IOSResponseFetch._();

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
}
