import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/redux/actions/mine_tab.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/mine_tab.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var content = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          buildAir(),
          Divider(height: 2),
          buildList(context),
          UserSongListWidget(),
        ],
      ),
    );
    return content;
  }

  Widget buildList(BuildContext context) {
    return Column(
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
        Container(
          height: 5,
          color: Theme.of(context).dividerColor,
        ),
      ],
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

///用户歌单 Widget
class UserSongListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserSongListState>(
      converter: (s) => s.state.userInfoState.songListState,
      onInit: (s) => s.dispatch(InitUserSongListAction()),
      builder: (context, state) {
        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, UserSongListState state) {
    var create = state.createSongList;
    var subList = state.subSongList;
    Widget createWidget = ExpansionSongList(
      songTitle: "创建的歌单 (${create.length})",
      initExpand: true,
      onAddTap: (){},
      onMoreTap: (){},
      child: (create.isNotEmpty)
          ? _buildListView(context, create)
          : _buildEmptyConvertWidget(),
    );
    Widget subWidget = Container();
    if (subList != null && subList.isNotEmpty) {
      subWidget = ExpansionSongList(
        songTitle: "收藏的歌单 (${subList.length})",
        child: _buildListView(context, subList),
        onMoreTap: (){},
      );
    }
    return Column(
      children: <Widget>[createWidget,subWidget],
    );
  }

  Widget _buildListView(BuildContext context, List<PlayListsModel> create) {
    var items = (context, index) {
      var songs = create[index];
      return SongListItem(
          url: songs.coverImageUrl, title: songs.name, count: songs.playCount);
    };

    return ListView.builder(
      itemBuilder: items,
      itemCount: create.length,
      shrinkWrap: true,
      itemExtent: 80,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildEmptyConvertWidget() {
    return SongListItem(url: null, title: "我喜欢的音乐", count: 0);
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
    Widget textContent;
    textContent = Text(
      text,
      style: TextStyle(fontSize: FontSize.small),
    );
    if (showDivider) {
      Decoration decoration = ShapeDecoration(
          shape: Border(
              bottom: BorderSide(
                  width: 0.5, color: Theme.of(context).dividerColor)));
      textContent = Container(
        decoration: decoration,
        height: 50,
        child: Align(
          alignment: Alignment.centerLeft,
          child: textContent,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                  child: Icon(
                    icon,
                    size: 20.0,
                    color: Theme.of(context).buttonColor,
                  ),
                )),
            Expanded(
              flex: 9,
              child: textContent,
            ),
          ],
        ),
      ),
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

  final TextStyle textStyle;

  final bool withInkWell;

  const ItemTab(this.icon, this.text, this.onTap,
      {this.size = 40,
      this.elevation = 2,
      this.padding = const EdgeInsets.only(top: 8),
      this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      this.textStyle,
      this.withInkWell = false});

  const ItemTab.large(
    this.icon,
    this.text,
    this.onTap,
  )   : this.size = 45,
        this.elevation = 1,
        this.padding = const EdgeInsets.only(top: 12),
        this.margin = null,
        withInkWell = false,
        textStyle = null;

  @override
  Widget build(BuildContext context) {
    Widget result = Container(
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
            style: textStyle ?? Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
    if (withInkWell) {
      result = InkWell(
        onTap: onTap,
        child: result,
      );
    } else {
      result = GestureDetector(
        onTap: onTap,
        child: result,
      );
    }
    return result;
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

  final String songTitle;

  final GestureTapCallback onAddTap;

  final GestureTapCallback onMoreTap;

  final Widget child;

  const ExpansionSongList(
      {Key key,
      this.initExpand = false,
      @required this.songTitle,
      this.onAddTap,
      this.onMoreTap,
      @required this.child})
      : super(key: key);

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
          child: widget.child,
        )
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    List<Widget> children = [];

    children.add(Expanded(
        child: Row(
      children: <Widget>[
        Icon(isExpand ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right),
        Text(
          widget.songTitle,
          style: TextStyle(
              fontSize: FontSize.medium,
              fontWeight: isExpand ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    )));

    /// add
    if (widget.onAddTap != null) {
      children.add(GestureDetector(
        onTap: widget.onAddTap,
        child: Padding(
          padding: EdgeInsets.only(right: 8, top: 4, bottom: 4),
          child: Icon(Icons.add),
        ),
      ));
    }

    ///more
    if (widget.onMoreTap != null) {
      children.add(GestureDetector(
        onTap: emptyTap,
        child: Icon(Icons.more_vert),
      ));
    }
    return InkWell(
      onTap: () {
        setState(() {
          isExpand = !isExpand;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}

///
/// 歌单条目
///
class SongListItem extends StatelessWidget {
  final String url;

  final String title;

  final int count;

  final GestureTapCallback onTap;

  final EdgeInsetsGeometry padding;

  final GestureTapCallback onMoreTap;

  const SongListItem({
    Key key,
    @required this.url,
    @required this.title,
    @required this.count,
    this.onTap,
    this.padding = const EdgeInsets.only(left: 16, top: 8, bottom: 8),
    this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    Widget image = Container(
      width: 60,
      height: 60,
      color: Theme.of(context).primaryColor,
    );

    if (url != null && url.isNotEmpty) {
      image = NetImageView(
        url: url,
        width: 60,
        height: 60,
        errorWidget: image,
      );
    }

    image = ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: image,
    );

    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          image,
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: FontSize.large,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text("$count首"),
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

  final double holderAspectRatio;

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
      this.imageBuilder,
      this.holderAspectRatio = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: url,
      imageBuilder: imageBuilder,
      fit: fit,
      placeholderFadeInDuration: Duration(milliseconds: 600),
      placeholder: (context, url) =>
          placeholder ?? _buildDefaultPlaceholder(context),
      errorWidget: (context, url, error) => Center(
        child: errorWidget ?? _buildDefaultError(context),
      ),
    );
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    Widget holder = Center(child: Icon(FontAwesomeIcons.music));
    if (width != null && height != null) {
      holder = SizedBox(
        width: width,
        height: height,
        child: holder,
      );
    }
    return holder;
  }

  Widget _buildDefaultError(BuildContext context) {
    return AspectRatio(
      child: Center(child: Icon(Icons.error_outline)),
      aspectRatio: holderAspectRatio,
    );
  }
}
