import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/redux/actions/play_page.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:flutter_net_music/utils/random.dart';
import 'package:flutter_net_music/utils/string.dart';

///播放器
class MusicPlayer {
  static AudioPlayer _audioPlayer;

  static bool isPlayerAvailable = false;

  static Duration lastSongDuration;

  static Duration showDuration;

  static AudioPlayerState lastState;

  static MusicPlayMode get playMode => _SwitchController.mode;

  static Stream<Duration> get positionStream => _audioPlayer.onAudioPositionChanged;

  static Stream<Duration> get durationStream => _audioPlayer.onDurationChanged;

  static int lastId;

  static bool get isPlaying => AudioPlayerState.PLAYING == lastState;

  static init() {
    if (isPlayerAvailable) {
      return;
    }
    _audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    _audioPlayer.onPlayerStateChanged.listen((state) {
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
          playNext();
          break;
      }
    });
    isPlayerAvailable = true;
  }

  void disConnect() {
    _audioPlayer.release();
    _audioPlayer.dispose();
  }

  static void _dispatchAction(ActionType action) {
    if (action != null) {
      StoreContainer.dispatch(action);
    }
  }

  static Future<int> getSongsDuration() {
    return _audioPlayer.getDuration();
  }

  static void playWithId(int id) async {
    init();
    if (lastId == id && lastState == AudioPlayerState.PLAYING) {
      return;
    }
    var result = await ApiService.getSongsDetail(id.toString());
    var url = result["data"][0]["url"] ?? "";
    var code;
    //如果有播放歌曲暂停
    if (lastId != id && lastState == AudioPlayerState.PLAYING) {
      await _audioPlayer.stop();
    }
    //实际播放
    //403或者url 为空处理
    code = await _audioPlayer.play((url == null || url == "")
        ? "https://music.163.com/song/media/outer/url?id=$id.mp3"
        : url);
    if (code == 1) {
      //播放成功
      lastId = id;
      _PlayedList.push(MusicPlayList.currentSong);
    } else {
      _dispatchAction(RequestPlayMusicFailed("播放器错误,$code"));
    }
  }

  ///播放下一首
  static void playNext() {
    int id = MusicPlayList.playList[_SwitchController.getNext()].id;
    _dispatchAction(PlayMusicWithIdAction(id));
  }

  ///播放下一首
  static void playPre() {
    int id = MusicPlayList.playList[_SwitchController.getPre()].id;
    _dispatchAction(PlayMusicWithIdAction(id));
  }

  static void pauseOrStart() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      _dispatchAction(MusicPauseAction());
    } else {
      await _audioPlayer.resume();
      _dispatchAction(MusicResumeAction());
    }
  }

  static MusicPlayMode changePlayMode([bool canHeartbeat = false]) {
    MusicPlayMode change;
    switch (playMode) {
      case MusicPlayMode.repeat_one:
        change = MusicPlayMode.repeat;
        break;
      case MusicPlayMode.repeat:
        change = MusicPlayMode.random;
        break;
      case MusicPlayMode.random:
        change =
            canHeartbeat ? MusicPlayMode.heartbeat : MusicPlayMode.repeat_one;
        break;
      case MusicPlayMode.heartbeat:
        change = MusicPlayMode.repeat_one;
    }
    _SwitchController.mode = change;
    return change;
  }
}

///播放列表
class MusicPlayList {
  // 播放列表
  static List<MusicTrackBean> _playList;

  // 歌单id
  static String listId;

  static int _current = -1;

  static int get lastIndex => _playList.length - 1;

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

///切换控制器
class _SwitchController {
  static MusicPlayMode mode = MusicPlayMode.repeat;

  static int getNext() {
    int cur = MusicPlayList._current;
    switch (mode) {
      case MusicPlayMode.repeat:
        if (cur == MusicPlayList.lastIndex) {
          MusicPlayList._current = 0;
        }else{
          MusicPlayList._current++;
        }
        break;
      case MusicPlayMode.random:
        MusicPlayList._current =
            randomInt(MusicPlayList.lastIndex, MusicPlayList._current);
        break;
      case MusicPlayMode.repeat_one:
        break;
      case MusicPlayMode.heartbeat:
        break;
    }
    return MusicPlayList._current;
  }

  static int getPre() {
    int cur = MusicPlayList._current;
    switch (mode) {
      case MusicPlayMode.repeat:
        if (cur == 0) {
          MusicPlayList._current = MusicPlayList.lastIndex;
        }else{
          MusicPlayList._current--;
        }
        break;
      case MusicPlayMode.random:
        var last = _PlayedList.getLast();
        int lastIndex = MusicPlayList._playList.indexOf(last);
        if (lastIndex != -1) {
          MusicPlayList._current = lastIndex;
        }
        break;
      case MusicPlayMode.repeat_one:
        break;
      case MusicPlayMode.heartbeat:
        break;
    }
    return MusicPlayList._current;
  }
}

/// 播放模式
enum MusicPlayMode { repeat_one, repeat, random, heartbeat }

//已播放列表
class _PlayedList {
  static Set<MusicTrackBean> _set = Set();

  static void push(MusicTrackBean bean) {
    _set.add(bean);
  }

  static MusicTrackBean getLast() {
    return _set.last;
  }

  static int getLastId() {
    return _set.last?.id ?? -1;
  }
}
