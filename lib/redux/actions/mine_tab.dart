import 'package:flutter_net_music/model/play_list_model.dart';

import 'main.dart';

class LoadUserSongList extends ActionType<int> {
  final int userId;

  LoadUserSongList(this.userId) : super(payload: userId);
}

class LoadUserSongListSuccessAction extends ActionType<List<PlayListsModel>> {
  final List<PlayListsModel> create;

  final List<PlayListsModel> sub;

  LoadUserSongListSuccessAction(this.create, this.sub);
}

class InitUserSongListAction extends VoidAction{}
