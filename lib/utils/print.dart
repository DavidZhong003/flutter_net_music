import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
class PrintUtil {
  /// 通用打印方法，Release 不会打印，超长字符串分段打印
  static print(dynamic message) {
    if (message != null) {
      var content = message.toString();
      if (content == '') {
        debugPrint('${DateTimeUtil.dateTimeNowIso()} ');
        return;
      }
      while (content.length > 800) {
        debugPrint(
            '${DateTimeUtil.dateTimeNowIso()} ${content.substring(0, 800)}');
        content = content.substring(800, content.length);
      }
      if (content != '')
        debugPrint('${DateTimeUtil.dateTimeNowIso()} $content');
    }
  }
}

class DateTimeUtil {
  static String dateTimeNowIso() => DateTime.now().toIso8601String();

  static int dateTimeNowMilli() => DateTime.now().millisecondsSinceEpoch;
}
var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
  ),
);
