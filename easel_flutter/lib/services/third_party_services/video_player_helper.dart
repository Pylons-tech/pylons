import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';

/// Abstract Class for providing Video player
abstract class VideoPlayerHelper {
  /// This method is used to initialize the Video player with local directory file
  /// Input : [file] the local video file from directory which needs to be played
  void initializeVideoPlayerWithFile({required File file});

  /// This method is used to initialize the Video player with network URL of the Video
  /// Input : [videoUrl] the Network URL of the video which needs to be played
  void initializeVideoPlayerWithUrl({required String videoUrl});

  /// This method is used to listen to the Position stream of the video player
  /// Output : [Duration] it will be a Stream for the realtime position
  /// duration on the video progress seekbar
  Stream<Duration?> positionStream();

  /// This method will be responsible for destroying the video player instances from the memory
  void destroyVideoPlayer();

  /// This method will be responsible for pausing the Video
  Future<void> pauseVideo();

  /// This method will be responsible for playing the Video
  Future<void> playVideo();

  /// This method will be responsible for seeking the Video when dragged forward of reverse
  /// Input: [Duration] this will take the new position of the seekbar and will update it
  Future<void> seekToVideo({required Duration position});

  /// This method will return the current initialized instance of the video player which
  /// Output:  [VideoPlayerController] which will be used to control action bar of video progress widget eventually
  ///
  VideoPlayerController getVideoPlayerController();
}

/// [VideoPlayerHelperImp] implementation of [VideoPlayerHelper]
class VideoPlayerHelperImp implements VideoPlayerHelper {
  late VideoPlayerController videoPlayerController;

  VideoPlayerHelperImp(this.videoPlayerController);

  @override
  void initializeVideoPlayerWithFile({required File file}) async {
    videoPlayerController = VideoPlayerController.file(file)..initialize().then((value) => {});
  }

  @override
  void initializeVideoPlayerWithUrl({required String videoUrl}) async {
    videoPlayerController = VideoPlayerController.network(videoUrl)..initialize().then((value) => {});
  }

  @override
  Stream<Duration?> positionStream() {
    return Stream.fromFuture(videoPlayerController.position);
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
