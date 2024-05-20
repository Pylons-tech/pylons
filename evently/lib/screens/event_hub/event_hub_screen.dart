import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/main.dart';
import 'package:evently/models/events.dart';
import 'package:evently/screens/event_hub/event_hub_view_model.dart';
import 'package:evently/screens/event_hub/widgets/delete_confirmation_dialog.dart';
import 'package:evently/screens/event_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:evently/screens/event_hub/widgets/nfts_grid_view.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/di/di.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/widgets/clipped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class EventHubScreen extends StatefulWidget {
  const EventHubScreen({super.key});

  @override
  State<EventHubScreen> createState() => _EventHubScreenState();
}

class _EventHubScreenState extends State<EventHubScreen> {
  EventHubViewModel get eventHubViewModel => sl<EventHubViewModel>();

  @override
  void initState() {
    eventHubViewModel.getPublishAndDraftData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: eventHubViewModel,
      child: FocusDetector(
        onFocusGained: () {
          eventHubViewModel.getPublishAndDraftData();
        },
        child: const EventHubContent(),
      ),
    );
  }
}

class EventHubContent extends StatefulWidget {
  const EventHubContent({super.key});

  @override
  State<EventHubContent> createState() => _EventHubContentState();
}

class _EventHubContentState extends State<EventHubContent> {
  TextStyle headingStyle = TextStyle(
    fontSize: isTablet ? 20.sp : 25,
    fontWeight: FontWeight.bold,
    color: EventlyAppTheme.kTextLightPurple,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle titleStyle = TextStyle(
    fontSize: isTablet ? 14.sp : 15,
    fontWeight: FontWeight.bold,
    color: EventlyAppTheme.kWhite,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle btnTxtStyle = TextStyle(
    fontSize: isTablet ? 12.sp : 12.sp,
    fontWeight: FontWeight.w700,
    color: EventlyAppTheme.kWhite,
    fontFamily: kUniversalFontFamily,
  );

  TextStyle subTitleStyle = TextStyle(
    fontSize: isTablet ? 12.sp : 15,
    fontWeight: FontWeight.w700,
    color: EventlyAppTheme.kGrey01,
    fontFamily: kUniversalFontFamily,
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EventHubViewModel>();
    return ColoredBox(
      color: EventlyAppTheme.kBlack,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: EventlyAppTheme.kBlack,
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pushNamed(RouteUtil.kCreateEvent),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(color: EventlyAppTheme.kTextLightBlue),
                        child: Icon(Icons.add, size: 21, color: EventlyAppTheme.kWhite),
                      ),
                    ),
                  ),
                ),
                Text(
                  LocaleKeys.eventhub.tr(),
                  style: headingStyle,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    LocaleKeys.welcome_event.tr(),
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getButton(
                        title: LocaleKeys.draft,
                        onTap: () => viewModel.changeSelectedCollection(CollectionType.draft),
                        isSelected: viewModel.selectedCollectionType == CollectionType.draft,
                      ),
                      getButton(
                        title: LocaleKeys.for_sale,
                        onTap: () => viewModel.changeSelectedCollection(CollectionType.forSale),
                        isSelected: viewModel.selectedCollectionType == CollectionType.forSale,
                      ),
                      getButton(
                        title: LocaleKeys.history,
                        onTap: () => viewModel.changeSelectedCollection(CollectionType.history),
                        isSelected: viewModel.selectedCollectionType == CollectionType.history,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 16.w),
                      InkWell(
                        onTap: () => viewModel.updateViewType(ViewType.viewGrid),
                        child: SvgPicture.asset(
                          SVGUtils.kGridIcon,
                          height: 18.h,
                          color: getButtonColor(isSelected: viewModel.viewType == ViewType.viewGrid),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      InkWell(
                        onTap: () => viewModel.updateViewType(ViewType.viewList),
                        child: SvgPicture.asset(
                          SVGUtils.kListIcon,
                          height: 18.h,
                          color: getButtonColor(isSelected: viewModel.viewType == ViewType.viewList),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                viewModel.viewType == ViewType.viewGrid
                    ? Expanded(
                        child: BuildGridView(
                          eventsList: viewModel.eventForDraftList,
                          onEmptyList: (BuildContext context) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  LocaleKeys.no_nft_created.tr(),
                                  style: subTitleStyle,
                                )),
                          ),
                          calculateBannerPrice: ({required String currency, required String price}) {
                            return '';
                          },
                        ),
                      )
                    : Expanded(
                        child: BuildListView(
                          eventsList: viewModel.eventForDraftList,
                          onEmptyList: (BuildContext context) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  LocaleKeys.no_nft_created.tr(),
                                  style: subTitleStyle,
                                )),
                          ),
                        ),
                      ),
                const Spacer(),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20.w), child: getCreateEventWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getButtonColor({required bool isSelected}) {
    if (isSelected) {
      return EventlyAppTheme.kBlue;
    } else {
      return EventlyAppTheme.kWhite;
    }
  }

  Widget getButton({required String title, required VoidCallback onTap, required bool isSelected}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(border: Border.all(color: isSelected ? EventlyAppTheme.kBlue : EventlyAppTheme.kWhite)),
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          child: Text(
            title.tr(),
            style: btnTxtStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget getCreateEventWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: ClippedButton(
        title: LocaleKeys.create_event.tr(),
        bgColor: EventlyAppTheme.kBlue,
        textColor: EventlyAppTheme.kWhite,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteUtil.kCreateEvent);
        },
        cuttingHeight: 15.h,
        clipperType: ClipperType.bottomLeftTopRight,
        isShadow: false,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}

