import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'handler/handler_factory.dart';
import 'models/sdk_ipc_message.dart';
import 'dart:developer';

class LocalServer {
  LocalServer(this.handlerFactory);

  HandlerFactory handlerFactory;

  Future<void> init() async {
    if (initialized) {
      return;
    }
    initialized = true;
    final handler = const Pipeline().addMiddleware(logRequests()).addHandler(_ipcRequest);
    final server = await shelf_io.serve(handler, 'localhost', 3333);

    // Enable content compression
    server.autoCompress = true;

    log('Serving at http://${server.address.host}:${server.port}');
  }

  Future<Response> _ipcRequest(Request request) async {
    log("Incoming request");

    final getMessage = request.url.toString().split('/').last;

    if (getMessage == "exists") {
      return Response.ok("Online");
    }

    SdkIpcMessage sdkIPCMessage;

    try {
      sdkIPCMessage = SdkIpcMessage.fromIpcMessage(getMessage);
      final handlerMessage = await handlerFactory.getHandler(sdkIPCMessage).handle();

      if (handlerMessage == null) {
        return Response.badRequest(body: "No data");
      }

      final messageLink = handlerMessage.createMessageLink(isAndroid: Platform.isAndroid);
      return Response.ok(messageLink);
    } catch (error) {
      return Response.badRequest(body: "Something went wrong ${error.toString()}");
    }
  }

  bool initialized = false;
}
