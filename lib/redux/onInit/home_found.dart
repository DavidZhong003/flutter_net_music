import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/home_found.dart';

void bannerInit(store) => ApiService.getBanner().then((map) {
      store.dispatch(LoadBannerSuccess(map));
    });
