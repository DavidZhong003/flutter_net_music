import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

///弱提示
///
///
Tooltip withToolTips(String msg, Widget child) {
  assert(msg != null && msg.isNotEmpty);
  return Tooltip(
    message: msg,
    child: child,
  );
}

Tooltip notDone(Widget child) => withToolTips("sorry,该功能未完成", child);

void withToast(BuildContext context, String msg) {
  Toast.show(msg, context);
}

void notDoneToast(BuildContext context) => withToast(context, "sorry,该功能未完成");
