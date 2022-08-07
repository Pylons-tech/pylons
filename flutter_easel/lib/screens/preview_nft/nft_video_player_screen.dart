import 'dart:ui';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/widgets/video_builder.dart';
import 'package:easel_flutter/widgets/video_progress_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class NFTVideoPlayerScreen extends StatelessWidget {
  const NFTVideoPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EaselAppTheme.kBlack,
      child: Consumer<EaselProvider>(
        builder: (context, EaselProvider viewModel, child) {
          return Stack(
            children: [
              VideoBuilder(
                  onVideoLoading: (BuildContext context) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kWhite),
                        ),
                      ),
                  onVideoHasError: (BuildContext context) => Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          videoPlayerError,
                          style: TextStyle(fontSize: 18.sp, color: EaselAppTheme.kWhite),
                        ),
                      )),
                  onVideoInitialized: (BuildContext context) => Center(
                        child: AspectRatio(
                          aspectRatio: viewModel.videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(viewModel.videoPlayerController),
                        ),
                      ),
                  easelProvider: viewModel),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: const VideoProgressWidget(darkMode: true, isForFile: false),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
