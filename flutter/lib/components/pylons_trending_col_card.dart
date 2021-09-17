import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsTrendingColCard extends StatelessWidget {

  const PylonsTrendingColCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(right: 6),
        width: 320,
        child:Column(
            children: [
              Row(
                  children: [
                    Expanded(
                        child:ListTile(
                            leading: CircleAvatar(
                              child: FlutterLogo(size: 20.0),
                            ),
                            title: Text('Linda')
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: IconButton(
                          onPressed: (){},
                          icon: ImageIcon(
                              AssetImage('assets/images/icon/add_friend.png')
                          ),
                        )
                    )
                  ]
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            //1x2 image
                            Image(
                              image: AssetImage('assets/images/Rectangle 312.png'),
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover
                            ),
                            SizedBox(
                              width: 2.0
                            ),
                            Column(
                              children: [
                                Image(
                                  image: AssetImage('assets/images/Rectangle 312.png'),
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover
                                ),
                                SizedBox(
                                    height: 2.0
                                ),
                                Image(
                                    image: AssetImage('assets/images/Rectangle 312.png'),
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover
                                )
                              ]
                            )
                          ],
                        )
                      )
                    ],
                  )
                )
              ),
              Container(
                child: Text('Collection Title'),
              )
            ]
        )
    );
  }
}
