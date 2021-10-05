import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsDashboardDropDown extends StatefulWidget {

  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {

  String dropdownValue = 'my_activity'.tr();

  List<String> spinnerItems = [
    'my_activity'.tr(),
    'recommended'.tr(),
    'following'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const ImageIcon(
          AssetImage('assets/images/icon/chevron-down.png'),
          size: 24,
          color: kSelectedIcon
      ),
      elevation: 16,
      underline: const SizedBox(),
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
   );
  }
}