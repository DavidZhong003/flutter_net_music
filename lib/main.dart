import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_net_music/utils/shared_preferences_helper.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SpHelper.init();
  runApp(MyApp());
  /// android 平台全透明
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  /// 远程action debug
  StoreContainer.connect();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: StoreContainer.global,
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
      navigatorKey: navigatorKey,
    );
  }
}
