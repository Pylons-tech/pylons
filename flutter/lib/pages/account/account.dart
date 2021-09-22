import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/forms/card_info_form.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_info.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_work.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_history.dart';
import 'package:pylons_wallet/pages/home/notification.dart';

class AccountScreenWidget extends StatefulWidget {
  const AccountScreenWidget({Key? key}) : super(key: key);

  @override
  State<AccountScreenWidget> createState() => _AccountScreenWidgetState();
}

class _AccountScreenWidgetState extends State<AccountScreenWidget> with SingleTickerProviderStateMixin {
  bool isExpanded = false;



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
              title: Text('Pylons Account', style: TextStyle(color: Color(0xFF080830))),
            ),
            SliverList(delegate: SliverChildListDelegate([
              Divider(),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 16
                ),
                child: ListTile(
                  minLeadingWidth : 10,
                  leading: CircleAvatar(
                    radius: 30,
                    child: FlutterLogo(size: 28.0),
                  ),
                  title: Text(
                      'Linda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF201D1D),
                      )
                  ),
                  subtitle: Text('Media Artist (3D, Motiongraphics, Collecting NFT)',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF616161)
                      )),
                  onTap: (){
                  },
                  trailing: IconButton(
                      icon: ImageIcon(
                          AssetImage('assets/images/icon/dots.png'),
                          size: 24,
                          color: kIconBGColor
                      ),
                      onPressed: () {}
                  ),
                ),
              ),
              Divider(),
              VerticalSpace(16),
              Padding(
                padding: EdgeInsets.all(16),
                child: PylonsTextInput(
                  controller: TextEditingController(), label: "User Name",
                  disabled: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: PylonsTextInput(
                  controller: TextEditingController(), label: "User ID",
                  disabled: true,
                ),
              ),
              Divider()
            ])
          )
        ]
      ),
    );
  }
}