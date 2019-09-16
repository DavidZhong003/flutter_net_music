import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/song_square.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/song_square.dart';
import 'package:flutter_net_music/screen/found_tab_page.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';
import 'package:flutter_net_music/utils/string.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class RecommendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RecommendState>(
        onInit: (s) => s.dispatch(RecommendRequestAction()),
        builder: (BuildContext context, RecommendState state) {
          if (state.loading) {
            return Container(
              child: Center(
                child: WaveLoading(),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _Banner(
                  banner: state.banner,
                ),
                SongCoverGridView(
                  list: state.list,
                ),
              ],
            ),
          );
        },
        converter: (s) => s.state.songSquareState.recommendState);
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

class _BannerState extends State<_Banner>{

  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex =0;
    StoreContainer.dispatch(ChangeBackImageAction(widget.banner[currentIndex].coverImageUrl));
  }
  @override
  Widget build(BuildContext context) {
    final List<PlayListsModel> banner = widget.banner;
    return Container(
      padding: EdgeInsets.all(16),
      height: 250,
      child: Swiper(
        itemCount: banner.length,
        itemBuilder: (context, index) {
          var bean = banner[index];
          return Opacity(
            opacity: currentIndex==index?1:0.6,
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
          );
        },
        controller: SwiperController(),
        loop: true,
        onIndexChanged: (int) {
          setState(() {
            currentIndex = int;
          });
          StoreContainer.dispatch(ChangeBackImageAction(banner[int].coverImageUrl));
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
          color:Colors.white.withOpacity(0.9),
          child: Center(child: Icon(Icons.play_arrow),),
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

  final ScrollPhysics physics;

  final bool canLoadMore;

  const SongCoverGridView({
    Key key,
    @required this.list,
    this.onTap,
    this.padding = const EdgeInsets.only(top: 8),
    this.delegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 3,
      crossAxisSpacing: 6,
      childAspectRatio: 10 / 12.8,
    ),
    this.physics = const NeverScrollableScrollPhysics(),
    this.canLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: padding,
        gridDelegate: delegate,
        physics: physics,
        itemCount: list.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          PlayListsModel bean = list[index];
          return SongCoverWidget(
            image: bean.coverImageUrl,
            name: bean.name,
            playCount: bean.playCountString,
            onTap: () {
              if (onTap != null) onTap(bean.id);
            },
          );
        });
  }
}
