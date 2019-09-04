import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_net_music/model/song_item_model.dart';
import 'dart:math';

import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/main.dart';

class MusicPlayer {
  //实际播放器
  static final AudioPlayer _audioPlayer = AudioPlayer()..onPlayerStateChanged.listen((s){
    print('Current player state: $s');
  })..onPlayerError.listen((msg){
    print('audioPlayer error : $msg');
  });

  //播放列表
  static _PlayList playList = _PlayList();

  static Future<int> _play(String url) {
   return  _audioPlayer.play(url);
  }

  static void pause() {
    _audioPlayer.pause();
  }

  static void stop() {
    _audioPlayer.stop();
  }

  ///绑定歌单
  static void bindMusicList(List<MusicTrackBean> musics, [int index = 0]) {
    playList.newPlayList(musics, index);
  }

  static MusicTrackBean getCurrent() {
    return playList._now;
  }

  static void playSongList({ActionType success, ActionType error}) async {
    var now = playList._now;
    if (now.url == null) {
      var result= await  ApiService.getSongsDetail(now.id.toString());
      now.url = result["data"][0]["url"];
    }
    if(now.url!=null){
      var result= await _play(now.url);
      print("=================");
      print(result);
      var duration =await  _audioPlayer.getDuration();
      print(duration);
    }else{

    }
  }
}

///播放列表
class _PlayList {
  List<MusicTrackBean> _list;
  int _current;

  _PlayList()
      : _list = [],
        _current = -1;

  _PlayList.newList(List<MusicTrackBean> list)
      : _list = list,
        _current = -1;

  void insert(MusicTrackBean bean) {
    if (_list.isEmpty || _current == _list.length - 1) {
      _list.add(bean);
    } else {
      _list.insert(_current + 1, bean);
    }
  }

  MusicTrackBean next() {
    if (_list.isEmpty) {
      return null;
    }
    if (_current == _list.length - 1) {
      return _list[_current = 0];
    } else {
      return _list[++_current];
    }
  }

  _PlayList newPlayList(List<MusicTrackBean> list, int index) {
    _list = list;
    _current = index;
    return this;
  }

  MusicTrackBean pre() {
    if (_current == -1 || _list.isEmpty) {
      return null;
    }
    if (_current == 0) {
      _current = _list.length - 1;
      return _list[_current];
    }
    return _list[--_current];
  }

  MusicTrackBean random() {
    return _list[_current = _getRandomIndex()];
  }

  int _getRandomIndex() {
    int index = Random().nextInt(_list.length - 1);
    return index == _current ? _getRandomIndex() : index;
  }

  MusicTrackBean get _now => _list[_current];
}

void loadMusicUrl(List<MusicTrackBean> list) async {
  assert(list.isNotEmpty);
  String ids;
  ids = list.map(((bean) => "${bean.id}")).join(",").toString();
  ApiService.getSongsDetail(ids).then((map) {
    List<dynamic> data = map["data"];
    data.asMap().forEach((index, value) {
      var bean = list[index];
      if (bean.id == value["id"]) {
        bean.url = value["url"];
      }
    });
  });
}
