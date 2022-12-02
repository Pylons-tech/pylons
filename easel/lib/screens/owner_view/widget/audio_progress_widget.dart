import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OwnerAudioWidget extends StatefulWidget {
  final String url;

  const OwnerAudioWidget({Key? key, required this.url}) : super(key: key);

  @override
  _OwnerAudioWidgetState createState() => _OwnerAudioWidgetState();
}

class _OwnerAudioWidgetState extends State<OwnerAudioWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EaselProvider>();
    return Row(
      crossAxisAlignment: viewModel.collapsed ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10.w, bottom: 10.h, top: 10.h, left: 5.w),
          child: ValueListenableBuilder<ButtonState>(
            valueListenable: viewModel.buttonNotifier,
            builder: (_, value, __) {
              switch (value) {
                case ButtonState.loading:
                  return SizedBox(height: 22.h, width: 22.h, child: CircularProgressIndicator(strokeWidth: 2.w, color: EaselAppTheme.kWhite));
                case ButtonState.paused:
                  return InkWell(
                    onTap: () {
                      viewModel.playAudio(forFile: false);
                    },
                    child: Icon(
                      Icons.play_arrow_outlined,
                      color: EaselAppTheme.kWhite,
                      size: 22.h,
                    ),
                  );

                case ButtonState.playing:
                  return InkWell(
                    onTap: () {
                      viewModel.pauseAudio(forFile: false);
                    },
                    child: Icon(
                      Icons.pause,
                      color: EaselAppTheme.kWhite,
                      size: 22.h,
                    ),
                  );
              }
            },
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<ProgressBarState>(
            valueListenable: viewModel.audioProgressNotifier,
            builder: (_, value, __) {
              return Padding(
                padding: EdgeInsets.only(bottom: viewModel.collapsed ? 0 : 3.h, right: 10.w),
                child: ProgressBar(
                  progressBarColor: EaselAppTheme.kWhite,
                  thumbColor: EaselAppTheme.kWhite,
                  progress: value.current,
                  baseBarColor: EaselAppTheme.kGrey,
                  bufferedBarColor: EaselAppTheme.kWhite,
                  buffered: value.buffered,
                  total: value.total,
                  timeLabelLocation: viewModel.collapsed ? TimeLabelLocation.none : TimeLabelLocation.below,
                  timeLabelTextStyle: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w800, fontSize: 9.sp),
                  thumbRadius: 6.h,
                  timeLabelPadding: 2.h,
                  onSeek: (position) {
                    viewModel.seekAudio(position, forFile: false);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    context.read<EaselProvider>().disposeAudioController();
    super.dispose();
  }
}
