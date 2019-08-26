import 'package:flutter/material.dart';
import 'package:flutter_net_music/redux/actions/home_found.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
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

  HomeFoundState({this.bannerState});

  HomeFoundState.initialState() : bannerState = BannerState.initialState();

  HomeFoundState copyWith({BannerState bannerState}) {
    return HomeFoundState(bannerState: bannerState ?? this.bannerState);
  }
}

class HomeFoundReducer extends Reducer<HomeFoundState> {
  @override
  HomeFoundState redux(HomeFoundState state, action) {
    return state.copyWith(
        bannerState: BannerReducer().redux(state.bannerState, action));
  }
}
