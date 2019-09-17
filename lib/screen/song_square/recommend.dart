import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/song_square.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_net_music/screen/found_tab_page.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class RecommendTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecommendTabState();
  }
}

class _RecommendTabState extends State<RecommendTab> {

  List<PlayListsModel> banner;

  Set<PlayListsModel> list;

  bool get _isLoading => banner == null || list == null;

  int page = 1;

  bool noMore = false;

  bool _isNetRequest = false;

  static const int MAX_LENGTH = 150;

  @override
  void initState() {
    //网络请求
    super.initState();
    _getPageData();
  }

  void _getPageData() {
    if (_isNetRequest || noMore) {
      return;
    }
    _isNetRequest = true;
    final start = DateTime.now();
    ApiService.getSongList(page: page).then((map) {
      _processResult(map);
      _notifyLoadSuccess(start);
    }).whenComplete(() {
      _isNetRequest = false;
    });
  }

  void _notifyLoadSuccess(DateTime start) {
    final end = DateTime.now();
    final duration = end.millisecond - start.millisecond;
    if (page != 0 && duration < 1000) {
      ///防止太快
      Future.delayed(Duration(milliseconds: (1000 - duration)))
          .whenComplete(() {
        //加载成功后page+1
        setState(() {
          page++;
        });
      });
    } else {
      //加载成功后page+1
      setState(() {
        page++;
      });
    }
  }

  void _processResult(Map<String, dynamic> map) {
    noMore = !map["more"];
    List<dynamic> playLists = map["playlists"];
    List<PlayListsModel> result =
        playLists.map((bean) => PlayListsModel.fromMap(bean)).toList();
    if (banner == null || banner.isEmpty) {
      banner = result.take(3).toList();
    }
    if (list == null) {
      list = result.sublist(3, result.length).toSet();
    } else {
      list.addAll(result);
    }
    if (list.length > MAX_LENGTH) {
      noMore = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        child: Center(
          child: WaveLoading(),
        ),
      );
    }
    final data = list.toList();
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels >=
            (notification.metrics.maxScrollExtent - 50)) {
          //加载更多
          _getPageData();
          return true;
        }
        return false;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _Banner(
              banner: banner,
            ),
          ),
          SongCoverGridView(
            list: data,
          ),
          buildMore(context),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildMore(BuildContext context) {
    Widget content;
    if (noMore) {
      content = Container();
    } else {
      content = WaveLoading(
        size: 24,
      );
    }
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        child: Center(
          child: content,
        ),
      ),
    );
  }
}

class _Banner extends StatefulWidget {
  final List<PlayListsModel> banner;

  const _Banner({Key key, @required this.banner}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BannerState();
  }
}

class _BannerState extends State<_Banner> {
  int currentIndex;

  SwiperController _controller;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _controller = SwiperController();
    StoreContainer.dispatch(
        ChangeBackImageAction(widget.banner[currentIndex].coverImageUrl));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PlayListsModel> banner = widget.banner;
    return Container(
      padding: EdgeInsets.all(16),
      height: 250,
      child: Swiper(
        itemCount: banner.length,
        controller: _controller,
        itemBuilder: (context, index) {
          var bean = banner[index];
          return GestureDetector(
            onTap: () {
              if (currentIndex == index) {
                jumpSongList(context, bean.id.toString());
              } else {
                _controller.move(index);
              }
            },
            child: Opacity(
              opacity: currentIndex == index ? 1 : 0.6,
              child: Card(
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    _buildCover(context, bean),
                    _buildTitle(bean, context),
                  ],
                ),
              ),
            ),
          );
        },
        loop: true,
        onIndexChanged: (int) {
          setState(() {
            currentIndex = int;
          });
          StoreContainer.dispatch(
              ChangeBackImageAction(banner[int].coverImageUrl));
        },
        viewportFraction: 0.46,
        scale: 0.8,
      ),
    );
  }

  Widget _buildCover(BuildContext context, PlayListsModel bean) {
    final theme = Theme.of(context);
    final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black12,
          Colors.transparent,
          Colors.transparent,
          Colors.black12,
        ]);
    final playCountWidget = Positioned(
      top: 2,
      right: 4,
      child: Row(
        children: <Widget>[
          Icon(Icons.play_arrow, color: theme.primaryIconTheme.color, size: 14),
          Text(
            bean.playCountString,
            style: theme.primaryTextTheme.caption,
          ),
        ],
      ),
    );
    final playButton = Positioned(
      bottom: 8,
      right: 8,
      child: ClipOval(
        child: Container(
          width: 30,
          height: 30,
          color: Colors.white.withOpacity(0.9),
          child: Center(
            child: Icon(Icons.play_arrow),
          ),
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        DecoratedBox(
            decoration: BoxDecoration(gradient: gradient),
            position: DecorationPosition.foreground,
            child: NetImageView(url: bean.coverImageUrl)),
        playCountWidget,
        playButton,
      ],
    );
  }

  Widget _buildTitle(PlayListsModel bean, BuildContext context) {
    return Expanded(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Text(
          bean.name,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    ));
  }
}

///封面gridView
class SongCoverGridView extends StatelessWidget {
  final List<PlayListsModel> list;

  final void Function(int id) onTap;

  final EdgeInsetsGeometry padding;

  final SliverGridDelegate delegate;

  const SongCoverGridView({
    Key key,
    @required this.list,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.delegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 16,
      childAspectRatio: 10 / 13.8,
    ),
  })  : assert(list != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            PlayListsModel bean = list[index];
            return SongCoverWidget(
              image: bean.coverImageUrl,
              name: bean.name,
              playCount: bean.playCountString,
              onTap: () {
                if (onTap != null) {
                  onTap(bean.id);
                } else {
                  //默认跳转歌单页
                  jumpSongList(context, bean.id.toString());
                }
              },
            );
          },
          childCount: list.length ?? 0,
        ),
        gridDelegate: delegate,
      ),
    );
  }
}
