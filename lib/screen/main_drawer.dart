import 'package:flutter/material.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/theme.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
              ],
            )),
            Divider(
              height: 0.5,
            ),
            _DrawerBottom(),
          ],
        ));
}

class _PersonHead extends StatelessWidget {
  static const hintText = "登录网易云音乐";
  static const text2 = "手机电脑多端同步,尽享海量高品质音乐";

  @override
  Widget build(BuildContext context) {
    return _buildNeedLogin(context);
  }

  Widget _buildNeedLogin(BuildContext context) {
    var themeData = Theme.of(context);
    return Container(
      height: 180,
      padding: EdgeInsets.only(top: 20),
      color: themeData.brightness==Brightness.light?Colors.grey[100]:Colors.black12,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            hintText,
            style: themeData.textTheme.caption,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            text2,
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
                //todo 跳转登录页
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
