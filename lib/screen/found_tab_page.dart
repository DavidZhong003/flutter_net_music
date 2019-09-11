import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/home_found.dart';
import 'package:flutter_net_music/redux/onInit/home_found.dart';
import 'package:flutter_net_music/redux/reducers/home_found.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:flutter_net_music/utils/string.dart';
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
        firstRefresh: false,
        refreshFooter: MaterialFooter(key: _footerKey),
        child: SingleChildScrollView(
          child: buildContent(context),
        ),
        onRefresh: () async {
          StoreContainer.dispatch(RandomPersonalizedSongAction());
        },
        loadMore: () async {});
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
        BannerWidget(),
        buildCenterButton(),
        Divider(),
        PersonalizedSongListWidget(),
        NewsSongOrAlbumsWidget(),
      ],
    );
  }

  Widget buildCenterButton() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ItemTab.large(Icons.calendar_today, "每日推荐", emptyTap),
          ItemTab.large(Icons.queue_music, "歌单", emptyTap),
          ItemTab.large(
            FontAwesomeIcons.gitter,
            "排行榜",
            emptyTap,
          ),
          ItemTab.large(Icons.radio, "电台", emptyTap),
          ItemTab.large(Icons.live_tv, "直播", emptyTap)
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
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColorLight,
                      BlendMode.colorBurn)),
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
        List<dynamic> list = state.showList;
        return GridView.builder(
            padding: EdgeInsets.only(top: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 6,
              childAspectRatio: 10 / 12.8,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length ?? 6,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Map<String, dynamic> songs = list[index] ?? [];
              return state.isLoading
                  ? Container(
                      color: Colors.grey[300],
                    )
                  : SongCoverWidget(
                      image: songs["picUrl"],
                      name: songs["name"],
                      playCount: formattedNumber(songs["playCount"]),
                      onTap: () {
                        // 动态路由
                        jumpSongList(context, songs["id"].toString(),
                            songs["copywriter"] ?? null);
                      },
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

  final double width;

  final double height;

  const OutRoundButton({
    Key key,
    this.onTap,
    this.borderColor = const Color(0xFFE0E0E0),
    @required this.text,
    this.style = const TextStyle(fontSize: FontSize.min),
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    this.borderRadius,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? null,
        height: height ?? null,
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(25)),
        child: Padding(
          padding: padding,
          child: Center(
            child: Text(
              text,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}

///歌封面Widget
class SongCoverWidget extends StatelessWidget {
  final String image;

  final String name;

  final GestureTapCallback onTap;

  final String playCount;

  const SongCoverWidget({
    Key key,
    @required this.image,
    @required this.name,
    this.onTap,
    this.playCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black54,
          Colors.black26,
          Colors.transparent,
          Colors.transparent,
        ]);

    final theme = Theme.of(context);

    Widget imageView = NetImageView(
      url: image,
      fit: BoxFit.cover,
    );
    if (playCount != null && playCount.isNotEmpty) {
      imageView = Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Stack(
          children: <Widget>[
            imageView,
            Positioned(
              top: 2,
              right: 4,
              child: Row(
                children: <Widget>[
                  Icon(Icons.play_arrow,
                      color: theme.primaryIconTheme.color, size: 14),
                  Text(
                    playCount ?? "",
                    style: theme.primaryTextTheme.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: imageView,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///最新新歌  最新新碟
///
class NewsSongOrAlbumsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsSongOrAlbumsState();
  }
}

class _NewsSongOrAlbumsState extends State<NewsSongOrAlbumsWidget> {
  bool selectAlbums = true;

  static const NEW_ALBUMS = "新碟";

  static const NEW_SONGS = "新歌";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            _buildTitle(context),
            SizedBox(
              height: 8,
            ),
            buildPicContent(),
          ],
        ),
      ),
    );
  }

  Widget buildPicContent() {
    Widget _buildCover(String image, String name, void Function() onTap) {
      return SongCoverWidget(
        image: image,
        name: name,
        onTap: onTap,
      );
    }

    final loading = WaveLoading();
    return StoreConnector<AppState, NewSongAlbumsState>(
        builder: (context, state) {
          if (state.isLoading ||
              state.songData.isEmpty ||
              state.albumsData.isEmpty) {
            return Container(
                height: 140,
                child: Center(
                  child: loading,
                ));
          }
          List<Widget> content;
          if (selectAlbums) {
            content = state.albumsData.map((map) {
              return _buildCover(map["picUrl"], map["name"], () {});
            }).toList();
          } else {
            content = state.songData
                .map((map) =>
                    _buildCover(map["album"]["picUrl"], map["name"], () {}))
                .toList();
          }
          return GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 0.8,
            children: content,
          );
        },
        onInit: (s) {
          s.dispatch(NewAlbumsRequestAction());
          s.dispatch(NewSongRequestAction());
        },
        converter: (s) => s.state.homeFoundState.newSongAlbumsState);
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final selectTheme =
        theme.textTheme.title.copyWith(fontWeight: FontWeight.bold);
    final normal = theme.textTheme.caption.copyWith(fontSize: 16);
    return Row(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  selectAlbums = true;
                });
              },
              child: Text(
                NEW_ALBUMS,
                style: selectAlbums ? selectTheme : normal,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              color: theme.dividerColor,
              width: 1,
              height: 20,
              margin: EdgeInsets.only(left: 8, right: 8),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectAlbums = false;
                  });
                },
                child: Text(NEW_SONGS,
                    style: !selectAlbums ? selectTheme : normal)),
          ],
        ),
        Expanded(child: Container()),
        OutRoundButton(
          width: 65,
          height: 25,
          text: "更多${selectAlbums ? NEW_ALBUMS : NEW_SONGS}",
          style: theme.textTheme.caption.copyWith(fontSize: 11),
          onTap: () {
            //todo 点击事件
          },
        ),
      ],
    );
  }
}
