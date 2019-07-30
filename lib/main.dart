import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'app.dart';

void main() {
  runApp(MyApp());
  /// android 平台全透明
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: appStore,
      child: StoreConnector<AppState, ThemeData>(
          builder: (context, theme) {
            return buildMaterialApp(theme);
          },
          converter: (store) => store.state.themeState.theme),
    );
  }

  MaterialApp buildMaterialApp(ThemeData theme) {
    return MaterialApp(
      theme: theme,
      routes: routes,
    );
  }
}
