

import 'dioHelper.dart';

class ApiService {
  static Future<Map<String,dynamic>> getBanner()  async{
     return DioUtils.request("/banner?type=1", data: {});
  }
  ///推荐歌单
  static Future<Map<String,dynamic>> getPersonalized(){
    return DioUtils.request("/personalized");
  }
}
