import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pylons_wallet/components/nft_view.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/forms/card_info_form.dart';
import 'package:pylons_wallet/forms/create_trade_form.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_info.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_work.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_history.dart';
import 'package:pylons_wallet/pages/home/notification.dart';
import 'package:pylons_wallet/pages/payment/payment_info_screen.dart';

class AddArtworkGridWidget extends StatefulWidget {
  const AddArtworkGridWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AddArtworkGridWidget> createState() => _AddArtworkGridWidgetState();
}

class _AddArtworkGridWidgetState extends State<AddArtworkGridWidget> with SingleTickerProviderStateMixin {

  var listTitle = [
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
  ];
  var listTitlestatus = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var totalNum = 0;
    double tileWidth = (MediaQuery. of(context). size. width - 32 - 32) /3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon:Icon(Icons.chevron_left, color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Row(children: [
              Text('15',),
              SizedBox(width: 10),
              Text('add'.tr(), style: TextStyle(color: Colors.white),)
            ])
          )],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 105,
                child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index)=>Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                      child: Stack(
                          children: [
                            Card(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                color: Color(0xFFC4C4C4),
                                    width: 60,
                                    height: 68
                                )
                              )
                            ),
                            Positioned( // will be positioned in the top right of the container
                                top: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Color(0x80000000),
                                  child:Icon(
                                      Icons.close,
                                      size: 15,
                                    color: Colors.white,
                                  ),
                                )
                            )
                          ]
                      )
                    )

                )
            ),

            Divider(),
            Container(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 20,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 1,),
                itemBuilder: (contxt, indx){
                  return Stack(
                      children: [
                        Card(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: listTitlestatus[indx] ? ( Border.all(color: Color(0xFF1212C4), width: 3)) : (null)
                                    ),
                                    width: tileWidth,
                                    height: tileWidth,
                                    child: InkWell(
                                      onTap: (){
                                        setState((){
                                          if(listTitlestatus[indx]){
                                            totalNum = totalNum - 1;
                                          }else{
                                            totalNum = totalNum + 1;
                                          }
                                          listTitlestatus[indx] = !listTitlestatus[indx];
                                        });
                                      },
                                      child: Image(
                                          image: AssetImage('assets/images/Rectangle 312.png'),
                                          fit: BoxFit.cover
                                      )
                                    )
                                )
                            )
                        ),
                        Positioned( // will be positioned in the top right of the container
                            top: 10,
                            right: 20,
                            child: Container(
                              child:CircleAvatar(
                                radius: 10,
                                backgroundColor:listTitlestatus[indx] ?( Color(0x801212C4)) : (Color(0x80000000)),
                                child: Text(listTitlestatus[indx] ? (indx.toString()) : '', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 10))
                                /*
                                child:Text(indx.toString(), style: TextStyle()),
                                 */
                              ),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: listTitlestatus[indx] ? Color(0xFFC4C4C4) : Color(0x80201D1D),
                                  width: 2.0,
                                ),
                              ),
                            )
                        )
                      ]
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
