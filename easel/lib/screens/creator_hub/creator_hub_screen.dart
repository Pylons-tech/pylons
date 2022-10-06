import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/draft_list_tile.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_grid_view.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class CreatorHubScreen extends StatefulWidget {
  const CreatorHubScreen({Key? key}) : super(key: key);

  @override
  State<CreatorHubScreen> createState() => _CreatorHubScreenState();
}

class _CreatorHubScreenState extends State<CreatorHubScreen> {
  CreatorHubViewModel get creatorHubViewModel => sl();

  EaselProvider get easelProvider => sl();

  @override
  void initState() {
    scheduleMicrotask(() {
      easelProvider.populateUserName();
      creatorHubViewModel.getPublishAndDraftData();
    });
    super.initState();

    easelProvider.setLog(screenName: AnalyticsScreenEvents.createrHubScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EaselAppTheme.kBgWhite,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: EaselAppTheme.kBgWhite,
          body: ChangeNotifierProvider.value(
            value: creatorHubViewModel,
            child: FocusDetector(
                onFocusGained: () {
                  GetIt.I.get<CreatorHubViewModel>().getDraftsList();
                  GetIt.I.get<CreatorHubViewModel>().getTotalForSale();
                },
                child: const CreatorHubContent()),
          ),
        ),
      ),
    );
  }
}

class CreatorHubContent extends StatefulWidget {
  const CreatorHubContent({Key? key}) : super(key: key);

  @override
  State<CreatorHubContent> createState() => _CreatorHubContentState();
}

