import 'package:flutter/material.dart' show immutable;
import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/login.dart';
import 'package:flutter_net_music/redux/actions/mine_tab.dart';
import 'package:flutter_net_music/utils/shared_preferences_helper.dart';

import 'main.dart';

///用户歌单
@immutable
class UserSongListState {
  final List<PlayListsModel> createSongList;

  final List<PlayListsModel> subSongList;

  UserSongListState({this.createSongList, this.subSongList});

  UserSongListState copyWith(
      {List<PlayListsModel> createSongList, List<PlayListsModel> subSongList}) {
    return UserSongListState(
      createSongList: createSongList ?? this.createSongList,
      subSongList: subSongList ?? this.createSongList,
    );
  }

  UserSongListState.initialState()
      : createSongList = [],
        subSongList = [];
}

class UserSongListReducer extends Reducer<UserSongListState> {
  @override
  UserSongListState redux(UserSongListState state, action) {
    switch (action.runtimeType) {
      case LoadUserSongList:
        ApiService.getUserPlayList(
          action.payload,
          successHandler: (map) {
            List<PlayListsModel> create = [];
            List<PlayListsModel> sub = [];
            List<dynamic> list = map["playlist"];
            list.forEach((playList) {
              int userId = playList["userId"];
              PlayListsModel model = PlayListsModel.fromMap(playList);
              print("doive,model=$model");
              if (userId == action.payload) {
                create.add(model);
              } else {
                sub.add(model);
              }
            });
            SpHelper.saveUserSongListInfo(map);
            return LoadUserSongListSuccessAction(create, sub);
          },
        );
        return state;

      ///加载成功
      case LoadUserSongListSuccessAction:
        return state.copyWith(
            createSongList: action.create, subSongList: action.sub);

      case InitUserSongListAction:
        Map<String, dynamic> map = SpHelper.getUserSongList();
        List<PlayListsModel> create = [];
        List<PlayListsModel> sub = [];
        List<dynamic> list = map["playlist"];
        final selfId = SpHelper.getUserInfo()["account"]["id"];
        list?.forEach((playList) {
          int userId = playList["userId"];
          PlayListsModel model = PlayListsModel.fromMap(playList);
          if (userId == selfId) {
            create.add(model);
          } else {
            sub.add(model);
          }
        });
        return state.copyWith(createSongList: create,subSongList: sub);
      case LogoutAction:
        SpHelper.cleanUserSongList();
        return UserSongListState.initialState();
    }
    return state;
  }
}
