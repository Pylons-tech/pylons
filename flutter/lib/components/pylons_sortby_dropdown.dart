import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PylonsSortByDropDown extends StatefulWidget {
  @override
  PylonsSortByDropDownWidget createState() => PylonsSortByDropDownWidget();
}

class PylonsSortByDropDownWidget extends State {

  String dropdownValue = 'Recommended';

  List <String> spinnerItems = [
    'What\'s New',
    'Trending',
    'Price: Low to High',
    'Price: High to Low'
  ] ;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: ImageIcon(
          AssetImage('assets/images/icon/chevron-down.png'),
          size: 24,
          color: Color(0xFF616161)
      ),
      iconSize: 24,
      elevation: 16,
      underline: SizedBox(),
      style: const TextStyle(color: Color(0xFF616161), fontSize: 14),
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