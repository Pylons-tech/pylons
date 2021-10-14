import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  _PylonsAppBarState createState() => _PylonsAppBarState();
}

class _PylonsAppBarState extends State<PylonsAppBar> {
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

  String dropdownValue = 'my_activity'.tr();

  List<String> spinnerItems = [
    'my_activity'.tr(),
    'recommended'.tr(),
    'following'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: true,
      floating: true,
      forceElevated: true,
      collapsedHeight: kAppBarSize,
      backgroundColor: Colors.white,
      leading: IconButton(onPressed: () {}, icon: const ImageIcon(AssetImage('assets/images/icon/drawer.png'), size: kIconSize, color: kSelectedIcon)),
      actions: [
        IconButton(
            icon: const ImageIcon(
              AssetImage('assets/images/icon/alert.png'),
              size: kIconSize,
              color: kSelectedIcon,
            ),
            onPressed: () {})
      ],
      bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Container(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const ImageIcon(AssetImage('assets/images/icon/chevron-down.png'), size: 24, color: kSelectedIcon),
                    elevation: 16,
                    underline: const SizedBox(),
                    style: const TextStyle(color: kSelectedIcon, fontSize: 14),
                    onChanged: (String? data) {
                      setState(() {
                        dropdownValue = data!;
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
                  const Spacer(),
                  IconButton(icon: const ImageIcon(AssetImage('assets/images/icon/callendar.png'), size: kIconSize, color: kSelectedIcon), onPressed: _selectDate),
                  IconButton(
                    icon: const ImageIcon(
                      AssetImage('assets/images/icon/Filter.png'),
                      size: kIconSize,
                      color: kSelectedIcon,
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
    );
  }
}
