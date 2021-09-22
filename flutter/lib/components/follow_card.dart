import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';

class FollowCardWidget extends StatelessWidget {

  const FollowCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double tileWidth = 85;
    double buttonWidth = tileWidth * 0.9;
    return Card(
            child: Container(
                width: tileWidth,
                child:Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                            child: InkWell(
                              child: Icon(Icons.close,size: 10),
                              onTap: () {  },
                            )
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            child: FlutterLogo(size: 20.0),
                          )
                      ),
                      Text('JIN'),
                      SizedBox(
                        height: 25,
                        width: buttonWidth,
                        child: PylonsBlueButton(text: 'Follow',onTap: () {  },
                      ),
                      )
                    ]
                )
            )
      );
  }
}
