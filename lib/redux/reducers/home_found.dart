import 'package:flutter/material.dart';
import 'package:flutter_net_music/redux/actions/home_found.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'dart:math';

import 'package:flutter_net_music/utils/print.dart';

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

  HomeFoundState({this.bannerState, this.personalizedSongState});

  HomeFoundState.initialState()
      : bannerState = BannerState.initialState(),
        personalizedSongState = PersonalizedSongState.initialState();

  HomeFoundState copyWith(
      {BannerState bannerState, PersonalizedSongState personalizedSongState}) {
    return HomeFoundState(
        bannerState: bannerState ?? this.bannerState,
        personalizedSongState:
            personalizedSongState ?? this.personalizedSongState);
  }
}

class HomeFoundReducer extends Reducer<HomeFoundState> {
  @override
  HomeFoundState redux(HomeFoundState state, action) {
    return state.copyWith(
      bannerState: BannerReducer().redux(state.bannerState, action),
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
        if(showList.isEmpty){
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