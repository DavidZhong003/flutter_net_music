import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/song_list.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/song_list.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///歌单列表
///
///
class SongsListPage extends StatelessWidget {
  final String id;

  const SongsListPage({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, SongListPageState>(
        converter: (store) => store.state.songListPageState,
        onInit: requestSongDetail(),
        builder: (BuildContext context, SongListPageState state) {
          if (state.isLoading) {
            return WaveLoading();
          }
          final map = state.songsDetail;
          if (map.isEmpty) {
            return CommonErrorWidget(onTap: requestSongDetail(),);
          }
          final Map<String, dynamic> playlist = map["playlist"];
          final Map<String, dynamic> creator = playlist["creator"];
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: 336,
                flexibleSpace: SongFlexibleSpaceBar(
                  collapsedTitle: playlist["name"],
                  expandedTitle: "歌单",
                  content: SongCoverContent(
                    shareCount: playlist["shareCount"].toString(),
                    coverUrl: playlist["coverImgUrl"],
                    title: playlist["name"],
                    creatorName: creator["nickname"],
                    creatorUrl: creator["avatarUrl"],
                    playCount: playlist["playCount"].toString(),
                    description: playlist["description"],
                    onCoverTap: emptyTap,
                    onCreatorTap: emptyTap,
                    commentCount: playlist["commentCount"].toString(),
                  ),
                  background: HeadBlurBackground(
                    imageUrl: playlist["coverImgUrl"],
                  ),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.search), onPressed: emptyTap),
                    PopupMenuButton(itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text("选择歌曲排序"),
                        ),
                        PopupMenuItem(
                          child: Text("选择歌曲排序"),
                        ),
                        PopupMenuItem(
                          child: Text("选择歌曲排序"),
                        ),
                      ];
                    })
                  ],
                ),
                bottom: SuspendedMusicHeader(playlist["trackCount"]),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      color: Colors.grey,
                      height: 1000,
                    )
                  ]))
            ],
          );
        },
      ),
    );
  }

  requestSongDetail() => StoreContainer.dispatch(SongsListRequestAction(id));

}


/// 歌单表头Bar
/// 类似[FlexibleSpaceBar]
/// 主要对它进行改造
class SongFlexibleSpaceBar extends StatefulWidget {
  final Widget background;

  final Widget content;

  //展开时候的title
  final String expandedTitle;

  //收时候title
  final String collapsedTitle;

  final List<Widget> actions;

  const SongFlexibleSpaceBar({
    Key key,
    this.background,
    this.expandedTitle,
    this.collapsedTitle,
    this.content,
    this.actions,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SongFlexibleSpaceBarState();
  }
}

class _SongFlexibleSpaceBarState extends State<SongFlexibleSpaceBar> {
  @override
  Widget build(BuildContext context) {
    ///提供大小以及不透明度信息
    final FlexibleSpaceBarSettings settings =
        context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    assert(settings != null,
        'A FlexibleSpaceBar must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().');

    final List<Widget> children = <Widget>[];

    ///可展开高度
    final double deltaExtent = settings.maxExtent - settings.minExtent;

    // 0.0 -> Expanded 完全展开
    // 1.0 -> Collapsed to toolbar  变成toolbar
    final double t =
        (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
            .clamp(0.0, 1.0);

    // background image
    if (widget.background != null) {
      // 去除不透明
      children.add(Positioned(
        top: -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t),
        left: 0.0,
        right: 0.0,
        height: settings.maxExtent,
        child: widget.background,
      ));
    }

    /// bottom padding
    double bottomPadding = 0;
    SliverAppBar sliverBar = context.ancestorWidgetOfExactType(SliverAppBar);
    if (sliverBar != null && sliverBar.bottom != null) {
      bottomPadding = sliverBar.bottom.preferredSize.height;
    }

    /// Title 封装
    double barHeight = settings.minExtent - bottomPadding;
    Widget title = Text(
      settings.maxExtent - settings.currentExtent > barHeight
          ? widget.collapsedTitle
          : widget.expandedTitle,
    );
    children.add(AppBar(
      backgroundColor: Colors.transparent,
      title: title,
      actions: widget.actions ?? [],
    ));

    /// 添加content
    children.add(Positioned(
      top: settings.currentExtent -
          settings.maxExtent +
          settings.minExtent -
          bottomPadding,
      left: 0,
      right: 0,
      height: settings.maxExtent - bottomPadding,
      child: Opacity(
        opacity: 1 - t,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Material(
              child: widget.content, elevation: 0, color: Colors.transparent),
        ),
      ),
    ));
    return ClipRect(
      child: Stack(
        children: children,
      ),
    );
  }
}

