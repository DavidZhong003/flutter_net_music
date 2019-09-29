import 'package:flutter/material.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/redux/actions/login.dart';
import 'package:flutter_net_music/redux/reducers/login.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'song_list/song_list.dart' show ClipOvalImageView, HeadBlurBackground;
import '../routes.dart';

class MainDrawer extends Drawer {
  MainDrawer()
      : super(
            child: Column(
          children: <Widget>[
            Expanded(
                child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _PersonHead(),
                ),
                SliverToBoxAdapter(
                  child: _CenterButtonGroup(),
                ),
                sliverDivider(),
                _ContentList(
                  map: {
                    "演出": MyIcons.ticket,
                    "商城": MyIcons.mall,
                    "附近的人": Icons.location_on,
                    "游戏推荐": Icons.games,
                    "口袋铃声": MyIcons.bell,
                  },
                ),
                sliverDivider(),
                _ContentList(map: {
                  "我的订单": MyIcons.order_form,
                  "定时停止播放": MyIcons.time,
                  "扫一扫": FontAwesomeIcons.qrcode,
                  "音乐闹钟": Icons.timer,
                  "在线听歌免流量": Icons.card_travel,
                  "优惠券": Icons.assignment,
                  "青少年模式": Icons.beenhere,
                }),
              ],
            )),
            Divider(
              height: 0.5,
            ),
            _DrawerBottom(),
          ],
        ));

  ///创建分割线
  static SliverToBoxAdapter sliverDivider() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Divider(
            height: 0.5,
          ),
        ),
      );
}

class _ContentList extends StatelessWidget {
  final Map<String, IconData> map;

  const _ContentList({Key key, @required this.map}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keys = map.keys;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final text = keys.elementAt(index);
        return InkWell(
          onTap: () {
            haveNotCompleteTap(context);
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: _LeftIconText(
                  iconData: map[text],
                  text: text,
                  textPaddingLeft: 12,
                ),
              ),
            ],
          ),
        );
      }, childCount: keys.length),
    );
  }
}

///头部
class _PersonHead extends StatelessWidget {
  static const LOGIN_IN_NET_MUSIC = "登录网易云音乐";
  static const ENJOY_MUSIC = "手机电脑多端同步,尽享海量高品质音乐";

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserInfoState>(
        builder: (BuildContext context, UserInfoState state) {
          if (!state.isLogin) {
            return _buildNeedLogin(context);
          }
          return Container(
            height: 180,
            child: Stack(
              children: <Widget>[
                HeadBlurBackground(
                  stackFit: StackFit.expand,
                  opacity: 0.1,
                  imageUrl: state.avatarUrl,
                  isFullScreen: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///fix 初始时候头像在中间显示
                      Row(
                        children: <Widget>[
                          ClipOvalImageView(
                            creatorUrl: state.avatarUrl,
                            size: 72,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        state.nickname,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        onInit: (s)=>s.dispatch(InitUserAction()),
        converter: (s) => s.state.userInfoState);
  }

  Widget _buildNeedLogin(BuildContext context) {
    var themeData = Theme.of(context);
    return Container(
      height: 180,
      padding: EdgeInsets.only(top: 20),
      color: themeData.brightness == Brightness.light
          ? Colors.grey[100]
          : Colors.black12,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            LOGIN_IN_NET_MUSIC,
            style: themeData.textTheme.caption,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            ENJOY_MUSIC,
            style: themeData.textTheme.caption,
          ),
          SizedBox(
            height: 16,
          ),
          ButtonTheme(
            height: 28,
            minWidth: 120,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: OutlineButton(
              highlightedBorderColor: Colors.transparent,
              focusColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed(PathName.ROUTE_LOGIN);
              },
              child: Text(
                "立即登录",
                style: themeData.textTheme.caption,
              ),
            ),
          )
        ],
      )),
    );
  }
}

///中间按钮组
class _CenterButtonGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconTopButton(
            icon: Icons.mail_outline,
            text: "我的消息",
          ),
          IconTopButton(
            icon: Icons.person_outline,
            text: "我的好友",
          ),
          IconTopButton(
            icon: Icons.mic,
            text: "听歌识曲",
          ),
          IconTopButton(
            icon: Icons.color_lens,
            text: "个性装扮",
          ),
        ],
      ),
    );
  }
}

haveNotCompleteTap(BuildContext context) {
  Toast.show("功能未完成", context);
}

///按钮
class IconTopButton extends StatelessWidget {
  final IconData icon;

  final String text;

  final void Function() onTap;

  final EdgeInsetsGeometry padding;

  final TextStyle textStyle;

  const IconTopButton(
      {Key key,
      @required this.icon,
      @required this.text,
      this.onTap,
      this.padding = const EdgeInsets.all(8.0),
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            haveNotCompleteTap(context);
          },
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

///底部控制
class _DrawerBottom extends StatelessWidget {
  static const padding = const EdgeInsets.all(8.0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: _DayAndNightButton(
            padding: padding,
          ),
        ),
        Expanded(
          flex: 4,
          child: InkWell(
            child: Padding(
              padding: padding,
              child: _LeftIconText(
                iconData: MyIcons.setting,
                text: "设置",
              ),
            ),
            onTap: () {},
          ),
        ),
        Expanded(
          flex: 4,
          child: InkWell(
            child: Padding(
              padding: padding,
              child: _LeftIconText(
                iconData: MyIcons.exit,
                text: "退出",
              ),
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _DayAndNightButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const _DayAndNightButton({Key key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
        builder: (BuildContext context, bool isNight) {
          Widget content = _LeftIconText(
            iconData: isNight ? MyIcons.sun : MyIcons.moon,
            text: isNight ? "日间模式" : "夜间模式",
          );
          if (padding != null) {
            content = Padding(
              padding: padding,
              child: content,
            );
          }
          return InkWell(
            child: content,
            onTap: () {
              StoreContainer.dispatch(ChangeNightTheme(!isNight));
            },
          );
        },
        converter: (s) => s.state.themeState.isNightMode());
  }
}

class _LeftIconText extends StatelessWidget {
  final IconData iconData;
  final String text;

  final double textPaddingLeft;

  final double iconSize;

  final TextStyle textStyle;

  final Padding padding;

  const _LeftIconText({
    Key key,
    @required this.iconData,
    @required this.text,
    this.textPaddingLeft = 8,
    this.iconSize = 20,
    this.textStyle,
    this.padding,
  })  : assert(iconData != null),
        assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final caption = Theme.of(context).textTheme.caption.copyWith(fontSize: 14);
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            iconData,
            color: (textStyle ?? caption).color,
            size: iconSize,
          ),
          SizedBox(
            width: textPaddingLeft,
          ),
          Text(
            text,
            style: textStyle ?? caption,
          ),
        ],
      ),
    );
  }
}
