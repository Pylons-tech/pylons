import 'dart:async';

import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerImpl implements VideoPlayerHelper {
  late VideoPlayerController videoPlayerController;

  MockVideoPlayerImpl(this.videoPlayerController);

  @override
  void destroyVideoPlayer() {
    videoPlayerController.dispose();
  }

  @override
  VideoPlayerController getVideoPlayerController() {
    return videoPlayerController;
  }

  @override
  Future initializeVideoPlayer({required String url}) async {
    videoPlayerController = VideoPlayerController.network(url)..initialize().then((value) {});
  }

  @override
  Future<void> pauseVideo() async {
    await videoPlayerController.pause();
  }

  @override
  Future<void> playVideo() async {
    await videoPlayerController.play();
  }

  @override
  StreamSubscription<Duration?> positionStream() {
    return Stream.fromFuture(videoPlayerController.position).listen((event) {});
  }

  @override
  Future<void> seekToVideo({required Duration position}) async {
    await videoPlayerController.seekTo(position);
  }
}
