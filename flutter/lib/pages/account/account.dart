import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';

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
                      color: kSelectedIcon
                  )
              ),
              title: Text('pylons_account'.tr(), style: const TextStyle(color: Color(0xFF080830))),
            ),
            SliverList(delegate: SliverChildListDelegate([
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 16
                ),
                child: ListTile(
                  minLeadingWidth : 10,
                  leading: const CircleAvatar(
                    radius: 30,
                    child: FlutterLogo(size: 28.0),
                  ),
                  title: const Text(
                      'Linda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF201D1D),
                      )
                  ),
                  subtitle: const Text('Media Artist (3D, Motiongraphics, Collecting NFT)',
                      style:  TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF616161)
                      )),
                  onTap: (){
                  },
                  trailing: IconButton(
                      icon: const ImageIcon(
                          AssetImage('assets/images/icon/dots.png'),
                          size: 24,
                          color: kSelectedIcon
                      ),
                      onPressed: () {}
                  ),
                ),
              ),
              const Divider(),
              const VerticalSpace(16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: PylonsTextInput(
                  controller: TextEditingController(), label: "user_name".tr(),
                  disabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: PylonsTextInput(
                  controller: TextEditingController(), label: "user_id".tr(),
                  disabled: true,
                ),
              ),
              const Divider()
            ])
          )
        ]
      ),
    );
  }
}