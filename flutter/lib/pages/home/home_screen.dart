import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_dashboard_filter.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/home/home_activity.dart';
import 'package:pylons_wallet/pages/home/home_following.dart';
import 'package:pylons_wallet/pages/home/home_recommendation.dart';
import 'package:pylons_wallet/pages/home/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            forceElevated: true,
            collapsedHeight: kAppBarSize,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {},
                icon: const ImageIcon(AssetImage('assets/icons/sort.png'),
                    size: kIconSize, color: kIconBGColor)),
            actions: [
              IconButton(
                  icon: const ImageIcon(
                    AssetImage('assets/icons/bell.png'),
                    size: 20,
                    color: kIconBGColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationWidget()));
                  })
            ],
            bottom: PreferredSize(
                preferredSize: const Size(0.0, 0.0),
                child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 0.0),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          value: dropdownValue,
                          icon: const ImageIcon(
                              AssetImage('assets/images/icon/chevron-down.png'),
                              size: 24,
                              color: kIconBGColor),
                          iconSize: 24,
                          elevation: 16,
                          underline: const SizedBox(),
                          focusColor: const Color(0xFF1212C4),
                          style: const TextStyle(
                              color: kIconBGColor, fontSize: 14),
                          onChanged: (String? data) {
                            setState(() {
                              dropdownValue = data!;
                            });
                          },
                          items: spinnerItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const Spacer(),
                        IconButton(
                            icon: const Icon(Icons.calendar_today_rounded,
                                size: kIconSize, color: kIconBGColor),
                            onPressed: _selectDate),
                        IconButton(
                          icon: const ImageIcon(
                            AssetImage('assets/icons/filter.png'),
                            size: kIconSize,
                            color: kIconBGColor,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PylonsDashboardFilterBox();
                                });
                          },
                        )
                      ],
                    ))),
          ),
          _pages[dropdownValue]!
        ],
      ),
    );
  }
}
