import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/redux/actions/recommend_songs.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_net_music/screen/music_play_contorl.dart';

import 'main.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
class RecommendSongsState {
  final bool isLoading;

  final List<MusicTrackBean> musics;

  RecommendSongsState({this.isLoading, this.musics});

  RecommendSongsState copyWith({bool isLoading, List<MusicTrackBean> musics}) {
    return RecommendSongsState(
        isLoading: isLoading ?? this.isLoading, musics: musics ?? this.musics);
  }

  RecommendSongsState.initialState()
      : isLoading = true,
        musics = [];
}

class RecommendSongsReducer extends Reducer<RecommendSongsState> {
  @override
  RecommendSongsState redux(RecommendSongsState state, action) {
    switch (action.runtimeType) {
      case RequestRecommendSongs:
        ApiService.getRecommendSongs();
        return state.copyWith(isLoading: true);
      case RequestRecommendSongsSuccess:
        List<dynamic> list = action.payload;
        return state.copyWith(
            isLoading: false,
            musics: list
                .map((l) => MusicTrackBean.fromRecommendSongsMap(l))
                .toList());
      case PlayAllRecommendSong:
        //加载歌单,播放歌曲,跳转页面
        if (state.musics.isNotEmpty) {
          MusicPlayList.bindMusicList(state.musics, RECOMMEND_EVERY_DAY_ID);
          StoreContainer.dispatch(PlayMusicWithIdAction(state.musics[0].id));
          // 跳转播放页面
          jumpPageByName(action.payload, PathName.ROUTE_MUSIC_PLAY);
        }
        return state;
    }
    return state;
  }
}
const RECOMMEND_EVERY_DAY_ID = "每日推荐";