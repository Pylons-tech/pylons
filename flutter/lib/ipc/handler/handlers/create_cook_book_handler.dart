import 'package:flutter/foundation.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/modules/pylons/module/client/pylons/tx.pb.dart';

class CreateCookBookHandler implements BaseHandler {

  List<String> wholeMessage;


  CreateCookBookHandler(this.wholeMessage);

  @override
  Future<String> handle() {

    MsgCreateCookbookResponse.fromJson();


    return SynchronousFuture('');
  }
}
