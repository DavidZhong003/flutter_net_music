import 'main.dart';
import 'package:flutter/material.dart';

@immutable
class PlayPageState {
  final String songName;

  final String songId;

  final String coverUrl;

  final MusicPlayMode mode;

  final MusicPlayState state;

  PlayPageState(
      this.songName, this.songId, this.coverUrl, this.mode, this.state);

  PlayPageState copyWith(
      {String songName,
      String songId,
      String coverUrl,
      MusicPlayMode mode,
      MusicPlayState state}) {
    return PlayPageState(songName ?? this.songName, songId ?? this.songId,
        coverUrl ?? this.coverUrl, mode ?? this.mode, state ?? this.state);
  }

  PlayPageState.initState()
      : songName = "",
        songId = "",
        mode = MusicPlayMode.repeat,
        state = MusicPlayState.initState(),
        coverUrl = "";
}

class MusicPlayState {
  final double duration;
  final double current;
  final bool isPlaying;

  MusicPlayState(this.duration, this.current, this.isPlaying);

  MusicPlayState copyWith({double duration, double current, bool isPlaying}) {
    return MusicPlayState(duration ?? this.duration, current ?? this.current,
        isPlaying ?? this.isPlaying);
  }

  MusicPlayState.initState()
      : duration = 0,
        current = 0,
        isPlaying = false;
}

enum MusicPlayMode { repeat_one, repeat, random, heartbeat }

class PlayPageRedux extends Reducer<PlayPageState> {
  @override
  PlayPageState redux(PlayPageState state, action) {
    switch(action.runtimeType){

    }
    return state;
  }
}
