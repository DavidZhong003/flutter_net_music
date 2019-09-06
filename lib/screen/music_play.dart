import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/redux/actions/music_play.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';

class MusicPlayWidget extends StatefulWidget {
  final Widget child;

  const MusicPlayWidget({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MusicPlayState();
  }
}

class _MusicPlayState extends State<MusicPlayWidget> {
  bool iPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MusicPlayer {
  static AudioPlayer audioPlayer;

  static bool isPlayerAvailable = false;

  static Duration lastSongDuration;

  static Duration showDuration;
  static init() {
    if (isPlayerAvailable) {
      return;
    }
    audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    audioPlayer.onAudioPositionChanged.listen((duration) {
      if(_durationFormat(showDuration)!=_durationFormat(duration)){
        showDuration = duration;
        StoreContainer.dispatch(PlayPositionChangeAction(duration));
      }
    });
    audioPlayer.onDurationChanged.listen((duration) {
      if(_durationFormat(lastSongDuration)!=_durationFormat(duration)){
        //长度改变
        lastSongDuration = duration;
        StoreContainer.dispatch(ChangeDurationAction(duration));
      }
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case AudioPlayerState.PLAYING:
          //播放成功or 恢复播放
          StoreContainer.dispatch(MusicPlayingAction());
          break;
        case AudioPlayerState.STOPPED:
          StoreContainer.dispatch(MusicStopAction());
          break;
        case AudioPlayerState.PAUSED:
          StoreContainer.dispatch(MusicPauseAction());
          break;
        case AudioPlayerState.COMPLETED:
          StoreContainer.dispatch(MusicCompleteAction());
          break;
      }
    });
    isPlayerAvailable = true;
  }

  void disConnect() {
    audioPlayer.release();
    audioPlayer.dispose();
  }

  static void _dispatchAction(ActionType action) {
    if (action != null) {
      StoreContainer.dispatch(action);
    }
  }

  static Future<int> getSongsDuration() {
    return audioPlayer.getDuration();
  }

  static void notifyDurationChange() async {
    var int = await audioPlayer.getDuration();
    _dispatchAction(ChangeDurationAction(Duration(microseconds: int)));
  }

  static void playWithId(int id) async {
    init();
    var result = await ApiService.getSongsDetail(id.toString());
    var url = result["data"][0]["url"] ?? "";
    if (url == null || url == "") {
      //播放失败
      _dispatchAction(RequestPlayMusicFailed("播放错误,资源不可用"));
      return;
    }
    //实际播放
    var code = await audioPlayer.play(url);
    if (code == 1) {
      //播放成功
    } else {
      _dispatchAction(RequestPlayMusicFailed("播放器错误,$code"));
    }
  }
}

String _durationFormat(Duration duration){
  if(duration==null){
    return "";
  }
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  if (duration.inMilliseconds < 0) {
    return "-${-duration}";
  }
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}