import 'package:pylons_sdk/pylons_sdk.dart';

class ShowInstallBottomSheetViewModel {
  final PylonsWallet pylonsWallet;

  ShowInstallBottomSheetViewModel({required this.pylonsWallet});

  Future<bool> goToInstall() async {
    final didGo = await pylonsWallet.goToInstall();
    return didGo;
  }
}
