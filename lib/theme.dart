//app主题
import 'package:flutter/material.dart';

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
      iconTheme: IconThemeData(color: Color(primaryColor.value-200)),
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

enum ChangeThemeAction { whiteTheme, redTheme, blue, green, amber, teal, dark }
