import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/utils/string.dart';
///播放器
class MusicPlayer {
  static AudioPlayer audioPlayer;

  static bool isPlayerAvailable = false;

  static Duration lastSongDuration;

  static Duration showDuration;

  static AudioPlayerState lastState;

  static int lastId;

  static init() {
    if (isPlayerAvailable) {
      return;
    }
    audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    audioPlayer.onAudioPositionChanged.listen((duration) {
      if (durationFormat(showDuration) != durationFormat(duration)) {
        showDuration = duration;
        StoreContainer.dispatch(PlayPositionChangeAction(duration));
      }
    });
    audioPlayer.onDurationChanged.listen((duration) {
      if (durationFormat(lastSongDuration) != durationFormat(duration)) {
        //长度改变
        lastSongDuration = duration;
        StoreContainer.dispatch(ChangeDurationAction(duration));
      }
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      lastState = state;
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
    if(lastId==id&&lastState!=AudioPlayerState.PLAYING){
      return;
    }
    var result = await ApiService.getSongsDetail(id.toString());
    var url = result["data"][0]["url"] ?? "";
    var code;
    //如果有播放歌曲暂停
    if(lastId!=id&&lastState==AudioPlayerState.PLAYING){
      await audioPlayer.stop();
    }
    //实际播放
    //403或者url 为空处理
    code = await audioPlayer.play((url == null || url == "")
        ? "https://music.163.com/song/media/outer/url?id=$id.mp3"
        : url);
    if (code == 1) {
      //播放成功
      lastId=id;
    } else {
      _dispatchAction(RequestPlayMusicFailed("播放器错误,$code"));
    }
  }

  ///播放下一首
  static void playNext() {
    //todo 更改id,播放歌曲
    _dispatchAction(ChangNextSongIdAction());
    _dispatchAction(PlayMusicWithIndexAction(1));
  }
}

///播放列表
class MusicPlayList {
  // 播放列表
  static List<MusicTrackBean> _playList;

  // 歌单id
  static String listId;

  static int _current = -1;

  ///绑定歌单
  ///[list]歌单
  ///[id] 歌单id
  ///[index]当前播放索引
  static void bindMusicList(List<MusicTrackBean> list, String id,
      [int index = 0]) {
    if (listId == id || list.isEmpty) {
      return;
    }
    _playList = list;
    id = listId;
    _current = index;
  }

  /// 获取当前歌单
  static get playList => _playList;

  ///获取当前索引
  static int get currentIndex => _current;

  static int get currentSongId => currentSong.id;

  static MusicTrackBean get currentSong {
    if (_current >= 0 && _current < _playList.length) {
      return _playList[_current];
    }
    return null;
  }
}
