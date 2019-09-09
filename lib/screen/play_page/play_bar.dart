import 'package:flutter/material.dart';
import 'package:flutter_net_music/my_font/my_icon.dart';
import 'package:flutter_net_music/routes.dart';
import 'package:flutter_net_music/screen/play_page/play_page.dart';
import 'package:flutter_net_music/screen/songList/song_list.dart';

var _testImag =
    "http://p1.music.126.net/8sPbSSzpMK73O3SHzD8LOg==/109951163214606033.jpg";

class MusicPlayBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
          width: 0.5,
          color: theme.dividerColor.withAlpha(0x10),
        ),
      )),
      child: GestureDetector(
        onTap: (){
          jumpPageByName(context, PathName.ROUTE_MUSIC_PLAY);
        },
        child: Opacity(
          opacity: 0.9,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //封面头像
                ClipOvalImageView(
                  size: 36,
                  creatorUrl: _testImag,
                ),
                SizedBox(
                  width: 8,
                ),
                //歌曲名
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "歌曲名",
                      style: theme.textTheme.body1,
                    ),
                    SizedBox(height: 2,),
                    Text(
                      "这是歌词",
                      style: theme.textTheme.caption,
                    ),
                  ],
                )),
                SizedBox(
                  width: 8,
                ),
                //播放按钮
                PlayPauseControllerButton(
                  size: 30,
                ),
                //列表
                IconButton(
                  icon: Icon(MyIcons.play_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MusicPlayBarContainer extends StatelessWidget {
  final Widget child;

  const MusicPlayBarContainer({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: child,
        ),
        MusicPlayBar(),
      ],
    );
  }
}
