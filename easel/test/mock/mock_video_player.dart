import 'dart:io';

import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerHelperImp implements VideoPlayerHelper {
  @override
  void destroyVideoPlayer() {
    // TODO: implement destroyVideoPlayer
  }

  @override
  VideoPlayerController getVideoPlayerController() {
    // TODO: implement getVideoPlayerController
    throw UnimplementedError();
  }

  @override
  void initializeVideoPlayerWithFile({required File file}) {
    // TODO: implement initializeVideoPlayerWithFile
  }

  @override
  void initializeVideoPlayerWithUrl({required String videoUrl}) {
    // TODO: implement initializeVideoPlayerWithUrl
  }

  @override
  Future<void> pauseVideo() {
    // TODO: implement pauseVideo
    throw UnimplementedError();
  }

  @override
  Future<void> playVideo() {
    // TODO: implement playVideo
    throw UnimplementedError();
  }

  @override
  Stream<Duration?> positionStream() {
    // TODO: implement positionStream
    throw UnimplementedError();
  }

  @override
  Future<void> seekToVideo({required Duration position}) {
    // TODO: implement seekToVideo
    throw UnimplementedError();
  }
}
