import 'package:flutter/material.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        )
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

  Widget buildAir() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: <Widget>[
          ItemTab(Icons.radio, "私人FM", () {}),
          ItemTab(FontAwesomeIcons.guitar, "古典专区", () {}),
          ItemTab(Icons.directions_car, "驾驶模式", () {}),
          ItemTab(FontAwesomeIcons.drum, "爵士电台", () {}),
          ItemTab(FontAwesomeIcons.moon, "Sati空间", () {}),
          ItemTab(Icons.child_care, "亲子频道", () {}),
          ItemTab(Icons.directions_run, "跑步电台", () {}),
        ],
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: <Widget>[
              Material(
                shape: CircleBorder(),
                elevation: 2,
                child: ClipOval(
                  child: Container(
                    width: 35,
                    height: 35,
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Text(
                text,
                style: TextStyle(fontSize: FontSize.miner),
              ),
            ],
          ),
        ));
  }

  ItemTab(this.icon, this.text, this.onTap);
}

final GestureTapCallback emptyTap = () {};

class ExpansionSongList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

class _ExpansionSongListState extends State<ExpansionSongList> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    ExpansionPanelList()
    return null;
  }
}
