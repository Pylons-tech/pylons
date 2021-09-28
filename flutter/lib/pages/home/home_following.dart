import 'dart:ui';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/add_friend_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/components/pylons_trending_col_card.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';
import 'package:pylons_wallet/pages/gallery/collections.dart';

class HomeFollowingWidget extends StatefulWidget {
  const HomeFollowingWidget({Key? key}) : super(key: key);

  @override
  State<HomeFollowingWidget> createState() => _HomeFollowingWidgetState();
}

class _HomeFollowingWidgetState extends State<HomeFollowingWidget> {

  @override
  Widget build(BuildContext context) {


    return SliverList(
      delegate: SliverChildListDelegate([
        ...List.generate(5, (index) => _FollowingCard(
          userName: "Linda$index",
          userImage: kImage2,
          collectionTitle: "Pylons$index",
        ))
      ])
    );
  }
}

class _FollowingCard extends StatelessWidget {
  final String userImage;
  final String userName;
  final String collectionTitle;

  const _FollowingCard({
    Key? key,
    required this.userImage, required this.userName, required this.collectionTitle
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    double tileWidth =  (MediaQuery. of(context). size. width - 30) / 3;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: UserImageWidget(imageUrl: userImage, radius: 16,),
                      horizontalTitleGap: 0,
                      title: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: userName, style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' created '),
                            TextSpan(text: "'$collectionTitle'", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' collection')
                          ],
                        ),
                      ),
                    ),
                  ),

                  MoreButton(
                    showText: false,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectionsScreen()));
                      })
                ]
            ),
          Card(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Column(
                      children: [
                        InkWell(
                            child: Container(
                                child: Row(
                                    children: [
                                      CachedNetworkImage(
                                          imageUrl: kImage1,
                                          width: tileWidth * 2,
                                          height: tileWidth * 2 + 3,
                                          fit: BoxFit.cover
                                      ),
                                      Spacer(),
                                      Column(
                                          children: [
                                            CachedNetworkImage(
                                                imageUrl: kImage,
                                                width: tileWidth,
                                                height: tileWidth,
                                                fit: BoxFit.cover
                                            ),
                                            SizedBox(height: 3),
                                            CachedNetworkImage(
                                                imageUrl: kImage2,
                                                width: tileWidth,
                                                height: tileWidth,
                                                fit: BoxFit.cover
                                            ),
                                          ]
                                      )
                                    ]
                                )
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> CollectionsScreen()));
                            }
                        ),

                        Row(
                            children:[
                              IconButton(
                                  icon: ImageIcon(
                                      AssetImage('assets/icons/comment.png'),
                                      size: 18,
                                      color: kIconBGColor
                                  ),
                                  onPressed: () {}
                              ),
                              Text('40'),
                              IconButton(
                                  icon: ImageIcon(
                                      AssetImage('assets/icons/like.png'),
                                      size: 18,
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
