import 'dart:convert';

import 'package:flutter/material.dart';

class PylonsDashboardFilterBox extends StatefulWidget {

  @override
  _PylonsDashboardFilterBoxState createState() => _PylonsDashboardFilterBoxState();
}

class _PylonsDashboardFilterBoxState extends State<PylonsDashboardFilterBox> {
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
              Row(
                children: [
                  ImageIcon(
                      AssetImage('assets/images/icon/Filter.png'),
                      size: 24,
                      color: Color(0xFF616161)
                  ),
                  Text('Filter'),
                  Spacer(),
                  FlatButton(
                    onPressed: (){},
                    child: Text('Reset')
                  )
                ],
              ),
              for (var i = 0; i < filter_strings.length; i += 1)
                  Row(
                    children: [
                      Checkbox(
                        onChanged: (value) {
                          setState((){
                            filter_strings[i]['checked']=value!;
                          });
                        },
                        tristate: i == 1,
                        value: filter_strings[i]['checked'] == true,
                        activeColor: Color(0xFF6200EE),
                      ),
                      Text(
                        filter_strings[i]['name'].toString()
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
              ButtonBar(
                children:[
                  FlatButton(onPressed: (){
                    Navigator.of(context).pop();
                  },
                    child: Text('Cancel'),
                  ),
                  FlatButton(onPressed: (){
                    Navigator.of(context).pop();
                  },
                    child: Text('Apply'),
                  )

                ]
              )
            ],
          ),
        ),

      ],
    );
  }
}