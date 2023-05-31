import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/gen/assets.gen.dart';
import 'package:pylons_wallet/pages/home/collection_screen/preview_nft_grid.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../components/pylons_app_theme.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../providers/collections_tab_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/image_util.dart';
import '../../../detailed_asset_view/widgets/nft_3d_asset.dart';
import '../../../detailed_asset_view/widgets/pdf_placeholder.dart';
import '../../../detailed_asset_view/widgets/video_placeholder.dart';
import '../collection_screen.dart';
import '../collection_view_model.dart';

class PurchasesCollection extends StatelessWidget {
  final OnNFTSelected onNFTSelected;

  const PurchasesCollection({super.key, required this.onNFTSelected});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.kMainBG,
      ),
      child: Column(
        children: [
          SheetHeading(
            leadingSVG: Assets.images.svg.purchases,
            title: LocaleKeys.my_purchase.tr(),
            collectionType: CollectionsType.purchases,
          ),
          SizedBox(
            height: 15.h,
          ),
          if (viewModel.collectionsType == CollectionsType.purchases)
            Expanded(
              child: GridView.custom(
                padding: EdgeInsets.only(
                  bottom: 16.h,
                  left: 16.w,
                  right: 16.w,
                ),
                gridDelegate: gridDelegate,
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final nft = viewModel.assets[index];
                    return PurchaseCollectionItem(
                      assetType: nft.assetType,
                      onPressed: () => onNFTSelected(nft),
                      name: nft.name,
                      thumbnailUrl: nft.thumbnailUrl,
                      url: nft.url,
                    );
                  },
                  childCount: viewModel.assets.length,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class PurchaseCollectionItem extends StatelessWidget {
  final VoidCallback onPressed;
  final AssetType assetType;
  final String url;
  final String thumbnailUrl;
  final String name;
  const PurchaseCollectionItem({
    super.key,
    required this.onPressed,
    required this.assetType,
    required this.url,
    required this.thumbnailUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        child: PreviewNFTGrid(
          assetType: assetType,
          on3dNFT: (BuildContext context) => Container(
            color: AppColors.k3DBackgroundColor,
            height: double.infinity,
            child: IgnorePointer(
              child: Nft3dWidget(
                url: url,
                cameraControls: false,
                backgroundColor: AppColors.k3DBackgroundColor,
              ),
            ),
          ),
          onPdfNFT: (BuildContext context) => PdfPlaceHolder(
            nftUrl: url,
            nftName: name,
            thumbnailUrl: thumbnailUrl,
          ),
          onVideoNFT: (BuildContext context) => VideoPlaceHolder(
            nftUrl: url,
            nftName: name,
            thumbnailUrl: thumbnailUrl,
          ),
          onImageNFT: (BuildContext context) => CachedNetworkImage(
            placeholder: (context, url) => Shimmer(
              color: PylonsAppTheme.cardBackground,
              child: const SizedBox.expand(),
            ),
            imageUrl: url,
            fit: BoxFit.cover,
          ),
          onAudioNFT: (BuildContext context) => _getAudioPlaceHolder(
            thumbnailUrl: thumbnailUrl,
          ),
        ),
      ),
    );
  }

  Widget _getAudioPlaceHolder({required String thumbnailUrl}) {
    return thumbnailUrl.isEmpty
        ? Image.asset(ImageUtil.AUDIO_BACKGROUND, fit: BoxFit.cover)
        : _getAudioThumbnailFromUrl(thumbnailUrl: thumbnailUrl);
  }

  Widget _getAudioThumbnailFromUrl({required String thumbnailUrl}) {
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
}
