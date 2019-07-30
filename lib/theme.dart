//app主题
import 'package:flutter/material.dart';

final quietThemes = [
  _buildTheme(Colors.white),
  _buildTheme(Colors.red),
  _buildTheme(Colors.blue),
  _buildTheme(Colors.green),
  _buildTheme(Colors.amber),
  _buildTheme(Colors.teal),
  ThemeData.dark(),
];

ThemeData _buildTheme(Color primaryColor) {
  return ThemeData(
    primaryColor: primaryColor,
    dividerColor: Color(0xfff5f5f5),
    iconTheme: IconThemeData(color: Color(0xFFb3b3b3)),
  );
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

enum ChangeThemeAction { whiteTheme, redTheme, blue, green, amber, teal, dark }
