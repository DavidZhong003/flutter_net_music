import 'package:flutter/material.dart';

import 'main.dart';

class RequestRecommendSongs extends VoidAction {}

class RequestRecommendSongsSuccess extends ActionType<List<dynamic>> {
  final List<dynamic> data;

  RequestRecommendSongsSuccess(this.data) : super(payload: data);
}

class PlayAllRecommendSong extends ActionType<BuildContext> {
  final BuildContext context;

  PlayAllRecommendSong(this.context) : super(payload: context);
}
