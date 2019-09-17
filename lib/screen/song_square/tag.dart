import 'package:flutter/material.dart';
import 'package:flutter_net_music/model/play_list_model.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/net/net_widget.dart';
import 'package:flutter_net_music/redux/actions/song_square.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
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
  Set<PlayListsModel> list;

  bool get _isLoading => list == null || list == null;

  int page = 1;

  bool noMore = false;

  bool _isNetRequest = false;

  @override
  void initState() {
    super.initState();
    _getPageData();
  }

  @override
  Widget build(BuildContext context) {
    //loading
    if (_isLoading) {
      return Container(
        child: Center(
          child: WaveLoading(),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels >=
            (notification.metrics.maxScrollExtent - 50)) {
          // todo  加载更多
          _getPageData();
          return true;
        }
        return false;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SongCoverGridView(
            list: list.toList(),
          ),
          buildMore(context,noMore),
        ],
      ),
    );
  }

  ///加载数据
  void _getPageData() {
    if (_isNetRequest || noMore) {
      return;
    }
    _isNetRequest = true;

    final start = DateTime.now();
    ApiService.getSongList(page: page, cat: widget.tag).then((map) {
      _processResult(map);
      _notifyLoadSuccess(start);
    }).whenComplete(() {
      _isNetRequest = false;
    });
  }

  void _processResult(Map<String, dynamic> map) {
    noMore = !map["more"];
    List<dynamic> playLists = map["playlists"];
    List<PlayListsModel> result =
        playLists.map((bean) => PlayListsModel.fromMap(bean)).toList();
    if (list == null) {
      list = result.toSet();

      ///通知更改背景
      StoreContainer.dispatch(ChangeBackImageAction(list.first.coverImageUrl));
    } else {
      list.addAll(result);
    }
    if (list.length > 150) {
      noMore = true;
    }
  }

  void _notifyLoadSuccess(DateTime start) {
    final end = DateTime.now();
    final duration = end.millisecond - start.millisecond;
    if (page != 0 && duration < 1000) {
      ///防止太快
      Future.delayed(Duration(milliseconds: (1000 - duration)))
          .whenComplete(() {
        //加载成功后page+1
        setState(() {
          page++;
        });
      });
    } else {
      //加载成功后page+1
      setState(() {
        page++;
      });
    }
  }
}
