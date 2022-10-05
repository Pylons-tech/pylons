import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/pdf_placeholder.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/video_placeholder.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/collection_screen/preview_nft_grid.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/home/easel_section/no_easel_art_work.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
    final viewModel = context.watch<CollectionViewModel>();

    final purchasesCollection = PurchasesCollection(
      onNFTSelected: (NFT asset) {
        shouldShowOwnerViewOrPurchaseViewForNFT(asset);
      },
    );
    final creationsCollection = CreationsCollection(
      onNFTSelected: (NFT asset) {
        shouldShowOwnerViewOrPurchaseViewForNFT(asset);
      },
    );

    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: viewModel.collectionsType == CollectionsType.purchases ? creationsCollection : purchasesCollection,
            )),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 50.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: viewModel.collectionsType == CollectionsType.purchases ? purchasesCollection : creationsCollection,
            )),
      ],
    );
  }

  void shouldShowOwnerViewOrPurchaseViewForNFT(NFT asset) {
    final walletsStore = GetIt.I.get<WalletsStore>();
    if (asset.type == NftType.TYPE_RECIPE) {
      onRecipeClicked(asset);
    } else {
      Navigator.of(context).pushNamed(RouteUtil.ROUTE_OWNER_VIEW, arguments: asset).then((_) => {walletsStore.setStateUpdatedFlag(flag: true)});
    }
  }

  Future<void> onRecipeClicked(NFT asset) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final loader = Loading()..showLoading();

    await asset.getOwnerAddress();

    loader.dismiss();
    Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_OWNER_VIEW, arguments: asset).then((_) => {walletsStore.setStateUpdatedFlag(flag: true)});
  }
}

class PurchasesCollection extends StatelessWidget {
  final OnNFTSelected onNFTSelected;

  const PurchasesCollection({Key? key, required this.onNFTSelected}) : super(key: key);

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
                fit: BoxFit.cover)),
        Align(
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(color: AppColors.kWhite.withOpacity(0.5), shape: BoxShape.circle),
            child: Image.asset(
              ImageUtil.AUDIO_ICON,
              width: 35.w,
              height: 35.h,
              color: AppColors.kBlack.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget getAudioPlaceHolder({required String thumbnailUrl}) {
    return thumbnailUrl.isEmpty ? Image.asset(ImageUtil.AUDIO_BACKGROUND, fit: BoxFit.cover) : getAudioThumbnailFromUrl(thumbnailUrl: thumbnailUrl);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();
    final isSelected = viewModel.collectionsType == CollectionsType.purchases;
    return DecoratedBox(
      decoration:  BoxDecoration(
        color: AppColors.kMainBG,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              viewModel.collectionsType = CollectionsType.purchases;
            },
            child: SizedBox(
              height: 40.h,
              child: Stack(
                children: [
                  if (isSelected)
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
                        )),
                  if (isSelected)
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
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_PURCHASES,
                              height: 25.h,
                            )),
                        Expanded(
                            flex: 8,
                            child: Text(
                              "my_purchase".tr(),
                              style: kWalletTitle,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: GridView.custom(
              padding: EdgeInsets.only(
                bottom: 16.w,
                left: 16.w,
                right: 16.w,
              ),
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: const [
                  QuiltedGridTile(4, 4),
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(2, 2),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                final nft = viewModel.purchases[index];
                return GestureDetector(
                  onTap: () =>  onNFTSelected(nft),
                  child: ClipRRect(
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
                      onPdfNFT: (BuildContext context) => PdfPlaceHolder(nftUrl: nft.url, nftName: nft.name, thumbnailUrl: nft.thumbnailUrl),
                      onVideoNFT: (BuildContext context) => VideoPlaceHolder(nftUrl: nft.url, nftName: nft.name, thumbnailUrl: nft.thumbnailUrl),
                      onImageNFT: (BuildContext context) =>
                          CachedNetworkImage(placeholder: (context, url) => Shimmer(color: PylonsAppTheme.cardBackground, child: const SizedBox.expand()), imageUrl: nft.url, fit: BoxFit.cover),
                      onAudioNFT: (BuildContext context) => getAudioPlaceHolder(thumbnailUrl: nft.thumbnailUrl),
                    ),
                  ),
                );
              }, childCount: viewModel.purchases.length),
            ),
          )
        ],
      ),
    );
  }
}

class CreationsCollection extends StatelessWidget {
  final OnNFTSelected onNFTSelected;

  const CreationsCollection({Key? key, required this.onNFTSelected}) : super(key: key);

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
                fit: BoxFit.cover)),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();

    final isSelected = viewModel.collectionsType == CollectionsType.creations;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.kMainBG,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              viewModel.collectionsType = CollectionsType.creations;
            },
            child: SizedBox(
              height: 40.h,
              child: Stack(
                children: [
                  if (isSelected)
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
                        )),
                  if (isSelected)
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
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              SVGUtil.MY_CREATIONS,
                              height: 20.h,
                            )),
                        Expanded(
                            flex: 8,
                            child: Text(
                              'my_creations'.tr(),
                              style: kWalletTitle,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
              child: viewModel.creations.isNotEmpty
                  ? GridView.custom(
                      padding: EdgeInsets.only(
                        bottom: 16.w,
                        left: 16.w,
                        right: 16.w,
                      ),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 6,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: const [
                          QuiltedGridTile(4, 4),
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(2, 2),
                        ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final nft = viewModel.creations[index];

                          return ClipRRect(
                            child: GestureDetector(
                              onTap: () => onNFTSelected(nft),
                              child: Banner(
                                color: AppColors.kPriceTagColor,
                                location: BannerLocation.topStart,
                                message: "${nft.ibcCoins.getCoinWithProperDenomination(nft.price)}  ${nft.ibcCoins.getAbbrev()}",
                                child: PreviewNFTGrid(
                                  assetType: nft.assetType,
                                  on3dNFT: (BuildContext context) => Container(
                                    color: Colors.grey.shade200,
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
                                  ),
                                  onVideoNFT: (BuildContext context) => VideoPlaceHolder(
                                    nftUrl: nft.url,
                                    nftName: nft.name,
                                    thumbnailUrl: nft.thumbnailUrl,
                                  ),
                                  onImageNFT: (BuildContext context) => CachedNetworkImage(
                                    placeholder: (context, url) => Shimmer(color: PylonsAppTheme.cardBackground, child: const SizedBox.expand()),
                                    imageUrl: nft.url,
                                    fit: BoxFit.cover,
                                  ),
                                  onAudioNFT: (BuildContext context) => getAudioPlaceHolder(thumbnailUrl: nft.thumbnailUrl),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: viewModel.creations.length,
                      ),
                    )
                  : const Center(child: NoEaselArtWork()))
        ],
      ),
    );
  }
}