class _CreatorHubContentState extends State<CreatorHubContent> {
  TextStyle headingStyle = TextStyle(
    fontSize: isTablet ? 20.sp : 25.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kDarkText,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle titleStyle = TextStyle(
    fontSize: isTablet ? 14.sp : 18.sp,
    fontWeight: FontWeight.w700,
    color: EaselAppTheme.kBlack,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle digitTextStyle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kWhite,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle subTextStyle = TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w700, fontFamily: kUniversalFontFamily, fontSize: isTablet ? 9.sp : 11.sp);

  EaselProvider get easelProvider => sl();

  void onRefreshPressed() async {
    GetIt.I.get<CreatorHubViewModel>().getDraftsList();
    GetIt.I.get<CreatorHubViewModel>().getRecipesList();
    GetIt.I.get<CreatorHubViewModel>().getTotalForSale();
  }

  Widget getRefreshButton(viewModel) {
    if (easelProvider.isPylonsInstalled) {
      switch (viewModel.selectedCollectionType) {
        case CollectionType.forSale:
        case CollectionType.published:
          return Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: InkWell(
                onTap: () => scheduleMicrotask(() => onRefreshPressed()),
                child: Icon(
                  Icons.refresh,
                  color: EaselAppTheme.kBlack,
                  size: 22.sp,
                )),
          );

        case CollectionType.draft:
          return const SizedBox();
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreatorHubViewModel>();
    return Container(
        color: EaselAppTheme.kWhite,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: EaselAppTheme.kBgWhite,
          body: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getRefreshButton(viewModel),
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(RouteUtil.kRouteHome),
                        child: Container(
                          decoration:
                              BoxDecoration(color: EaselAppTheme.kpurpleDark, boxShadow: [BoxShadow(color: EaselAppTheme.kpurpleDark.withOpacity(0.6), offset: const Offset(0, 0), blurRadius: 8.0)]),
                          child: Icon(Icons.add, size: 27.h, color: EaselAppTheme.kWhite),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "creator_hub".tr(),
                      style: headingStyle,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: AutoSizeText(
                    "welcome_msg".tr(),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: titleStyle.copyWith(color: EaselAppTheme.kTextGrey, fontSize: isTablet ? 12.sp : 15.sp),
                  ),
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      viewModel.selectedCollectionType == CollectionType.draft
                          ? buildSelectedBox(title: "draft".tr(), viewModel: viewModel, color: EaselAppTheme.kLightRed, collectionType: CollectionType.draft)
                          : buildOutlinedBox(title: "draft".tr(), viewModel: viewModel, collectionType: CollectionType.draft),
                      SizedBox(width: 14.w),
                      viewModel.selectedCollectionType == CollectionType.published
                          ? buildSelectedBox(title: "published".tr(), viewModel: viewModel, color: EaselAppTheme.kDarkGreen, collectionType: CollectionType.published)
                          : buildOutlinedBox(title: "published".tr(), viewModel: viewModel, collectionType: CollectionType.published),
                      SizedBox(width: 14.w),
                      viewModel.selectedCollectionType == CollectionType.forSale
                          ? buildSelectedBox(title: "for_sale".tr(), viewModel: viewModel, color: EaselAppTheme.kBlue, collectionType: CollectionType.forSale)
                          : buildOutlinedBox(title: "for_sale".tr(), viewModel: viewModel, collectionType: CollectionType.forSale),
                      SizedBox(width: 16.w),
                      InkWell(
                          onTap: () => viewModel.updateViewType(ViewType.viewGrid),
                          child: SvgPicture.asset(kGridIcon, height: 15.h, color: viewModel.viewType == ViewType.viewGrid ? EaselAppTheme.kBlack : EaselAppTheme.kGreyIcon)),
                      SizedBox(width: 14.w),
                      InkWell(
                        onTap: () => viewModel.updateViewType(ViewType.viewList),
                        child: SvgPicture.asset(kListIcon, height: 15.h, color: viewModel.viewType == ViewType.viewList ? EaselAppTheme.kBlack : EaselAppTheme.kGreyIcon),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: NFTsViewBuilder(
                      onGridSelected: (context) => BuildNFTsContent(
                          onDraftList: (context) => BuildGridView(
                                nftsList: viewModel.nftDraftList,
                                onEmptyList: (context) => getEmptyDraftListWidget(),
                              ),
                          onForSaleList: (context) => BuildGridView(
                                nftsList: viewModel.nftForSaleList,
                                onEmptyList: (context) => getEmptyWidgetForSale(),
                              ),
                          onPublishedList: (context) => BuildGridView(
                                nftsList: viewModel.nftPublishedList,
                                onEmptyList: (context) => getEmptyPublishedWidget(),
                              ),
                          collectionType: viewModel.selectedCollectionType),
                      onListSelected: (context) => BuildNFTsContent(
                          onDraftList: (context) => BuildListView(
                                nftsList: viewModel.nftDraftList,
                                onEmptyList: (context) => getEmptyDraftListWidget(),
                              ),
                          onForSaleList: (context) => BuildListView(
                                nftsList: viewModel.nftForSaleList,
                                onEmptyList: (context) => getEmptyWidgetForSale(),
                              ),
                          onPublishedList: (context) => BuildListView(
                                key: ValueKey(viewModel.nftPublishedList.length),
                                nftsList: viewModel.nftPublishedList,
                                onEmptyList: (context) => getEmptyPublishedWidget(),
                              ),
                          collectionType: viewModel.selectedCollectionType),
                      viewType: viewModel.viewType,
                    ),

                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Widget getEmptyWidgetForSale() {
    return Text(
      "no_for_sale_nft".tr(),
      style: TextStyle(fontWeight: FontWeight.w700, color: EaselAppTheme.kLightGrey, fontSize: isTablet ? 12.sp : 15.sp),
    );
  }

  Widget getEmptyPublishedWidget() {
    return Text(
      "no_published_nft".tr(),
      style: TextStyle(fontWeight: FontWeight.w700, color: EaselAppTheme.kLightGrey, fontSize: isTablet ? 12.sp : 15.sp),
    );
  }

  Widget getEmptyDraftListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "no_nft_created".tr(),
          style: TextStyle(fontWeight: FontWeight.w700, color: EaselAppTheme.kLightGrey, fontSize: isTablet ? 12.sp : 15.sp),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: ClippedButton(
            title: "create_draft".tr(),
            bgColor: EaselAppTheme.kBlue,
            textColor: EaselAppTheme.kWhite,
            onPressed: () {
              Navigator.of(context).pushNamed(RouteUtil.kRouteHome);
            },
            cuttingHeight: 15.h,
            clipperType: ClipperType.bottomLeftTopRight,
            isShadow: false,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget buildOutlinedBox({required String title, required CreatorHubViewModel viewModel, required CollectionType collectionType}) {
    return Expanded(
      child: InkWell(
        onTap: () => viewModel.changeSelectedCollection(collectionType),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(title, style: subTextStyle.copyWith(color: EaselAppTheme.kBlack)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectedBox({required String title, required CreatorHubViewModel viewModel, required Color color, required CollectionType collectionType}) {
    return Expanded(
      child: InkWell(
        onTap: () => viewModel.changeSelectedCollection(collectionType),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 2.sp, color: color), color: color),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(title, style: subTextStyle.copyWith(color: EaselAppTheme.kWhite)),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildNFTsContent extends StatelessWidget {
  final WidgetBuilder onDraftList;
  final WidgetBuilder onPublishedList;
  final WidgetBuilder onForSaleList;
  final CollectionType collectionType;

  const BuildNFTsContent({
    Key? key,
    required this.onDraftList,
    required this.onForSaleList,
    required this.onPublishedList,
    required this.collectionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (collectionType) {
      case CollectionType.draft:
        return onDraftList(context);

      case CollectionType.published:
        return onPublishedList(context);

      case CollectionType.forSale:
        return onForSaleList(context);
    }
  }
}

class NFTsViewBuilder extends StatelessWidget {
  final WidgetBuilder onGridSelected;
  final WidgetBuilder onListSelected;
  final ViewType viewType;

  const NFTsViewBuilder({
    Key? key,
    required this.onGridSelected,
    required this.onListSelected,
    required this.viewType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewType) {
      case ViewType.viewGrid:
        return onGridSelected(context);
      case ViewType.viewList:
        return onListSelected(context);
    }
  }
}

class BuildGridView extends StatelessWidget {
  final List<NFT> nftsList;
  final WidgetBuilder onEmptyList;

  const BuildGridView({Key? key, required this.nftsList, required this.onEmptyList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (nftsList.isEmpty) {
      return onEmptyList(context);
    }
    return GridView.builder(
        itemCount: nftsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.5,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final nft = nftsList[index];
          return NftGridViewItem(nft: nft);
        });
  }
}

class BuildListView extends StatelessWidget {
  final List<NFT> nftsList;
  final WidgetBuilder onEmptyList;

  const BuildListView({Key? key, required this.nftsList, required this.onEmptyList}) : super(key: key);

  CreatorHubViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    if (nftsList.isEmpty) {
      return onEmptyList(context);
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: nftsList.length,
        itemBuilder: (context, index) {
          final nft = nftsList[index];
          return viewModel.selectedCollectionType == CollectionType.draft ? DraftListTile(nft: nft, viewModel: viewModel) : NFTsListTile(publishedNFT: nft);
        });
  }
}
