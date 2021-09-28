import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pylons_wallet/components/NotificationItem.dart';
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
                        AssetImage('assets/images/icon/before.png'),
                        size: kIconSize,
                        color: kIconBGColor
                    )
                ),
                title: Text('Notification', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: kTextBlackColor, fontFamily: 'Roboto', )),
              ),

              //this Week
              SliverStickyHeader(
                header: Container(
                  height: 60,
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text('This Week',
                    style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) => NotificationItem(),
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
                        child:Text('This Month',
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                    ]
                  )
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) => NotificationItem(),
                    childCount: 2,
                  ),
                ),
              ),

            ]
        )
    );
  }
}
