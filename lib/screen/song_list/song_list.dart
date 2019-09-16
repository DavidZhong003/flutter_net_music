import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/song_list.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/song_list.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';
import 'package:flutter_net_music/screen/play_page/play_bar.dart';
import 'package:flutter_net_music/utils/string.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///歌单列表
///
///
class SongsListPage extends StatelessWidget {
  final String id;

  final String copywriter;

  const SongsListPage({Key key, @required this.id, this.copywriter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MusicPlayBarContainer(
        child: StoreConnector<AppState, SongListPageState>(
          converter: (store) => store.state.songListPageState,
          onInit: requestSongDetail,
          builder: (BuildContext context, SongListPageState state) {
            if (state.isLoading) {
              return WaveLoading();
            }
            final map = state.songsDetail;
            if (map.isEmpty) {
              return CommonErrorWidget(
                onTap: requestSongDetail(StoreContainer.global),
              );
            }
            final Map<String, dynamic> playlist = map["playlist"];
            final Map<String, dynamic> creator = playlist["creator"];
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  expandedHeight: 336,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: SongFlexibleSpaceBar(
                    collapsedTitle: playlist["name"],
                    expandedTitle: "歌单",
                    subTitle: copywriter,
                    content: SongCoverContent(
                      shareCount: playlist["shareCount"].toString(),
                      coverUrl: playlist["coverImgUrl"],
                      title: playlist["name"],
                      creatorName: creator["nickname"],
                      creatorUrl: creator["avatarUrl"],
                      playCount: formattedNumber(playlist["playCount"]),
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
                            child: ListIconTitle(
                              Icons.storage,
                              "选择歌曲排序",
                              emptyTap,
                              showDivider: false,
                            ),
                          ),
                          PopupMenuItem(
                            child: ListIconTitle(
                              FontAwesomeIcons.trashAlt,
                              "选择歌曲排序",
                              emptyTap,
                              showDivider: false,
                            ),
                          ),
                          PopupMenuItem(
                            child: ListIconTitle(
                              Icons.warning,
                              "举报",
                              emptyTap,
                              showDivider: false,
                            ),
                          ),
                        ];
                      })
                    ],
                  ),
                  bottom: SuspendedMusicHeader(playlist["trackCount"]),
                ),
                _buildSongList(context, state),
                SliverToBoxAdapter(
                  child: _buildSubscribed(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ///歌曲列表内容
  Widget _buildSongList(BuildContext context, SongListPageState state) {
    final List<MusicTrackBean> musics = state.musics;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return StoreConnector<AppState, MusicTrackBean>(
          converter: (store) => store.state.musicPlayState.music,
          builder: (context, music) {
            final song = musics[index];
            return SongListItemWidget(
              isPlaying: song.id == music?.id,
              haveMv: song.haveMv(),
              index: index,
              songName: song.name,
              arName: song.getArName(),
              albumName: song.album.name,
              onItemTap: () {
                //播放某个歌曲
                StoreContainer.dispatch(PlaySongAction(song.id));
              },
              onMvTap: emptyTap,
              onMoreTap: emptyTap,
            );
          },
        );
      }, childCount: musics.length),
    );
  }

  requestSongDetail(store) => store.dispatch(RequestSongsListAction(id));

  Widget _buildSubscribed(BuildContext context, SongListPageState state) {
    final Map<String, dynamic> playlist = state.songsDetail["playlist"];
    final List<dynamic> subscribers = playlist["subscribers"];
    final subscribedCount = playlist["subscribedCount"];
    if (subscribedCount <= 0 || subscribers == null || subscribers.isEmpty) {
      return Container();
    }
    List<Widget> content = [];
    List<Widget> head = subscribers.take(5).map((sub) {
      return InkWell(
        onTap: emptyTap,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ClipOvalImageView(
            creatorUrl: sub["avatarUrl"],
          ),
        ),
      );
    }).toList();
    content.addAll(head);
    content.add(Spacer());
    content.add(Text(
      "${formattedNumber(subscribedCount)}人收藏",
      style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
    ));
    return Container(
      padding: EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
    );
  }
}

///播放条目view
class SongListItemWidget extends StatelessWidget {
  final bool isPlaying;
  final bool haveMv;
  final int index;
  final String songName;
  final String arName;
  final String albumName;
  final GestureTapCallback onMoreTap;
  final GestureTapCallback onItemTap;
  final GestureTapCallback onMvTap;

