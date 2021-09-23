import 'package:cosmos_ui_components/cosmos_ui_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_main.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    //TODO: Create an option for the user to change to a different wallet.
    if (store.loadWalletsFailure.value == null) {
      //Loads the last used wallet.
      final prefs = await SharedPreferences.getInstance();
      final currentWallet = prefs.getString("pylons:current_wallet");
      if (currentWallet == null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PresentingOnboardPage()));
      } else {
        PylonsApp.currentWallet = PylonsApp.walletsStore.wallets.value
            .firstWhere((wallet) => wallet.name == currentWallet);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const Dashboard()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      body: ContentStateSwitcher(
        isLoading: PylonsApp.walletsStore.areWalletsLoading.value,
        isError: PylonsApp.walletsStore.loadWalletsFailure.value != null,
        errorChild: CosmosErrorView(
          title: "somethingWrong".tr(),
          message: "walletRetrievingErrMsg".tr(),
        ),
        contentChild: const SizedBox(),
      ),
    );
  }
}
