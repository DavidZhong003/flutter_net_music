import 'package:flutter_net_music/redux/actions/main.dart';

class SongListRequestSuccess extends ActionType<Map<String, dynamic>> {
  final Map<String, dynamic> data;

  SongListRequestSuccess(this.data) : super(payload: data);
}
class RequestSongsListAction extends ActionType<String>{
  final String id;
  RequestSongsListAction(this.id):super(payload:id);
}