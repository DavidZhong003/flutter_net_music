import 'package:flutter_net_music/redux/actions/login.dart';

import 'main.dart';
import 'package:flutter/material.dart';

const String _EMPTY = "";
const int _EMPTY_ID = -1;

@immutable
class UserInfoState {
  final int userId;

  final String nickname;

  final String avatarUrl;

  final String phone;

  UserInfoState({this.phone, this.nickname, this.userId, this.avatarUrl});

  UserInfoState copyWith({int userId, String avatarUrl, String name}) {
    return UserInfoState(
      userId: userId ?? this.userId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nickname: name ?? this.nickname,
    );
  }

  UserInfoState.initialState()
      : userId = _EMPTY_ID,
        nickname = _EMPTY,
        phone = _EMPTY,
        avatarUrl = _EMPTY;

  bool get isLogin => userId != -1;
}

class UserReducer extends Reducer<UserInfoState> {
  @override
  UserInfoState redux(UserInfoState state, action) {
    switch (action.runtimeType) {
      case LoginSuccessAction:
        Map<String, dynamic> map = action.payload;
        return state.copyWith(
            userId: map["account"]["id"],
            avatarUrl: map["profile"]["avatarUrl"],
            name: map["profile"]["nickname"]);
    }
    return state;
  }
}
