import 'package:just_audio/just_audio.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';

class MockAudioPlayerImpl implements AudioPlayerHelper{
  @override
  Stream<Duration> bufferedPositionStream() {
    // TODO: implement bufferedPositionStream
    throw UnimplementedError();
  }

  @override
  void destroyAudioPlayer() {
    // TODO: implement destroyAudioPlayer
  }

  @override
  Stream<Duration?> durationStream() {
    // TODO: implement durationStream
    throw UnimplementedError();
  }

  @override
  Future<void> pauseAudio() {
    // TODO: implement pauseAudio
    throw UnimplementedError();
  }

  @override
  Future<void> playAudio() {
    // TODO: implement playAudio
    throw UnimplementedError();
  }

  @override
  Stream<PlayerState> playerStateStream() {
    // TODO: implement playerStateStream
    throw UnimplementedError();
  }

  @override
  Stream<Duration> positionStream() {
    // TODO: implement positionStream
    throw UnimplementedError();
  }

  @override
  Future<void> seekAudio({required Duration position}) {
    // TODO: implement seekAudio
    throw UnimplementedError();
  }

  @override
  Future<bool> setUrl({required String url}) {
    // TODO: implement setUrl
    throw UnimplementedError();
  }

}