import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/next_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/gallery/collections.dart';


class GalleryTabCollectionWidget extends StatelessWidget {

  const GalleryTabCollectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double tileWidth = (MediaQuery. of(context). size. width - 30) / 3;

    return Padding(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 20),
        //margin: const EdgeInsets.only(bottom: 100.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 4,
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) => _CollectionWidget(tileWidth: tileWidth),),
    );
  }
}

class _CollectionWidget extends StatelessWidget {
  const _CollectionWidget({
    Key? key,
    required this.tileWidth,
  }) : super(key: key);

  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child:Column(
          children: [
            InkWell(
                child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: kImage,
                    width: tileWidth * 2,
                    height: tileWidth * 2 + 2,
                    fit: BoxFit.cover
                  ),
                  SizedBox(width: 2),
                  Column(
                    children: [
                      CachedNetworkImage(
                          imageUrl: kImage2, width: tileWidth,
                        height: tileWidth,
                        fit: BoxFit.cover
                      ),
                      SizedBox(height: 2),
                      CachedNetworkImage(
                          imageUrl: kImage3, width: tileWidth,
                          height: tileWidth,
                          fit: BoxFit.cover
                      ),

                    ]
                  )
                ],
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectionsScreen()));
              }
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text('photo_collection'.tr()),

                    IconButton(
                        icon: Icon(Icons.more_vert,
                          size: 24,
                          color: Color(0xFF616161)
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectionsScreen()));
                        }
                    ),
                  ]
                ),
            )
            ],
          ),
        ),
      );
  }
}
