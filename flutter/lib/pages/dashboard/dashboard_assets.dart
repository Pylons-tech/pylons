import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_white_button.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/transactions/buy_pylons.dart';
import 'package:pylons_wallet/transactions/pylons_balance.dart';
import 'package:web_socket_channel/io.dart';

class DashboardAssets extends StatefulWidget {
  const DashboardAssets({Key? key}) : super(key: key);

  @override
  _DashboardAssetsState createState() => _DashboardAssetsState();
}

class _DashboardAssetsState extends State<DashboardAssets> {
  late Decimal _balance = Decimal.fromInt(0);

  @override
  void initState() {
    super.initState();
    //Query the balance and update it.
    () async {
      PylonsBalance(PylonsApp.baseEnv)
        ..getBalance(PylonsApp.currentWallet.publicAddress).then((balance) {
          setState(() {
            _balance = balance.amount.value;
          });
        });
    }();
    final channel = IOWebSocketChannel.connect(Uri.parse(
        "${PylonsApp.baseEnv.baseWsUrl}?transfer.recipient=${PylonsApp.currentWallet.publicAddress}"));
    channel.stream.listen((message) {
      debugPrint("received $message");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("total_assets".tr(),
                  style: const TextStyle(color: Colors.black, fontSize: 18)),
            ],
          ),
          Row(children: <Widget>[
            Text("$_balance",
                style: const TextStyle(color: Colors.black, fontSize: 36)),
            const Text("  PYLONS",
                style: TextStyle(color: Colors.indigo, fontSize: 36)),
          ]),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PylonsBlueButton(onTap: _buypylons, text: "${'buy'.tr()} Pylons"),
                  PylonsWhiteButton(onTap: () {}, text: "${'send'.tr()} Pylons")
                ],
              )),
        ],
      ),
    );
  }

  void _buypylons() {
    BuyPylons()
      ..buy().then((value) {
        PylonsBalance(PylonsApp.baseEnv)
          ..getBalance(PylonsApp.currentWallet.publicAddress).then((balance) {
            setState(() {
              _balance = balance.amount.value;
            });
          });
      });
  }
}
