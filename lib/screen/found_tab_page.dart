import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/home_found.dart';
import 'package:flutter_net_music/redux/onInit/home_found.dart';
import 'package:flutter_net_music/redux/reducers/home_found.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:flutter_net_music/utils/print.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'main_tab_page.dart';

class FoundTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FoundPageState();
}

class FoundPageState extends State<StatefulWidget> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  Animation<Color> refreshColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        key: _easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: _headerKey,
        ),
        firstRefresh: true,
        refreshFooter: MaterialFooter(key: _footerKey),
        child: SingleChildScrollView(
          child: buildContent(context),
        ),
        onRefresh: () async {},
        loadMore: () async {});
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
        BannerWidget(),
        buildCenterButton(),
        Divider(),
        PersonalizedSongListWidget()
      ],
    );
  }

  Widget buildCenterButton() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
              child: ItemTab.large(Icons.calendar_today, "每日推荐", emptyTap)),
          Expanded(child: ItemTab.large(Icons.queue_music, "歌单", emptyTap)),
          Expanded(
              child: ItemTab.large(
            FontAwesomeIcons.gitter,
            "排行榜",
            emptyTap,
          )),
          Expanded(child: ItemTab.large(Icons.radio, "电台", emptyTap)),
          Expanded(child: ItemTab.large(Icons.live_tv, "直播", emptyTap))
        ],
      ),
    );
  }
}

/// 轮播图
class BannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BannerState();
}

class _BannerState extends State<BannerWidget> {
  SwiperController controller;

  @override
  void initState() {
    super.initState();
    controller = SwiperController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.stopAutoplay();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BannerState>(
        builder: (context, banner) {
          return RefreshSafeArea(
              child: Stack(
            children: <Widget>[
              Container(
                height: 90,
                color: Theme.of(context).primaryColor,
              ),
              Container(
                margin: EdgeInsets.all(8),
                height: 150,
                child: banner.isLoading
                    ? WaveLoading()
                    : buildRefreshSafeArea(context, banner.banner),
              )
            ],
          ));
        },
        onInit: bannerInit,
        converter: (store) => store.state.homeFoundState.bannerState);
  }

  Widget buildRefreshSafeArea(BuildContext context,
      [Map<String, dynamic> map]) {
    var banners = map["banners"];
    Widget content;
    if (banners != null) {
      content = Swiper(
        itemCount: banners?.length ?? 0,
        itemBuilder: (context, index) {
          Map banner = banners[index];
          return GestureDetector(
              onTap: emptyTap,
              child: buildImage(context, banner["pic"] ?? "", index));
        },
        autoplay: true,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                activeSize: 9,
                size: 8,
                activeColor: Theme.of(context).iconTheme.color)),
        controller: controller,
      );
    }
    return content ?? Container();
  }

  Widget buildImage(BuildContext context, String url, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: NetImageView(
          url: url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
            ),
          ),
        ),
      ),
    );
  }
}

/// 推荐歌单
///
class PersonalizedSongListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        children: <Widget>[buildTitle(), buildSongContent()],
      ),
    );
  }

  Widget buildSongContent() {
    return StoreConnector<AppState, PersonalizedSongState>(
      converter: (store) => store.state.homeFoundState.personalizedSongState,
      onInit: requestPersonalizedSongAction,
      builder: (BuildContext context, PersonalizedSongState state) {
        List<dynamic> list=state.showList;
        return GridView.builder(
            padding: EdgeInsets.only(top: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 10 / 12.5,
            ),
            itemCount: list.length ?? 6,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Map<String, dynamic> songs = list[index] ?? [];
              return state.isLoading
                  ? Container(color: Colors.grey[300],)
                  : SongCoverWidget(
                      image: songs["picUrl"],
                      name: songs["name"],
                      onTap: emptyTap,
                    );
            });
      },
    );
  }

  Widget buildTitle() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "推荐歌单",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: FontSize.normal),
          ),
        ),
        new OutRoundButton(
          text: "歌单广场",
          onTap: emptyTap,
        ),
      ],
    );
  }
}

/// 圆框按钮
class OutRoundButton extends StatelessWidget {
  final GestureTapCallback onTap;

  //Colors.grey[300]
  final Color borderColor;
  final String text;

  //TextStyle(fontSize: FontSize.min)
  final TextStyle style;

  //const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
  final EdgeInsetsGeometry padding;

  //BorderRadius.circular(25)
  final BorderRadiusGeometry borderRadius;

  const OutRoundButton({
    Key key,
    this.onTap,
    this.borderColor = const Color(0xFFE0E0E0),
    @required this.text,
    this.style = const TextStyle(fontSize: FontSize.min),
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(25)),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: style,
          ),
        ),
      ),
    );
  }
}

///歌单列表
class SongCoverWidget extends StatelessWidget {
  final String image;

  final String name;

  final GestureTapCallback onTap;

  const SongCoverWidget(
      {Key key, @required this.image, @required this.name, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image(
                  fit: BoxFit.cover, image: CachedNetworkImageProvider(image)),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  name,
                  style: TextStyle(fontSize: FontSize.smaller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
