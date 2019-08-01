import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/taurus_footer.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'MainTabPage.dart';

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

  List<String> images = [
    "http://p1.music.126.net/RXOs3QupZTIvn2TSstpJAA==/109951164251499691.jpg",
    "http://p1.music.126.net/xmd-Zt7BzSDVeuIAeKhspg==/109951164253364415.jpg",
    "http://p1.music.126.net/pPxRjcKzxvcg_5e2KKDDDA==/109951164253700896.jpg",
    "http://p1.music.126.net/1UR01iEyQozBrZZkpM70_w==/109951164253625432.jpg",
    "http://p1.music.126.net/n9_Y1jfbdy3z7kcw2ypVHg==/109951164253380200.jpg"
  ];

  @override
  Widget build(BuildContext context) {
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
          child: Swiper(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return buildImage(context, index);
            },
            autoplay: true,
            pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                    activeSize: 9,
                    size: 8,
                    activeColor: Theme.of(context).iconTheme.color)),
            controller: controller,
          ),
        )
      ],
    ));
  }

  Widget buildImage(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: NetImageView(
          url: images[index],
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
class PersonalizedSongListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PersonalizedSongState();
}

class PersonalizedSongState extends State<PersonalizedSongListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        children: <Widget>[
          buildTitle(),
          GridView.builder(
            padding: EdgeInsets.only(top: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 10/12.5,
              ),
              itemCount: 6,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SongCoverWidget();
              })
        ],
      ),
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

class SongCoverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: emptyTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                      "https://p2.music.126.net/QCJQ-7OA-WVZgjipwXNB9g==/18602637232541777.jpg")),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  "深情布鲁斯，浓情老酒馆。",
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
