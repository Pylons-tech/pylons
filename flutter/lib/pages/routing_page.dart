import 'package:cosmos_ui_components/cosmos_ui_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_main.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page.dart';
import 'package:pylons_wallet/pylons_app.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  _RoutingPageState createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  @override
  void initState() {
    super.initState();
    _loadWallets();
  }

  Future<void> _loadWallets() async {
    final store = PylonsApp.walletsStore;
    await store.loadWallets();
    if (store.wallets.value.isEmpty) {
      //Loads the last used wallet.
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => PresentingOnboardPage()));
    } else {
      // Assigning the latest wallet to the app.
      PylonsApp.currentWallet = store.wallets.value.last;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Dashboard()));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      body: ContentStateSwitcher(
        isLoading: PylonsApp.walletsStore.areWalletsLoading.value,
        isError: PylonsApp.walletsStore.loadWalletsFailure.value != null,
        errorChild: CosmosErrorView(
          title: "something_wrong".tr(),
          message: "wallet_retrieving_err_msg".tr(),
        ),
        contentChild: const SizedBox(),
      ),
    );
  }
}
