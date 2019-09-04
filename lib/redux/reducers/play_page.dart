import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/screen/play_page/player.dart';

import 'main.dart';
import 'package:flutter/material.dart';

@immutable
class PlayPageState {
  final bool isLoaded;
  final MusicPlayMode mode;

  final MusicPlayState state;

  final MusicTrackBean music;

  PlayPageState(this.mode, this.state, this.music, this.isLoaded);

  PlayPageState copyWith(
      {MusicPlayMode mode,
      MusicTrackBean music,
      MusicPlayState state,
      bool isLoaded}) {
    return PlayPageState(mode ?? this.mode, state ?? this.state,
        music ?? this.music, isLoaded ?? this.isLoaded);
  }

  PlayPageState.initState()
      : music = null,
        isLoaded = false,
        mode = MusicPlayMode.repeat,
        state = MusicPlayState.initState();
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
    switch (action.runtimeType) {
      case LoadMusicInfoAction:
        var music = MusicPlayer.getCurrent();
        //请求播放地址
        StoreContainer.dispatch(StartPlayMusicUrlAction());
        return state.copyWith(music: music);
      case StartPlayMusicUrlAction:
        // 异步处理
        () async {
          MusicPlayer.playSongList();
        }();
        return state;
    }
    return state;
  }
}
