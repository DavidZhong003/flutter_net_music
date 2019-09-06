import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/redux/reducers/music_play.dart';

import 'main.dart';

///加载播放列表
class LoadPlaylistAction extends ActionType<List<MusicTrackBean>> {
  final List<MusicTrackBean> musicList;

  LoadPlaylistAction(this.musicList) : super(payload: musicList);
}

///请求播放歌曲
class RequestPlayMusicAction extends VoidAction {}

class RequestPlayMusicSuccess extends VoidAction {}

class RequestPlayMusicFailed extends ActionType<String> {
  final String errorMsg;

  RequestPlayMusicFailed(this.errorMsg) : super(payload: errorMsg);
}

class PlayPositionChangeAction extends ActionType<Duration> {
  final Duration duration;

  PlayPositionChangeAction(this.duration) : super(payload: duration);
}
//歌曲长度改变动作
class ChangeDurationAction extends ActionType<Duration>{
  final Duration duration;

  ChangeDurationAction(this.duration): super(payload: duration);
}

class PlayModeChangeAction extends ActionType<MusicPlayMode> {
  final MusicPlayMode mode;

  PlayModeChangeAction(this.mode) : super(payload: mode);
}

class PlayNextAction extends VoidAction{}

class PlayPreAction extends VoidAction{}

class MusicPauseAction extends VoidAction{}

class MusicStopAction extends VoidAction{}

class MusicCompleteAction extends VoidAction{}

class SavePlayStateAction extends VoidAction{}

class MusicPlayingAction extends VoidAction{}