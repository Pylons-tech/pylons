import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/next_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';

class GalleryTabCollectionWidget extends StatelessWidget {

  const GalleryTabCollectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 100),
        //margin: const EdgeInsets.only(bottom: 100.0),
        child: Column(
            children: [
              //Creator
              Card(
                child: Column(
                  children: [

                  ],
                )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFF1F1F2),  // red as border color
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: FlutterLogo(),
                    ),
                    title:RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: 'Linda', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' purchased'),
                          TextSpan(text: ' Title of Artwork', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    subtitle: Text('28 Dec, 2021',style: TextStyle(color: Color(0xFFC4C4C4))),
                    trailing: NextButton(onTap: (){}),
                  )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFF1F1F2),  // red as border color
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: FlutterLogo(),
                  ),
                  title:RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: 'Linda', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' purchased'),
                        TextSpan(text: ' Title of Artwork', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  subtitle: Text('28 Dec, 2021',style: TextStyle(color: Color(0xFFC4C4C4))),
                  trailing: NextButton(onTap: (){}),
                ),
              )
            ]
        )
    );
  }
}
