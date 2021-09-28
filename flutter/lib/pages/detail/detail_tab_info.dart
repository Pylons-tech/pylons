import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';

class DetailTabInfoWidget extends StatelessWidget {

  const DetailTabInfoWidget({
    Key? key,
  }) : super(key: key);

  static List<String> tags = [
    '#3D', '#Photography', '#Sculpture'
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 100),
        //margin: const EdgeInsets.only(bottom: 100.0),
        child: Column(

          children: [
            //Creator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 6, bottom: 6),
                  child: Text('creator'.tr(), style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                ListTile(
                  leading: UserImageWidget(imageUrl: kImage1),
                  title: Text('Jimin',style: TextStyle(fontSize:16, fontWeight: FontWeight.w600)),
                  trailing: SizedBox(
                    width: 100,
                    height: 35,
                    child: PylonsBlueButton(
                      onTap: (){},
                      text :'following'.tr()
                    ),
                  )
                ),
                Divider()
              ],
            ),
            //owner list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 6, bottom: 6),
                  child: Text('owner'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: 20,
                    itemBuilder: (_, index) => _OwnerWidget(
                      userName: "Linda",
                      userImage: kImage3,
                      onButtonPressed: (){},
                    ),
                ),


              ],
            )
          ],
        )
    );
  }
}

class _OwnerWidget extends StatelessWidget {
  const _OwnerWidget({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.onButtonPressed,
  }) : super(key: key);


  final String userName;
  final String userImage;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
    leading: UserImageWidget(imageUrl: userImage,),
    title: Text(userName,style: TextStyle(fontSize:16, fontWeight: FontWeight.w600)),
    trailing: SizedBox(
      width: 100,
      height: 35,
      child: PylonsBlueButton(
          onTap: onButtonPressed,
          text :'following'.tr()
      ),
    )
                );
  }
}
