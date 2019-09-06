
import 'package:flutter_net_music/screen/music_play_contorl.dart';

import 'main.dart';

///请求播放歌曲
class PlayMusicWithIdAction extends ActionType<int> {
  final int id;
  PlayMusicWithIdAction(this.id) : super(payload: id);
}

class RequestPlayMusicSuccess extends VoidAction {}

class RequestPlayMusicFailed extends ActionType<String> {
  final String errorMsg;

  RequestPlayMusicFailed(this.errorMsg) : super(payload: errorMsg);
}

class PlayPositionChangeAction extends ActionType<Duration> {
  final Duration duration;

  PlayPositionChangeAction(this.duration) : super(payload: duration);
}
///初始化播放页
class InitPlayPageAction extends VoidAction{}

//歌曲长度改变动作
class ChangeDurationAction extends ActionType<Duration> {
  final Duration duration;

  ChangeDurationAction(this.duration) : super(payload: duration);
}

class ChangePlayModeAction extends VoidAction {}

class PlayPreAction extends VoidAction {}

class MusicPauseAction extends VoidAction {}

class MusicResumeAction extends VoidAction {}

class MusicStopAction extends VoidAction {}

class SavePlayStateAction extends VoidAction {}

class MusicPlayingAction extends VoidAction {}
