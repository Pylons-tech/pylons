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
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../generated/locale_keys.g.dart';

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
    super.initState();

    scheduleMicrotask(() {
      easelProvider.populateUserName();
      creatorHubViewModel.getPublishAndDraftData();
    });

    easelProvider.setLog(screenName: AnalyticsScreenEvents.createrHubScreen);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
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
              child: const CreatorHubContent(),
            ),
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
  TextStyle subTextStyle = TextStyle(
    color: EaselAppTheme.kWhite,
    fontWeight: FontWeight.w700,
    fontFamily: kUniversalFontFamily,
    fontSize: isTablet ? 9.sp : 11.sp,
  );

  EaselProvider get easelProvider => sl();

  Future<void> onRefreshPressed() async {
    GetIt.I.get<CreatorHubViewModel>().getDraftsList();
    GetIt.I.get<CreatorHubViewModel>().getRecipesList();
    GetIt.I.get<CreatorHubViewModel>().getTotalForSale();
  }

  Widget getRefreshButton(CreatorHubViewModel viewModel) {
    final shouldShowRefreshButton = easelProvider.isPylonsInstalled &&
        viewModel.selectedCollectionType == CollectionType.published &&
        viewModel.nftPublishedList.isNotEmpty;
    if (shouldShowRefreshButton) {
      return Padding(
        key: const Key(kRefreshPublishedNFTButtonKey),
        padding: EdgeInsets.only(right: 15.w),
        child: InkWell(
          onTap: () => scheduleMicrotask(() => onRefreshPressed()),
          child: Icon(
            Icons.refresh,
            color: EaselAppTheme.kBlack,
            size: 22.sp,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreatorHubViewModel>();
    return ColoredBox(
      color: EaselAppTheme.kWhite,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: EaselAppTheme.kBgWhite,
          body: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      getRefreshButton(viewModel),
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(RouteUtil.kRouteHome),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: EaselAppTheme.kpurpleDark,
                            boxShadow: [BoxShadow(color: EaselAppTheme.kpurpleDark.withOpacity(0.6), blurRadius: 8.0)],
                          ),
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
                  child: getTitleWidget(
                    isDraftCreated: viewModel.nftDraftList.isNotEmpty || viewModel.nftPublishedList.isNotEmpty,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: getDescriptionWidget(
                    isDraftCreated: viewModel.nftDraftList.isNotEmpty || viewModel.nftPublishedList.isNotEmpty,
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      if (viewModel.selectedCollectionType == CollectionType.draft)
                        buildSelectedBox(
                          key: kSelectedDraftButtonKey,
                          title: LocaleKeys.draft.tr(),
                          viewModel: viewModel,
                          color: EaselAppTheme.kLightRed,
                          collectionType: CollectionType.draft,
                        )
                      else
                        buildOutlinedBox(
                          title: LocaleKeys.draft.tr(),
                          viewModel: viewModel,
                          collectionType: CollectionType.draft,
                        ),
                      SizedBox(width: 14.w),
                      if (viewModel.selectedCollectionType == CollectionType.published)
                        buildSelectedBox(
                          key: kSelectedPublishedButtonKey,
                          title: LocaleKeys.published.tr(),
                          viewModel: viewModel,
                          color: EaselAppTheme.kDarkGreen,
                          collectionType: CollectionType.published,
                        )
                      else
                        buildOutlinedBox(
                          title: LocaleKeys.published.tr(),
                          viewModel: viewModel,
                          collectionType: CollectionType.published,
                        ),
                      const Expanded(child: SizedBox()),
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
                SizedBox(height: 32.h),
                Expanded(
                  child: NFTsViewBuilder(
                    onGridSelected: (context) => BuildNFTsContent(
                        onDraftList: (context) => BuildGridView(
                              nftsList: viewModel.nftDraftList,
                              onEmptyList: (context) => getDraftPublishListEmptyWidget(isForDraft: true),
                            ),
                        onPublishedList: (context) => BuildGridView(
                              nftsList: viewModel.nftPublishedList,
                              onEmptyList: (context) => getDraftPublishListEmptyWidget(isForDraft: false),
                            ),
                        collectionType: viewModel.selectedCollectionType),
                    onListSelected: (context) => BuildNFTsContent(
                        onDraftList: (context) => BuildListView(
                              nftsList: viewModel.nftDraftList,
                              onEmptyList: (context) => getDraftPublishListEmptyWidget(isForDraft: true),
                            ),
                        onPublishedList: (context) => BuildListView(
                              key: ValueKey(viewModel.nftPublishedList.length),
                              nftsList: viewModel.nftPublishedList,
                              onEmptyList: (context) => getDraftPublishListEmptyWidget(isForDraft: false),
                            ),
                        collectionType: viewModel.selectedCollectionType),
                    viewType: viewModel.viewType,
                  ),
                ),
                if (viewModel.selectedCollectionType == CollectionType.draft ||
                    (viewModel.selectedCollectionType == CollectionType.published &&
                        viewModel.nftPublishedList.isEmpty))
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: getCreateNFTWidget(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitleWidget({required bool isDraftCreated}) {
    if (isDraftCreated) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: LocaleKeys.hello.tr(),
              style: titleStyle.copyWith(
                color: EaselAppTheme.kTextGrey,
                fontSize: isTablet ? 16.sp : 18.sp,
              ),
            ),
            TextSpan(
              text: easelProvider.currentUsername,
              style: titleStyle,
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          LocaleKeys.creator_hub.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: EaselAppTheme.kBlack,
            fontSize: isTablet ? 17.sp : 20.sp,
            fontFamily: kUniversalFontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  Widget getDescriptionWidget({required bool isDraftCreated}) {
    if (isDraftCreated) {
      return AutoSizeText(
        LocaleKeys.welcome_msg.tr(),
        textAlign: TextAlign.start,
        maxLines: 4,
        style: titleStyle.copyWith(
          fontSize: isTablet ? 9.sp : 12.sp,
        ),
      );
    } else {
      return AutoSizeText(
        LocaleKeys.first_welcome_msg.tr(),
        textAlign: TextAlign.start,
        maxLines: 6,
        style: titleStyle.copyWith(
          fontSize: isTablet ? 9.sp : 11.sp,
          color: EaselAppTheme.kTextGrey,
        ),
      );
    }
  }

  Color getButtonColor({required bool isSelected}) {
    if (isSelected) {
      return EaselAppTheme.kBlack;
    } else {
      return EaselAppTheme.kGreyIcon;
    }
  }

  Widget getDraftPublishListEmptyWidget({required bool isForDraft}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isForDraft ? LocaleKeys.no_nft_created.tr() : LocaleKeys.no_published_nft.tr(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: EaselAppTheme.kLightGrey,
              fontSize: isTablet ? 12.sp : 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget getCreateNFTWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: ClippedButton(
        title: LocaleKeys.create_draft.tr(),
        bgColor: EaselAppTheme.kBlue,
        textColor: EaselAppTheme.kWhite,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteUtil.kRouteHome);
        },
        cuttingHeight: 15.h,
        clipperType: ClipperType.bottomLeftTopRight,
        isShadow: false,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }

  Widget buildOutlinedBox({
    required String title,
    required CreatorHubViewModel viewModel,
    required CollectionType collectionType,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => viewModel.changeSelectedCollection(collectionType),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 1.7.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(
                title,
                style: subTextStyle.copyWith(color: EaselAppTheme.kBlack, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectedBox(
      {required String key,
      required String title,
      required CreatorHubViewModel viewModel,
      required Color color,
      required CollectionType collectionType}) {
    return Expanded(
      child: InkWell(
        onTap: () => viewModel.changeSelectedCollection(collectionType),
        child: DecoratedBox(
          key: Key(key),
          decoration: BoxDecoration(
            border: Border.all(width: 2.sp, color: color),
            color: color,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(
                title,
                style: subTextStyle.copyWith(
                  color: EaselAppTheme.kWhite,
                ),
              ),
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
  final CollectionType collectionType;

  const BuildNFTsContent({
    Key? key,
    required this.onDraftList,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        itemCount: nftsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.5,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final nft = nftsList[index];
          if (nft.price.isNotEmpty && double.parse(nft.price) > 0) {
            return ClipRRect(
              child: Banner(
                key: const Key(kPriceBannerKey),
                color: EaselAppTheme.kDarkGreen,
                location: BannerLocation.topEnd,
                message: "${nft.ibcCoins.getCoinWithProperDenomination(nft.price)} ${nft.ibcCoins.getAbbrev()}",
                child: NftGridViewItem(
                  nft: nft,
                ),
              ),
            );
          } else {
            return NftGridViewItem(
              nft: nft,
            );
          }
        },
      ),
    );
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
        if (viewModel.selectedCollectionType == CollectionType.draft) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: DraftListTile(nft: nftsList[index], viewModel: viewModel),
          );
        } else {
          return NFTsListTile(publishedNFT: nftsList[index]);
        }
      },
    );
  }
}
