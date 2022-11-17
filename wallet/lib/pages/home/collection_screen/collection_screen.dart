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
            left: 0.w,
            right: 0.w,
            bottom: 0.h,
            top: 0.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: getFirstTabTitleWidget(collectionViewModel: viewModel),
            ),
          ),
          Positioned(
            left: 0.w,
            right: 0.w,
            bottom: 0.h,
            top: 50.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: getSecondTabTitleWidget(collectionViewModel: viewModel),
            ),
          ),
          Positioned(
            left: 0.w,
            right: 0.w,
            bottom: 0.h,
            top: 100.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: getThirdTabTitleWidget(collectionViewModel: viewModel),
            ),
          ),
        ],
      );
    });
  }

  Widget getFirstTabTitleWidget({required CollectionViewModel collectionViewModel}){
    switch(collectionViewModel.collectionsType){
      case CollectionsType.purchases:
        return const CreationsCollection();
      case CollectionsType.creations:
        return const FavoritesCollection();
      default:
        return const PurchasesCollection();
    }
  }

  Widget getSecondTabTitleWidget({required CollectionViewModel collectionViewModel}){
    switch(collectionViewModel.collectionsType){
      case CollectionsType.purchases:
        return const FavoritesCollection();
      case CollectionsType.creations:
        return const PurchasesCollection();
      default:
        return const CreationsCollection();
    }
  }

  Widget getThirdTabTitleWidget({required CollectionViewModel collectionViewModel}){
    switch(collectionViewModel.collectionsType){
      case CollectionsType.purchases:
        return const PurchasesCollection();
      case CollectionsType.creations:
        return const CreationsCollection();
      default:
        return const FavoritesCollection();
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
      decoration: const BoxDecoration(
        color: Colors.transparent,
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
                    left: 0.w,
                    right: 0.w,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 3,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          BoxShadow(color: AppColors.kMainBG, offset: const Offset(0, 30)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0.w,
                    top: 0.h,
                    right: 0.w,
                    bottom: 0.h,
                    child: SvgPicture.asset(
                      SVGUtil.COLLECTION_BACKGROUND,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: 0.w,
                    right: 0.w,
                    top: 0.h,
                    bottom: 0.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.0.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_PURCHASES,
                              height: 25.h,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              LocaleKeys.my_purchase.tr(),
                              style: kWalletTitle,
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
              key: const Key(kPurchasesTabGridViewKey),
              child: getNFTsCollectionWidget(collectionViewModel: viewModel, nftList: viewModel.purchases),
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
      decoration: const BoxDecoration(
        color: Colors.transparent,
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
                    top: 0.h,
                    bottom: 0.h,
                    left: 0.w,
                    right: 0.w,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 3,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          BoxShadow(color: AppColors.kMainBG, offset: const Offset(0, 30)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0.w,
                    top: 0.h,
                    right: 0.w,
                    bottom: 0.h,
                    child: SvgPicture.asset(
                      SVGUtil.COLLECTION_BACKGROUND,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: 0.w,
                    right: 0.w,
                    top: 0.h,
                    bottom: 0.h,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_CREATIONS,
                              height: 20.h,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              LocaleKeys.my_creations.tr(),
                              style: kWalletTitle,
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
              key: const Key(kCreationTabGridViewKey),
              child: viewModel.creations.isNotEmpty ? getNFTsCollectionWidget(collectionViewModel: viewModel, nftList: viewModel.creations) : const NoEaselArtWork(),
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
      decoration: const BoxDecoration(
        color: Colors.transparent,
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
                    top: 0.h,
                    bottom: 0.h,
                    left: 0.w,
                    right: 0.w,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 3,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          BoxShadow(color: AppColors.kMainBG, offset: const Offset(0, 30)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0.w,
                    top: 0.h,
                    right: 0.w,
                    bottom: 0.h,
                    child: SvgPicture.asset(
                      SVGUtil.COLLECTION_BACKGROUND,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: 0.w,
                    right: 0.w,
                    top: 0.h,
                    bottom: 0.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.0.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_FAVORITES,
                              height: 20.h,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              LocaleKeys.favorites.tr(),
                              style: kWalletTitle,
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
              key: const Key(kFavoritesTabGridViewKey),
              child: getNFTsCollectionWidget(collectionViewModel: viewModel, nftList: viewModel.favorites, isListFavorite: true),
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

Widget getNFTsCollectionWidget({required CollectionViewModel collectionViewModel, required List<NFT> nftList, bool isListFavorite = false}) {
  return ColoredBox(
    color: AppColors.kMainBG,
    child: GridView.custom(
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
      childrenDelegate: SliverChildBuilderDelegate((context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => collectionViewModel.shouldShowOwnerViewOrPurchaseViewForNFT(asset: nftList[index], context: context),
              child: PreviewNFTGrid(
                assetType: nftList[index].assetType,
                on3dNFT: (BuildContext context) => Container(
                  color: AppColors.k3DBackgroundColor,
                  height: double.infinity,
                  child: IgnorePointer(
                    child: Nft3dWidget(
                      url: nftList[index].url,
                      cameraControls: false,
                      backgroundColor: AppColors.k3DBackgroundColor,
                    ),
                  ),
                ),
                onPdfNFT: (BuildContext context) => PdfPlaceHolder(
                  nftUrl: nftList[index].url,
                  nftName: nftList[index].name,
                  thumbnailUrl: nftList[index].thumbnailUrl,
                ),
                onVideoNFT: (BuildContext context) => VideoPlaceHolder(
                  nftUrl: nftList[index].url,
                  nftName: nftList[index].name,
                  thumbnailUrl: nftList[index].thumbnailUrl,
                ),
                onImageNFT: (BuildContext context) => CachedNetworkImage(
                  placeholder: (context, url) => Shimmer(color: PylonsAppTheme.cardBackground, child: const SizedBox.expand()),
                  imageUrl: nftList[index].url,
                  fit: BoxFit.cover,
                ),
                onAudioNFT: (BuildContext context) => getAudioPlaceHolder(thumbnailUrl: nftList[index].thumbnailUrl),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  alignment: Alignment.topLeft,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black45, Colors.black38, Colors.black26, Colors.black12, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5.w, top: 5.h),
                  width: double.maxFinite,
                  // height: 17.h,
                  child: SvgPicture.asset(
                    collectionViewModel.getNFTIcon(nftList[index].assetType),
                    color: Colors.white,
                    width: 14.w,
                    height: 14.h,
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  alignment: Alignment.topLeft,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black12, Colors.black26, Colors.black38, Colors.black45],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
                  width: double.maxFinite,
                  // height: 17.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: !isListFavorite,
                          child: Text(
                            "${nftList[index].name}  #${nftList[index].amountMinted}",
                            style: TextStyle(fontSize: 7.sp, color: AppColors.kWhite),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isListFavorite,
                        child: Image.asset(
                          'assets/images/icons/like_full.png',
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
      }, childCount: nftList.length),
    ),
  );
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
      Align(
        child: Container(
          width: 35.w,
          height: 35.h,
          decoration: BoxDecoration(color: AppColors.kWhite.withOpacity(0.5), shape: BoxShape.circle),
          padding: EdgeInsets.all(5.h),
          child: Image.asset(
            ImageUtil.AUDIO_ICON,
            color: AppColors.kBlack,
          ),
        ),
      ),
    ],
  );
}

Widget getAudioPlaceHolder({required String thumbnailUrl}) {
  return thumbnailUrl.isEmpty ? Image.asset(ImageUtil.AUDIO_BACKGROUND, fit: BoxFit.cover) : getAudioThumbnailFromUrl(thumbnailUrl: thumbnailUrl);
}
