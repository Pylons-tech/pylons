import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pylons_wallet/components/notification_item.dart';
import 'package:pylons_wallet/constants/constants.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('notification'.tr(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: kTextBlackColor, fontFamily: 'Roboto', )),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
        body: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              // SliverAppBar(
              //   pinned: true,
              //   snap: true,
              //   floating: true,
              //   forceElevated: false,
              //   toolbarHeight: kAppBarNormalSize,
              //   collapsedHeight: kAppBarNormalSize,
              //   backgroundColor: Colors.transparent,
              //   automaticallyImplyLeading: true,
              //   centerTitle: true,
              //   // leading: IconButton(
              //   //     onPressed: (){
              //   //       Navigator.pop(context);
              //   //     },
              //   //     icon: const ImageIcon(
              //   //         AssetImage('assets/images/icon/before.png'),
              //   //         size: kIconSize,
              //   //         color: kIconBGColor
              //   //     )
              //   // ),
              //   title: Text('Notification', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: kTextBlackColor, fontFamily: 'Roboto', )),
              // ),

              //this Week
              SliverStickyHeader(
                header: Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text('this_week'.tr(),
                    style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) => const NotificationItem(),
                    childCount: 6,
                  ),
                ),
              ),
              //this month
              SliverStickyHeader(
                header: Container(
                  height: 60,
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Divider(),
                      Container(
                        alignment: Alignment.centerLeft,
                        child:Text('this_month'.tr(),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                    ]
                  )
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) => NotificationItem(),
                    childCount: 10,
                  ),
                ),
              ),

            ]
        )
    );
  }
}
