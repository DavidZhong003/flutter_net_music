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
  static const IconData play_list = const _MyIconData(0xe716);
  static const IconData comment_lines = const _MyIconData(0xe7c4);
  static const IconData share = const _MyIconData(0xe6ca);
  static const IconData download_cloud = const _MyIconData(0xe610);
  static const IconData check_all = const _MyIconData(0xe91a);
}

class _MyIconData extends IconData {
  const _MyIconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'iconfont',
          matchTextDirection: true,
        );
}
