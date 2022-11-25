import 'dart:io';
import 'package:easel_flutter/services/third_party_services/audio_player_helper.dart';
import 'package:just_audio/just_audio.dart';

class MockAudioPlayerHelperImp implements AudioPlayerHelper {
  @override
  Stream<Duration> bufferedPositionStream() {
    throw UnimplementedError();
  }

  @override
  void destroyAudioPlayer() {
  }

  @override
  Stream<Duration?> durationStream() {
    throw UnimplementedError();
  }

  @override
  Future<void> pauseAudio() {
    throw UnimplementedError();
  }

  @override
  Future<void> playAudio() {
    throw UnimplementedError();
  }

  @override
  Stream<PlayerState> playerStateStream() {
    throw UnimplementedError();
  }

  @override
  Stream<Duration> positionStream() {
    throw UnimplementedError();
  }

  @override
  Future<void> seekAudio({required Duration position}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setAudioSource({required File file}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> setFile({required String file}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> setUrl({required String url}) {
    throw UnimplementedError();
  }
}
