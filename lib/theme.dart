//app主题
import 'package:flutter/material.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';

final quietThemes = [
  ThemeData(
      primaryColor: Colors.white,
      buttonColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black87),
      accentColor: Colors.black),
  _buildTheme(Colors.red),
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
// ignore: must_be_immutable
class ThemeState {
  ThemeData _theme;

  ThemeData get theme => _theme ?? quietThemes.first;

  ThemeState(this._theme);

  ThemeState.initState() {
    _theme = quietThemes.first;
  }
}

class ChangeThemeAction extends ActionType<int> {
  final int index;

  ChangeThemeAction(this.index) : super(payload: index);
}

class ThemeReducer extends Reducer<ThemeState> {
  @override
  ThemeState redux(ThemeState state, ActionType action) {
    switch (action.runtimeType) {
      case ChangeThemeAction:
        return ThemeState(quietThemes[action.payload < 0 ? 0 : action.payload]);
    }
    return state;
  }
}
