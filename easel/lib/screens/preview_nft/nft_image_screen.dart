import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/utils/screen_size_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NftImageWidget extends StatelessWidget {
  final String imageUrl;

  const NftImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);

    return Padding(
      padding: EdgeInsets.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: (a, b, c) => Center(
            child: Text(
          "unable_to_fetch_nft_item".tr(),
          style: Theme.of(context).textTheme.bodyText1,
        )),
        imageBuilder: (context, imageProvider) {
          return Container(
            width: screenSize.width(),
            height: screenSize.height(),
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: FractionalOffset.center,
                image: imageProvider,
                fit: BoxFit.fitHeight,
              ),
            ),
          );
        },
      ),
    );
  }
}
