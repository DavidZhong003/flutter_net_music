import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/redux/reducers/play_page.dart';

import 'main.dart';

///请求播放歌曲
class PlayMusicWithIndexAction extends ActionType<int> {
  final int index;

  PlayMusicWithIndexAction(this.index) : super(payload: index);
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

class PlayModeChangeAction extends ActionType<MusicPlayMode> {
  final MusicPlayMode mode;

  PlayModeChangeAction(this.mode) : super(payload: mode);
}

class ChangNextSongIdAction extends VoidAction {}

class PlayPreAction extends VoidAction {}

class MusicPauseAction extends VoidAction {}

class MusicStopAction extends VoidAction {}

class MusicCompleteAction extends VoidAction {}

class SavePlayStateAction extends VoidAction {}

class MusicPlayingAction extends VoidAction {}
