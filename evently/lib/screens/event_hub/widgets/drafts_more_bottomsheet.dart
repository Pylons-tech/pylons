import 'package:evently/evently_provider.dart';
import 'package:evently/main.dart';
import 'package:evently/models/events.dart';
import 'package:evently/screens/event_hub/event_hub_view_model.dart';
import 'package:evently/screens/event_hub/widgets/delete_confirmation_dialog.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/di/di.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/widgets/clippers/bottom_sheet_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

TextStyle titleStyle = TextStyle(fontSize: isTablet ? 13.sp : 16.sp, fontWeight: FontWeight.w800, fontFamily: kUniversalFontFamily, color: EventlyAppTheme.kBlack);

class DraftsBottomSheet {
  final BuildContext buildContext;
  final Events events;

  EventHubViewModel get creatorHubViewModel => sl();

  DraftsBottomSheet({required this.buildContext, required this.events});

  Future<void> show() async {
    return showModalBottomSheet(
      backgroundColor: EventlyAppTheme.kTransparent,
      context: buildContext,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: creatorHubViewModel,
          child: DraftsMoreBottomSheet(
            events: events,
          ),
        );
      },
    );
  }
}

class DraftsMoreBottomSheet extends StatelessWidget {
  const DraftsMoreBottomSheet({super.key, required this.events});

  final Events events;

  EventlyProvider get easelProvider => sl();

  Future<void> onViewOnIPFSPressed({required BuildContext context, required Events events}) async {
    // final easelProvider = Provider.of<EventlyProvider>(context, listen: false);
    // await easelProvider.repository.launchMyUrl(url: nft.url.changeDomain());
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = context.watch<EventHubViewModel>();
    return ClipPath(
      clipper: BottomSheetClipper(),
      child: Container(
        color: EventlyAppTheme.kGrey02,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Wrap(
          children: [
            moreOptionTile(
                title: "publish",
                image: SVGUtils.kSvgPublish,
                onPressed: () {
                  // viewModel.saveNFT(nft: nft);
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pushNamed(RouteUtil.kRouteHome);
                }),
            const Divider(
              color: EventlyAppTheme.kGrey01,
            ),
            moreOptionTile(
                title: "delete",
                image: SVGUtils.kSvgDelete,
                onPressed: () {
                  Navigator.of(context).pop();

                  final DeleteDialog deleteDialog = DeleteDialog(contextt: context, events: events);

                  deleteDialog.show();
                }),
            const Divider(
              color: EventlyAppTheme.kGrey01,
            ),
          ],
        ),
      ),
    );
  }
}

Widget moreOptionTile({required String title, required String image, required VoidCallback onPressed, bool isSvg = true}) {
  final TextStyle titleStyle = TextStyle(fontSize: isTablet ? 13.sp : 16.sp, fontWeight: FontWeight.w800, fontFamily: kUniversalFontFamily, color: EventlyAppTheme.kBlack);

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          if (isSvg) SvgPicture.asset(image) else Image.asset(image),
          SizedBox(
            width: 30.w,
          ),
          Text(
            title,
            style: titleStyle.copyWith(fontSize: 16.sp),
          )
        ],
      ),
    ),
  );
}
