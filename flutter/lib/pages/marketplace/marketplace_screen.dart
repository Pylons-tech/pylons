import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:pylons_wallet/components/pylons_marketplace_card.dart';
import 'package:pylons_wallet/components/pylons_marketplace_filter.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _sortValue = "recommended".tr();
  List list = [
    "recommended".tr(),
    "what_is_new".tr(),
    "trending".tr(),
    "${'price'.tr()} : ${'low_to_high'.tr()}",
    "${'price'.tr()} : ${'high_to_low'.tr()}"
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
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: GFSearchBar(
              searchQueryBuilder:(query, list) {
                return list.where((item)=>item!.toString().toLowerCase().contains(query.toLowerCase())).toList();
              },
              overlaySearchListItemBuilder: (item){
                return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
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
            preferredSize: const Size(0.0,0.0),
            child: Container(
                padding: const EdgeInsets.only(left: 16.0, top:0, right: 16.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: _sortValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
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
                    const Spacer(),
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
                            child: const ImageIcon(
                              AssetImage('assets/icons/filter.png'),
                              size: 24,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 10, left: 5),
                              child: Text('filter_by'.tr())
                          ),
                          const Icon(
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
                return const Center(
                  child: PylonsMarketplaceCard(),
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
