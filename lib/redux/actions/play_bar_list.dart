import 'package:flutter_net_music/redux/actions/main.dart';

class OnInitPlayListData extends VoidAction {}

class ChangePlaySongIdAction extends ActionType<int> {
  final int playId;

  ChangePlaySongIdAction(this.playId) : super(payload: playId);
}