///音乐列表头
///[count] 列表数量
///[tail] 尾部收藏按钮
class SuspendedMusicHeader extends StatelessWidget
    implements PreferredSizeWidget {
  SuspendedMusicHeader(this.count, {this.tail});

  final int count;

  final Widget tail;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        child: InkWell(
          onTap: () {},
          child: SizedBox.fromSize(
            size: preferredSize,
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 16)),
                Icon(
                  Icons.play_circle_outline,
                  color: Theme.of(context).iconTheme.color,
                ),
                Padding(padding: EdgeInsets.only(left: 4)),
                Text(
                  "播放全部",
                  style: Theme.of(context).textTheme.body1,
                ),
                Padding(padding: EdgeInsets.only(left: 2)),
                Text(
                  "(共$count首)",
                  style: Theme.of(context).textTheme.caption,
                ),
                Spacer(),
                tail,
              ]..removeWhere((v) => v == null),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

///头部高斯模糊背景
class HeadBlurBackground extends StatelessWidget {
  final String imageUrl;

  const HeadBlurBackground({Key key, @required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: NetImageView(
            fit: BoxFit.cover,
            url: imageUrl,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(color: Colors.black.withOpacity(0.3)),
        )
      ],
    );
  }
}

/// 头部封面
///
///
///
class SongCoverContent extends StatelessWidget {
  final String coverUrl;

  final String title;

  final String description;

  final String creatorUrl;

  final String creatorName;

  final String playCount;

  final String commentCount;

  final String shareCount;

  final GestureTapCallback onCoverTap;

  final GestureTapCallback onCreatorTap;

  final GestureTapCallback onCommentTap;

  final GestureTapCallback onShareTap;

  final GestureTapCallback onDownTap;

  final GestureTapCallback onMultipleSelectTap;

  const SongCoverContent(
      {Key key,
      @required this.coverUrl,
      @required this.title,
      @required this.description,
      @required this.creatorUrl,
      @required this.creatorName,
      @required this.onCoverTap,
      @required this.onCreatorTap,
      @required this.playCount,
      this.onCommentTap,
      this.onShareTap,
      this.onDownTap,
      this.onMultipleSelectTap,
      @required this.commentCount,
      @required this.shareCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(),
      child: Column(
        children: <Widget>[
          _buildContent(context),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _ActionButton(FontAwesomeIcons.commentDots, commentCount ?? "留言",
                  onCommentTap),
              _ActionButton(Icons.share, shareCount ?? "分享", onShareTap),
              _ActionButton(FontAwesomeIcons.cloudDownloadAlt, "下载", onDownTap),
              _ActionButton(
                  FontAwesomeIcons.checkDouble, "多选", onMultipleSelectTap),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black54,
          Colors.black26,
          Colors.transparent,
          Colors.transparent,
        ]);
    return GestureDetector(
      onTap: onCoverTap,
      child: Container(
        height: 150,
        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Row(
          children: <Widget>[
            ///图片
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: gradient),
                child: Stack(
                  children: <Widget>[
                    NetImageView(
                      url: coverUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 4,
                      right: 8,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.play_arrow,
                              color: theme.primaryIconTheme.color, size: 14),
                          Text(
                            playCount ?? "",
                            style: theme.primaryTextTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///间隔
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    title ?? "",
                    style: theme.primaryTextTheme.title.copyWith(
                      fontSize: 17,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  //作者封面
                  Expanded(
                    child: GestureDetector(
                      onTap: onCreatorTap,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipOval(
                              child: NetImageView(
                                width: 24,
                                height: 24,
                                url: creatorUrl ?? "",
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              creatorName ?? "",
                              style: theme.primaryTextTheme.caption,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 18,
                              color: theme.primaryIconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  //描述
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 160),
                        child: Opacity(
                          opacity: 0.8,
                          child: Text(
                            description ?? "",
                            softWrap: true,
                            style: theme.primaryTextTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 18,
                        color: theme.primaryIconTheme.color,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  _ActionButton(this.icon, this.text, this.onTap);

  final IconData icon;

  final String text;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).primaryTextTheme;

    return InkResponse(
      onTap: onTap,
      splashColor: textTheme.body1.color,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Opacity(
          opacity: onTap == null ? 0.7 : 1,
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: textTheme.body1.color,
              ),
              const Padding(padding: EdgeInsets.only(top: 4)),
              Text(
                text,
                style: textTheme.caption,
              )
            ],
          ),
        ),
      ),
    );
  }
}
