import 'package:flutter/material.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/ipc/local_server.dart';

class UserInfoProvider extends ChangeNotifier {
  final IPCEngine _ipcEngine;
  final LocalServer _localServer;

  UserInfoProvider(this._ipcEngine, this._localServer);

  void onImageChange() {
    notifyListeners();
  }

  void initIPC() {
    _ipcEngine.init();
    _localServer.init();
  }

  @override
  void dispose() {
    _ipcEngine.dispose();
    super.dispose();
  }
}
