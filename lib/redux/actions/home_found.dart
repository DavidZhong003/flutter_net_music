import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';
import 'package:redux/redux.dart';

///刷新
class RefreshAction extends VoidAction {}

///加载更多
class LoadMoreAction extends VoidAction {}

///加载轮播图
class LoadBanner extends VoidAction {}

///加载推荐歌单
///加载轮播图成功
class LoadBannerSuccess extends ActionType<Map<String, dynamic>> {
  final Map<String, dynamic> banner;

  LoadBannerSuccess(this.banner) : super(payload: banner);
}

void requestBannerAction(Store<AppState> store) async{
  ApiService.getBanner().then((map){
    store.dispatch(LoadBannerSuccess(map));
  });
}
