import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:video_player/video_player.dart';

class PurchaseVideoPlayerScreen extends StatefulWidget {
  final NFT nft;

  const PurchaseVideoPlayerScreen({Key? key, required this.nft})
      : super(key: key);

  @override
  State<PurchaseVideoPlayerScreen> createState() =>
      _PurchaseVideoPlayerScreenState();
}

class _PurchaseVideoPlayerScreenState extends State<PurchaseVideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, PurchaseItemViewModel viewModel, child) {
      return ColoredBox(
        color: AppColors.kBlack,
        child: viewModel.isVideoLoading
            ?  Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhite),
                ),
              )
            : viewModel.videoLoadingError.isNotEmpty
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "video_player_network_error".tr(),
                      style: TextStyle(fontSize: 18.sp, color: AppColors.kWhite),
                    ),
                  ))
                : Center(
                    child: viewModel.videoPlayerController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: viewModel
                                .videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(viewModel.videoPlayerController),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhite),
                            ),
                          ),
                  ),
      );
    });
  }
}
