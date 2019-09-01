import 'package:flutter/material.dart';

class MyIcons {
  //&#xe660
  static const IconData repeat = const _MyIconData(0xe660);
  static const IconData repeat_one = const _MyIconData(0xe65b);
  static const IconData random = const _MyIconData(0xef9b);
  static const IconData play = const _MyIconData(0xe618);
  static const IconData pause = const _MyIconData(0xe6bc);
  static const IconData skip_previous = const _MyIconData(0xe600);
  static const IconData skip_next = const _MyIconData(0xe633);
  static const IconData play_list = const _MyIconData(0xe643);
}

class _MyIconData extends IconData {
  const _MyIconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'iconfont',
          matchTextDirection: true,
        );
}
