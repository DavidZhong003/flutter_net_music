import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/redux/actions/play_bar_list.dart';
import 'package:flutter_net_music/redux/actions/song_list.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/play_bar_list.dart';
import 'package:flutter_net_music/redux/reducers/play_page.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_net_music/screen/play_page/play_page.dart';
import 'package:flutter_net_music/screen/song_list/song_list.dart';
import 'package:flutter_net_music/utils/string.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MusicPlayBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget content = buildContent(context);
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
          width: 0.5,
          color: theme.dividerColor.withAlpha(0x10),
        ),
      )),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          jumpPageByName(context, PathName.ROUTE_MUSIC_PLAY);
        },
        child: Opacity(
          opacity: 0.9,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: content,
          ),
        ),
      ),
    );
  }

  ///构建主要内容
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.textTheme.body1.color.withAlpha(0xbb);
    return StoreConnector<AppState, PlayPageState>(
        converter: (store) => store.state.musicPlayState,
        builder: (BuildContext context, PlayPageState state) {
          if (state.music == null) {
            return Container();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //封面头像
              ClipOvalImageView(
                size: 36,
                creatorUrl: state.music?.album?.picUrl,
              ),
              SizedBox(
                width: 8,
              ),
              //歌曲名
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    state.music.name,
                    style: theme.textTheme.body1,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  //todo 歌词
                  Text(
                    state.music?.getArName(),
                    style: theme.textTheme.caption,
                  ),
                ],
              )),
              SizedBox(
                width: 8,
              ),
              //播放按钮
              PlayPauseControllerButton(
                color: color,
                size: 24,
              ),
              //列表
              PlayListButton(),
            ],
          );
        });
  }
}

class MusicPlayBarContainer extends StatelessWidget {
  final Widget child;

  const MusicPlayBarContainer({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: child,
        ),
        MusicPlayBar(),
      ],
    );
  }
}

class PlayListButton extends StatelessWidget {
  final Color color;

  final double size;

  const PlayListButton({Key key, this.color, this.size = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.textTheme.body1.color.withAlpha(0xbb);
    return IconButton(
      icon: Icon(
        MyIcons.play_list,
        color: this.color ?? color,
        size: this.size,
      ),
      onPressed: () async {
        _showModalBottomSheet(context);
      },
    );
  }

  // 弹出底部菜单列表模态对话框
  Future<int> _showModalBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.textTheme.caption.color.withAlpha(0x6a);
    return showModalBottomSheet<int>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StoreConnector<AppState, PlayListState>(
          converter: (s) => s.state.playListState,
          onInit: (s) => s.dispatch(OnInitPlayListData()),
          builder: (BuildContext context, state) {
            final musics = state.playList;
            return IconTheme(
              data: theme.iconTheme.copyWith(color: iconColor),
              child: Column(
                children: <Widget>[
                  //标头
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        buildPlayModelIcon(context, state.playMode),
                        Expanded(
                            child: Text(
                          "${playModeName(state.playMode)} (${musics?.length ?? 0})",
                          style: theme.textTheme.body1.copyWith(fontSize: 18),
                        )),
                        IconButton(
                          iconSize: 18,
                          icon: Icon(MyIcons.delete_item),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.5,
                  ),
                  Expanded(
                    child: _MusicListView(
                      playList: state.playList,
                      playId: state.playSongId,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MusicListView extends StatefulWidget {
  final List<MusicTrackBean> playList;

  final int playId;

  const _MusicListView({Key key, this.playList, this.playId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MusicListState();
  }
}

///控制列表状态
class _MusicListState extends State<_MusicListView> {
  ScrollController _controller;

  static double _itemExtent = 45;

  static int _screenItemCount = 9;

  @override
  void initState() {
    super.initState();
    if (widget.playList != null && widget.playId != -1) {
      // find index
      var index =
          widget.playList.indexWhere((bean) => bean.id == widget.playId) ?? 0;
      var offset = _computeOffset(index);
      // scroll to
      _controller = ScrollController(
          initialScrollOffset: offset, keepScrollOffset: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final musics = widget.playList;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return buildSongItem(context, index, widget.playId);
      },
      itemCount: musics?.length ?? 0,
      controller: _controller,
      itemExtent: _itemExtent,
    );
  }

  Widget buildSongItem(BuildContext context, int index, int playId) {
    final music = widget.playList[index];
    final theme = Theme.of(context);
    final bool isPlaying = playId == music.id;
    List<Widget> children = [];
    if (isPlaying) {
      children.add(Icon(
        MyIcons.volume_up,
        color: Colors.red,
        size: 18,
      ));
      children.add(SizedBox(
        width: 2,
      ));
    }
    final textColor = isPlaying ? Colors.red : null;
    //歌名
    children.add(Expanded(
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            text: music.name,
            style:
                theme.textTheme.body1.copyWith(fontSize: 15, color: textColor),
            children: <TextSpan>[
              TextSpan(
                  text: " - ${music.getArName()}",
                  style: theme.textTheme.caption.copyWith(color: textColor))
            ]),
      ),
    ));
    //删除图标
    children.add(GestureDetector(
      onTap: () {},
      child: Icon(
        Icons.close,
        size: 20,
        color: theme.textTheme.caption.color.withAlpha(0x64),
      ),
    ));
    return InkWell(
      onTap: () {
        //播放某个歌曲
        StoreContainer.dispatch(PlaySongAction(music.id));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8, top: 12, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  ///计算偏移量
  double _computeOffset(int index) {
    int length = widget.playList.length;
    if (length < _screenItemCount) {
      return 0;
    }
    var i = index - _screenItemCount / 2 + 1;
    var len = i * _itemExtent;
    var max = _itemExtent * (length - _screenItemCount);
    if (len > max) {
      len = max;
    } else if (len < 0) {
      len = 0;
    }
    return len;
  }
}
