import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/song_list.dart';

import 'main.dart';

import 'package:flutter/material.dart';

@immutable
class SongListPageState {
  final bool isLoading;

  final String id;

  final Map<String, dynamic> songsDetail;

  SongListPageState({this.id, this.isLoading, this.songsDetail});

  SongListPageState copyWith(
      {bool isLoading, Map<String, dynamic> songsDetail, String id}) {
    return SongListPageState(
        isLoading: isLoading ?? this.isLoading,
        id: id ?? this.id,
        songsDetail: songsDetail ?? this.songsDetail);
  }

  SongListPageState.initialState()
      : isLoading = true,
        id = "",
        songsDetail = {};
}

class SongListReducer extends Reducer<SongListPageState> {
  @override
  SongListPageState redux(SongListPageState state, action) {
    switch (action.runtimeType) {
      case SongListRequestSuccess:
        return state.copyWith(isLoading: false, songsDetail: action.payload);
      case RequestSongsListAction:
        String id = action.payload;
        if(state.id==id&&state.songsDetail.isNotEmpty){
          return state;
        }else{
          ApiService.getSongListDetails(id).then((map) {
            StoreContainer.dispatch(SongListRequestSuccess(map));
          });
        }
        return state.copyWith(isLoading: true, id: id);
    }
    return state;
  }
}
