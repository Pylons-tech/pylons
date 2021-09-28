import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsTrendingNewCard extends StatelessWidget {

  const PylonsTrendingNewCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const layout = [
      [1, 1],
      [2, 2],
      [1, 1],
      [1, 1],
      [1, 1],
      [1, 1]
    ];

    return Container(
        padding: EdgeInsets.only(right: 6),
        width: 325,
        child:

        Row(
            children: [
              Column(
                children: [
                  CachedNetworkImage(
                      imageUrl: kImage3,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover
                  ),
                  SizedBox(height: 5.0),
                  CachedNetworkImage(
                      imageUrl: kImage2,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover
                  ),
                  SizedBox(height: 5.0),
                  CachedNetworkImage(
                      imageUrl: kImage,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover
                  ),
               ],
              ),
              SizedBox(width:5.0),
              Column(
                children: [
                  CachedNetworkImage(
                      imageUrl: kImage1,
                      width: 205.0,
                      height: 205.0,
                      fit: BoxFit.cover
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      CachedNetworkImage(
                          imageUrl: kImage,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover
                      ),
                      SizedBox(width: 5.0),
                      CachedNetworkImage(
                          imageUrl: kImage2,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover
                      ),
                    ],
                  )
                ],
              )
           ]
        )
    );
  }
}