class BuildListView extends StatelessWidget {
  final List<Events> eventsList;
  final WidgetBuilder onEmptyList;

  const BuildListView({super.key, required this.eventsList, required this.onEmptyList});

  EventHubViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    if (eventsList.isEmpty) {
      return onEmptyList(context);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: eventsList.length,
      itemBuilder: (context, index) {
        final events = eventsList[index];
        if (viewModel.selectedCollectionType == CollectionType.draft) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: DraftListTile(events: events, viewModel: viewModel),
          );
        } else {
          return const Placeholder();
        }
      },
    );
  }
}

class DraftListTile extends StatefulWidget {
  final Events events;
  final EventHubViewModel viewModel;

  const DraftListTile({super.key, required this.events, required this.viewModel});

  @override
  State<DraftListTile> createState() => _DraftListTileState();
}

class _DraftListTileState extends State<DraftListTile> {
  Widget getDraftCard() {
    return InkWell(
      onTap: () {
        final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
          buildContext: context,
          events: widget.events,
        );
        draftsBottomSheet.show();
        return;
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
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
              CachedNetworkImage(
                width: 90.w,
                fit: BoxFit.contain,
                imageUrl: widget.events.thumbnail,
                errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                progressIndicatorBuilder: (context, _, progress) {
                  return Shimmer(color: EventlyAppTheme.kGrey04, child: const SizedBox.expand());
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.events.eventName.isNotEmpty) ? widget.events.eventName : 'Event Name',
                      style: titleStyle.copyWith(fontSize: isTablet ? 13.sp : 18.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        color: EventlyAppTheme.kLightRed,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      child: Text(
                        LocaleKeys.draft.tr(),
                        style: EventlyAppTheme.titleStyle.copyWith(color: EventlyAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(4.0.w),
                  child: SvgPicture.asset(SVGUtils.kSvgMoreOption),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slidable(
          key: ValueKey(widget.events.id),
          closeOnScroll: false,
          endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              buildSlidableAction(
                context,
                callback: () {
                  final DeleteDialog deleteDialog = DeleteDialog(contextt: context, events: widget.events);
                  deleteDialog.show();
                },
                icon: SVGUtils.kSvgDelete,
              ),
            ],
          ),
          child: getDraftCard(),
        ),
      ],
    );
  }

  Widget buildSlidableAction(BuildContext context, {required VoidCallback callback, required String icon, bool isSvg = true}) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: isSvg ? SvgPicture.asset(icon) : Image.asset(icon),
      ),
    );
  }
}

class BuildGridView extends StatelessWidget {
  final List<Events> eventsList;
  final WidgetBuilder onEmptyList;
  final String Function({
    required String price,
    required String currency,
  }) calculateBannerPrice;

  const BuildGridView({
    super.key,
    required this.eventsList,
    required this.onEmptyList,
    required this.calculateBannerPrice,
  });

  @override
  Widget build(BuildContext context) {
    if (eventsList.isEmpty) {
      return onEmptyList(context);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        itemCount: eventsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.5,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final events = eventsList[index];
          return NftGridViewItem(events: events);
        },
      ),
    );
  }
}
