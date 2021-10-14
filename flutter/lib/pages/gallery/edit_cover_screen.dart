import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';

import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/account/account.dart';
import 'package:pylons_wallet/pages/edit_profile/edit_profile_screen.dart';
import 'package:pylons_wallet/pages/gallery/widget/collection_view_widget.dart';
import 'package:pylons_wallet/pages/gallery/widget/custom_card_widget.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class EditCoverScreen extends StatefulWidget {
  @override
  State<EditCoverScreen> createState() => _EditCoverScreenState();
}

class _EditCoverScreenState extends State<EditCoverScreen> {
  // final double bannerSize = 135;
  String dropdownValue = 'all_collection'.tr();

  List<String> spinnerItems = [
    'all_collection'.tr(),
    'recommended'.tr(),
    'following'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    final bannerSize = screenSize.height(percent: 0.20);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'edit_cover'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF080830), fontFamily: 'Inter'),
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
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF1212C4), fontFamily: 'Inter'),
              ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(kImage3), fit: BoxFit.cover)),
            width: MediaQuery.of(context).size.width,
            height: bannerSize,
          ),
          Container(
            margin: EdgeInsets.only(
              top: bannerSize * 0.6,
            ),
            child: Column(
              children: [
                Card(
                    elevation: 8,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width * .90,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 10,
                            leading: const UserImageWidget(imageUrl: kImage2),
                            title: const Text('Linda',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF201D1D),
                                )),
                            subtitle: const Text('Media Artist (3D, Motiongraphics, Collecting NFT)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF616161))),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreenWidget()));
                            },
                          ),
                          Row(
                            children: [const SizedBox(width: 70), Text('${'followers'.tr()}: 23'), const SizedBox(width: 50), Text('${'following'.tr().toLowerCase()}: 20')],
                          ),
                          const VerticalSpace(10),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          side: const BorderSide(
                                            color: Color(0xffCACACA),
                                          ))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Edit Profile", style: TextStyle(fontSize: 15, color: Color(0xff616161))),
                                    ],
                                  ),
                                ),
                              ),

                              //),
                              // SizedBox(
                              //   height: 30,
                              //   width: 30,
                              //   child: OutlinedButton(
                              //     onPressed: () {
                              //       this.setExandMode();
                              //     },
                              //     style: ElevatedButton.styleFrom(
                              //       alignment:Alignment.center,
                              //       primary: Colors.white,
                              //       padding: EdgeInsets.all(0),
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(5), // <-- Radius
                              //       ),
                              //     ),
                              //
                              //     child: Center(
                              //       child: Icon(
                              //         (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                              //         color: Color(0xFF616161),
                              //      ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                    )),
                const VerticalSpace(6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const ImageIcon(AssetImage('assets/images/icon/chevron-down.png'), size: 24, color: kSelectedIcon),
                      elevation: 16,
                      underline: const SizedBox(),
                      focusColor: const Color(0xFF1212C4),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black, fontFamily: 'Inter'),
                      onChanged: (String? data) {
                        setState(() {
                          dropdownValue = data!;
                        });
                      },
                      items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(child: CollectionViewWidget())
              ],
            ),
          )
        ],
      ),
    );
  }
}
