import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/home_found.dart';
import 'package:flutter_net_music/redux/onInit/home_found.dart';
import 'package:flutter_net_music/redux/reducers/home_found.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_net_music/screen/song_square/page.dart';
import 'package:flutter_net_music/style/font.dart';
import 'package:flutter_net_music/utils/string.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'mine_tab_page.dart';

class FoundTabPage extends StatefulWidget {
  const FoundTabPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FoundPageState();
}

class FoundPageState extends State<StatefulWidget>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
    return EasyRefresh(
        key: _easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: _headerKey,
        ),
        firstRefresh: false,
        refreshFooter: MaterialFooter(key: _footerKey),
        child: CustomScrollView(
          slivers: buildContent(context),
        ),
        onRefresh: () async {
          StoreContainer.dispatch(RandomPersonalizedSongAction());
        },
        loadMore: () async {});
  }

  List<Widget> buildContent(BuildContext context) {
    List<Widget> content = [
      BannerWidget(),
      buildCenterButton(),
      Divider(),
      PersonalizedSongListWidget(),
      NewsSongOrAlbumsWidget(),
    ];
    return content
        .map((w) => SliverToBoxAdapter(
              child: w,
            ))
        .toList();
  }

  Widget buildCenterButton() {
    final d= DateTime.now().day;
    final day = d<10?"0$d":d.toString();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ItemTab.large(Icons.calendar_today, "每日推荐", () {
                Navigator.of(context).pushNamed(PathName.ROUTE_RECOMMEND_SONGS);
              }),
              IgnorePointer(
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6,left: 3.5),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          ItemTab.large(Icons.queue_music, "歌单", () {
            jumpPage(context, SongSquarePage());
          }),
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

  @override
  bool get wantKeepAlive => true;
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
        children: <Widget>[buildTitle(context), buildSongContent()],
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
              mainAxisSpacing: 8,
              crossAxisSpacing: 16,
              childAspectRatio: 10 / 13.8,
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

  Widget buildTitle(BuildContext context) {
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
          onTap: () {
            jumpPage(context, SongSquarePage());
          },
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

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry textPadding;

  final bool textExpend;

  const SongCoverWidget({
    Key key,
    @required this.image,
    this.name,
    this.onTap,
    this.playCount,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    this.textPadding = const EdgeInsets.only(top: 2), this.textExpend = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black26,
          Colors.black12,
          Colors.transparent,
          Colors.transparent,
        ]);

    final theme = Theme.of(context);

    Widget imageView = NetImageView(
      url: image,
      fit: BoxFit.cover,
    );
    if (playCount != null && playCount.isNotEmpty) {
      imageView = Stack(
        children: <Widget>[
          DecoratedBox(
              decoration: BoxDecoration(gradient: gradient),
              position: DecorationPosition.foreground,
              child: imageView),
          Positioned(
            top: 2,
            right: 4,
            child: Row(
              children: <Widget>[
                Icon(Icons.play_arrow, color: Colors.white, size: 14),
                Text(
                  playCount ?? "",
                  style: theme.primaryTextTheme.caption
                      .copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      );
    }
    Widget text;
    if (name != null) {
      text = Padding(
        padding: textPadding,
        child: Text(
          name,
          style: Theme.of(context).textTheme.caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    Widget content;
    content = ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: imageView,
    );
    if (text != null) {
      if(textExpend==true){
        text = Expanded(child: text);
      }
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          content,
          text,
        ],
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: content,
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
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: SongCoverWidget(
          image: image,
          name: name,
          onTap: onTap,
          textExpend: true,
        ),
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
