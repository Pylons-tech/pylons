import 'package:flutter/material.dart';

class PylonsAppDrawer extends StatelessWidget {
  final String title;

  const PylonsAppDrawer({
    Key? key,
    this.title = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child:  Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Tierre'),
              accountEmail: Text('werwerw'),
              currentAccountPicture: const CircleAvatar(
                child: FlutterLogo(size: 42.0),
              ),
            ),
            ListTile(
              title: Text('qwerqwerqwer'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                //Navigator.pop(context);
              },
            ),
            ListTile(
                title: Text('qwerqwerqwer'),
                leading:const Icon(Icons.comment),
                onTap: (){
                  //Navigator.pop(context);
                }
            )
          ],
        ),
      ),
    );
  }
}
