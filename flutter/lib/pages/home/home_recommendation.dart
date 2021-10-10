import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/pylons_trending_card.dart';
import 'package:pylons_wallet/components/pylons_trending_col_card.dart';
import 'package:pylons_wallet/components/pylons_trending_new_card.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
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
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('trending'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    // Spacer(),
                    MoreButton(onTap: (){
                    })
                  ]
              ),

              SizedBox(
                  height: 360,
                  child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index)=> const PylonsTrendingCard()
                  )
              ),
            ],
          )
        ),
        const SizedBox(height: 20,),
        //Trending Collection
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('trending_ollections'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  // Spacer(),
                  // AddFriendButton(onTap: (){
                  // })
                ]
              ),
              const VerticalSpace(10),
              SizedBox(
                height: 301,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 15,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index)=> const PylonsTrendingColCard()
                )
              )
            ],
          )
        ),
        const SizedBox(height: 20,),
        //What's New
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('what_is_new'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  // const Spacer(),
                  MoreButton(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ItemsNewScreenWidget()));
                  })
                ],
              ),
              const VerticalSpace(10),
              SizedBox(
                height: 350,
                child: ListView.builder(
                  itemCount: 15,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index)=>const PylonsTrendingNewCard(),
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
