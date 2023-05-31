import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class NftImageWidget extends StatelessWidget {
  final String url;

  final double opacity;

  const NftImageWidget({super.key, required this.url, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        errorWidget: (a, b, c) => Center(
          child: Text(
            LocaleKeys.unable_to_fetch_nft_item.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        imageBuilder: (context, imageProvider) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: FractionalOffset.center,
                image: imageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}
