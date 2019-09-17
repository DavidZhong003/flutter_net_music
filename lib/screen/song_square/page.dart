import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/screen/play_page/play_bar.dart';
import 'package:flutter_net_music/screen/song_list/song_list.dart';
import 'package:flutter_net_music/screen/song_square/recommend.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SongSquarePage extends StatelessWidget {
  static const List<String> _tabs = ["推荐", "官方", "精品", "华语", "流行"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: MusicPlayBarContainer(
          child: _buildTabBarView(),
        ),
      ),
    );
  }

  TabBarView _buildTabBarView() {
    List<Widget> children = [];
    children.add(RecommendTab());
    children.add(RecommendTab());
    children.add(RecommendTab());
    children.add(RecommendTab());
    children.add(RecommendTab());
    return TabBarView(
      children: children,
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
              isScrollable: _tabs.length>5,
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
    return StoreConnector<AppState, String>(
        builder: (BuildContext context,String url){
          if(url==null||url.isEmpty){
            return Container(color: Theme.of(context).primaryColor,);
          }
          return HeadBlurBackground(
            stackFit: StackFit.expand,
            opacity: 0.65,
            imageUrl: url,
            isFullScreen: false,
          );
        }, converter: (s) => s.state.songSquareState.backImage);
  }
}
