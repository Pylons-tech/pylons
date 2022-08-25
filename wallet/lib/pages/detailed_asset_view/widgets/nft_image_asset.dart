import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:simple_rich_text/simple_rich_text.dart';

class NftImageWidget extends StatelessWidget {
  final String url;

  final double opacity;

  const NftImageWidget({Key? key, required this.url, required this.opacity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);

    return Padding(
      padding: EdgeInsets.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        errorWidget: (a, b, c) => Center(
            child: SimpleRichText(
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
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(opacity),
                  BlendMode.srcOver,
                ),
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
