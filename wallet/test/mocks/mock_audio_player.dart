import 'package:just_audio/just_audio.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';

class MockAudioPlayerImpl implements AudioPlayerHelper {
  final AudioPlayer audioPlayer;

  MockAudioPlayerImpl(this.audioPlayer);

  @override
  Stream<Duration> bufferedPositionStream() {
    return audioPlayer.bufferedPositionStream;
  }

  @override
  void destroyAudioPlayer() {
    // TODO: implement destroyAudioPlayer
  }

  @override
  Stream<Duration?> durationStream() {
    return audioPlayer.durationStream;
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
  Stream<PlayerState> playerStateStream() {
    return audioPlayer.playerStateStream;
  }

  @override
  Stream<Duration> positionStream() {
    return audioPlayer.positionStream;
  }

  @override
  Future<void> seekAudio({required Duration position}) {
    return audioPlayer.seek(position);
  }

  @override
  Future<bool> setUrl({required String url}) async {
    await audioPlayer.setUrl(url);
    return true;
  }
}
