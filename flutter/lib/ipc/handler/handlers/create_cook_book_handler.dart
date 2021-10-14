import 'package:flutter/foundation.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';

class CreateCookBookHandler implements BaseHandler {
  List<String> wholeMessage;

  CreateCookBookHandler(this.wholeMessage);

  @override
  Future<String> handle() {
    // MsgCreateCookbookResponse.fromJson();

    return SynchronousFuture('');
  }
}