  const SongListItemWidget(
      {Key key,
      this.isPlaying = false,
      this.haveMv,
      this.index,
      this.songName,
      this.arName,
      this.albumName,
      this.onMoreTap,
      this.onItemTap,
      this.onMvTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 56,
      child: InkWell(
        onTap: onItemTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
          child: Row(
            children: <Widget>[
              //leading
              _buildLeading(context),
              SizedBox(
                width: 4,
              ),
              _buildContent(context, theme),
              //play icon,
              _buildPlayIcon(context),
              _buildMore(theme)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMore(ThemeData theme) {
    return InkWell(
      onTap: onMoreTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
        child: Opacity(
          opacity: 0.45,
          child: Icon(
            Icons.more_vert,
            size: 24,
            color: theme.textTheme.subtitle.color,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          songName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.subhead.copyWith(fontSize: 16),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "$arName - $albumName",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.caption,
        )
      ],
    ));
  }

  Widget _buildLeading(BuildContext context) {
    final theme = Theme.of(context);
    Widget leading;
    if (isPlaying) {
      leading = SizedBox(
        width: 24,
        child: Icon(Icons.volume_up, color: theme.primaryColor),
      );
    } else {
      leading = Opacity(
        opacity: 0.45,
        child: Text(
          (index + 1).toString(),
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 16),
          maxLines: 1,
        ),
      );
    }
    return SizedBox(
      width: 48,
      child: Center(
        child: leading,
      ),
    );
  }

  Widget _buildPlayIcon(BuildContext context) {
    if (!haveMv) {
      return Container();
    }
    return InkWell(
      onTap: onMvTap,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Icon(
          FontAwesomeIcons.youtube,
          size: 16,
          color: Theme.of(context).textTheme.caption.color,
        ),
      ),
    );
  }
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

  final String subTitle;

  final List<Widget> actions;

  const SongFlexibleSpaceBar({
    Key key,
    this.background,
    this.expandedTitle,
    this.collapsedTitle,
    this.content,
    this.actions,
    this.subTitle,
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
      maxLines: 1,
      style: Theme.of(context).primaryTextTheme.title.copyWith(fontSize: 16),
      overflow: TextOverflow.ellipsis,
    );
    if (widget.subTitle != null) {
      title = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title,
          SizedBox(
            height: 2,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: Text(
              widget.subTitle,
              style: Theme.of(context).primaryTextTheme.caption.copyWith(
                    fontSize: 11,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    }
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
          onTap: () {
            //播放全部
            StoreContainer.dispatch(PlayAllAction(context));
          },
          child: SizedBox.fromSize(
            size: preferredSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 16)),
                Icon(
                  Icons.play_circle_outline,
                  color: Theme.of(context).iconTheme.color,
                ),
                Padding(padding: EdgeInsets.only(left: 16)),
                Text(
                  "播放全部",
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 18),
                ),
                Text(
                  "(共$count首)",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 16),
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

  final double opacity;

  final double sigmaX;

  final double sigmaY;

  final Color filterColor;

  final StackFit stackFit;

  final BoxFit imageFit;

  final bool isFullScreen;

  const HeadBlurBackground({
    Key key,
    @required this.imageUrl,
    this.opacity = 0.9,
    this.sigmaX = 30,
    this.sigmaY = 30,
    this.filterColor,
    this.stackFit = StackFit.passthrough,
    this.imageFit = BoxFit.fill,
    this.isFullScreen = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget filter = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: Container(color: filterColor ?? Colors.black.withOpacity(0.3)),
    );
    //如果不要全屏效果,进行剪裁操作
    if (!isFullScreen) {
      filter = ClipRect(
        child: filter,
      );
    }
    return Stack(
      fit: stackFit,
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: NetImageView(
            fit: imageFit,
            url: imageUrl,
          ),
        ),
        filter,
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

  const SongCoverContent({
    Key key,
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
    @required this.shareCount,
  }) : super(key: key);

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
              _ActionButton(
                  MyIcons.comment_lines, commentCount ?? "留言", onCommentTap),
              _ActionButton(MyIcons.share, shareCount ?? "分享", onShareTap),
              _ActionButton(MyIcons.download_cloud, "下载", onDownTap),
              _ActionButton(MyIcons.check_all, "多选", onMultipleSelectTap),
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
          Colors.black26,
          Colors.black12,
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
              child: Stack(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(gradient: gradient),
                    position: DecorationPosition.foreground,
                    child: NetImageView(
                      url: coverUrl,
                      fit: BoxFit.cover,
                    ),
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
                            ClipOvalImageView(creatorUrl: creatorUrl),
                            SizedBox(
                              width: 8,
                            ),
                            ConstrainedBox(
                              child: Text(
                                creatorName ?? "",
                                style: theme.primaryTextTheme.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              constraints: BoxConstraints(maxWidth: 140),
                            ),
                            SizedBox(
                              width: 4,
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

///用户头像
class ClipOvalImageView extends StatelessWidget {
  final String creatorUrl;

  final double size;

  final GestureTapCallback onTap;

  const ClipOvalImageView(
      {Key key, @required this.creatorUrl, this.size = 24, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (creatorUrl == null) {
      content = Container(
        width: size,
        height: size,
        color: Theme.of(context).buttonTheme.colorScheme.error,
      );
    } else {
      content = NetImageView(
        width: size,
        height: size,
        url: creatorUrl,
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: content,
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
