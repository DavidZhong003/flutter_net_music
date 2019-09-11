import 'package:flutter/material.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/home_found.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';

@immutable
class BannerState {
  final bool isLoading;

  final Map<String, dynamic> banner;

  BannerState({this.isLoading, this.banner});

  BannerState copyWith({bool isLoading, Map<String, dynamic> banner}) {
    return BannerState(
        isLoading: isLoading ?? this.isLoading, banner: banner ?? this.banner);
  }

  BannerState.initialState()
      : isLoading = true,
        banner = {};
}

class BannerReducer extends Reducer<BannerState> {
  @override
  BannerState redux(BannerState state, action) {
    switch (action.runtimeType) {
      case LoadBanner:
        return state.copyWith(isLoading: true);
      case LoadBannerSuccess:
        return state.copyWith(isLoading: false, banner: action.payload);
    }
    return state;
  }
}

@immutable
class HomeFoundState {
  final BannerState bannerState;

  final PersonalizedSongState personalizedSongState;

  final NewSongAlbumsState newSongAlbumsState;

  HomeFoundState(
      {this.bannerState, this.personalizedSongState, this.newSongAlbumsState});

  HomeFoundState.initialState()
      : bannerState = BannerState.initialState(),
        newSongAlbumsState = NewSongAlbumsState.initialState(),
        personalizedSongState = PersonalizedSongState.initialState();

  HomeFoundState copyWith({
    BannerState bannerState,
    PersonalizedSongState personalizedSongState,
    NewSongAlbumsState newSongAlbumsState,
  }) {
    return HomeFoundState(
        bannerState: bannerState ?? this.bannerState,
        newSongAlbumsState: newSongAlbumsState ?? this.newSongAlbumsState,
        personalizedSongState:
            personalizedSongState ?? this.personalizedSongState);
  }
}

class HomeFoundReducer extends Reducer<HomeFoundState> {
  @override
  HomeFoundState redux(HomeFoundState state, action) {
    return state.copyWith(
      bannerState: BannerReducer().redux(state.bannerState, action),
      newSongAlbumsState:
          NewSongAlbumsReducer().redux(state.newSongAlbumsState, action),
      personalizedSongState:
          PersonalizedSongReducer().redux(state.personalizedSongState, action),
    );
  }
}

/// 推荐歌单
///
@immutable
class PersonalizedSongState {
  final bool isLoading;

  final Map<String, dynamic> originData;

  final List<dynamic> showList;

  PersonalizedSongState({
    this.isLoading,
    this.originData,
    this.showList,
  });

  PersonalizedSongState copyWith(
      {bool isLoading,
      Map<String, dynamic> originData,
      List<dynamic> showData}) {
    return PersonalizedSongState(
        isLoading: isLoading ?? this.isLoading,
        originData: originData ?? this.originData,
        showList: showData ?? this.showList);
  }

  PersonalizedSongState.initialState()
      : isLoading = true,
        showList = [],
        originData = {};
}

class PersonalizedSongReducer extends Reducer<PersonalizedSongState> {
  @override
  PersonalizedSongState redux(PersonalizedSongState state, action) {
    switch (action.runtimeType) {
      case LoadPersonalizedSong:
        return state.copyWith(isLoading: true);
      case LoadPersonalizedSongSuccess:
        Map<String, dynamic> originData = action.payload;
        List<dynamic> showList = state.showList;
        if (showList.isEmpty) {
          showList = _randomDate(originData);
        }
        return state.copyWith(
          isLoading: false,
          originData: originData,
          showData: showList,
        );
      case ObtainPersonalizedSong:
        return state.copyWith(
          isLoading: false,
          showData: _randomDate(state.originData),
        );
      case RandomPersonalizedSongAction:
        return state.copyWith(showData: _randomDate(state.originData));
    }
    return state;
  }
}

List<dynamic> _randomDate(Map<String, dynamic> originData) {
  if (originData.containsKey("result")) {
    List<dynamic> list = originData["result"];
    if (list.length > 6) {
      List<dynamic> send = list.sublist(2)..shuffle();
      return list.take(2).toList()..addAll(send.take(4));
    }
  }
  return [];
}

///新歌/新碟
///
@immutable
class NewSongAlbumsState {
  final List<dynamic> songData;
  final List<dynamic> albumsData;
  final bool isLoading;

  NewSongAlbumsState({this.songData, this.isLoading,this.albumsData});

  NewSongAlbumsState copyWith({
    bool isLoading,
    List<dynamic> songData,
    List<dynamic> albumsData,
  }) {
    return NewSongAlbumsState(
      isLoading: isLoading ?? this.isLoading,
      songData: songData ?? this.songData,
      albumsData: albumsData??this.albumsData,
    );
  }

  NewSongAlbumsState.initialState()
      : isLoading = true,
        albumsData=[],
        songData = [];
}

class NewSongAlbumsReducer extends Reducer<NewSongAlbumsState> {
  @override
  NewSongAlbumsState redux(NewSongAlbumsState state, action) {
    switch (action.runtimeType) {
      case NewSongRequestAction:
        ApiService.getNewSongs();
        return state.copyWith(isLoading: true);
      case NewAlbumsRequestAction:
        ApiService.getNewAlbums();
        return state.copyWith(isLoading: true);
      case NewSongRequestSuccessAction:
        return state.copyWith(isLoading: false,songData: action.payload);
      case NewAlbumsRequestSuccessAction:
        return state.copyWith(isLoading: false,albumsData: action.payload);
    }
    return state;
  }
}
