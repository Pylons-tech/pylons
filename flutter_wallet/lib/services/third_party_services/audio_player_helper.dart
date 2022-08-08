import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:just_audio/just_audio.dart';
import 'package:pylons_wallet/components/loading.dart';

/// Abstract Class for providing audio player
abstract class AudioPlayerHelper {
  /// This method is used to initialize the Audio player
  /// Input : [url] for the network audio to be play via Audio Player
  /// Output : [bool] this boolean future represents whether the player is initialized successfully or not
  Future<bool> setUrl({required String url});

  /// This method is used to listen to the playing stream of the audio player
  /// Output : [Stream][PlayerState] it will be a Stream for the playing audio
  Stream<PlayerState> playerStateStream();

  /// This method is used to listen to the Position stream of the audio player
  /// Output : [Stream][Duration] it will be a Stream for the realtime position on the audio seekbar
  Stream<Duration> positionStream();

  /// This method is used to listen to the Buffered Position stream of the audio player
  /// Output : [Stream][Duration] it will be a Stream for the realtime Buffered position on the audio seekbar
  Stream<Duration> bufferedPositionStream();

  /// This method is used to listen to the Duration stream of the audio player
  /// Output : [Stream][Duration] it will be a Stream for the realtime Duration of the audio seekbar
  Stream<Duration?> durationStream();

  /// This method is used to destroy the audio player instances from the memory
  void destroyAudioPlayer();

  /// This method will be responsible for Pausing the Audio
  Future<void> pauseAudio();

  /// This method will be responsible for Playing the Audio
  Future<void> playAudio();

  /// This method will be responsible for seeking the audio when dragged forward of reverse
  Future<void> seekAudio({required Duration position});
}

/// [AudioPlayerHelperImpl] implementation of [AudioPlayerHelper]
class AudioPlayerHelperImpl implements AudioPlayerHelper {
  final AudioPlayer audioPlayer;

  AudioPlayerHelperImpl(this.audioPlayer);

  @override
  Future<bool> setUrl({required String url}) async {
    try {
      await audioPlayer.setUrl(url);
      return true;
    } catch (e) {
      'audio_failed_to_load'.tr().show();
      return false;
    }
  }

  @override
  Stream<PlayerState> playerStateStream() {
    return audioPlayer.playerStateStream;
  }

  @override
  Stream<Duration> positionStream() {
    return audioPlayer.positionStream;
  }

  @override
  Stream<Duration> bufferedPositionStream() {
    return audioPlayer.bufferedPositionStream;
  }

  @override
  Stream<Duration?> durationStream() {
    return audioPlayer.durationStream;
  }

  @override
  void destroyAudioPlayer() {
    audioPlayer.dispose();
  }

  @override
  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  @override
  Future<void> playAudio() async {
    await audioPlayer.play();
  }

  @override
  Future<void> seekAudio({required Duration position}) async {
    await audioPlayer.seek(position);
  }
}
