import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/redux/actions/play_list.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/screen/music_play_contorl.dart';
import 'main.dart';

@immutable
class PlayListState {
  // 当前播放模式
  final MusicPlayMode playMode;

  final int playSongId;

  final List<MusicTrackBean> playList;

  PlayListState({this.playMode, this.playList, this.playSongId});

  PlayListState copyWith({
    MusicPlayMode playMode,
    List<MusicTrackBean> playList,
    int playSongId,
  }) {
    return PlayListState(
      playMode: playMode ?? this.playMode,
      playList: playList ?? this.playList,
      playSongId: playSongId ?? this.playSongId,
    );
  }

  PlayListState.initState()
      : playMode = MusicPlayer.playMode,
        playSongId = MusicPlayList.currentSongId,
        playList = MusicPlayList.playList;

  @override
  String toString() {
    return "list=$playList,id=$playSongId,playMode=$playMode";
  }
}

class PlayListRedux extends Reducer<PlayListState> {
  @override
  PlayListState redux(PlayListState state, action) {
    switch (action.runtimeType) {
      case ChangePlayModeAction:
        return state.copyWith(playMode: MusicPlayer.playMode);
      case OnInitPlayListData:
        return state.copyWith(
          playSongId: MusicPlayList.currentSongId,
          playMode: MusicPlayer.playMode,
          playList: MusicPlayList.playList,
        );
      case ChangePlaySongIdAction:
        return state.copyWith(playSongId: action.payload);
    }
    return state;
  }
}
