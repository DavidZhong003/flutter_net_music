import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/song_square.dart';

import 'main.dart';
import 'package:flutter/material.dart';

@immutable
class SongSquareState {
  final String backImage;

  final RecommendState recommendState;

  SongSquareState({this.backImage, this.recommendState});

  SongSquareState copyWith({
    String backImage,
    RecommendState recommendState,
  }) {
    return SongSquareState(
        backImage: backImage ?? this.backImage,
        recommendState: recommendState ?? this.recommendState);
  }

  SongSquareState.initialState()
      : backImage = "",
        recommendState = RecommendState.initialState();
}

class SongSquareReducer extends Reducer<SongSquareState> {
  @override
  SongSquareState redux(SongSquareState state, action) {
    RecommendState recommendState =
        RecommendReducer().redux(state.recommendState, action);
    switch (action.runtimeType) {
      case ChangeBackImageAction:
        return state.copyWith(
            backImage: action.payload, recommendState: recommendState);
    }
    return state.copyWith(recommendState: recommendState);
  }
}

@immutable
class RecommendState {
  final List<PlayListsModel> banner;
  final List<PlayListsModel> list;

  final bool loading;

  RecommendState({this.banner, this.list, this.loading});

  RecommendState copyWith({
    List<PlayListsModel> banner,
    List<PlayListsModel> list,
    bool loading,
  }) {
    return RecommendState(
        banner: banner ?? this.banner,
        list: list ?? this.banner,
        loading: loading ?? this.loading);
  }

  RecommendState.initialState()
      : banner = [],
        loading = true,
        list = [];

  bool get needRequest => banner.isEmpty || list.isEmpty;
}

class RecommendReducer extends Reducer<RecommendState> {
  @override
  RecommendState redux(RecommendState state, action) {
    switch (action.runtimeType) {
      case RecommendRequestAction:
        if (state.needRequest) {
          ApiService.getPersonalized(
              limit: -1,
              successHandler: (map) {
                List<dynamic> result = map["result"];
                return RecommendSuccessAction(result
                    .map((bean) => PlayListsModel.fromRecommendMap(bean))
                    .toList());
              });
        }
        return state.copyWith(loading: state.needRequest);
      case RecommendSuccessAction:
        final List<PlayListsModel> list = action.payload;
        return state.copyWith(
            loading: false,
            banner: list.sublist(0, 3),
            list: list.sublist(3, list.length));
    }
    return state;
  }
}
