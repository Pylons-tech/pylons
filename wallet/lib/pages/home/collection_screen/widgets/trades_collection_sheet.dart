import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/collection_screen/preview_nft_grid.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../components/pylons_app_theme.dart';
import '../../../../providers/collections_tab_provider.dart';
import '../../../../utils/image_util.dart';
import '../../../detailed_asset_view/widgets/nft_3d_asset.dart';
import '../../../detailed_asset_view/widgets/pdf_placeholder.dart';
import '../../../detailed_asset_view/widgets/video_placeholder.dart';
import '../collection_screen.dart';

class TradesCollection extends StatelessWidget {
  final OnNFTSelected onNFTSelected;

  const TradesCollection({Key? key, required this.onNFTSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.kMainBG,
      ),
      child: Column(
        children: [
          const SheetHeading(
            leadingSVG: "assets/images/svg/code.svg",
            title: "Trades",
            collectionType: CollectionsType.trades,
          ),
          SizedBox(
            height: 15.h,
          ),
          if (viewModel.collectionsType == CollectionsType.trades)
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
                    final nft = viewModel.trades[index];
                    return ClipRRect(
                      child: GestureDetector(
                        onTap: () => onNFTSelected(nft),
                        child: Banner(
                          color: AppColors.kPriceTagColor,
                          location: BannerLocation.topStart,
                          message:
                              "${nft.ibcCoins.getCoinWithProperDenomination(nft.price)}  ${nft.ibcCoins.getAbbrev()}",
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
                              placeholder: (context, url) => Shimmer(
                                color: PylonsAppTheme.cardBackground,
                                child: const SizedBox.expand(),
                              ),
                              imageUrl: nft.url,
                              fit: BoxFit.cover,
                            ),
                            onAudioNFT: (BuildContext context) => _getAudioPlaceHolder(
                              thumbnailUrl: nft.thumbnailUrl,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: viewModel.trades.length,
                ),
              ),
            )
        ],
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
