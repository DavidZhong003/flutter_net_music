import 'package:flutter_net_music/redux/actions/home_found.dart';
import 'package:flutter_net_music/redux/actions/login.dart';

import 'dio_helper.dart';

class ApiService {
  static Future<Map<String, dynamic>> getBanner() async {
    return DioUtils.request("/banner?type=1",
        data: {}, cacheOptions: CacheOptions.day_1);
  }

  ///推荐歌单
  static Future<Map<String, dynamic>> getPersonalized(
      {int limit = 20,
      SuccessHandler successHandler,
      ErrorHandler errorHandler}) {
    return DioUtils.request("/personalized?limit=$limit",
        successHandler: successHandler, errorHandler: errorHandler);
  }

  ///歌单详情
  ////playlist/detail?id=2948171497
  static Future<Map<String, dynamic>> getSongListDetails(String id) {
    return DioUtils.request("/playlist/detail?id=$id",
        cacheOptions: CacheOptions.day_15);
  }

  ///获取歌曲Url
  ///id 用,拼接
  static Future<Map<String, dynamic>> getSongsDetail(String ids) {
    return DioUtils.request("/song/url?id=$ids",
        cacheOptions: CacheOptions.minutes_15);
  }

  ///获取新碟
  static Future<Map<String, dynamic>> getNewAlbums() {
    return DioUtils.request("/top/album",
        successHandler: (map) =>
            NewAlbumsRequestSuccessAction(map["albums"].sublist(0, 3)));
  }

  ///获取新歌
  static Future<Map<String, dynamic>> getNewSongs([int type = 0]) {
    return DioUtils.request("/top/song?type=$type",
        successHandler: (map) =>
            NewSongRequestSuccessAction(map["data"].sublist(0, 3)));
  }

  ///歌单
  static Future<Map<String, dynamic>> getSongList(
      {String cat,
      int limit = 30,
      int page = 0,
      SuccessHandler successHandler}) {
    String url =
        "/top/playlist?cat=${cat ?? "全部"}&limit=$limit&offset=${(page - 1) * limit}";
    return DioUtils.request(url, successHandler: successHandler);
  }

  ///精品歌单
  static Future<Map<String, dynamic>> getHighQualitySongList([int limit]) {
    String url = "/top/playlist/highquality?limit=$limit";
    return DioUtils.request(
      url,
    );
  }

  ///登录
  static Future<Map<String, dynamic>> login(String phone, String pwd) {
    return DioUtils.request(
      "/login/cellphone?phone=$phone&password=$pwd",
      successHandler: (map) => LoginSuccessAction(map),
    );
  }

  ///退出登录
  static Future<Map<String, dynamic>> logout() {
    return DioUtils.request("/logout",
        successHandler: (map) => LogoutAction());
  }
}

/// 错误信息
class RequestFailureInfo {
  String errorCode;
  String errorMessage;
  String dateTime;

  RequestFailureInfo({this.errorCode, this.errorMessage, this.dateTime});

  RequestFailureInfo.initialState() {
    errorCode = '';
    errorMessage = '';
    dateTime = '';
  }

  bool get hasErrorInfo =>
      !(errorCode == null || errorCode.isEmpty) ||
      !(errorMessage == null || errorMessage.isEmpty);

  @override
  String toString() {
    return 'RequestFailureInfo{errorCode: $errorCode, errorMessage: $errorMessage, dateTime: $dateTime}';
  }

  @override
  int get hashCode =>
      errorCode.hashCode ^ errorMessage.hashCode ^ dateTime.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is RequestFailureInfo &&
          errorCode == other.errorCode &&
          errorMessage == other.errorMessage &&
          dateTime == other.dateTime;
}
