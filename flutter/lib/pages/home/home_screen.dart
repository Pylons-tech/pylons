import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_dashboard_filter.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/home/home_following.dart';
import 'package:pylons_wallet/pages/home/home_recommendation.dart';
import 'package:pylons_wallet/pages/home/home_activity.dart';

import 'package:pylons_wallet/pages/home/notification.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {

  String dropdownValue = 'My Activity';

  List <String> spinnerItems = [
    'My Activity',
    'Recommended',
    'Following',
  ];

  static const Map<String, Widget> _pages = {
    'My Activity': HomeActivityWidget(),
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
              onPressed: (){},
              icon: const ImageIcon(
                  AssetImage('assets/icons/sort.png'),
                  size: kIconSize,
                  color: kIconBGColor
              )
          ),
          actions: [
            IconButton(
                icon: const ImageIcon(
                  AssetImage('assets/icons/bell.png'),
                  size: 20,
                  color: kIconBGColor,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationWidget()));
                }
            )
          ],
          bottom: PreferredSize(
              preferredSize: Size(0.0, 0.0),
              child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 0.0),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: ImageIcon(
                            AssetImage('assets/images/icon/chevron-down.png'),
                            size: 24,
                            color: kIconBGColor
                        ),
                        iconSize: 24,
                        elevation: 16,
                        underline: SizedBox(),
                        focusColor: Color(0xFF1212C4),
                        style: TextStyle(color: kIconBGColor, fontSize: 14),
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
                      Spacer(),
                      IconButton(
                          icon: const Icon(
                              Icons.calendar_today_rounded,
                              size: kIconSize,
                              color:kIconBGColor
                          ),
                          onPressed: _selectDate
                      ),
                      IconButton(
                        icon: const ImageIcon(
                          AssetImage('assets/icons/filter.png'),
                          size:kIconSize,
                          color: kIconBGColor,
                        ),
                        onPressed: (){
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return PylonsDashboardFilterBox();
                              }
                          );
                        },
                      )
                    ],
                  )
              )
          ),
        ),
          _pages[dropdownValue]!
        ],
      ),
    );
  }
}
