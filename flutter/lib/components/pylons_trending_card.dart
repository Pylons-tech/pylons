import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';

class PylonsTrendingCard extends StatelessWidget {
  const PylonsTrendingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 6, left: 6),
        width: 200,
        child: Column(children: [
          Row(children: [
            Expanded(
                child: ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const UserImageWidget(
                imageUrl: kImage2,
                radius: 15,
              ),
              title: const Text('Linda'),
              trailing: IconButton(
                onPressed: () {},
                icon: const ImageIcon(AssetImage('assets/images/icon/add_friend.png')),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailScreenWidget(isOwner: false)));
              },
            )),
          ]),
          ClipRRect(borderRadius: BorderRadius.circular(5.0), child: CachedNetworkImage(imageUrl: kImage2, width: 200.0, height: 250.0, fit: BoxFit.cover)),
          Row(children: [
            TextButton.icon(
              icon: const ImageIcon(AssetImage('assets/icons/comment.png'), size: kIconSize, color: kUnselectedIcon),
              label: const Text(
                '40',
                style: TextStyle(color: kUnselectedIcon),
              ),
              onPressed: () {},
            ),
            TextButton.icon(
              icon: const ImageIcon(AssetImage('assets/icons/like.png'), size: kIconSize, color: kUnselectedIcon),
              label: const Text('142', style: TextStyle(color: kUnselectedIcon)),
              onPressed: () {},
            ),
            const Spacer(),
            IconButton(
              icon: const ImageIcon(AssetImage('assets/images/icon/dots.png'), size: kIconSize, color: kUnselectedIcon),
              onPressed: () {},
            )
          ])
        ]));
  }
}
