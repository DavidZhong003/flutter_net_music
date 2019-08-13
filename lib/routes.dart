import 'package:flutter/material.dart';
import 'package:flutter_net_music/screen/main_page.dart';


class Path {
  static const ROUTE_MAIN = Navigator.defaultRouteName;

  static const ROUTE_LOGIN = "/login";
}

///app routers
final Map<String, WidgetBuilder> routes = {
  Path.ROUTE_MAIN : (context) => MainPage()
};

