import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_net_music/screen/play_page/play_bar.dart';
import 'package:flutter_net_music/screen/song_list/song_list.dart';

import '../main_tab_page.dart';

class SongSquarePage extends StatelessWidget {
  static const List<String> _tabs = ["推荐", "官方", "精品", "华语", "流行"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: MusicPlayBarContainer(
          child: Container(
            child: TabBarView(
              children: _tabs
                  .map((s) => Container(
                        child: Text(s),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Stack(
        children: <Widget>[
          _buildBackground(),
          AppBar(
            title: Text("歌单广场"),
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              tabs: _tabs
                  .map((s) => Tab(
                        text: s,
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBackground() {
    final image =
        "https://p1.music.126.net/CKY9WSM1-1SHMc8wRJyccQ==/109951164353129687.jpg";
    return HeadBlurBackground(
      stackFit: StackFit.expand,
      opacity: 0.65,
      imageUrl:image,
      isFullScreen: false,
    );
  }
}
