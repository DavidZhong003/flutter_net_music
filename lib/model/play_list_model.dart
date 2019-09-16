import 'package:flutter_net_music/utils/string.dart';

///歌单条目模型
///
///
class PlayListsModel {
  int id;
  String name;
  String coverImageUrl;
  int playCount;

  PlayListsModel(this.id, {this.name, this.coverImageUrl, this.playCount});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayListsModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  String toString() {
    return 'PlayListsModel{id: $id, name: $name, coverImageUrl: $coverImageUrl, playCount: $playCount}';
  }

  @override
  int get hashCode => id.hashCode;

  static PlayListsModel fromMap(Map map) {
    if (map == null) {
      return null;
    }
    return PlayListsModel(map["id"],
        name: map["name"],
        coverImageUrl: map["coverImgUrl"],
        playCount: map["playCount"]);
  }

  static PlayListsModel fromRecommendMap(Map map) {
    if (map == null) {
      return null;
    }
    return PlayListsModel(map["id"],
        name: map["name"],
        coverImageUrl: map["picUrl"],
        playCount: map["playCount"]);
  }

  String get playCountString =>formattedNumber(this.playCount??0);
}
