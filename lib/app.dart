import 'package:flutter/material.dart';
import 'package:flutter_net_music/theme.dart';
import 'package:redux/redux.dart';

/// app
/// 主要信息:
/// 全局设置
/// 路由
@immutable
// ignore: must_be_immutable
class AppState {
  ThemeState _themeState;

  ThemeState get themeState => _themeState;

  AppState.initState() {
    _themeState = ThemeState.initState();
  }

  AppState(this._themeState);

  AppState.changeTheme(ThemeData themeData){
    _themeState = ThemeState(themeData);
  }
}

enum AppAction {
  changeTheme,
}

AppState _redux(AppState state, action) {
  if(action == AppAction.changeTheme){
    return AppState.changeTheme(quietThemes[1]);
  }
  return state;
}

final appStore = Store<AppState>(_redux, initialState: AppState.initState());
