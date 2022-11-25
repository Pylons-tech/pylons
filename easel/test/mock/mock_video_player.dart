import 'dart:io';
import 'package:easel_flutter/services/third_party_services/video_player_helper.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerHelperImp implements VideoPlayerHelper {
  @override
  void destroyVideoPlayer() {
  }

  @override
  VideoPlayerController getVideoPlayerController() {
    throw UnimplementedError();
  }

  @override
  void initializeVideoPlayerWithFile({required File file}) {
  }

  @override
  void initializeVideoPlayerWithUrl({required String videoUrl}) {
  }

  @override
  Future<void> pauseVideo() {
    throw UnimplementedError();
  }

  @override
  Future<void> playVideo() {

    throw UnimplementedError();
  }

  @override
  Stream<Duration?> positionStream() {
    throw UnimplementedError();
  }

  @override
  Future<void> seekToVideo({required Duration position}) {
    throw UnimplementedError();
  }
}
