import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';

class NotificationItem extends StatelessWidget {

  const NotificationItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.only(right: 6, left: 6),
        child:Column(
            children: [
              Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: const UserImageWidget(imageUrl: kImage2,),
                        title: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(text: 'Jimin', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' ${'purchased'.tr()}'),
                              const TextSpan(text: ' Title of Artwork', style: TextStyle(fontWeight: FontWeight.bold)),
                              const TextSpan(text: '  10min', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                     const HorizontalSpace(10),
                     ClipRRect(
                       borderRadius: BorderRadius.circular(4),
                       child: CachedNetworkImage(
                         imageUrl: kImage3,
                         width: 44,
                         height: 44,
                         fit: BoxFit.fill,
                       ),
                     ),
                    const HorizontalSpace(10),
                  ]
              ),
          ]
        )
    );
  }
}
