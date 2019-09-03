import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/screen/songList/song_list.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';

import 'lyric_widget.dart';

///音乐播放界面
class MusicPlayPage extends StatelessWidget {
  final MusicTrackBean music;

  const MusicPlayPage({Key key, this.music}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //背景
          _buildBlurBackground(),
          Column(
            children: <Widget>[
              //appbar,
              _buildAppBar(context),
              //歌词or 旋转唱片
              Expanded(
                //淡入和淡出的view
                child: AnimatedCrossFade(
                    firstChild: LyricWidget(),
                    secondChild: RotateCoverWidget(
                      coverUrl: music.album.picUrl,
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
      ),
    );
  }

  ///标题 AppBar
  AppBar _buildAppBar(BuildContext context) {
    print(music);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            music.name,
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
                  music.getArName(),
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
  Widget _buildBlurBackground() {
    return HeadBlurBackground(
      opacity: 0.9,
      imageUrl: music.album.picUrl,
    );
  }
}

///音乐进度条
class MusicDurationProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryTextTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("00:00", style: theme.body1),
          Expanded(
            child: _buildProgressIndicator(context),
          ),
          Text("03:30", style: theme.body1),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return SliderTheme(
      data: Theme.of(context).sliderTheme.copyWith(
            //修改圆形半价,默认为10
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
          ),
      child: Slider(
          value: 0.3,
          activeColor: theme.primaryIconTheme.color.withOpacity(0.8),
          inactiveColor: theme.primaryIconTheme.color.withOpacity(0.4),
          onChanged: (value) {}),
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
              onPressed: emptyTap,
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

  const RotateCoverWidget({Key key, @required this.coverUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RotateCoverWidgetState();
  }
}

class _RotateCoverWidgetState extends State<RotateCoverWidget>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;

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
        if (_isPlaying &&
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
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _playOrStopAction();
              });
            },
            child: SizedBox(
              width: 250,
              child: Transform.rotate(
                angle: rotation,
                child: ClipOval(
                  child: NetImageView(url: widget.coverUrl),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _playOrStopAction() {
    if (!_isPlaying) {
      _animationController.stop();
    } else {
      _animationController.forward(
          from: _animationController.value);
    }
  }
}
