import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/edit_profile/edit_profile_screen.dart';
import 'package:pylons_wallet/pages/gallery/widget/collection_view_widget.dart';
import 'package:pylons_wallet/pages/gallery/widget/custom_card_widget.dart';

class EditCoverScreen extends StatefulWidget {
  @override
  State<EditCoverScreen> createState() => _EditCoverScreenState();
}

class _EditCoverScreenState extends State<EditCoverScreen> {
  final double bannerSize = 135;
  String dropdownValue = 'all_collection'.tr();

  List<String> spinnerItems = [
    'all_collection'.tr(),
    'recommended'.tr(),
    'following'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'edit_cover'.tr(),
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF080830),
              fontFamily: 'Inter'),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Color(0xFF616161),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          TextButton(
              onPressed: null,
              child: Text(
                'Save',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF1212C4),
                    fontFamily: 'Inter'),
              ))
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              alignment: Alignment.centerRight,
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width,
              height: bannerSize,
            ),
          ),
          Positioned(
            top: bannerSize + 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const ImageIcon(
                          AssetImage('assets/images/icon/chevron-down.png'),
                          size: 24,
                          color: kSelectedIcon),
                      elevation: 16,
                      underline: const SizedBox(),
                      focusColor: const Color(0xFF1212C4),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Inter'),
                      onChanged: (String? data) {
                        setState(() {
                          dropdownValue = data!;
                        });
                      },
                      items: spinnerItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: CollectionViewWidget(),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              top: bannerSize - 45,
              left: 15,
              right: 15,
              child: CustomCardWidget(
                buttonWidget: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => EditProfileScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(138, 36),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: const BorderSide(
                            color: Color(0xffCACACA),
                          ))),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Edit Profile",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff616161))),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
