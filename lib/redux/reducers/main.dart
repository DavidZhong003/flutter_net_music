import 'package:flutter/material.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/middleware/main.dart';
import 'package:flutter_net_music/redux/reducers/login.dart';
import 'package:flutter_net_music/redux/reducers/play_bar_list.dart';
import 'package:flutter_net_music/redux/reducers/play_page.dart';
import 'package:flutter_net_music/redux/reducers/recommend_songs.dart';
import 'package:flutter_net_music/redux/reducers/song_list.dart';
import 'package:flutter_net_music/redux/reducers/song_square.dart';
import 'package:flutter_net_music/theme.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'home_found.dart';

@immutable
class AppState {
  final ThemeState themeState;

  final HomeFoundState homeFoundState;

  final SongListPageState songListPageState;

  final PlayPageState musicPlayState;

  final PlayListState playListState;

  final SongSquareState songSquareState;

  final UserInfoState userInfoState;

  final RecommendSongsState recommendSongsState;

  const AppState({
    this.songListPageState,
    this.themeState,
    this.homeFoundState,
    this.musicPlayState,
    this.playListState,
    this.songSquareState,
    this.userInfoState,
    this.recommendSongsState,
  });
}

AppState _initReduxState() {
  return AppState(
    themeState: ThemeState.initState(),
    homeFoundState: HomeFoundState.initialState(),
    songListPageState: SongListPageState.initialState(),
    musicPlayState: PlayPageState.initState(),
    playListState: PlayListState.initState(),
    songSquareState: SongSquareState.initialState(),
    userInfoState: UserInfoState.initialState(),
    recommendSongsState: RecommendSongsState.initialState(),
  );
}

AppState reduxReducer(AppState state, action) => AppState(
      themeState: ThemeReducer().redux(state.themeState, action),
      homeFoundState: HomeFoundReducer().redux(state.homeFoundState, action),
      songListPageState:
          SongListReducer().redux(state.songListPageState, action),
      musicPlayState: PlayPageRedux().redux(state.musicPlayState, action),
      playListState: PlayListRedux().redux(state.playListState, action),
      songSquareState: SongSquareReducer().redux(state.songSquareState, action),
      userInfoState: UserReducer().redux(state.userInfoState, action),
      recommendSongsState:
          RecommendSongsReducer().redux(state.recommendSongsState, action),
    );

abstract class ViewModel {
  final Store<AppState> store;

  ViewModel({this.store});
}

class StoreContainer {
  static final Store<AppState> global = reduxStore();

  static dispatch(dynamic action) => global.dispatch(action);

  static connect() async {
    remoteDevelopTools.store = global;
    await remoteDevelopTools.connect();
  }
}

Store reduxStore() => Store<AppState>(reduxReducer,
    middleware: [
      loggingMiddleware,
      remoteDevelopTools,
      thunkMiddleware,
    ],
    initialState: _initReduxState(),
    distinct: true);

abstract class Reducer<T> {
  T redux(T state, action);
}

abstract class RequestState<T> {
  final bool isLoading;

  final RequestFailureInfo info;

  final T mainDate;

  RequestState({this.mainDate, this.isLoading, this.info});

  bool isSuccess() => mainDate != null && info != null && !isLoading;

  bool isFailure() => info != null;
}
