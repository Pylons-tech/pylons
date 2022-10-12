import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PdfPlaceHolder extends StatelessWidget {
  final String nftUrl;
  final String nftName;
  final String thumbnailUrl;

  const PdfPlaceHolder({
    Key? key,
    required this.nftUrl,
    required this.nftName,
    required this.thumbnailUrl,
  }) : super(key: key);

  Widget getPdfThumbnailFromUrl() {
    return Stack(
      children: [
        Positioned.fill(
            child: CachedNetworkImage(
                placeholder: (context, url) => Shimmer(
                      color: PylonsAppTheme.cardBackground,
                      child: const SizedBox.expand(),
                    ),
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover)),
        Align(
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(
                color: AppColors.kWhite.withOpacity(0.5), shape: BoxShape.circle),
            child: const Icon(Icons.picture_as_pdf),
          ),
        ),
      ],
    );
  }

  Widget getPdfPlaceHolder() {
    return Align(
      child: Container(
        width: 35.w,
        height: 35.h,
        decoration: BoxDecoration(
            color: AppColors.kWhite.withOpacity(0.5), shape: BoxShape.circle),
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: AppColors.kWhite,
        child: thumbnailUrl.isNotEmpty
            ? getPdfThumbnailFromUrl()
            : getPdfPlaceHolder());
  }
}
