import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/transactions/pylons_balance.dart';

class DashboardAssets extends StatefulWidget {
  const DashboardAssets({Key? key}) : super(key: key);

  @override
  _DashboardAssetsState createState() => _DashboardAssetsState();
}

class _DashboardAssetsState extends State<DashboardAssets> {

  @override
  void initState() {
    super.initState();
  }

  var _assetsList = <Widget>[];

  @override
  Widget build(BuildContext context) {
    final address = PylonsApp.currentWallet.publicAddress;
    _buildAssetsList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balances'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Address".tr(),
                      style:
                      const TextStyle(color: Colors.black, fontSize: 18)),
                  Text(address,
                      style:
                      const TextStyle(color: Colors.black, fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: address));
                    },
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: _assetsList,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment Counter',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _buildAssetsList() async {
    //Query the balance and update it.
    final balanceObj = PylonsBalance(PylonsApp.baseEnv);
    final balances = await balanceObj.getBalance(PylonsApp.currentWallet.publicAddress);
    final assetsList = <Widget>[];
    for (final balance in balances) {
      final denom = balance.denom.toString();
      final amount = balance.amount.toString();
      assetsList.add(Row(children: <Widget>[
        Text("$denom: ", style: const TextStyle(color: Colors.indigo, fontSize: 36)),
        Text(amount, style: const TextStyle(color: Colors.black, fontSize: 36)),
      ]));
    }
    setState(() {
      _assetsList = assetsList;
    });
  }
}
