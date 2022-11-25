import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class OwnerVideoProgressWidget extends StatefulWidget {
  final String url;

  const OwnerVideoProgressWidget({Key? key, required this.url}) : super(key: key);

  @override
  _OwnerVideoProgressWidgetState createState() => _OwnerVideoProgressWidgetState();
}

class _OwnerVideoProgressWidgetState extends State<OwnerVideoProgressWidget> {
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
      padding: EdgeInsets.only(right: 10.w, bottom: 5.h, top: 5.h, left: 5.w),
      child: Consumer<EaselProvider>(builder: (context, viewModel, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (viewModel.videoLoadingError.isNotEmpty)
              const SizedBox()
            else
              Row(
                children: [
                  if (viewModel.isVideoLoading)
                    SizedBox(
                      height: 22.h,
                      width: 22.h,
                      child: CircularProgressIndicator(strokeWidth: 2.w, color: EaselAppTheme.kWhite),
                    )
                  else if (viewModel.videoPlayerController.value.isPlaying)
                    InkWell(
                      onTap: viewModel.pauseVideo,
                      child: Icon(
                        Icons.pause,
                        color: EaselAppTheme.kWhite,
                        size: 20.h,
                      ),
                    )
                  else
                    InkWell(
                      onTap: viewModel.playVideo,
                      child: Icon(
                        Icons.play_arrow_outlined,
                        color: EaselAppTheme.kWhite,
                        size: 20.h,
                      ),
                    ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: VideoProgressIndicator(
                      viewModel.videoPlayerController,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        backgroundColor: EaselAppTheme.kGrey,
                        playedColor: EaselAppTheme.kWhite,
                        bufferedColor: EaselAppTheme.kWhite.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            if (viewModel.videoLoadingError.isNotEmpty)
              const SizedBox()
            else
              SizedBox(
                height: 15.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<Duration?>(
                          stream: viewModel.videoPlayerController.position.asStream(),
                          builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
                            if (snapshot.hasData) {
                              final String duration = _getDuration(snapshot.data!);
                              return Text(
                                duration,
                                style: TextStyle(color: EaselAppTheme.kWhite, fontSize: 9.sp),
                              );
                            } else {
                              return SizedBox(
                                height: 22.h,
                                width: 18.w,
                                child: CircularProgressIndicator(strokeWidth: 2.w, color: EaselAppTheme.kWhite),
                              );
                            }
                          }),
                      Text(
                        formatDuration(viewModel.videoPlayerController.value.duration.inSeconds),
                        style: TextStyle(color: EaselAppTheme.kWhite, fontSize: 9.sp),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
