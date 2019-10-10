/// 歌条目模型
///
class MusicTrackBean {
  MusicTrackBean(
      {this.id, this.name, this.album, this.artist, int mvId})
      : this.mvId = mvId ?? 0;

  int id;

  String name;

  Album album;

  List<Artist> artist;

  int mvId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicTrackBean &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Music{id: $id, title: $name, album: $album, artist: $artist}';
  }

  static MusicTrackBean fromMap(Map map) {
    if (map == null) {
      return null;
    }
    return MusicTrackBean(
        id: map["id"],
        name: map["name"],
        album: Album.fromMap(map["al"]),
        mvId: map['mv'] ?? 0,
        artist: (map["ar"] as List).cast<Map>().map(Artist.fromMap).toList());
  }

  static MusicTrackBean fromRecommendSongsMap(Map map) {
    if (map == null) {
      return null;
    }
    return MusicTrackBean(
        id: map["id"],
        name: map["name"],
        album: Album.fromMap(map["album"]),
        mvId: map['mv'] ?? 0,
        artist: (map["artists"] as List).cast<Map>().map(Artist.fromMap).toList());
  }

  Map toMap() {
    return {
      "id": id,
      "name": name,
      'mvId': mvId,
      "al": album.toMap(),
      "ar": artist.map((e) => e.toMap()).toList()
    };
  }

  bool haveMv() => this.mvId != 0;

  String getArName() {
    if (artist != null && artist.isNotEmpty) {
      if(artist.length==1){
        return artist[0].name;
      }
      String result="";
      artist.forEach((art){
        if(art == artist.last){
          result += "${art.name}";
        }else{
          result += "${art.name}/";
        }
      });
      return result;
    }
    return "";
  }
}

///专辑
class Album {
  Album({this.picUrl, this.name, this.id});

  String picUrl;

  String name;

  int id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Album &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'Album{name: $name, id: $id}';
  }

  static Album fromMap(Map map) {
    return Album(id: map["id"], name: map["name"], picUrl: map["picUrl"]);
  }

  Map toMap() {
    return {"id": id, "name": name, "picUrl": picUrl};
  }
}

///歌手
class Artist {
  Artist({
    this.name,
    this.id,
  });

  String name;

  int id;

  @override
  String toString() {
    return 'Artist{name: $name, id: $id}';
  }

  static Artist fromMap(Map map) {
    return Artist(id: map["id"], name: map["name"]);
  }

  Map toMap() {
    return {"id": id, "name": name};
  }
}
