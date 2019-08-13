import 'package:flutter/material.dart';
import 'package:flutter_net_music/app.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:flutter_net_music/utils/permission.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main_tab_page.dart';
import 'found_tab_page.dart';
import 'main_drawer.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  List tabs = ["我的", "发现", "朋友", "视频"];

  List<Widget> _tabPage = [
    Container(
      child: MainTabPage(),
    ),
    Container(
      child: FoundTabPage(),
    ),
    Container(
      child: Text("333"),
    ),
    Container(
      child: Text("444"),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 请求权限
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280)..init(context);
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 1,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: buildAppBar(),
        body: TabBarView(
          children: _tabPage,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Container(
        child: TabBar(
          ///去除下划线
          indicator: const BoxDecoration(),
          labelPadding: EdgeInsets.only(left: 0, right: 0),
          labelStyle:
              TextStyle(fontSize: FontSize.normal, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
              fontSize: FontSize.smaller, fontWeight: FontWeight.normal),
          tabs: tabs
              .map((e) => Tab(
                    text: e,
                  ))
              .toList(),
        ),
      ),
      actions: <Widget>[
        StoreConnector<AppState, VoidCallback>(
          converter: (store) {
            return () => store.dispatch(AppAction.changeTheme);
          },
          builder: (context, callback) {
            return IconButton(icon: Icon(Icons.search), onPressed: callback);
          },
        )
      ],
    );
  }
}
