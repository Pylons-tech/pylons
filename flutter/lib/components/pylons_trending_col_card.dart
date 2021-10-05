import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsTrendingColCard extends StatelessWidget {

  const PylonsTrendingColCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.zero,
        width: 320,
        child:Column(

            children: [
              Row(
                  children: [
                    const Expanded(
                        child:ListTile(
                          contentPadding: EdgeInsets.zero,
                            leading: UserImageWidget(imageUrl: kImage2, radius: 16,),
                            title: Text('Linda')
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.zero,
                        child: IconButton(
                          onPressed: (){},
                          icon: const ImageIcon(
                              AssetImage('assets/images/icon/add_friend.png')
                          ),
                        )
                    )
                  ]
              ),
              Card(
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(

                      children: [
                        //1x2 image
                        CachedNetworkImage(
                            imageUrl: kImage1,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover
                        ),
                        const HorizontalSpace(2.0),
                        Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: kImage3,
                              width: 110.0,
                              height: 100.0,
                              fit: BoxFit.cover
                            ),
                            const VerticalSpace(2.0),
                            CachedNetworkImage(
                                imageUrl: kImage1,
                                width: 110.0,
                                height: 100.0,
                                fit: BoxFit.cover
                            )
                          ]
                        )
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('collection_title'.tr()),
                    )
                  ],
                )
              ),

            ]
        )
    );
  }
}
