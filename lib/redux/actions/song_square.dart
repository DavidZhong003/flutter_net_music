import 'package:flutter_net_music/model/play_list_model.dart';

import 'main.dart';

class ChangeBackImageAction extends ActionType<String> {
  final String image;

  ChangeBackImageAction(this.image) : super(payload: image);
}

///recommend
class RecommendRequestAction extends VoidAction {}

class RecommendSuccessAction extends ActionType<List<PlayListsModel>> {
  final List<PlayListsModel> data;

  RecommendSuccessAction(this.data) : super(payload: data);
}

///请求下一页
class RecommendRequestNextPageAction extends VoidAction{}