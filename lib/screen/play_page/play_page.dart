import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/play_page.dart';
import 'package:flutter_net_music/screen/songList/song_list.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../music_play_contorl.dart';
import 'lyric_widget.dart';

String _testPicUrl =
    "http://p2.music.126.net/t9FzacVQw6CC-P1-X5Pquw==/109951164308230490.jpg";

///音乐播放界面
class MusicPlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var content = StoreConnector<AppState, PlayPageState>(
      converter: (store) => store.state.musicPlayState,
      onInit: (store) => store.dispatch(InitPlayPageAction()),
      builder: (BuildContext context, PlayPageState state) {
        final music = state.music;
        return Stack(
          children: <Widget>[
            //背景
            _buildBlurBackground(music?.album?.picUrl ?? _testPicUrl),
            Column(
              children: <Widget>[
                //appbar,
                _buildAppBar(
                    context, music?.name ?? "", music?.getArName() ?? ""),
                //歌词or 旋转唱片
                Expanded(
                  //淡入和淡出的view
                  child: AnimatedCrossFade(
                      firstChild: LyricWidget(),
                      secondChild: RotateCoverWidget(
                        coverUrl: music?.album?.picUrl ?? _testPicUrl,
                        isPlaying: state.isPlaying,
                      ),
                      crossFadeState: CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 300)),
                ),
                //进度条
                MusicDurationProgressBar(),
                //底部控制器
                _MusicControllerBar(),
              ],
            )
          ],
        );
      },
    );
    return Scaffold(
      body: content,
    );
  }

  ///标题 AppBar
  AppBar _buildAppBar(BuildContext context, String name, String arName) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(
                  arName,
                  style: Theme.of(context).primaryTextTheme.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: 16,
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.share),
        )
      ],
    );
  }

  /// 背景
  Widget _buildBlurBackground(String picUrl) {
    return HeadBlurBackground(
      opacity: 0.9,
      imageUrl: picUrl,
    );
  }
}

///音乐进度条
class MusicDurationProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryTextTheme;
    return StoreConnector<AppState, DurationState>(
      converter: (store) => store.state.musicPlayState.durationState,
      builder: (BuildContext context, DurationState duration) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(duration.positionString, style: theme.body1),
              Expanded(
                child: _buildProgressIndicator(context, duration),
              ),
              Text(duration.durationString, style: theme.body1),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(BuildContext context, DurationState duration) {
    final theme = Theme.of(context);
    return SliderTheme(
      data: Theme.of(context).sliderTheme.copyWith(
            //修改圆形半价,默认为10
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
          ),
      child: Slider(
          value: duration.positionValue,
          activeColor: theme.primaryIconTheme.color.withOpacity(0.8),
          inactiveColor: theme.primaryIconTheme.color.withOpacity(0.4),
          onChanged: (value) {
            print("value===========$value");
          }),
    );
  }
}

class _MusicControllerBar extends StatelessWidget {
  Widget buildPlayModel(BuildContext context) {
    return IconButton(icon: Icon(MyIcons.random), onPressed: emptyTap);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final theme = appTheme.copyWith(
      iconTheme: appTheme.iconTheme.copyWith(
        color: appTheme.primaryIconTheme.color,
      ),
    );
    return Theme(
      data: theme,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildPlayModel(context),
            IconButton(
              icon: Icon(MyIcons.skip_previous),
              onPressed: emptyTap,
            ),
            IconButton(
              icon: Icon(
                MyIcons.pause,
                size: 36,
              ),
              onPressed: emptyTap,
            ),
            IconButton(
              icon: Icon(
                MyIcons.skip_next,
              ),
              onPressed: () {
                //下一首
                MusicPlayer.playNext();
              },
            ),
            IconButton(
              icon: Icon(MyIcons.play_list),
              onPressed: emptyTap,
            ),
          ],
        ),
      ),
    );
  }
}

///旋转封面
class RotateCoverWidget extends StatefulWidget {
  final String coverUrl;

  final bool isPlaying;

  const RotateCoverWidget({Key key, @required this.coverUrl, @required this.isPlaying})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RotateCoverWidgetState();
  }
}

class _RotateCoverWidgetState extends State<RotateCoverWidget>
    with SingleTickerProviderStateMixin {
  double rotation = 0;

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(seconds: 20),
        vsync: this,
        animationBehavior: AnimationBehavior.normal);
    _animationController
      ..addListener(() {
        setState(() {
          rotation = _animationController.value * 2 * pi;
        });
      })
      ..addStatusListener((status) {
        ///重新播放
        if (widget.isPlaying &&
            status == AnimationStatus.completed &&
            _animationController.value == 1) {
          _animationController.forward(from: 0);
        }
      });
    _playOrStopAction();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 250,
              child: Transform.rotate(
                angle: rotation,
                child: ClipOval(
                  child: NetImageView(
                    url: widget.coverUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _playOrStopAction() {
    if (!widget.isPlaying) {
      _animationController.stop();
    } else {
      _animationController.forward(from: _animationController.value);
    }
  }
}
