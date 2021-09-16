import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_dashboard_dropdown.dart';
import 'package:pylons_wallet/components/pylons_dashboard_filter.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function onPageSelected;
  const PylonsAppBar({
    Key? key,
    this.title = "",
    required this.onPageSelected,
  }) : super(key: key);


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _PylonsAppBarState createState() =>  _PylonsAppBarState();
}

  class _PylonsAppBarState extends State<PylonsAppBar> {
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

    String dropdownValue = 'My activity';

    List <String> spinnerItems = [
      'My activity',
      'Recommended',
      'Following',
    ] ;

    @override
  Widget build(BuildContext context) {
     return SliverAppBar(
        pinned: true,
        snap: true,
        floating: true,
        forceElevated: true,
        collapsedHeight: kAppBarSize,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: (){},
            icon: const ImageIcon(
                AssetImage('assets/images/icon/drawer.png'),
                size: kIconSize,
                color: kIconBGColor
            )
        ),
        actions: [
          IconButton(
              icon: const ImageIcon(
                AssetImage('assets/images/icon/alert.png'),
                size: kIconSize,
                color: kIconBGColor,
              ),
              onPressed: () {}
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
                      style: TextStyle(color: kIconBGColor, fontSize: 14),
                      onChanged: (String? data) {
                        setState(() {
                          dropdownValue = data!!;
                        });
                        widget.onPageSelected(dropdownValue);
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
                        icon: const ImageIcon(
                            AssetImage('assets/images/icon/callendar.png'),
                            size: kIconSize,
                            color:kIconBGColor
                        ),
                        onPressed: _selectDate
                    ),
                    IconButton(
                      icon: const ImageIcon(
                        AssetImage('assets/images/icon/Filter.png'),
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
      );
   }
}
