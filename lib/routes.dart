import 'package:flutter/material.dart';
import 'package:flutter_net_music/screen/main_page.dart';
import 'package:flutter_net_music/screen/songList/song_list.dart';

class Path {
  static const ROUTE_MAIN = Navigator.defaultRouteName;

  static const ROUTE_LOGIN = "/login";
}

///app routers
final Map<String, WidgetBuilder> routes = {
  Path.ROUTE_MAIN: (context) => MainPage()
};
///跳转歌单列表页
void jumpSongList(BuildContext context, String id) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return SongsListPage(
      id: id,
    );
  }));
}
