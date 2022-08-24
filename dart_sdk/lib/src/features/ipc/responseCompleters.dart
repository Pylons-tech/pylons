import 'dart:async';

import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

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

/// Initialize a response completer for [key] and return that completer.
Completer<SDKIPCResponse> initResponseCompleter(String key) {
  responseCompleters[key] = Completer();
  return responseCompleters[key]!;
}
