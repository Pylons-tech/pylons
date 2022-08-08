import 'dart:async';
import 'package:video_player/video_player.dart';

/// Abstract Class for providing Video player
abstract class VideoPlayerHelper {
  /// This method will be do the main heavy lifting and it will
  /// initialize the video player and make it ready to use
  Future initializeVideoPlayer({required String url});

  /// This method will be a listener to the positionStream which
  /// will listen to the current duration of the video being played
  StreamSubscription<Duration?> positionStream();

  /// This method will be responsible for destroying the video player instances from the memory
  void destroyVideoPlayer();

  /// This method will be responsible for pausing the Video
  Future<void> pauseVideo();

  /// This method will be responsible for playing the Video
  Future<void> playVideo();

  /// This method will be responsible for seeking the Video when dragged forward of reverse
  Future<void> seekToVideo({required Duration position});

  VideoPlayerController getVideoPlayerController();
}

/// [VideoPlayerHelperImp] implementation of [VideoPlayerHelper]
class VideoPlayerHelperImp implements VideoPlayerHelper {
  late VideoPlayerController videoPlayerController;

  VideoPlayerHelperImp(this.videoPlayerController);

  @override
  Future initializeVideoPlayer({required String url}) async {
    videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((value) => {});
  }

  @override
  StreamSubscription<Duration?> positionStream() {
    return Stream.fromFuture(videoPlayerController.position).listen((event) {});
  }

  @override
  void destroyVideoPlayer() {
    videoPlayerController.dispose();
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
  Future<void> seekToVideo({required Duration position}) async {
    await videoPlayerController.seekTo(position);
  }

  @override
  VideoPlayerController getVideoPlayerController() {
    return videoPlayerController;
  }
}
