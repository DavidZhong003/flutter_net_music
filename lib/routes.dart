import 'package:flutter/material.dart';
import 'package:flutter_net_music/screen/main_page.dart';
import 'package:flutter_net_music/screen/play_page/play_page.dart';
import 'package:flutter_net_music/screen/songList/song_list.dart';

class PathName {
  static const ROUTE_MAIN = Navigator.defaultRouteName;

  static const ROUTE_LOGIN = "/login";

  static const ROUTE_MUSIC_PLAY = "/music/play";
}

///app routers
final Map<String, WidgetBuilder> routes = {
  PathName.ROUTE_MAIN: (context) => MainPage(),
  PathName.ROUTE_MUSIC_PLAY: (context) => MusicPlayPage(),
};

///跳转歌单列表页
void jumpSongList(BuildContext context, String id,[String copywriter]) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return SongsListPage(
      id: id,
      copywriter: copywriter,
    );
  }));
}
void jumpPage(BuildContext context,Widget page){
  Navigator.of(context).push(MaterialPageRoute(builder: (context){return page;}));
}

void jumpPageByName(BuildContext context,String name){
  Navigator.of(context).pushNamed(name);
}
