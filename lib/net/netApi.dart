import 'package:dio/dio.dart';
import 'package:flutter_net_music/model/banner_module_entity.dart';
import 'package:rxdart/rxdart.dart';

import 'dioHelper.dart';

class ApiService {
  static Future<Map> getBanner()  async{
     return DioUtils.request("/banner?type=1", data: {});
  }
}
