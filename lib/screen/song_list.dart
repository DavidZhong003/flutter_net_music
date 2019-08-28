import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';

///歌单列表
///
///
class SongsListPage extends StatelessWidget {
  final String id;

  const SongsListPage({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            elevation: 0,
            title: Text("歌单"),
            expandedHeight: 280.0,
            flexibleSpace: FlexibleSpaceBar(
                background: HeadBlurBackground(
              imageUrl:
                  "https://p1.music.126.net/R5AvQBqbu5NfmwkteKHCCA==/109951164279733424.jpg",
            )),
            bottom: MusicListHeader(30),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              color: Colors.grey,
              height: 1000,
            )
          ]))
        ],
      ),
    );
  }
}

///模仿  [FlexibleSpaceBar]
class FlexibleSpaceHeaderBar extends StatelessWidget {
  final Widget title;
  final Widget background;
  final bool centerTitle;
  final CollapseMode collapseMode;
  final EdgeInsetsGeometry titlePadding;

  final Widget content;

  const FlexibleSpaceHeaderBar(
      {Key key,
      this.title,
      this.background,
      this.centerTitle,
      this.collapseMode,
      this.titlePadding, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //提供bar的大小以及不透明度信息
    final FlexibleSpaceBarSettings settings =
        context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    final List<Widget> children = <Widget>[];
    final double deltaExtent = settings.maxExtent - settings.minExtent;

    // 0.0 -> Expanded
    // 1.0 -> Collapsed to toolbar
    final double t =
        (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
            .clamp(0.0, 1.0);
    // background image
    if (background != null) {
      children.add(Positioned(
        top: -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t),
        left: 0,
        right: 0,
        height: settings.maxExtent,
        child: background,
      ));
    }
    //底部padding
    double bottomPadding = 0;
    SliverAppBar sliverBar = context.ancestorWidgetOfExactType(SliverAppBar);
    if (sliverBar != null && sliverBar.bottom != null) {
      bottomPadding = sliverBar.bottom.preferredSize.height;
    }
    children.add(Positioned(
      top: settings.currentExtent - settings.maxExtent,
      left: 0,
      right: 0,
      height: settings.maxExtent,
      child: Opacity(
        opacity: 1 - t,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Material(
              child: DefaultTextStyle(
                  style: Theme.of(context).primaryTextTheme.body1,
                  child: content),
              elevation: 0,
              color: Colors.transparent),
        ),
      ),
    ));
    return null;
  }
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

///音乐列表头
///[count] 列表数量
///[tail] 尾部收藏按钮
class MusicListHeader extends StatelessWidget implements PreferredSizeWidget {
  MusicListHeader(this.count, {this.tail});

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
