import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EaselAppTheme.kWhite,
      child: Stack(
        children: [
          Positioned.fill(
              child: CachedNetworkImage(
                  placeholder: (context, url) => Shimmer(
                        color: EaselAppTheme.cardBackground,
                        child: const SizedBox.expand(),
                      ),
                  errorWidget: (context, url, error) => Align(child: Container(color: EaselAppTheme.kWhite)),
                  imageUrl: thumbnailUrl,
                  fit: BoxFit.cover)),
          Align(
            child: Container(
              width: 25.w,
              height: 25.h,
              decoration: BoxDecoration(color: EaselAppTheme.kWhite.withOpacity(0.5), shape: BoxShape.circle),
              child: Image.asset(
                kVideoIcon,
                color: EaselAppTheme.kBlack,
              ),
            ),
          ),

        ],
      ),
    );
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
