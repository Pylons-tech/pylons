import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class NotificationItem extends StatelessWidget {

  const NotificationItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(right: 6, left: 6),
        child:Column(
            children: [
              Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: FlutterLogo(size: 20.0),
                        ),
                        title: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: 'Jimin', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' purchased'),
                              TextSpan(text: ' Title of Artwork', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: ClipRect(
                          child: Image(
                            image: AssetImage('assets/images/Rectangle 312.png'),
                            width: 44,
                            height: 44,
                            fit: BoxFit.fill,
                          )
                        )
                    )
                  ]
              ),
          ]
        )
    );
  }
}
