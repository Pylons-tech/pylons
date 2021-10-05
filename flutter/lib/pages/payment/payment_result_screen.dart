import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

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
                      color: kSelectedIcon
                  )
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([
              //nft image
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/purchase_done.png'),
                          fit: BoxFit.cover
                      )
                  ),
                  child:  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                          bottom: 70,
                          child: Column(
                            children: [
                              Text('congratulations'.tr(), style: const TextStyle(color: Color(0xFF1212C4), fontSize: 20, fontWeight: FontWeight.w700)),
                              Text('successfully_bought_the_item'.tr(), style: const TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500))
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
                                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                      child: ExpandablePanel(
                                        theme: const ExpandableThemeData(),
                                        header: Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                            child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('product_name'.tr(), style: const TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500)),
                                                  const Spacer(),
                                                  Text('title_of_artwork'.tr(), style: const TextStyle(color: Color(0xFF201D1D), fontSize: 16, fontWeight: FontWeight.w500))
                                                ]
                                            )
                                        ),
                                        expanded: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image(
                                                image: const AssetImage(kImage2),
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                height: 300,
                                                fit: BoxFit.cover
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Wrap(
                                                  spacing: 10,
                                                  runSpacing: 5,
                                                  children: tags.map((tag) =>
                                                   Chip(
                                                    backgroundColor: const Color(0xFFED8864),
                                                    label: Text(tag),
                                                  )
                                                  ).toList()
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    constraints: const BoxConstraints(
                                                      minHeight: 80,
                                                    ),
                                                    child: Text('artwork_description'.tr(), )
                                                )
                                            ),
                                            Column(
                                                children:[
                                                  const Divider(),
                                                  Padding(
                                                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                                                      child: Row(
                                                          children: [
                                                            Text('price'.tr(), style: const TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500)),
                                                            const Spacer(),
                                                            const Text('\$82.00', style: TextStyle(color: Color(0xFF201D1D), fontSize: 16, fontWeight: FontWeight.w500))
                                                          ]
                                                      )
                                                  )
                                                ]
                                            )
                                          ],
                                        ),
                                        collapsed: Column(
                                            children:[
                                              const Divider(),
                                              Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                                                  child: Row(
                                                      children: [
                                                        Text('price'.tr(), style: const TextStyle(color: Color(0xFF616161), fontSize: 16, fontWeight: FontWeight.w500)),
                                                        const Spacer(),
                                                        const Text('\$82.00', style: TextStyle(color: Color(0xFF201D1D), fontSize: 16, fontWeight: FontWeight.w500))
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
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          alignment: Alignment.center,
          height: 60,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: (){

              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF1212C4),
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                minimumSize: const Size(double.infinity, 30), // double.infinity is the width and 30 is the height
              ),
              child: Text('continue'.tr(), style: const TextStyle(color: Colors.white))
          )
      ),
    );
  }
}