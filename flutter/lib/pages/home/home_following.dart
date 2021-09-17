import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/add_friend_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/components/pylons_trending_col_card.dart';
import 'package:pylons_wallet/constants/constants.dart';

class HomeFollowingWidget extends StatefulWidget {
  const HomeFollowingWidget({Key? key}) : super(key: key);

  @override
  State<HomeFollowingWidget> createState() => _HomeFollowingWidgetState();
}

class _HomeFollowingWidgetState extends State<HomeFollowingWidget> {

  @override
  Widget build(BuildContext context) {
    double padding = 10;
    double tileWidth =  (MediaQuery. of(context). size. width - 30) / 3;

    return SliverList(
      delegate: SliverChildListDelegate([
        //3 image card
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
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
                                TextSpan(text: ' created'),
                                TextSpan(text: ' \'Photography\'', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' collection')
                              ],
                            ),
                          ),
                        ),
                      ),

                      MoreButton(onTap: (){
                      })
                    ]
                ),
              Container(
                child:  Card(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Column(
                        children: [
                          Container(
                              child: Row(
                                children: [
                                  Image(
                                    image: AssetImage('assets/images/Rectangle 312.png'),
                                    width: tileWidth * 2,
                                    height: tileWidth * 2 + 3,
                                    fit: BoxFit.cover
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Image(
                                        image: AssetImage('assets/images/Rectangle 312.png'),
                                        width: tileWidth,
                                        height: tileWidth,
                                        fit: BoxFit.cover
                                      ),
                                      SizedBox(height: 3),
                                      Image(
                                        image: AssetImage('assets/images/Rectangle 312.png'),
                                        width: tileWidth,
                                        height: tileWidth,
                                        fit: BoxFit.cover
                                      ),
                                    ]
                                  )
                                ]
                              )
                          ),
                          Row(
                              children:[
                                IconButton(
                                    icon: ImageIcon(
                                        AssetImage('assets/images/icon/union.png'),
                                        size: 24,
                                        color: kIconBGColor
                                    ),
                                    onPressed: () {}
                                ),
                                Text('40'),
                                IconButton(
                                    icon: ImageIcon(
                                        AssetImage('assets/images/icon/favorite_border.png'),
                                        size: 24,
                                        color: kIconBGColor
                                    ),
                                    onPressed: () {}
                                ),
                                Text('142'),
                                Spacer(),
                                IconButton(
                                    icon: ImageIcon(
                                        AssetImage('assets/images/icon/dots.png'),
                                        size: 24,
                                        color: kIconBGColor
                                    ),
                                    onPressed: () {}
                                ),
                              ]
                          )
                        ]
                        )
                    )
                ),

              ),
          ],
        )
      ),
        SizedBox(height: 20),
        //1 image card
        Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

            child: Column(
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
                                TextSpan(text: ' created'),
                                TextSpan(text: ' \'Photography\'', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' collection')
                              ],
                            ),
                          ),
                        ),
                      ),

                      MoreButton(onTap: (){
                      })
                    ]
                ),
                Container(
                  child:  Card(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Column(
                          children: [
                            Image(
                                image: AssetImage('assets/images/Rectangle 312.png'),
                                width: MediaQuery. of(context). size. width - 20,
                                height: tileWidth,
                                fit: BoxFit.fitWidth
                            ),
                            Row(
                                children:[
                                  IconButton(
                                      icon: ImageIcon(
                                          AssetImage('assets/images/icon/union.png'),
                                          size: 24,
                                          color: kIconBGColor
                                      ),
                                      onPressed: () {}
                                  ),
                                  Text('40'),
                                  IconButton(
                                      icon: ImageIcon(
                                          AssetImage('assets/images/icon/favorite_border.png'),
                                          size: 24,
                                          color: kIconBGColor
                                      ),
                                      onPressed: () {}
                                  ),
                                  Text('142'),
                                  Spacer(),
                                  IconButton(
                                      icon: ImageIcon(
                                          AssetImage('assets/images/icon/dots.png'),
                                          size: 24,
                                          color: kIconBGColor
                                      ),
                                      onPressed: () {}
                                  ),
                                ]
                            )
                          ]
                      )
                    )
                  ),

                ),
              ],
            )
        ),
        SizedBox(height: 20),
        Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

            child: Column(
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
                                TextSpan(text: ' created'),
                                TextSpan(text: ' \'Photography\'', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' collection')
                              ],
                            ),
                          ),
                        ),
                      ),

                      MoreButton(onTap: (){
                      })
                    ]
                ),
                Container(
                  child:  Card(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                              children: [
                                Image(
                                    image: AssetImage('assets/images/Rectangle 312.png'),
                                    width: MediaQuery. of(context). size. width - 20,
                                    height: tileWidth,
                                    fit: BoxFit.fitWidth
                                ),
                                Row(
                                    children:[
                                      IconButton(
                                          icon: ImageIcon(
                                              AssetImage('assets/images/icon/union.png'),
                                              size: 24,
                                              color: kIconBGColor
                                          ),
                                          onPressed: () {}
                                      ),
                                      Text('40'),
                                      IconButton(
                                          icon: ImageIcon(
                                              AssetImage('assets/images/icon/favorite_border.png'),
                                              size: 24,
                                              color: kIconBGColor
                                          ),
                                          onPressed: () {}
                                      ),
                                      Text('142'),
                                      Spacer(),
                                      IconButton(
                                          icon: ImageIcon(
                                              AssetImage('assets/images/icon/dots.png'),
                                              size: 24,
                                              color: kIconBGColor
                                          ),
                                          onPressed: () {}
                                      ),
                                    ]
                                )
                              ]
                          )
                      )
                  ),

                ),
              ],
            )
        ),
        SizedBox(height: 20),
      ])
    );
  }
}
