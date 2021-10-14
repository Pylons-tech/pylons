import 'package:flutter/material.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_assets.dart';

class PylonsAppDrawer extends StatelessWidget {
  final String title;

  const PylonsAppDrawer({
    Key? key,
    this.title = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Tierre'),
              accountEmail: Text('werwerw'),
              currentAccountPicture: CircleAvatar(
                child: FlutterLogo(size: 42.0),
              ),
            ),
            ListTile(
              title: const Text('qwerqwerqwer'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                //Navigator.pop(context);
              },
            ),
            ListTile(
                title: const Text('qwerqwerqwer'),
                leading: const Icon(Icons.comment),
                onTap: () {
                  //Navigator.pop(context);
                }),
            ListTile(
                title: const Text('Balances'),
                leading: const Icon(Icons.account_balance_wallet),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardAssets()));
                })
          ],
        ),
      ),
    );
  }
}
