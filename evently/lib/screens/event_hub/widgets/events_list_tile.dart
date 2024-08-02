import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/main.dart';
import 'package:evently/models/events.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/extension_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../generated/locale_keys.g.dart';

class NFTsListTile extends StatelessWidget {
  final Events publishedEvents;

  const NFTsListTile({super.key, required this.publishedEvents});

  EventlyProvider get _easelProvider => GetIt.I.get();

  void buildBottomSheet({required BuildContext context}) {}

  Widget getPublishedCard({required BuildContext context}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: EventlyAppTheme.kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Row(
          children: [
            SizedBox(
              height: 45.h,
              width: 45.w,
              child: NftTypeBuilder(
                onImage: (context) => buildCachedNetworkImage(publishedEvents.thumbnail),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    publishedEvents.eventName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: EventlyAppTheme.titleStyle.copyWith(fontSize: isTablet ? 13.sp : 18.sp),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.h),
                      color: EventlyAppTheme.kDarkGreen,
                    ),
                    child: Text(
                      LocaleKeys.published.tr(),
                      style: EventlyAppTheme.titleStyle.copyWith(color: EventlyAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            InkWell(
              onTap: () => buildBottomSheet(context: context),
              child: Padding(
                padding: EdgeInsets.all(4.0.w),
                child: SvgPicture.asset(SVGUtils.kSvgMoreOption),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (publishedEvents.price.isNotEmpty && double.parse(publishedEvents.price) > 0)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Card(
              elevation: 5,
              margin: EdgeInsets.zero,
              child: ClipRRect(
                child: Banner(
                  key: Key("${publishedEvents.denom.getCoinWithProperDenomination(publishedEvents.price)} ${publishedEvents.denom.getAbbrev()}"),
                  color: EventlyAppTheme.kDarkGreen,
                  location: BannerLocation.topEnd,
                  message: "${publishedEvents.denom.getCoinWithProperDenomination(publishedEvents.price)} ${publishedEvents.denom.getAbbrev()}",
                  child: getPublishedCard(context: context),
                ),
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: getPublishedCard(context: context),
          ),
      ],
    );
  }

  CachedNetworkImage buildCachedNetworkImage(String url) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: url,
      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
      placeholder: (context, url) => Shimmer(color: EventlyAppTheme.cardBackground, child: const SizedBox.expand()),
    );
  }
}

class NftTypeBuilder extends StatelessWidget {
  final WidgetBuilder onImage;

  const NftTypeBuilder({
    super.key,
    required this.onImage,
  });

  @override
  Widget build(BuildContext context) {
    return onImage(context);
  }
}
