import 'dart:core';

import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/screen/music_play_contorl.dart';

import 'main.dart';
import 'package:flutter/material.dart';

const int EMPTY_MUSIC_ID = -1;

@immutable
class PlayPageState {
  //当前播放的歌曲
  final MusicTrackBean music;

  // 当前播放模式
  final MusicPlayMode playMode;

  // 播放错误信息
  final String errorMsg;

  PlayPageState({
    this.music,
    this.playMode,
    this.errorMsg,
  });

  PlayPageState copyWith({
    MusicTrackBean music,
    MusicPlayMode playMode,
    String errorMsg,
  }) {
    return PlayPageState(
        music: music ?? this.music,
        playMode: playMode ?? this.playMode,
        errorMsg: errorMsg ?? this.errorMsg);
  }

  PlayPageState.initState()
      : music = MusicPlayList.currentSong,
        playMode = MusicPlayer.playMode,
        errorMsg = "";

  @override
  String toString() {
    return "PlayPageState={music:$music,playMode:$playMode,errorMsg:$errorMsg,}";
  }
}

class PlayPageRedux extends Reducer<PlayPageState> {
  @override
  PlayPageState redux(PlayPageState state, action) {
    switch (action.runtimeType) {
      case InitPlayPageAction:
        ///加载歌曲信息S
        return state.copyWith(music: MusicPlayList.currentSong);
      case PlayMusicWithIdAction:
        ///播放歌曲
        var id = action.payload;
        if (id != EMPTY_MUSIC_ID) {
          MusicPlayer.playWithId(id);
        }
        return state.copyWith(music: MusicPlayList.currentSong);
      case MusicPlayingAction:
        // 正在播放歌曲
        return state.copyWith(
          music: MusicPlayList.currentSong,
        );
      case RequestPlayMusicFailed:
        //播放失败
        return state.copyWith(errorMsg: action.payload);
      case ChangePlayModeAction:
        //更改模式
        return state.copyWith(playMode: MusicPlayer.playMode);
    }
    return state;
  }
}
