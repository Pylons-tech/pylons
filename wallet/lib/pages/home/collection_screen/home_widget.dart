import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



import '../../../components/pylons_app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/route_util.dart';
import '../../detailed_asset_view/widgets/nft_3d_asset.dart';
import '../../detailed_asset_view/widgets/pdf_placeholder.dart';
import '../../detailed_asset_view/widgets/video_placeholder.dart';
import 'collection_view_model.dart';

import 'preview_nft_grid.dart';



class WidgetNFTPickerScreen extends StatefulWidget {
  const WidgetNFTPickerScreen({Key? key}) : super(key: key);

  @override
  State<WidgetNFTPickerScreen> createState() => _WidgetNFTPickerScreenState();
}

class _WidgetNFTPickerScreenState extends State<WidgetNFTPickerScreen> {
  late String imagePicked;
  bool isSelected = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

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
                fit: BoxFit.cover)),
        Align(
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(color: kWhite.withOpacity(0.5), shape: BoxShape.circle),
            child: Image.asset(
              ImageUtil.AUDIO_ICON,
              width: 35.w,
              height: 35.h,
              color: kBlack.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget getAudioPlaceHolder({required String thumbnailUrl}) {
    return thumbnailUrl.isEmpty ? Image.asset(ImageUtil.AUDIO_BACKGROUND, fit: BoxFit.cover) : getAudioThumbnailFromUrl(thumbnailUrl: thumbnailUrl);
  }

  Future<void> _updateWidget() async {
    try {
      HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionViewModel = GetIt.I.get<CollectionViewModel>();
    return
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: kMainBG,
        body:
        ChangeNotifierProvider.value(
        value: collectionViewModel,
        builder: (context, child)
    {
      return Consumer<CollectionViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                SizedBox(height: 60.h),
                Text("pick_nft".tr(), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 20.h),
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

                      if (isSelected) {
                        isSelected = false;
                        return GestureDetector(
                          onTap: () async {
                            imagePicked = nft.url;
                            isSelected = true;
                            setState(() {});
                          },

                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 5.r),
                            ),
                            child: ClipRRect(
                              child:
                              PreviewNFTGrid(
                                assetType: nft.assetType,
                                on3dNFT: (BuildContext context) =>
                                    Container(
                                      color: k3DBackgroundColor,
                                      height: double.infinity,
                                      child: IgnorePointer(
                                        child: Nft3dWidget(
                                          url: nft.url,
                                          cameraControls: false,
                                          backgroundColor: k3DBackgroundColor,
                                        ),
                                      ),
                                    ),
                                onPdfNFT: (BuildContext context) =>
                                    PdfPlaceHolder(nftUrl: nft.url,
                                        nftName: nft.name,
                                        thumbnailUrl: nft.thumbnailUrl),
                                onVideoNFT: (BuildContext context) =>
                                    VideoPlaceHolder(nftUrl: nft.url,
                                        nftName: nft.name,
                                        thumbnailUrl: nft.thumbnailUrl),
                                onImageNFT: (BuildContext context) =>
                                    CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Shimmer(color: PylonsAppTheme
                                                .cardBackground,
                                                child: const SizedBox.expand()),
                                        imageUrl: nft.url,
                                        fit: BoxFit.cover),
                                onAudioNFT: (BuildContext context) =>
                                    getAudioPlaceHolder(
                                        thumbnailUrl: nft.thumbnailUrl),
                              ),
                            ),
                          ),

                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            imagePicked = nft.url;
                            isSelected = true;
                            setState(() {});
                          },

                          child: ClipRRect(
                              child:
                              PreviewNFTGrid(
                                assetType: nft.assetType,
                                on3dNFT: (BuildContext context) =>
                                    Container(
                                      color: k3DBackgroundColor,
                                      height: double.infinity,
                                      child: IgnorePointer(
                                        child: Nft3dWidget(
                                          url: nft.url,
                                          cameraControls: false,
                                          backgroundColor: k3DBackgroundColor,
                                        ),
                                      ),
                                    ),
                                onPdfNFT: (BuildContext context) =>
                                    PdfPlaceHolder(nftUrl: nft.url,
                                        nftName: nft.name,
                                        thumbnailUrl: nft.thumbnailUrl),
                                onVideoNFT: (BuildContext context) =>
                                    VideoPlaceHolder(nftUrl: nft.url,
                                        nftName: nft.name,
                                        thumbnailUrl: nft.thumbnailUrl),
                                onImageNFT: (BuildContext context) =>
                                    CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Shimmer(color: PylonsAppTheme
                                                .cardBackground,
                                                child: const SizedBox.expand()),
                                        imageUrl: nft.url,
                                        fit: BoxFit.cover),
                                onAudioNFT: (BuildContext context) =>
                                    getAudioPlaceHolder(
                                        thumbnailUrl: nft.thumbnailUrl),
                              ),
                            ),
                        );
                      }


                    }, childCount: viewModel.purchases.length),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: ClipPath(
                    clipper: PylonButtonClipper(),
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pushNamed(RouteUtil.ROUTE_HOME);
                        await HomeWidget.saveWidgetData<String>('image', imagePicked);
                        _updateWidget();
                      },
                      child: Container(
                        width: 180.w,
                        height: 40.h,
                        color: kDarkRed,
                        child: Center(
                          child: Text(
                            "update_widget".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kWhite, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            );
          }
      );
    }
    ),
    ),
    );
  }
}

class PylonButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width - 18, size.height);
    path.lineTo(size.width, size.height - 18);
    path.lineTo(size.width, 0);
    path.lineTo(18, 0);
    path.lineTo(0, 18);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
