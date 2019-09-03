import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

class MusicPlayer {
  static final AudioPlayer audioPlayer = AudioPlayer();

  static bool isPlaying = false;

  static void play(String url){
     audioPlayer.play(url);
  }

  static void pause() {
    audioPlayer.pause();
  }

  static void stop(){
    audioPlayer.stop();
  }
}

///播放状态
enum PlayState { none, load_error, playing, pause, stop }

///播放信息
class PlayInfo {
  final int duration;
  final int current;
  final PlayState state;

  PlayInfo(this.duration, this.current, this.state);

  PlayInfo copyWith({int duration, int current, PlayState state}) {
    return PlayInfo(duration ?? this.duration, current ?? this.current,
        state ?? this.state);
  }

  PlayInfo.initState()
      :duration=0,
        current=0,
        state=PlayState.none;
}
