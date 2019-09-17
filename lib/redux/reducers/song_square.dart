import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/song_square.dart';

import 'main.dart';
import 'package:flutter/material.dart';

@immutable
class SongSquareState {
  final String backImage;

  SongSquareState({
    this.backImage,
  });

  SongSquareState copyWith({
    String backImage,
  }) {
    return SongSquareState(
      backImage: backImage ?? this.backImage,
    );
  }

  SongSquareState.initialState() : backImage = "";
}

class SongSquareReducer extends Reducer<SongSquareState> {
  @override
  SongSquareState redux(SongSquareState state, action) {
    switch (action.runtimeType) {
      case ChangeBackImageAction:
        return state.copyWith(
          backImage: action.payload,
        );
    }
    return state;
  }
}
