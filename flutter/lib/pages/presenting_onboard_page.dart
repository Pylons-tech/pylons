import 'dart:async';

import 'package:cosmos_utils/mnemonic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_white_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/forms/import_from_google_form.dart';
import 'package:pylons_wallet/forms/new_user_form.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_main.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

PageController _controller = PageController();

class PresentingOnboardPage extends StatelessWidget {


  WalletsStore get walletsStore => GetIt.I.get();




  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          SizedBox(
            height: screenSize.height(percent: 0.075),
            child: SmoothPageIndicator(
              controller: _controller, // PageController
              count: 3,
              effect: const WormEffect(
                dotHeight: 4,
                dotWidth: 4,
              ), // your preferred effect
            ),
          ),
          SizedBox(
            height: screenSize.height(percent: 0.72),
            child: OnboardingPageView(),
          ),
          PylonsWhiteButton(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  builder: (context) => Wrap(children: const [ImportFromGoogleForm()]));
            },
            text: "import_an_account".tr(),
          ),
          const VerticalSpace(10),
          PylonsBlueButton(
            onTap: () {
              onCreateAccountPressed(context);
            },
            text: "create_an_account".tr(),
          ),
          const VerticalSpace(10),
          GestureDetector(
            onTap: () {},
            child: Text("terms_of_service".tr(),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    // decoration: TextDecoration.underline,
                    color: Color(0xff1212C4))),
          )
        ]),
      )),
    );
  }

  /// Create the new wallet and associate the choosen username with it.
  Future _registerNewUser(String userName, BuildContext context) async {
    final _mnemonic = await generateMnemonic();
    final _username = userName;

    PylonsApp.currentWallet = await walletsStore.importAlanWallet(_mnemonic, _username);
    // print("Wallet add: ${value.publicAddress} ${value.name} ${value.chainId}");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => Dashboard()), (route) => true);
  }

  void onCreateAccountPressed(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) => Wrap(children: [NewUserForm(onValidate: (userName) => _registerNewUser(userName, context))]));
  }
}

class OnboardingPageView extends StatefulWidget {
  @override
  _OnboardingPageViewState createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  // static const TextStyle textLooks = TextStyle(fontFamily: 'Inter');

  var _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // TODO enable it later causing issue in testing
    const interval = Duration(seconds: 5);
    var timer = Timer.periodic(interval, (Timer timer) {
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
      onPageChanged: (page) {
        _currentPage = page;
      },
      children: [
        Page1(),
        Page2(),
        Page3(),
      ],
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Expanded(
        child: Image(
          image: AssetImage(
            'assets/images/image_001.png',
          ),
        ),
      ),
      const SizedBox(
        height: 29,
      ),
      Text(
        "manage_your_nft".tr(),
        style: Theme.of(context).textTheme.headline2!.copyWith(color: const Color(0xFF333333)),
      ),
      Text("pylons_infrastructure".tr(), style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xFF616161))),
      const SizedBox(
        height: 38,
      ),
    ]);
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Expanded(
        child: Image(
          image: AssetImage('assets/images/image_002.png'),
        ),
      ),
      const SizedBox(
        height: 29,
      ),
      Text("sell_and_buy_artworks".tr(), style: Theme.of(context).textTheme.headline2!.copyWith(color: const Color(0xFF333333))),
      Text("transactions_free".tr(), style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xFF616161))),
      Text("easy_for_everyone".tr(), style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xFF616161))),
      const SizedBox(
        height: 19,
      ),
    ]);
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Column(children: <Widget>[
      const Expanded(
        child: Image(
          image: AssetImage('assets/images/image_001.png'),
          alignment: Alignment.bottomCenter,
        ),
      ),
      const SizedBox(
        height: 29,
      ),
      Text("it_stores_in_blockchain".tr(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline2!.copyWith(color: const Color(0xFF333333))),
      SizedBox(
        height: screenSize.height(percent: 0.077),
      ),
    ]);
  }
}
