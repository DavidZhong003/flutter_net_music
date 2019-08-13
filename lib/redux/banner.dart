import 'package:flutter/material.dart';
import 'package:flutter_net_music/net/netApi.dart';
enum BannerAction{
  loadBanner
}

@immutable
// ignore: must_be_immutable
class BannerState {
  bool isLoading;
  bool isError;
  bool loadDateComplete;
  Map<String, dynamic> banner;

  BannerState.initState() {
    isLoading = true;
    isError = false;
    loadDateComplete = false;
  }
}
class BannerReducer{
  static BannerState reducer(BannerState state, action){
    if(action==BannerAction.loadBanner){

    }
    return state;
  }
}