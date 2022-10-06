import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class VideoPlaceHolder extends StatelessWidget {
  final String nftUrl;
  final String nftName;
  final String thumbnailUrl;

  const VideoPlaceHolder({
    Key? key,
    required this.nftUrl,
    required this.nftName,
    required this.thumbnailUrl,
  }) : super(key: key);

  Widget getVideoThumbnailFromUrl() {
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
            child: Image.asset(
              ImageUtil.VIDEO_ICON,
              color: AppColors.kBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget getWaitingWidget() {
    return Stack(children: [
      Align(
          child: SizedBox(
              width: 35.w,
              height: 35.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: AppColors.kBlack,
              ))),
    ]);
  }

  Widget getVideoPlaceHolder() {
    return Align(
      child: Container(
        width: 35.w,
        height: 35.h,
        decoration: BoxDecoration(
            color:AppColors.kWhite.withOpacity(0.5), shape: BoxShape.circle),
        child: Image.asset(
          ImageUtil.VIDEO_ICON,
          color: AppColors.kBlack.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget getSuccessWidget(AsyncSnapshot<String?> snapshot) {
    return Stack(children: [
      Positioned.fill(
          child: Image.file(File(snapshot.data.toString()),
              fit: BoxFit.fitWidth, cacheWidth: 100, cacheHeight: 110)),
      Align(
          child: Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                  color: AppColors.kWhite.withOpacity(0.5), shape: BoxShape.circle),
              child: Image.asset(ImageUtil.VIDEO_ICON,
                  color: AppColors.kBlack.withOpacity(0.7))))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: AppColors.kWhite,
        child: thumbnailUrl.isNotEmpty
            ? getVideoThumbnailFromUrl()
            : getVideoPlaceHolder());
  }
}

class BuildThumbnailContainer extends StatelessWidget {
  final AsyncSnapshot<String?> snapshot;
  final WidgetBuilder errorWidget;
  final WidgetBuilder successWidget;
  final WidgetBuilder waitingWidget;

  const BuildThumbnailContainer({
    Key? key,
    required this.snapshot,
    required this.errorWidget,
    required this.successWidget,
    required this.waitingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return waitingWidget(context);
    } else if (snapshot.hasError) {
      return errorWidget(context);
    } else {
      return successWidget(context);
    }
  }
}
