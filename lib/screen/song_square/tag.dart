import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/screen/song_square/recommend.dart';

class TagSongListWidget extends StatefulWidget {
  final String tag;

  const TagSongListWidget({Key key, this.tag}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TagSongListState();
  }
}

class _TagSongListState extends State<TagSongListWidget> {
  List<PlayListsModel> list;
  int page = 0;

  bool canLoadMore = true;
  @override
  void initState() {
    super.initState();
    loadPageData(page);
  }

  void loadPageData(int page) {
    ApiService.getSongList(cat: widget.tag, page: page).then((map){
      List<PlayListsModel> result = map["playlists"].map((bean) => PlayListsModel.fromMap(bean))
          .toList();
      bool more = map["more"];
      setState(() {
        canLoadMore = more;
        if(result!=null&&result.isNotEmpty){
          if(list==null){
            list = result;
          }else{
            list.addAll(result);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //loading
    if (list == null || list.isEmpty) {
      return Container(
        child: Center(
          child: WaveLoading(),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(16),
      child: SongCoverGridView(
        list: list,
      ),
    );
  }
}
