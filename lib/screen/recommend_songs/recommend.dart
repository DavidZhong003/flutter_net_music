import 'package:flutter/material.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/recommend_songs.dart';
import 'package:flutter_net_music/redux/actions/song_list.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/recommend_songs.dart';
import 'package:flutter_net_music/screen/music_play_contorl.dart';
import 'package:flutter_net_music/screen/play_page/play_bar.dart';
import 'package:flutter_net_music/screen/song_list/song_list.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RecommendSongsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, b) {
          return [_RecommendHead()];
        },
        body: MusicPlayBarContainer(child: _buildContent(context)),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StoreConnector<AppState, RecommendSongsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return WaveLoading();
          }
          var musics = state.musics;
          //具体音乐条目
          return MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final song = musics[index];
                return SongListItemWidget.formMusicTrackBean(
                  song,
                  isPlaying: MusicPlayList.currentSongId==song.id,
                  albumPicUrl: song.album.picUrl,
                  leadingPaddingRight: 8,
                  onItemTap: () {
                    //播放某个歌曲
                    StoreContainer.dispatch(PlaySongAction(song.id));
                  },
                );
              },
              itemCount: musics.length,
              shrinkWrap: true,
              itemExtent: 60,
              physics: const NeverScrollableScrollPhysics(),
            ),
          );
        },
        onInit: (s) => s.dispatch(RequestRecommendSongs()),
        converter: (s) => s.state.recommendSongsState);
  }
}

///头部
class _RecommendHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = ThemeData.dark().textTheme;
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      expandedHeight: 220,
      iconTheme: ThemeData.dark().iconTheme,
      flexibleSpace: SongFlexibleSpaceBar(
        collapsedTitle: "每日推荐",
        titleTextStyle: textTheme.title,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.help_outline),
          ),
        ],
        content: _buildContent(context),
      ),
      bottom: SuspendedMusicHeader(
        tail: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.list),
            Text("多选"),
          ],
        ),
        onPlayAllTap: () {
          StoreContainer.dispatch(PlayAllRecommendSong(context));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textTheme = ThemeData.dark().textTheme;
    final now = DateTime.now();
    final day = now.day < 10 ? "0${now.day}" : now.day.toString();
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(TextSpan(
                children: [
                  TextSpan(
                      text: day,
                      style: textTheme.display4.copyWith(fontSize: 40)),
                  TextSpan(
                      text: "/${now.month}",
                      style: textTheme.display4.copyWith(fontSize: 20)),
                ],
              )),
              _buildRow(context),
            ],
          ),
        )
      ],
    );
  }

  Row _buildRow(BuildContext context) {
    List<Widget> children = [];
    children.add(
      Transform(
        transform: Matrix4.identity()..scale(0.75),
        child: Chip(
          label: Text("历史日推"),
        ),
      ),
    );
    return Row(
      children: children,
    );
  }
}
