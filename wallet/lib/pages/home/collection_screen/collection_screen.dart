import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/pdf_placeholder.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/video_placeholder.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/collection_screen/preview_nft_grid.dart';
import 'package:pylons_wallet/pages/home/easel_section/no_easel_art_work.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../utils/favorites_change_notifier.dart';

typedef OnNFTSelected = void Function(NFT asset);

TextStyle kWalletTitle = TextStyle(fontSize: 15.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);

class Collection {
  final String icon;
  final String title;
  final String type; // cookbook | app
  final String app_name;

  Collection({
    required this.icon,
    required this.title,
    required this.type,
    this.app_name = "",
  });
}

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      context.read<CollectionViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionViewModel>(builder: (context, viewModel, child) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: BuildTitleTabsWidget(
                collectionViewModel: viewModel,
                tabNo: 1,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 50.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: BuildTitleTabsWidget(
                collectionViewModel: viewModel,
                tabNo: 2,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 100.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: BuildTitleTabsWidget(
                collectionViewModel: viewModel,
                tabNo: 3,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class BuildTitleTabsWidget extends StatelessWidget {
  final CollectionViewModel collectionViewModel;
  final int tabNo;

  const BuildTitleTabsWidget({Key? key, required this.collectionViewModel, required this.tabNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tabNo == 1) {
      if (collectionViewModel.collectionsType == CollectionsType.creations) {
        return const PurchasesCollection(key: Key("abc"));
      } else if (collectionViewModel.collectionsType == CollectionsType.purchases) {
        return const FavoritesCollection();
      } else {
        return const CreationsCollection();
      }
    } else if (tabNo == 2) {
      if (collectionViewModel.collectionsType == CollectionsType.creations) {
        return const FavoritesCollection();
      } else if (collectionViewModel.collectionsType == CollectionsType.purchases) {
        return const CreationsCollection();
      } else {
        return const PurchasesCollection(key: Key("abc"));
      }
    } else if (tabNo == 3) {
      if (collectionViewModel.collectionsType == CollectionsType.creations) {
        return const CreationsCollection();
      } else if (collectionViewModel.collectionsType == CollectionsType.purchases) {
        return const PurchasesCollection(key: Key("abc"));
      } else {
        return const FavoritesCollection();
      }
    } else {
      return const SizedBox();
    }
  }
}

class PurchasesCollection extends StatelessWidget {
  const PurchasesCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.kTransparentColor,
      ),
      child: Column(
        children: [
          InkWell(
            key: const Key(kPurchasesTabButtonKey),
            onTap: () {
              viewModel.collectionsType = CollectionsType.purchases;
            },
            child: SizedBox(
              height: 40.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 3,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          BoxShadow(color: AppColors.kMainBG, offset: Offset(0, 30.r)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: SvgPicture.asset(
                      SVGUtil.COLLECTION_BACKGROUND,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_PURCHASES,
                              height: 25.h,
                              color: getSelectedTabColor(isSelected: viewModel.collectionsType == CollectionsType.purchases),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              LocaleKeys.my_purchase.tr(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: kUniversalFontFamily,
                                color: getSelectedTabColor(isSelected: viewModel.collectionsType == CollectionsType.purchases),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          if (viewModel.collectionsType == CollectionsType.purchases)
            Expanded(
              child: NFTsGridViewWidget(
                nftList: viewModel.purchases,
              ),
            )
          else
            Expanded(
              child: ColoredBox(
                color: AppColors.kMainBG,
              ),
            )
        ],
      ),
    );
  }
}

class CreationsCollection extends StatelessWidget {
  const CreationsCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.kTransparentColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            key: const Key(kCreationTabButtonKey),
            onTap: () {
              viewModel.collectionsType = CollectionsType.creations;
            },
            child: SizedBox(
              height: 40.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 3,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          BoxShadow(color: AppColors.kMainBG, offset: Offset(0, 30.r)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: SvgPicture.asset(
                      SVGUtil.COLLECTION_BACKGROUND,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_CREATIONS,
                              height: 20.h,
                              color: getSelectedTabColor(isSelected: viewModel.collectionsType == CollectionsType.creations),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              LocaleKeys.my_creations.tr(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: kUniversalFontFamily,
                                color: getSelectedTabColor(isSelected: viewModel.collectionsType == CollectionsType.creations),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          if (viewModel.collectionsType == CollectionsType.creations)
            Expanded(
              child: viewModel.creations.isNotEmpty
                  ? NFTsGridViewWidget(
                      nftList: viewModel.creations,
                    )
                  : const NoEaselArtWork(),
            )
        ],
      ),
    );
  }
}

class FavoritesCollection extends StatelessWidget {
  const FavoritesCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.kTransparentColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            key: const Key(kFavoritesTabButtonKey),
            onTap: () {
              viewModel.collectionsType = CollectionsType.favorites;
            },
            child: SizedBox(
              height: 40.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 3,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          BoxShadow(color: AppColors.kMainBG, offset: Offset(0, 30.r)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: SvgPicture.asset(
                      SVGUtil.COLLECTION_BACKGROUND,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_FAVORITES,
                              height: 20.h,
                              color: getSelectedTabColor(isSelected: viewModel.collectionsType == CollectionsType.favorites),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              LocaleKeys.favorites.tr(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: kUniversalFontFamily,
                                color: getSelectedTabColor(isSelected: viewModel.collectionsType == CollectionsType.favorites),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          if (viewModel.collectionsType == CollectionsType.favorites)
            Expanded(
              child: ChangeNotifierProvider.value(
                value: viewModel.favoritesChangeNotifier,
                builder: (context, widget) {
                  return Consumer<FavoritesChangeNotifier>(
                    builder: (context, favoritesChangeNotifier, widget) {
                      return NFTsGridViewWidget(
                        nftList: favoritesChangeNotifier.favorites,
                        isListFavorite: true,
                      );
                    },
                  );
                },
              ),
            )
          else
            Expanded(
              child: ColoredBox(
                color: AppColors.kMainBG,
              ),
            )
        ],
      ),
    );
  }
}

class NFTsGridViewWidget extends StatelessWidget {
  final List<NFT> nftList;
  final bool isListFavorite;

  const NFTsGridViewWidget({Key? key, required this.nftList, this.isListFavorite = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.kMainBG,
      child: GridView.custom(
        key: const Key(kCollectionGridViewKey),
        padding: EdgeInsets.only(
          bottom: 16.h,
          left: 16.w,
          right: 16.w,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            return NFTWidget(
              nft: nftList[index],
              isListFavorite: isListFavorite,
            );
          },
          childCount: nftList.length,
        ),
      ),
    );
  }
}

class NFTWidget extends StatelessWidget {
  final NFT nft;
  final bool isListFavorite;

  const NFTWidget({Key? key, required this.nft, required this.isListFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collectionViewModel = context.watch<CollectionViewModel>();
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () => collectionViewModel.shouldShowOwnerViewOrPurchaseViewForNFT(asset: nft, context: context),
          child: PreviewNFTGrid(
            assetType: nft.assetType,
            on3dNFT: (BuildContext context) => Container(
              color: AppColors.k3DBackgroundColor,
              height: double.infinity,
              child: IgnorePointer(
                child: Nft3dWidget(
                  url: nft.url,
                  cameraControls: false,
                  backgroundColor: AppColors.k3DBackgroundColor,
                ),
              ),
            ),
            onPdfNFT: (BuildContext context) => PdfPlaceHolder(
              nftUrl: nft.url,
              nftName: nft.name,
              thumbnailUrl: nft.thumbnailUrl,
              showIcon: false,
            ),
            onVideoNFT: (BuildContext context) => VideoPlaceHolder(
              nftUrl: nft.url,
              nftName: nft.name,
              thumbnailUrl: nft.thumbnailUrl,
              showIcon: false,
            ),
            onImageNFT: (BuildContext context) => CachedNetworkImage(
              placeholder: (context, url) => Shimmer(color: PylonsAppTheme.cardBackground, child: const SizedBox.expand()),
              imageUrl: nft.url,
              fit: BoxFit.cover,
            ),
            onAudioNFT: (BuildContext context) => getAudioPlaceHolder(thumbnailUrl: nft.thumbnailUrl),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.zero,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black45, Colors.black38, Colors.black26, Colors.black12, AppColors.kTransparentColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.only(left: 5.w, top: 5.h),
              width: double.maxFinite,
              child: SvgPicture.asset(
                collectionViewModel.getNFTIcon(nft.assetType),
                color: Colors.white,
                width: 14.w,
                height: 14.h,
              ),
            ),
            Container(
              margin: EdgeInsets.zero,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.kTransparentColor, Colors.black12, Colors.black26, Colors.black38, Colors.black45],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
              width: double.maxFinite,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Visibility(
                      visible: !isListFavorite,
                      child: Text(
                        "${nft.name}  #${nft.amountMinted}",
                        style: TextStyle(fontSize: 7.sp, color: AppColors.kWhite),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isListFavorite,
                    child: Image.asset(
                      ImageUtil.LIKE_FULL,
                      height: 10.h,
                      color: AppColors.kDarkRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

Widget getAudioThumbnailFromUrl({required String thumbnailUrl}) {
  return Stack(
    children: [
      Positioned.fill(
        child: CachedNetworkImage(
          placeholder: (context, url) => Shimmer(
            color: PylonsAppTheme.cardBackground,
            child: const SizedBox.expand(),
          ),
          imageUrl: thumbnailUrl,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

Widget getAudioPlaceHolder({required String thumbnailUrl}) {
  return thumbnailUrl.isEmpty ? Image.asset(ImageUtil.AUDIO_BACKGROUND, fit: BoxFit.cover) : getAudioThumbnailFromUrl(thumbnailUrl: thumbnailUrl);
}

Color getSelectedTabColor({required bool isSelected}) {
  if (isSelected) {
    return AppColors.kDarkPurple;
  } else {
    return AppColors.kGreyColor;
  }
}
