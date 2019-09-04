import 'dio_helper.dart';

class ApiService {
  static Future<Map<String, dynamic>> getBanner() async {
    return DioUtils.request("/banner?type=1", data: {});
  }

  ///推荐歌单
  static Future<Map<String, dynamic>> getPersonalized() {
    return DioUtils.request("/personalized");
  }

  ///歌单详情
  ////playlist/detail?id=2948171497
  static Future<Map<String, dynamic>> getSongListDetails(String id) {
    return DioUtils.request("/playlist/detail?id=$id");
  }
  ///获取歌曲Url
  ///id 用,拼接
  static Future<Map<String, dynamic>> getSongsDetail(String ids) {
    return DioUtils.request("/song/url?id=$ids");
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
