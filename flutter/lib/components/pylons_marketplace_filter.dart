import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:parent_child_checkbox/parent_child_checkbox.dart';

class PylonsMarketplaceFilterBox extends StatefulWidget {

  @override
  _PylonsMarketplaceFilterBoxState createState() => _PylonsMarketplaceFilterBoxState();
}

class _PylonsMarketplaceFilterBoxState extends State<PylonsMarketplaceFilterBox> {
  var filter_strings = [
    {"name":"Purchase", 'checked': true},
    {"name":"Mint", "checked": false},
    {"name":"Follow", "checked": false},
    {"name":"Trade", "checked": false},
    {"name":"Music", "checked": false},];

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
  Stack contentBox(BuildContext context){
    return Stack(
      children: <Widget>[
        Container(

          padding: EdgeInsets.only(
              left: 16,
              top: 16,
              right: 16,
              bottom: 16
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                trailing: Icon(Icons.search, color: Color(0xFFC4C4C4), size: 20),
                title: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 18,
                        )
                    )
                ),
              ),

              ParentChildCheckbox(
                parent: Text('Art'),
                children: [
                  Text('Animated GIF'),
                  Text('Animated GIF'),
                  Text('Animated GIF'),
                ],
              ),
              ParentChildCheckbox(
                  parent: Text('Sound'),
                  children: [
                    Text('Music'),
                    Text('Sound Effect')
                  ])
            ],
          ),
        ),

      ],
    );
  }
}