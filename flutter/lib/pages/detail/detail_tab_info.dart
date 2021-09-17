import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';

class DetailTabInfoWidget extends StatelessWidget {

  const DetailTabInfoWidget({
    Key? key,
  }) : super(key: key);

  static List<String> tags = [
    '#3D', '#Photography', '#Sculpture'
  ];

  static List<String> nfts= [
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 100),
        //margin: const EdgeInsets.only(bottom: 100.0),
        child: Column(
          children: [
            //Creator
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child:Text('Creator', style:TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: FlutterLogo(),
                  ),
                  title: Text('Jimin',style: TextStyle(fontSize:16, fontWeight: FontWeight.w600)),
                  trailing: ElevatedButton(
                    onPressed: (){},
                    child: Text('Following')
                  ),
                ),
                Divider()
              ],
            ),
            //owner list
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Owner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: FlutterLogo(),
                  ),
                  title: Text('Linda',style: TextStyle(fontSize:16, fontWeight: FontWeight.w600)),
                  trailing: ElevatedButton(
                      onPressed: (){},
                      child: Text('Following')
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: FlutterLogo(),
                  ),
                  title: Text('Yuri',style: TextStyle(fontSize:16, fontWeight: FontWeight.w600)),
                  trailing: ElevatedButton(
                      onPressed: (){},
                      child: Text('Following')
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}
