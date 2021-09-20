import 'dart:async';

import 'package:cosmos_ui_components/components/cosmos_app_bar.dart';
import 'package:cosmos_utils/mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_white_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/forms/import_from_google_form.dart';
import 'package:pylons_wallet/forms/new_user_form.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:pylons_wallet/pages/dashboard/dashboard_main.dart';

PageController _controller = PageController();

class PresentingOnboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, //const CosmosAppBar(
        //title: "Presentation",
      //),
      body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              SizedBox(
                height: 50,
                child: SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: 3,
                  // effect: const WormEffect(), // your preferred effect
                ),
              ),
              SizedBox(
                height: 450,
                child: OnboardingPageView(),
              ),
              PylonsWhiteButton(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                        ),
                      ),
                      builder: (context) => new Wrap(
                          children: [const ImportFromGoogleForm()]
                      )
                  );
                },
                text: "Import an account",
              ),
              const VerticalSpace(10),
              PylonsBlueButton(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft:  Radius.circular(30.0),
                          topRight:  Radius.circular(30.0),
                        ),
                      ),
                      builder: (context) =>  Wrap(
                        children: [NewUserForm(onValidate: (userName) => _registerNewUser(userName,context))]
                      )
                  );
                },
                text: "Create an account",
              ),
              const VerticalSpace(10),
              GestureDetector(
                onTap: () {
                  // TODO : implement hyperlink action
                },
                child: const Text("Terms of service",
                    style: TextStyle(
                        // decoration: TextDecoration.underline,
                        color: Color(0xff1212C4))),
              )
            ]),
        )),
    );
  }

  /// Create the new wallet and associate the choosen username with it.
  Future _registerNewUser(String userName, BuildContext context) async {
    final _mnemonic = generateMnemonic();
    final _username = userName;

    await PylonsApp.walletsStore.importAlanWallet(_mnemonic, _username)
        .then((value){
          //TODO: refactoring : create an util class to read / write values in the preferences store.
          SharedPreferences.getInstance().then((prefs) => prefs.setString("pylons:current_wallet", _username));
          PylonsApp.currentWallet = value;
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Dashboard()));
        });
  }
}

class OnboardingPageView extends StatefulWidget {
  @override
  _OnboardingPageViewState createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  static const TextStyle textLooks = TextStyle(fontFamily: 'Inter');

  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
    const interval =  Duration(seconds: 5);
    Timer.periodic(interval, (Timer timer) {
      if (_currentPage <= 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        Page1(),
        Page2(),
        Page3(),
      ],
      onPageChanged: (page) {
        _currentPage = page;
      },
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: const <Widget>[
      Image(
        image: AssetImage('assets/images/image_001.png'),
        alignment: Alignment.bottomCenter,
      ),
      Text(
        "MANAGE YOUR NFT",
        style: PylonsAppTheme.HOME_TITLE,
      ),
      Text("Pylons is a fast NFT infrastructure",
          style: PylonsAppTheme.HOME_LABEL),
    ]);
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: const <Widget>[
      Image(
        image: AssetImage('assets/images/image_002.png'),
        alignment: Alignment.bottomCenter,
      ),
      Text("SELL AND BUY ARTWORKS", style: PylonsAppTheme.HOME_TITLE),
      Text("Transactions are free", style: PylonsAppTheme.HOME_LABEL),
      Text("Easy to use for everyone", style: PylonsAppTheme.HOME_LABEL),
    ]);
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: const <Widget>[
      Image(
        image: AssetImage('assets/images/image_001.png'),
        alignment: Alignment.bottomCenter,
      ),
      Text("IT STORES IN BLOCKCHAIN", style: PylonsAppTheme.HOME_TITLE),
    ]);
  }
}
