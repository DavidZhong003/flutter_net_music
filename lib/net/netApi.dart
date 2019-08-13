

import 'dioHelper.dart';

class ApiService {
  static Future<Map<String,dynamic>> getBanner()  async{
     return DioUtils.request("/banner?type=1", data: {});
  }
}
