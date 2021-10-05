import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class PylonsMarketplaceCard extends StatelessWidget {
  const PylonsMarketplaceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Container(
      width: screenSize.width(),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
            children: const [
           Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: UserImageWidget(imageUrl: kImage2, radius: 16,),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Linda',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),),),
          Text('10 min',
              style: TextStyle(fontSize: 12, color: Color(0xFF201D1D)))
        ]),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          margin: EdgeInsets.zero,
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
              InkWell(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: kImage1,
                    width: screenSize.width(),
                    height: 200,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const DetailScreenWidget(isOwner: false,)));
                }
              ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text('Title of Artwork',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF201D1D))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                child: Row(children: [
                  GestureDetector(
                      child: const ImageIcon(
                          AssetImage('assets/icons/comment.png'),
                          size: 16,
                          color: Color(0xFFC4C4C4)),
                      onTap: () {}),
                  const HorizontalSpace(4),
                  const Text('40', style:  TextStyle(fontSize: 13, color: Color(0xFFC4C4C4)),),
                  const HorizontalSpace(10),
                  GestureDetector(
                      child: const ImageIcon(
                          AssetImage('assets/icons/like.png'),
                          size: 16,
                          color: Color(0xFFC4C4C4)),
                      onTap: () {}),
                  const HorizontalSpace(4),
                  const Text('142', style:  TextStyle(fontSize: 13, color: Color(0xFFC4C4C4))),
                  const Spacer(),
                  const Text(
                    '\$ 12.00',
                    style:  TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  )
                ]),
              )
            ])),
      ]),
    );
  }
}
