import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/taurus_footer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

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
      ],
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
      padding: EdgeInsets.only(left: 16,right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: images[index],
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
            ),
          ),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
      ),
    );
  }
}
