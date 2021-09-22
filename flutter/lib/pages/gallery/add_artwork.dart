import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_grey_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

import 'add_artwork_grid.dart';

class AddArtworkWidget extends StatefulWidget {

  @override
  _AddArtworkWidgetState createState() => _AddArtworkWidgetState();
}

class _AddArtworkWidgetState extends State<AddArtworkWidget> {
  var filter_strings = [
    {"name":"Purchase", 'checked': true},
    {"name":"Mint", "checked": false},
    {"name":"Follow", "checked": false},
    {"name":"Trade", "checked": false},
    {"name":"Music", "checked": false},];


  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }
  Widget contentBox(BuildContext context){
    double tileWidth = (MediaQuery. of(context). size. width - 32 -32 - 36) / 4;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            child: Row(
                children:[
                  Icon(Icons.add, color: Color(0xFF616161), size: 16,),
                  Text('Add Artwork',style: TextStyle(color: Color(0xFF616161), fontSize: 14, fontWeight: FontWeight.w600))
                ]
            ),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddArtworkGridWidget()));
            },
          ),
          VerticalSpace(16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: tileWidth,
                  height: tileWidth,
                  decoration: BoxDecoration(color: Color(0xFFC4C4C4))
               ),
              ),
              SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                    width: tileWidth,
                    height: tileWidth,
                    decoration: BoxDecoration(color: Color(0xFFC4C4C4))
                ),
              ),
              SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                    width: tileWidth,
                    height: tileWidth,
                    decoration: BoxDecoration(color: Color(0xFFC4C4C4))
                ),
              ),
              SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                    width: tileWidth,
                    height: tileWidth,
                    decoration: BoxDecoration(color: Color(0xFFC4C4C4)),
                  child: Center(
                    child:CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Center(
                        child: Text('+6', style: TextStyle(color: Color(0xFF616161)))
                      )
                    )
                  )

                ),
              )
            ]
          ),
          VerticalSpace(16),
          TextFormField(
            controller: TextEditingController(text:'Photography'),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),

                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                filled: true,
                fillColor: Colors.white70
            ),
          ),
          VerticalSpace(16),
          TextFormField(
            minLines: 3,
            maxLines: 3,
            controller: TextEditingController(),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),

                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                fillColor: Colors.white70
            ),
          ),

          const VerticalSpace(10),
          Row(
              children:[
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: PylonsBlueButton(onTap: (){}, text: "Confirm",),
                  ),),
                const HorizontalSpace(20),
                Expanded(
                  child: SizedBox(
                      height: 30,
                      child: PylonsGreyButton (onTap: (){}, text: "Cancel",)),
                ),

              ]
          )
        ],
      ),
    );
  }
}
