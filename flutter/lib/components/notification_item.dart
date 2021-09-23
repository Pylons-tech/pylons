import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationItem extends StatelessWidget {

  const NotificationItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.only(right: 6, left: 6),
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
                              TextSpan(text: ' ${'purchased'.tr()}'),
                              TextSpan(text: ' Title of Artwork', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '  10min', style: TextStyle(color: Colors.grey, fontSize: 13)),
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
