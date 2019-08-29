import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:flutter_net_music/utils/print.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

class MainTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        buildAir(),
        Divider(height: 2),
        buildList(context),
        Container(
          height: 5,
          color: Theme.of(context).dividerColor,
        ),
        ExpansionSongList(
          initExpand: true,
        ),
        ExpansionSongList()
      ],
    );
  }

  Widget buildList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: 15, right: 16),
      child: Column(
        children: <Widget>[
          ListIconTitle(FontAwesomeIcons.music, "本地音乐", emptyTap),
          ListIconTitle(FontAwesomeIcons.play, "最近播放", emptyTap),
          ListIconTitle(FontAwesomeIcons.download, "下载管理", emptyTap),
          ListIconTitle(FontAwesomeIcons.podcast, "我的电台", emptyTap),
          ListIconTitle(
            FontAwesomeIcons.star,
            "我的收藏",
            emptyTap,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  final Map<String, IconData> _airMap = {
    "私人FM": Icons.radio,
    "古典专区": FontAwesomeIcons.guitar,
    "驾驶模式": Icons.directions_car,
    "爵士电台": FontAwesomeIcons.drum,
    "Sati空间": FontAwesomeIcons.moon,
    "亲子频道": Icons.child_care,
    "跑步电台": Icons.directions_run,
  };

  Widget buildAir() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: _airMap.keys
            .map((title) => ItemTab(_airMap[title], title, emptyTap))
            .toList(),
      ),
    );
  }
}

class ListIconTitle extends StatelessWidget {
  final IconData icon;

  final String text;

  final GestureTapCallback onTap;

  final bool showDivider;

  const ListIconTitle(
    this.icon,
    this.text,
    this.onTap, {
    Key key,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildContainer(context);
  }

  Widget buildContainer(BuildContext context) {
    Decoration decoration = ShapeDecoration(
        shape: Border(
            bottom:
                BorderSide(width: 0.5, color: Theme.of(context).dividerColor)));
    return Container(
      decoration: showDivider ? decoration : null,
      child: buildListTile(context),
    );
  }

  ListTile buildListTile(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, top: 0),
      leading: Icon(
        icon,
        size: 20.0,
        color: Theme.of(context).buttonColor,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: FontSize.small),
      ),
      onTap: onTap,
    );
  }
}

class ItemTab extends StatelessWidget {
  final IconData icon;

  final String text;

  final GestureTapCallback onTap;

  final double size;

  final double elevation;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;
  final double fontSize;

  const ItemTab(this.icon, this.text, this.onTap,
      {this.size = 35,
      this.elevation = 2,
      this.padding = const EdgeInsets.only(top: 8),
      this.fontSize = FontSize.miner,
      this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 16)});

  const ItemTab.large(this.icon, this.text, this.onTap)
      : this.size = 45,
        this.elevation = 1,
        this.padding = const EdgeInsets.only(top: 12),
        this.margin = null,
        fontSize = FontSize.smaller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: margin,
          child: Column(
            children: <Widget>[
              Material(
                shape: CircleBorder(),
                elevation: elevation,
                child: ClipOval(
                  child: Container(
                    width: size,
                    height: size,
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
                ),
              ),
              Padding(padding: padding),
              Text(
                text,
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),
        ));
  }
}

final GestureTapCallback emptyTap = () {};

///
/// 可展开的歌单列表
/// 有封面
/// 歌单名称
/// 数量信息
class ExpansionSongList extends StatefulWidget {
  final bool initExpand;

  const ExpansionSongList({Key key, this.initExpand = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpansionSongListState();
}

class _ExpansionSongListState extends State<ExpansionSongList> {
  bool isExpand;

  @override
  void initState() {
    super.initState();
    isExpand = widget.initExpand;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildTitle(context),
        Visibility(
          visible: isExpand,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SongListItem(),
              SongListItem(),
            ],
          ),
        )
      ],
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            isExpand = !isExpand;
          });
        },
        child: Row(
          children: <Widget>[
            Expanded(
                child: Row(
              children: <Widget>[
                Icon(isExpand
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right),
                Text(
                  "创建的歌单",
                  style: TextStyle(
                      fontSize: FontSize.medium,
                      fontWeight:
                          isExpand ? FontWeight.bold : FontWeight.normal),
                ),
              ],
            )),
            GestureDetector(
              onTap: emptyTap,
              child: Padding(
                padding: EdgeInsets.only(right: 8, top: 4, bottom: 4),
                child: Icon(Icons.add),
              ),
            ),
            GestureDetector(
              onTap: emptyTap,
              child: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// 歌单条目
///
class SongListItem extends StatelessWidget {
  static String url = "http://pix2.tvzhe.com/thumb/drama/74/7/240x180.jpg";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: emptyTap,
      child: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: NetImageView(
              url: url,
              width: 60,
              height: 60,
            ),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "我喜欢的音乐",
                      style: TextStyle(
                          fontSize: FontSize.large,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text("11首"),
                    )
                  ],
                )),
          ),
          IconButton(
            iconSize: 20,
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class NetImageView extends StatelessWidget {
  final String url;

  final double width;

  final double height;

  final BoxFit fit;

  final Widget placeholder;

  final Widget errorWidget;

  final Widget Function(BuildContext context, ImageProvider imageProvider)
      imageBuilder;

  const NetImageView(
      {Key key,
      @required this.url,
      this.width,
      this.height,
      this.fit = BoxFit.fill,
      this.placeholder,
      this.errorWidget,
      this.imageBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: url,
      imageBuilder: imageBuilder,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            child: Icon(FontAwesomeIcons.music),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            child: Icon(Icons.error_outline),
          ),
    );
  }
}
