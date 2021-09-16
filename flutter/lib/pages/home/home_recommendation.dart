import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/add_friend_button.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/pylons_trending_card.dart';
import 'package:pylons_wallet/components/pylons_trending_col_card.dart';
import 'package:pylons_wallet/components/pylons_trending_new_card.dart';
import 'package:pylons_wallet/pages/home/items_new_screen.dart';

class HomeRecommendationWidget extends StatefulWidget {
  const HomeRecommendationWidget({Key? key}) : super(key: key);

  @override
  State<HomeRecommendationWidget> createState() => _HomeRecommendationWidgetState();
}

class _HomeRecommendationWidgetState extends State<HomeRecommendationWidget> {


  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        //Trending
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                  children: [
                    const Text('Trending', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Spacer(),
                    MoreButton(onTap: (){
                    })
                  ]
              ),

              Container(
                  height: 360,
                  child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index)=>PylonsTrendingCard()
                  )
              ),
            ],
          )
        ),
        SizedBox(height: 12,),
        //Trending Collection
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Trending Collection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  Spacer(),
                  AddFriendButton(onTap: (){
                  })
                ]
              ),
              Container(
                height: 400,
                child: ListView.builder(
                  itemCount: 15,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index)=>PylonsTrendingColCard()
                )
              )
            ],
          )
        ),
        SizedBox(height: 12,),
        //What's New
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  const Text('What\'s New', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  Spacer(),
                  MoreButton(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemsNewScreenWidget()));
                  })
                ],
              ),
              Container(
                height: 350,
                child: ListView.builder(
                  itemCount: 15,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index)=>PylonsTrendingNewCard(),
                )
              )
            ],
          )
        )
        //Games
      ]),
    );
  }
}
