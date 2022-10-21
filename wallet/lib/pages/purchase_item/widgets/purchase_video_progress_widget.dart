import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:video_player/video_player.dart';

class PurchaseVideoProgressWidget extends StatefulWidget {
  final String url;

  const PurchaseVideoProgressWidget({Key? key, required this.url}) : super(key: key);

  @override
  _PurchaseVideoProgressWidgetState createState() => _PurchaseVideoProgressWidgetState();
}

class _PurchaseVideoProgressWidgetState extends State<PurchaseVideoProgressWidget> {
  String _getDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w, bottom: 10.h, top: 10.h, left: 5.w),
      child: Consumer<PurchaseItemViewModel>(builder: (context, viewModel, _) {
        return Column(
          children: [
            if (viewModel.videoLoadingError.isNotEmpty || viewModel.videoPlayerController == null)
              const SizedBox()
            else
              Row(
                children: [
                  if ( viewModel.isVideoLoading)
                    SizedBox(
                      height: 22.h,
                      width: 22.h,
                      child: CircularProgressIndicator(strokeWidth: 2.w, color: AppColors.kWhite),
                    )
                  else if (viewModel.videoPlayerController!.value.isPlaying)
                    InkWell(
                      onTap: viewModel.pauseVideo,
                      child: Icon(
                        Icons.pause,
                        color: AppColors.kWhite,
                        size: 21.h,
                      ),
                    )
                  else
                    InkWell(
                      onTap: viewModel.playVideo,
                      child: Icon(
                        Icons.play_arrow_outlined,
                        color: AppColors.kWhite,
                        size: 21.h,
                      ),
                    ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: VideoProgressIndicator(
                      viewModel.videoPlayerController!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        backgroundColor: AppColors.kGray,
                        playedColor: AppColors.kWhite,
                        bufferedColor: AppColors.kWhite.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            if (viewModel.videoLoadingError.isNotEmpty || viewModel.videoPlayerController == null)
              const SizedBox()
            else
              SizedBox(
                height: 15.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<Duration?>(
                        stream: viewModel.videoPlayerController!.position.asStream(),
                        builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
                          if (snapshot.hasData) {
                            final String duration = _getDuration(snapshot.data!);
                            return Text(
                              duration,
                              style: const TextStyle(color: Colors.white),
                            );
                          } else {
                            return SizedBox(height: 22.h, width: 18.w, child: CircularProgressIndicator(strokeWidth: 2.w, color: AppColors.kWhite));
                          }
                        }),
                    Text(
                      formatDuration(viewModel.videoPlayerController!.value.duration.inSeconds),
                      style:  TextStyle(color: AppColors.kWhite),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}
