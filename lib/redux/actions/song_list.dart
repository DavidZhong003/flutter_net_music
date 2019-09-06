import 'package:flutter/material.dart';
import 'package:flutter_net_music/redux/actions/main.dart';

class SongListRequestSuccess extends ActionType<Map<String, dynamic>> {
  final Map<String, dynamic> data;

  SongListRequestSuccess(this.data) : super(payload: data);
}

class RequestSongsListAction extends ActionType<String> {
  final String id;

  RequestSongsListAction(this.id) : super(payload: id);
}

//播放全部
class PlayAllAction extends ActionType<BuildContext> {
  final BuildContext context;

  PlayAllAction(this.context) : super(payload: context);
}

class PlaySongAction extends ActionType<int> {
  final int id;
  PlaySongAction(this.id) : super(payload: id);
}
