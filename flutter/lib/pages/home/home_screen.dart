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

  static final Map<String, Widget> _pages = {'my_activity'.tr(): const HomeActivityWidget(), 'recommended'.tr(): const HomeRecommendationWidget(), 'following'.tr(): const HomeFollowingWidget()};

  DateTime _date = DateTime(2020, 11, 17);

  Future<void> _selectDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017),
      lastDate: DateTime(2022, 7),
      helpText: 'select_a_date'.tr(),
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  // int _selectedIndex = 0;
  bool enableList = false;

  // void _onChanged(int position) {
  //   setState(() {
  //     _selectedIndex = position;
  //     enableList = !enableList;
  //   });
  // }

  // void _onhandleTap() {
  //   setState(() {
  //     enableList = !enableList;
  //   });
  // }

/*
  Widget _buildDropdownList() => Container(
    height: 30.0 * spinnerItems.length,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5))
    ),
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    margin: EdgeInsets.only(top: 5.0),
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: spinnerItems.length,
      itemBuilder: (context, position){
        return InkWell(
          onTap: (){
            _onChanged(position);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration:BoxDecoration(
              color:position == _selectedIndex ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Text(spinnerItems[position], style: TextStyle(color: Colors.black))
          )
        );
      }
    )
  );
*/
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          forceElevated: true,
          collapsedHeight: kAppBarSize,
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: () {}, icon: const ImageIcon(AssetImage('assets/icons/sort.png'), size: kIconSize, color: kSelectedIcon)),
          actions: [
            IconButton(
                icon: const ImageIcon(
                  AssetImage('assets/icons/bell.png'),
                  size: 20,
                  color: kSelectedIcon,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationWidget()));
                })
          ],
          bottom: PreferredSize(
              preferredSize: Size.zero,
              child: Container(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: kSelectedIcon),
                        elevation: 16,
                        underline: const SizedBox(),
                        focusColor: const Color(0xFF1212C4),
                        style: const TextStyle(color: kSelectedIcon, fontSize: 14),
                        onChanged: (String? data) {
                          setState(() {
                            dropdownValue = data!;
                          });
                        },
                        items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      /*InkWell(
                        onTap: _onhandleTap,
                        child: Row(
                          children: [
                            Text(spinnerItems[_selectedIndex])
                          ]
                        )
                      ),*/
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.calendar_today_rounded, size: kSmallIconSize, color: kUnselectedIcon), onPressed: _selectDate),
                      IconButton(
                        icon: const ImageIcon(
                          AssetImage('assets/icons/filter.png'),
                          size: kSmallIconSize,
                          color: kUnselectedIcon,
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
        /*enableList? _buildDropdownList(): Container(),*/
        _pages[dropdownValue]!
      ],
    );
  }
}
