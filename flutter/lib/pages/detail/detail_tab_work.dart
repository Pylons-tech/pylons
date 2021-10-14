import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';

class DetailTabWorkWidget extends StatelessWidget {
  const DetailTabWorkWidget({
    Key? key,
  }) : super(key: key);

  static List<String> tags = ['#3D', '#Photography', '#Sculpture'];

  static List<String> nfts = [...kImageList, kImage];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(bottom: 100, top: 10, left: 20, right: 20),
          //margin: const EdgeInsets.only(bottom: 100.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('title_of_artwork'.tr(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xFF080830))),
                  const Spacer(),
                  FavoriteButton(onTap: () {}),
                  ShareButton(onTap: () {})
                ],
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: tags
                          .map((tag) => Chip(
                                backgroundColor: const Color(0xFFED8864),
                                label: Text(tag),
                              ))
                          .toList())),

              const VerticalSpace(10),
              //Description
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'artwork_description'.tr(),
                  )),

              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) => const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: UserImageWidget(imageUrl: kImage2),
                        title: Text(
                          'jimin',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('Really Love the artwork!', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
                        trailing: Text('10 min', style: TextStyle(color: Color(0xFFC4C4C4), fontSize: 16, fontWeight: FontWeight.w400)),
                      ),
                  separatorBuilder: (_, index) => const Divider(),
                  itemCount: 5),

              Row(
                children: [Text('related_items'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF242423))), const Spacer(), MoreButton(onTap: () {})],
              ),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 3.5 / 4,
                children: nfts.map((nft) => ClipRRect(borderRadius: BorderRadius.circular(5), child: CachedNetworkImage(imageUrl: nft, height: 60, fit: BoxFit.cover))).toList(),
              )
            ],
          )),
    );
  }
}
