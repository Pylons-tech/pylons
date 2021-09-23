import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/forms/card_info_form.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_info.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_work.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_history.dart';
import 'package:pylons_wallet/pages/home/notification.dart';

class PaymentResultScreenWidget extends StatefulWidget {
  const PaymentResultScreenWidget({Key? key}) : super(key: key);

  @override
  State<PaymentResultScreenWidget> createState() => _PaymentResultScreenWidgetState();
}

class _PaymentResultScreenWidgetState extends State<PaymentResultScreenWidget> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  static List<String> tags = [
    '#3D', '#Photography', '#Sculpture'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              forceElevated: true,
              toolbarHeight: kAppBarNormalSize,
              collapsedHeight: kAppBarNormalSize,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const ImageIcon(
                      AssetImage('assets/images/icon/close.png'),
                      size: kIconSize,
                      color: kIconBGColor
                  )
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([
              //nft image
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/purchase_done.png'),
                          fit: BoxFit.cover
                      )
                  ),
                  child: new Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                          bottom: 70,
                          child: Column(
                            children: [
                              Text('congratulations'.tr(), style: TextStyle(color: Color(0xFF1212C4), fontSize: 20, fontWeight: FontWeight.w700)),
                              Text('successfully_bought_the_item'.tr(), style: TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500))
                            ],
                          )
                      ),
                      Positioned(
                          top: 70,
                          left: 16,
                          right: 16,
                          child: Card(
                              elevation: 8,
                              child: Column(
                                  children:[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                      child: ExpandablePanel(
                                        theme: ExpandableThemeData(),
                                        header: Padding(
                                            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                            child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text('product_name'.tr(), style:TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500)),
                                                  Spacer(),
                                                  Text('title_of_artwork'.tr(), style:TextStyle(color: Color(0xFF201D1D), fontSize: 16, fontWeight: FontWeight.w500))
                                                ]
                                            )
                                        ),
                                        expanded: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image(
                                                image: AssetImage('assets/images/Rectangle 312.png'),
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                height: 300,
                                                fit: BoxFit.cover
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Wrap(
                                                  alignment: WrapAlignment.start,
                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                  spacing: 10,
                                                  runSpacing: 5,
                                                  children: tags.map((tag) =>
                                                  new Chip(
                                                    backgroundColor: Color(0xFFED8864),
                                                    label: new Text(tag),
                                                  )
                                                  ).toList()
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    constraints: BoxConstraints(
                                                      minHeight: 80,
                                                    ),
                                                    child: Text('artwork_description'.tr(), )
                                                )
                                            ),
                                            Column(
                                                children:[
                                                  Divider(),
                                                  Padding(
                                                      padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                                                      child: Row(
                                                          children: [
                                                            Text('price'.tr(), style:TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500)),
                                                            Spacer(),
                                                            Text('\$82.00', style:TextStyle(color: Color(0xFF201D1D), fontSize: 16, fontWeight: FontWeight.w500))
                                                          ]
                                                      )
                                                  )
                                                ]
                                            )
                                          ],
                                        ),
                                        collapsed: Column(
                                            children:[
                                              Divider(),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                                                  child: Row(
                                                      children: [
                                                        Text('price'.tr(), style:TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500)),
                                                        Spacer(),
                                                        Text('\$82.00', style:TextStyle(color: Color(0xFF201D1D), fontSize: 16, fontWeight: FontWeight.w500))
                                                      ]
                                                  )
                                              )
                                            ]
                                        ),
                                      ),
                                    ),

                                  ]
                              )
                          )
                      ),


                    ],
                  )
              )

            ]))

          ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          alignment: Alignment.center,
          height: 60,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: (){

              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF1212C4),
                padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
              ),
              child: Text('continue'.tr(), style: TextStyle(color: Colors.white))
          )
      ),
    );
  }
}