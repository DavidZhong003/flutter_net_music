import 'package:flutter/material.dart';
import 'package:flutter_net_music/theme.dart';
import 'package:redux/redux.dart';

/// app
/// 主要信息:
/// 全局设置
/// 路由

class AppState {
  ThemeState _themeState;

  ThemeState get themeState => _themeState;

  AppState.initState() {
    _themeState = ThemeState.initState();
  }
}

enum AppAction {
  changeTheme,
}

AppState _redux(AppState state, action) {
  return state;
}

final appStore = Store<AppState>(_redux, initialState: AppState.initState());
