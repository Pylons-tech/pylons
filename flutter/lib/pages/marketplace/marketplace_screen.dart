import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_marketplace_card.dart';
import 'package:pylons_wallet/components/pylons_marketplace_filter.dart';

class MarketplaceScreenWidget extends StatefulWidget {
  const MarketplaceScreenWidget({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreenWidget> createState() => _MarketplaceScreenWidgetState();
}

class _MarketplaceScreenWidgetState extends State<MarketplaceScreenWidget> {
  String _sortValue = "Recommended";
  List list = [
    "Recommended",
    "What's New",
    "Trending",
    "Price : Low to High",
    "Price : High to Low"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          expandedHeight: 120.0,
          collapsedHeight: 120.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.fromLTRB(16, 30, 16, 10),
            child: GFSearchBar(

              searchQueryBuilder:(query, list) {
                return list.where((item)=>item!.toString().toLowerCase().contains(query.toLowerCase())).toList();
              },
              overlaySearchListItemBuilder: (item){
                return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    child: Text(
                        item.toString(),
                        style: const TextStyle(fontSize: 18)
                    )
                );
              },
              onItemSelected: (item){
                setState((){

                });
              },
              searchList: list,
            ),
          ) ,

          bottom: PreferredSize(
            preferredSize: Size(0.0,0.0),
            child: Container(
                padding: EdgeInsets.only(left: 16.0, top:0, right: 16.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: _sortValue,
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                      underline: Container(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (data) {
                        setState(() {
                          _sortValue = data!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text("$value", style: TextStyle(color: Color(0xFF616161))),
                        );
                      }).toList(),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showDialog(context: context,
                            builder: (BuildContext context){
                              return PylonsMarketplaceFilterBox();
                            }
                        );
                      },
                      child:    Row(
                        children: [
                          Transform.rotate(
                            angle: -pi * 0.5,
                            child: ImageIcon(
                              AssetImage('assets/icons/filter.png'),
                              size: 24,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 10, left: 5),
                              child: Text('FILTER BY')
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                          ),
                        ],
                      ),
                    )
                  ],
                )
            )
          )
      ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: PylonsMarketplaceCard(),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
