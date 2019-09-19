import 'package:flutter/material.dart';

class MyIcons {
  //&#xe660
  static const IconData repeat = const _MyIconData(0xe63d);
  static const IconData repeat_one = const _MyIconData(0xe615);
  static const IconData random = const _MyIconData(0xe605);
  static const IconData play = const _MyIconData(0xe618);
  static const IconData pause = const _MyIconData(0xe6bc);
  static const IconData skip_previous = const _MyIconData(0xe600);
  static const IconData skip_next = const _MyIconData(0xe633);
  static const IconData play_list = const _MyIconData(0xe716);
  static const IconData comment_lines = const _MyIconData(0xe7c4);
  static const IconData share = const _MyIconData(0xe6ca);
  static const IconData download_cloud = const _MyIconData(0xe610);
  static const IconData check_all = const _MyIconData(0xe91a);
  static const IconData mv = const _MyIconData(0xe601);
  static const IconData delete_item = const _MyIconData(0xe603);
  static const IconData volume_up = const _MyIconData(0xe6c0);

  static const IconData exit = const _MyIconData(0xe604);
  static const IconData time = const _MyIconData(0xe632);
  static const IconData mall = const _MyIconData(0xe602);
  static const IconData ticket = const _MyIconData(0xe6cb);
  static const IconData order_form = const _MyIconData(0xe6cb);
  static const IconData moon = const _MyIconData(0xe741);
  static const IconData sun = const _MyIconData(0xe606);
  static const IconData bell = const _MyIconData(0xe86a);
  static const IconData setting = const _MyIconData(0xe607);
}

class _MyIconData extends IconData {
  const _MyIconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'iconfont',
          matchTextDirection: true,
        );
}
