//app主题
import 'package:flutter/material.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';

final quietThemes = [
  _buildTheme(Colors.red),
  ThemeData(
      primaryColor: Colors.white,
      buttonColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black87),
      accentColor: Colors.black),
  _buildTheme(Colors.blue),
  _buildTheme(Colors.green),
  _buildTheme(Colors.amber),
  _buildTheme(Colors.teal),
  ThemeData.dark(),
];

ThemeData _buildTheme(Color primaryColor, {Color buttonColor}) {
  return ThemeData(
      primaryColor: primaryColor,
//    dividerColor: Colors.,
      buttonColor: buttonColor ?? primaryColor,
      iconTheme: IconThemeData(color: Color(primaryColor.value - 200)),
      accentColor: primaryColor);
}

@immutable
class ThemeState {

  final ThemeData theme;

  final ThemeData lastTheme;

  ThemeState({this.theme, this.lastTheme});

  ThemeState.initState()
      : theme = quietThemes.first,
        lastTheme = quietThemes.first;

  bool isNightMode() => theme == ThemeData.dark();

  ThemeState copyWith({
    ThemeData theme,
    ThemeData lastTheme,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
      lastTheme: lastTheme??this.lastTheme,
    );
  }
}

class ChangeThemeAction extends ActionType<int> {
  final int index;

  ChangeThemeAction(this.index) : super(payload: index);
}

class ChangeNightTheme extends ActionType<bool> {
  final bool isNight;

  ChangeNightTheme(this.isNight) : super(payload: isNight);
}

class ThemeReducer extends Reducer<ThemeState> {
  @override
  ThemeState redux(ThemeState state, action) {
    switch (action.runtimeType) {
      case ChangeThemeAction:
        final now = quietThemes[action.payload < 0 ? 0 : action.payload];
        return state.copyWith(theme: now, lastTheme: state.theme);
      case ChangeNightTheme:
        bool isNight = action.payload;
        final last = state.theme;
        return state.copyWith(
            theme: isNight ? quietThemes.last : state.lastTheme,
            lastTheme: last);
    }
    return state;
  }
}
