import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsDashboardDropDown extends StatefulWidget {
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {

  String dropdownValue = 'My activity';

  List <String> spinnerItems = [
    'My activity',
    'Recommended',
    'Following',
  ] ;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
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