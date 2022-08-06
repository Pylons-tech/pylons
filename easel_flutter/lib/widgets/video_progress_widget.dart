import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoProgressWidget extends StatelessWidget {
  final bool darkMode;
  final bool isForFile;

  const VideoProgressWidget({Key? key, required this.darkMode, required this.isForFile}) : super(key: key);

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
    final easelProvider = context.watch<EaselProvider>();

    return Padding(
        padding: EdgeInsets.only(right: 10.w, bottom: 3.h, top: 3.h, left: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (easelProvider.videoLoadingError.isNotEmpty)
              const SizedBox()
            else
              easelProvider.isVideoLoading
                  ? const SizedBox()
                  : Row(
                      children: [
                        if (easelProvider.isVideoLoading)
                          SizedBox(height: 22.h, width: 22.h, child: Image.asset(kLoadingGif))
                        else if (easelProvider.videoPlayerController.value.isPlaying)
                          SizedBox(
                            height: 20.0.h,
                            child: InkWell(
                              onTap: easelProvider.pauseVideo,
                              child: Icon(
                                Icons.pause,
                                color: darkMode ? EaselAppTheme.kWhite : EaselAppTheme.kDarkBlue,
                                size: 25.h,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 20.0.h,
                            child: InkWell(
                              onTap: easelProvider.playVideo,
                              child: Icon(
                                Icons.play_arrow_outlined,
                                color: darkMode ? EaselAppTheme.kWhite : EaselAppTheme.kDarkBlue,
                                size: 25.h,
                              ),
                            ),
                          ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: VideoProgressIndicator(
                            easelProvider.videoPlayerController,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              backgroundColor: darkMode ? EaselAppTheme.kWhite : EaselAppTheme.kBlack,
                              playedColor: EaselAppTheme.kLightRed,
                              bufferedColor: darkMode ? EaselAppTheme.kBlack.withOpacity(0.7) : EaselAppTheme.kWhite.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
            if (easelProvider.videoLoadingError.isNotEmpty || easelProvider.isVideoLoading)
              const SizedBox()
            else
              SizedBox(
                height: 15.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<Duration?>(
                        stream: easelProvider.videoPlayerController.position.asStream(),
                        builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
                          if (snapshot.hasData) {
                            final String duration = _getDuration(snapshot.data!);
                            return Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Text(
                                duration,
                                style: TextStyle(color: darkMode ? EaselAppTheme.kWhite : EaselAppTheme.kBlack, fontWeight: FontWeight.w800, fontSize: 10.sp),
                              ),
                            );
                          }
                          return SizedBox(width: 30.w, child: Image.asset(kLoadingGif));
                        }),
                    Text(
                      isForFile ? formatDuration(easelProvider.fileDuration ~/ kSecInMillis) : formatDuration(easelProvider.videoPlayerController.value.duration.inSeconds),
                      style: TextStyle(color: darkMode ? EaselAppTheme.kWhite : EaselAppTheme.kBlack, fontWeight: FontWeight.w800, fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
          ],
        ));
  }
}
