import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:video_player/video_player.dart';

class OwnerVideoPlayerScreen extends StatefulWidget {
  final NFT nft;

  const OwnerVideoPlayerScreen({Key? key, required this.nft}) : super(key: key);

  @override
  State<OwnerVideoPlayerScreen> createState() => _OwnerVideoPlayerScreenState();
}

class _OwnerVideoPlayerScreenState extends State<OwnerVideoPlayerScreen> {
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
    return Consumer(
      builder: (context, OwnerViewViewModel viewModel, child) {
        return ColoredBox(
          color: AppColors.kBlack,
          child: viewModel.isVideoLoading || viewModel.videoPlayerController == null
              ? Center(
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
                      child: viewModel.videoPlayerController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: viewModel
                                  .videoPlayerController!.value.aspectRatio,
                              child:
                                  VideoPlayer(viewModel.videoPlayerController!),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(AppColors.kWhite),
                              ),
                            ),
                    ),
        );
      },
    );
  }
}
