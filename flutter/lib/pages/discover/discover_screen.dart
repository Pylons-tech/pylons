import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_dashboard_filter.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/home/home_following.dart';
import 'package:pylons_wallet/pages/home/home_recommendation.dart';
import 'package:pylons_wallet/pages/home/home_activity.dart';

import 'package:pylons_wallet/pages/home/notification.dart';

class DiscoverScreenWidget extends StatefulWidget {
  const DiscoverScreenWidget({Key? key}) : super(key: key);

  @override
  State<DiscoverScreenWidget> createState() => _DiscoverScreenWidgetState();
}

class _DiscoverScreenWidgetState extends State<DiscoverScreenWidget> {

  String dropdownValue = 'My activity';

  List <String> spinnerItems = [
    'My Activity',
    'Recommended',
    'Following',
  ];

  static const Map<String, Widget> _pages = {
    'My activity': HomeActivityWidget(),
    'Recommended': HomeRecommendationWidget(),
    'Following': HomeFollowingWidget()
  };

  DateTime _date = DateTime(2020, 11, 17);

  Future<void> _selectDate()  async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  List list = [
    "asdf",
    "asdf",
    "aaaa"
  ];
  List chips = [
    "+",
    "#3D",
    "#Photography",
    "#Sculpture",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            snap: false,
            floating: false,
            forceElevated: false,
            toolbarHeight: kAppBarNormalSize,
            collapsedHeight: kAppBarNormalSize,
            backgroundColor: Colors.white,
            stretch: true,
            titleSpacing: 0,

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
                }, searchList: list,
              ),
            ) ,
          ),

          SliverList(
              delegate: SliverChildListDelegate([
                //3 image card
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: chips.map((tag) =>
                           Chip(
                            backgroundColor: Color(0xFFED8864),
                            label: new Text(tag.toString()),
                          )
                        ).toList()
                    )
                ),
                SizedBox(height: 20),
              ])
          ),

      SliverPadding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        sliver:SliverStaggeredGrid.countBuilder(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            itemCount: 15,
            itemBuilder: (context, index) {
              return Container(
                  decoration:BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(5)
                      )
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Image(
                        image: AssetImage('assets/images/Rectangle 312.png'),
                        fit: BoxFit.cover
                    ),
                  )
              );
            },
            staggeredTileBuilder: (index) {
              return StaggeredTile.count((index == 1 || index == 6)? 2: 1,(index == 1 || index == 6)? 2: 1 );
            }
        ),
      )


        ],
      ),
    );
  }
}
