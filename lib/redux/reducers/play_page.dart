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

  // 当前进度
  final DurationState durationState;

  // 当前播放模式
  final MusicPlayMode playMode;

  // readyToPlay 是否可以播放
  final bool isPlaying;

  // 播放错误信息
  final String errorMsg;

  PlayPageState({
    this.music,
    this.durationState,
    this.playMode,
    this.isPlaying,
    this.errorMsg,
  });

  PlayPageState copyWith({
    MusicTrackBean music,
    DurationState duration,
    MusicPlayMode playMode,
    bool isPlaying,
    String errorMsg,
  }) {
    print("2222222,$music,this.music=${this.music}");
    return PlayPageState(
        music: music ?? this.music,
        durationState: duration ?? this.durationState,
        playMode: playMode ?? this.playMode,
        isPlaying: isPlaying ?? this.isPlaying,
        errorMsg: errorMsg ?? this.errorMsg);
  }

  PlayPageState.initState()
      : music = MusicPlayList.currentSong,
        durationState = DurationState.initState(),
        playMode = MusicPlayer.playMode,
        errorMsg = "",
        isPlaying = false;

  @override
  String toString() {
    return "PlayPageState={music:$music,durationState:$durationState,playMode:$playMode,errorMsg:$errorMsg,readyPlay=$isPlaying}";
  }
}

class PlayPageRedux extends Reducer<PlayPageState> {
  @override
  PlayPageState redux(PlayPageState state, action) {
    var duration = DurationRedux().redux(state.durationState, action);
    switch (action.runtimeType) {
      case InitPlayPageAction:
        ///加载歌曲信息S
        return state.copyWith(
            music: MusicPlayList.currentSong, isPlaying: MusicPlayer.isPlaying);
      case PlayMusicWithIdAction:
        ///播放歌曲
        var id = action.payload;
        if (id != EMPTY_MUSIC_ID) {
          MusicPlayer.playWithId(id);
        }
        return state.copyWith(
            music: MusicPlayList.currentSong, duration: duration);
      case MusicPlayingAction:
        // 正在播放歌曲
        return state.copyWith(
            music: MusicPlayList.currentSong, isPlaying: true);
      case MusicPauseAction:
        //暂停歌曲
        return state.copyWith(isPlaying: false);
      case MusicResumeAction:
        //恢复歌曲
        return state.copyWith(isPlaying: true);
      case RequestPlayMusicFailed:
        //播放失败
        return state.copyWith(isPlaying: false, errorMsg: action.payload);
      case ChangePlayModeAction:
        //更改模式
        return state.copyWith(playMode:  MusicPlayer.playMode);
    }
    return state.copyWith(duration: duration);
  }
}

///进度管理器
@immutable
class DurationState {
  // 当前进度
  final Duration position;

  // 总时长
  final Duration duration;

  DurationState({this.position, this.duration});

  DurationState copyWith({
    Duration position,
    Duration duration,
  }) {
    return DurationState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  DurationState.initState()
      : position = Duration.zero,
        duration = Duration.zero;

  String get durationString => _durationFormat(duration);

  String get positionString => _durationFormat(position);

  double get positionValue {
    if (position == null || duration == null || duration == Duration.zero) {
      return 0;
    }
    var value = (position.inMilliseconds) / (duration.inMilliseconds);
    return value;
  }
}

//进度文本格式化 00:00
String _durationFormat(Duration duration) {
  if (duration == null) {
    return "00:00";
  }
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  if (duration.inSeconds < 0) {
    return "-${-duration}";
  }
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

class DurationRedux extends Reducer<DurationState> {
  @override
  DurationState redux(DurationState state, action) {
    switch (action.runtimeType) {
      case PlayPositionChangeAction:
        //如果长度异常重新请求下
        if ((state.duration == null || state.duration == Duration.zero) &&
            action.payload != null) {
          MusicPlayer.notifyDurationChange();
        }
        return state.copyWith(position: action.payload);
      case ChangeDurationAction:
        return state.copyWith(duration: action.payload);
    }
    return state;
  }
}
