import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';
import 'package:pylons_wallet/pages/home/home_activity.dart';
import 'package:pylons_wallet/pages/home/home_following.dart';
import 'package:pylons_wallet/pages/home/home_recommendation.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String dropdownValue = 'my_activity'.tr();

  List<String> spinnerItems = [
    'my_activity'.tr(),
    'recommended'.tr(),
    'following'.tr(),
  ];

  static final Map<String, Widget> _pages = {
    'my_activity'.tr(): const HomeActivityWidget(),
    'recommended'.tr(): const HomeRecommendationWidget(),
    'following'.tr(): const HomeFollowingWidget()
  };

  DateTime _date = DateTime(2020, 11, 17);

  Future<void> _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'select_a_date'.tr(),
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  List list = ["asdf", "asdf", "aaaa"];
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
            pinned: true,
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
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: GFSearchBar(
                searchQueryBuilder: (query, list) {
                  return list
                      .where((item) => item!
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                },
                overlaySearchListItemBuilder: (item) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8),
                      child: Text(item.toString(),
                          style: const TextStyle(fontSize: 18)));
                },
                onItemSelected: (item) {
                  setState(() {});
                },
                searchList: list,
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            //3 image card
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: chips
                        .map((tag) => Chip(
                              backgroundColor: const Color(0xFFED8864),
                              label: Text(tag.toString()),
                            ))
                        .toList())),
            const SizedBox(height: 20),
          ])),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            sliver: SliverStaggeredGrid.countBuilder(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: InkWell(
                            child: const Image(
                                image: AssetImage(
                                    'assets/images/Rectangle 312.png'),
                                fit: BoxFit.cover),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DetailScreenWidget(
                                              isOwner: false)));
                            },
                          )));
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count((index == 1 || index == 6) ? 2 : 1,
                      (index == 1 || index == 6) ? 2 : 1);
                }),
          )
        ],
      ),
    );
  }
}
