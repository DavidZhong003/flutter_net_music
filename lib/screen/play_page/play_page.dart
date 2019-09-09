import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/redux/reducers/play_page.dart';
import 'package:flutter_net_music/screen/songList/song_list.dart';
import 'package:flutter_net_music/screen/main_tab_page.dart';
import 'package:flutter_net_music/utils/string.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toast/toast.dart';

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
                      ),
                      crossFadeState: CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 300)),
                ),
                //进度条
                DurationProgressBar(),
                //底部控制器
                _MusicControllerBar(
                  playMode: state.playMode,
                ),
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
class DurationProgressBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DurationProgressState();
  }
}

class _DurationProgressState extends State<DurationProgressBar> {
  Duration position = Duration.zero;

  Duration duration = Duration.zero;

  StreamSubscription _durationSub;

  StreamSubscription _positionSub;

  @override
  void initState() {
    super.initState();
    _durationSub = MusicPlayer.durationStream.listen((duration) {
      if (_durationFormat(this.duration) != _durationFormat(duration)) {
        setState(() {
          this.duration = duration;
        });
      }
    });
    _positionSub = MusicPlayer.positionStream.listen((position) {
      if (_durationFormat(this.position) != _durationFormat(position)) {
        setState(() {
          this.position = position;
        });
      }
    });
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryTextTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_durationFormat(position), style: theme.body1),
          Expanded(
            child: _buildProgressIndicator(context),
          ),
          Text(_durationFormat(duration), style: theme.body1),
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
          value: _positionValue,
          activeColor: theme.primaryIconTheme.color.withOpacity(0.8),
          inactiveColor: theme.primaryIconTheme.color.withOpacity(0.4),
          onChanged: (value) {}),
    );
  }

  double get _positionValue {
    if (position == null || duration == null || duration == Duration.zero) {
      return 0;
    }
    var value = (position.inMilliseconds) / (duration.inMilliseconds);
    return value;
  }

  String _durationFormat(Duration duration) {
    if (duration == null) {
      return "00:00";
    }
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    if (duration.inSeconds < 0) {
      return "-${-duration}";
    }
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

///底部控制器
class _MusicControllerBar extends StatelessWidget {
  // 当前播放模式
  final MusicPlayMode playMode;

  const _MusicControllerBar({Key key, @required this.playMode})
      : super(key: key);

  Widget buildPlayModel(BuildContext context) {
    var icons;
    switch (playMode) {
      case MusicPlayMode.heartbeat:
        icons = Icons.cast;
        break;
      case MusicPlayMode.random:
        icons = MyIcons.random;
        break;
      case MusicPlayMode.repeat:
        icons = MyIcons.repeat;
        break;
      case MusicPlayMode.repeat_one:
        icons = MyIcons.repeat_one;
        break;
    }
    return IconButton(
        icon: Icon(icons),
        onPressed: () {
          var mode = MusicPlayer.changePlayMode();
          Toast.show(playModeName(mode), context);
          StoreContainer.dispatch(ChangePlayModeAction());
        });
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
              ///上一首
              icon: Icon(MyIcons.skip_previous),
              onPressed: () {
                MusicPlayer.playPre();
              },
            ),
            PlayPauseControllerButton(),
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

  const RotateCoverWidget({Key key, @required this.coverUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RotateCoverWidgetState();
  }
}

class _RotateCoverWidgetState extends State<RotateCoverWidget>
    with SingleTickerProviderStateMixin {
  double rotation = 0;

  AnimationController _animationController;
  StreamSubscription _playingSub;

  bool _isPlaying = false;

  bool _isDispose;

  @override
  void initState() {
    super.initState();
    _isDispose = false;
    _isPlaying = MusicPlayer.lastState == AudioPlayerState.PLAYING;
    //动画控制
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

    _playingSub = MusicPlayer.playStateStream.listen((AudioPlayerState state) {
      if (_isDispose) {
        return;
      }
      animationControllerByState(state == AudioPlayerState.PLAYING);
    });
    animationControllerByState(_isPlaying);
  }
  /// 控制动画播放或者停止
  /// [isPlay] 播放标志位
  ///
  void animationControllerByState(bool isPlay) {
    if (isPlay) {
      _animationController.forward(from: _animationController.value);
      _isPlaying = true;
    } else {
      _isPlaying = false;
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _isDispose = true;
    _playingSub?.cancel();
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
              //todo 切换歌词
            },
            child: Transform.rotate(
              angle: rotation,
              child: ClipOval(
                child: SizedBox(
                  width: 250,
                  height: 250,
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
}

//播放暂停按钮
class PlayPauseControllerButton extends StatefulWidget {
  final double size;
  final Color color;

  const PlayPauseControllerButton({Key key, this.size, this.color}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayOrPauseState();
  }
}

class _PlayOrPauseState extends State<PlayPauseControllerButton> {
  bool _isPlaying = false;

  StreamSubscription _playSub;

  @override
  void initState() {
    super.initState();
    _isPlaying = MusicPlayer.lastState == AudioPlayerState.PLAYING;
    _playSub = MusicPlayer.playStateStream.listen((AudioPlayerState state) {
      setState(() {
        _isPlaying = state == AudioPlayerState.PLAYING;
      });
    });
  }

  @override
  void dispose() {
    _playSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isPlaying ? MyIcons.pause : MyIcons.play,
        color: widget.color,
        size: widget.size??36,
      ),
      onPressed: () {
        MusicPlayer.pauseOrStart();
      },
    );
  }
}
