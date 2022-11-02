import 'dart:async';

import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerImpl implements VideoPlayerHelper {
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
  Future initializeVideoPlayer({required String url}) {
    // TODO: implement initializeVideoPlayer
    throw UnimplementedError();
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
  StreamSubscription<Duration?> positionStream() {
    // TODO: implement positionStream
    throw UnimplementedError();
  }

  @override
  Future<void> seekToVideo({required Duration position}) {
    // TODO: implement seekToVideo
    throw UnimplementedError();
  }
}
