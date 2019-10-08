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

///初始化播放页
class InitPlayPageAction extends VoidAction{}


class ChangePlayModeAction extends VoidAction {}

class PlayPreAction extends VoidAction {}

class MusicStopAction extends VoidAction {}

class SavePlayStateAction extends VoidAction {}

class MusicPlayingAction extends VoidAction {}
