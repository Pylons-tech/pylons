import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';

class PylonsHistoryCard extends StatelessWidget {
  final String text;

  const PylonsHistoryCard({
    Key? key,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              horizontalTitleGap: 0,
                leading: const UserImageWidget(imageUrl: kImage2, radius: 16,),
                // title: Text('Linda purchased \'Title of Artwork\''),
              contentPadding: EdgeInsets.zero,
                title: RichText(text: TextSpan(text: "Linda", style: const TextStyle(color: Colors.black,
                fontWeight: FontWeight.w500, fontSize: 14),
                  children: [
                    TextSpan(text: " ${'purchased'.tr()} ", style: const TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                    ),),
                    const TextSpan(text: "'Title of Artwork'", style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ))
                  ]
                )),
                trailing: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 16,
                    color: kUnselectedIcon
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const DetailScreenWidget(isOwner: true)));
                },
            ),
            Card(
              margin: EdgeInsets.zero,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                      child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: kImage2,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      Row(
                          children:[
                            Padding(
                              padding: const EdgeInsets.only(right: 4, left: 10),
                              child: GestureDetector(
                                  child: Image.asset('assets/icons/comment.png',
                                      width: kSmallIconSize,
                                      fit: BoxFit.fill,
                                      color: kUnselectedIcon,
                                  ),
                                  onTap: () {}
                              ),
                            ),
                            const Text('40', style: TextStyle(color: kUnselectedIcon)),
                            const HorizontalSpace(10),
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: GestureDetector(
                                  child: Image.asset('assets/icons/like.png',
                                      width: kSmallIconSize,
                                      color: kUnselectedIcon
                                  ),
                                  onTap: () {}
                              ),
                            ),
                            const Text('142', style: TextStyle(color: kUnselectedIcon)),
                            const Spacer(),
                            IconButton(
                                icon: const Icon(
                                    Icons.more_vert,
                                    size: kSmallIconSize,
                                    color: kUnselectedIcon
                                ),
                                onPressed: () {}
                            ),
                          ]
                      )
                    ]
                )
              ),
            ),


          ]
      ),
    );
/*
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF1212C4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              text,
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
 */
  }
}
