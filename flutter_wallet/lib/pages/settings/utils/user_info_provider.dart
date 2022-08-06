import 'package:flutter/material.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';

class UserInfoProvider extends ChangeNotifier {
  final IPCEngine _ipcEngine;


  UserInfoProvider(this._ipcEngine);

  void onImageChange() {
    notifyListeners();
  }



  void initIPC(){
    _ipcEngine.init();
  }


  @override
  void dispose(){
    _ipcEngine.dispose();
    super.dispose();
  }


}
