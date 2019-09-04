import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/redux/actions/song_list.dart';
import 'package:flutter_net_music/screen/play_page/play_page.dart';
import 'package:flutter_net_music/screen/play_page/player.dart';

import '../../routes.dart';
import 'main.dart';

import 'package:flutter/material.dart';

@immutable
class SongListPageState {
  final bool isLoading;

  final String id;

  final Map<String, dynamic> songsDetail;

  final List<MusicTrackBean> musics;

  SongListPageState({this.id, this.isLoading, this.songsDetail, this.musics});

  SongListPageState copyWith(
      {bool isLoading,
      Map<String, dynamic> songsDetail,
      String id,
      List<MusicTrackBean> musics}) {
    return SongListPageState(
        isLoading: isLoading ?? this.isLoading,
        id: id ?? this.id,
        songsDetail: songsDetail ?? this.songsDetail,
        musics: musics ?? this.musics);
  }

  SongListPageState.initialState()
      : isLoading = true,
        id = "",
        musics = [],
        songsDetail = {};
}

class SongListReducer extends Reducer<SongListPageState> {
  @override
  SongListPageState redux(SongListPageState state, action) {
    switch (action.runtimeType) {
      case SongListRequestSuccess:
        List<MusicTrackBean> music;
        List<dynamic> tracks = action.payload["playlist"]["tracks"];
        music = tracks.map((tracks) {
          return MusicTrackBean.fromMap(tracks);
        }).toList();
        return state.copyWith(
            isLoading: false, songsDetail: action.payload, musics: music);
      case RequestSongsListAction:
        String id = action.payload;
        if (state.id == id && state.songsDetail.isNotEmpty) {
          return state;
        } else {
          ApiService.getSongListDetails(id).then((map) {
            StoreContainer.dispatch(SongListRequestSuccess(map));
          });
        }
        return state.copyWith(isLoading: true, id: id);
      case PlayAllAction:
        // 绑定播放列表
        MusicPlayer.bindMusicList(state.musics);
        // 跳转播放页面
        jumpPageByName(action.payload, PathName.ROUTE_MUSIC_PLAY);
        return state;
    }
    return state;
  }
}
