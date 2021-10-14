import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parent_child_checkbox/parent_child_checkbox.dart';

class PylonsMarketplaceFilterBox extends StatefulWidget {
  @override
  _PylonsMarketplaceFilterBoxState createState() => _PylonsMarketplaceFilterBoxState();
}

class _PylonsMarketplaceFilterBoxState extends State<PylonsMarketplaceFilterBox> {
  List<Map<String, Object>> filter_strings = [
    {"name": "Purchase", 'checked': true},
    {"name": "Mint", "checked": false},
    {"name": "Follow", "checked": false},
    {"name": "Trade", "checked": false},
    {"name": "Music", "checked": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  Stack contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                trailing: const Icon(Icons.search, color: Color(0xFFC4C4C4), size: 20),
                title: TextField(
                    decoration: InputDecoration(
                        hintText: 'search'.tr(),
                        hintStyle: const TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 18,
                        ))),
              ),
              ParentChildCheckbox(
                parent: Text('art'.tr()),
                children: const [
                  Text('Animated GIF'),
                  Text('Animated GIF'),
                  Text('Animated GIF'),
                ],
              ),
              ParentChildCheckbox(parent: Text('sound'.tr()), children: const [Text('Music'), Text('Sound Effect')])
            ],
          ),
        ),
      ],
    );
  }
}
