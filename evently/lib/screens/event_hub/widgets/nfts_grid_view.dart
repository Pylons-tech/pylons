import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/models/events.dart';
import 'package:evently/screens/event_hub/event_hub_view_model.dart';
import 'package:evently/screens/event_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';

List<Color> gradientBlackToTransparent = <Color>[
  Colors.black87,
  Colors.black54,
  Colors.black45,
  Colors.black38,
  Colors.black26,
  Colors.black12,
  EventlyAppTheme.kTransparent,
];

List<Color> gradientTransparentToBlack = <Color>[
  EventlyAppTheme.kTransparent,
  Colors.black12,
  Colors.black26,
  Colors.black38,
  Colors.black45,
  Colors.black54,
  Colors.black87,
];

class NftGridViewItem extends StatelessWidget {
  const NftGridViewItem({
    super.key,
    required this.events,
  });
  final Events events;

  EventlyProvider get _easelProvider => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200.h,
          width: 150.w,
          child: InkWell(
            onTap: () {
              final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                buildContext: context,
                events: events,
              );
              draftsBottomSheet.show();
              return;
            },
            child: CachedNetworkImage(
              fit: BoxFit.fitHeight,
              imageUrl: events.thumbnail,
              errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
              placeholder: (context, url) => Shimmer(color: EventlyAppTheme.kGery03, child: const SizedBox.expand()),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientBlackToTransparent,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, top: 10.0.h),
                child: SvgPicture.asset(
                  SVGUtils.kFileTypeImageIcon,
                  color: Colors.white,
                  width: 14,
                  height: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientTransparentToBlack,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.h),
                      color: context.read<EventHubViewModel>().selectedCollectionType == CollectionType.draft ? EventlyAppTheme.kLightRed : EventlyAppTheme.kDarkGreen,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                    child: Text(
                      context.read<EventHubViewModel>().selectedCollectionType == CollectionType.draft ? LocaleKeys.draft.tr() : LocaleKeys.published.tr(),
                      style: EventlyAppTheme.titleStyle.copyWith(
                        color: EventlyAppTheme.kWhite,
                        fontSize: isTablet ? 8.sp : 11.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (context.read<EventHubViewModel>().selectedCollectionType == CollectionType.draft) {
                        final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                          buildContext: context,
                          events: events,
                        );
                        draftsBottomSheet.show();
                        return;
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.0.w),
                      child: SvgPicture.asset(SVGUtils.kSvgMoreOption, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  CachedNetworkImage buildNFTPreview({required String url}) {
    return CachedNetworkImage(
      fit: BoxFit.fitHeight,
      imageUrl: url,
      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
      placeholder: (context, url) => Shimmer(color: EventlyAppTheme.kGrey01, child: const SizedBox.expand()),
    );
  }
}
