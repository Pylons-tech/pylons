import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/nft_format.dart';

class AudioWidget extends StatefulWidget {
  final File? file;
  final String? filePath;
  final bool previewFlag;

  const AudioWidget(
      {Key? key, this.file, required this.previewFlag, this.filePath})
      : super(key: key);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> with WidgetsBindingObserver {
  EaselProvider get easelProvider => GetIt.I.get();

  Repository get repository => GetIt.I.get<Repository>();

  @override
  initState() {
    super.initState();

    if (!widget.previewFlag) {
      easelProvider.initializeAudioPlayer(publishedNFTUrl: widget.filePath);
      return;
    } else {
      easelProvider.initializeAudioPlayerForFile(file: widget.file!);
      return;
    }
  }

  BoxDecoration getAudioBackgroundDecoration(
      {required EaselProvider viewModel}) {
    if (widget.previewFlag && viewModel.audioThumbnail == null) {
      return const BoxDecoration();
    }
    if (widget.previewFlag && viewModel.audioThumbnail != null) {
      return BoxDecoration(
          image: DecorationImage(
              image: FileImage(viewModel.audioThumbnail!),
              fit: BoxFit.fitHeight));
    }
    return BoxDecoration(
        image: viewModel.nft.thumbnailUrl.isNotEmpty
            ? DecorationImage(
                image: CachedNetworkImageProvider(
                    viewModel.nft.thumbnailUrl.changeDomain()),
                fit: BoxFit.fitHeight)
            : null);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EaselProvider>();

    return WillPopScope(
        onWillPop: () {
          easelProvider.setAudioThumbnail(null);
          Navigator.pop(context);
          return Future.value(true);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: getAudioBackgroundDecoration(viewModel: viewModel),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 0.4.sh,
                  ),
                  (shouldShowThumbnailButtonOrStepsOrNot())
                      ? SizedBox(
                          height: 100.h,
                          width: 330.0.w,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 10.w,
                                      bottom: 10.h,
                                      top: 10.h,
                                      left: 5.w),
                                  child: ValueListenableBuilder<ButtonState>(
                                    valueListenable: viewModel.buttonNotifier,
                                    builder: (_, value, __) {
                                      switch (value) {
                                        case ButtonState.loading:
                                          return SizedBox(
                                              height: 22.h,
                                              width: 22.h,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2.w,
                                                  color: Colors.black));
                                        case ButtonState.paused:
                                          return InkWell(
                                            onTap: () {
                                              viewModel.playAudio(
                                                  widget.file != null);
                                            },
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: EaselAppTheme.kDarkBlue,
                                              size: 35.h,
                                            ),
                                          );

                                        case ButtonState.playing:
                                          return InkWell(
                                            onTap: () {
                                              viewModel.pauseAudio(
                                                  widget.file != null);
                                            },
                                            child: Icon(
                                              Icons.pause,
                                              color: EaselAppTheme.kDarkBlue,
                                              size: 35.h,
                                            ),
                                          );
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child:
                                      ValueListenableBuilder<ProgressBarState>(
                                    valueListenable:
                                        viewModel.audioProgressNotifier,
                                    builder: (_, value, __) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 3.h, right: 20.w),
                                        child: ProgressBar(
                                          progressBarColor:
                                              EaselAppTheme.kDarkBlue,
                                          thumbColor: EaselAppTheme.kDarkBlue,
                                          progress: value.current,
                                          baseBarColor: EaselAppTheme.kBlack,
                                          bufferedBarColor:
                                              EaselAppTheme.kLightGrey,
                                          buffered: value.buffered,
                                          total: value.total,
                                          timeLabelTextStyle: TextStyle(
                                              color: EaselAppTheme.kDartGrey,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 9.sp),
                                          thumbRadius: 10.h,
                                          timeLabelPadding: 3.h,
                                          onSeek: (position) {
                                            viewModel.seekAudio(
                                                position, widget.file != null);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : const SizedBox(),
                  SizedBox(
                    height: 40.0.h,
                  ),
                  shouldShowThumbnailButtonOrStepsOrNot()
                      ? _buildThumbnailButton()
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ));
  }

  bool shouldShowThumbnailButtonOrStepsOrNot() {
    return widget.previewFlag;
  }

  @override
  void dispose() {
    easelProvider.disposeAudioController();
    super.dispose();
  }

  Widget _buildThumbnailButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.h),
        child: SizedBox(
          height: 120.h,
          width: 120.w,
          child: InkWell(
            onTap: () {
              audioThumbnailPicker();
            },
            child: SvgPicture.asset(kUploadThumbnail),
          ),
        ),
      ),
    );
  }

  void audioThumbnailPicker() async {
    easelProvider.pauseAudio(true);
    final pickedFile = await repository.pickFile(NftFormat.supportedFormats[0]);
    final result = pickedFile.getOrElse(
        () => PickedFileModel(path: "", fileName: "", extension: ""));
    if (result.path.isEmpty) {
      return;
    }
    easelProvider.setAudioThumbnail(File(result.path));
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}
