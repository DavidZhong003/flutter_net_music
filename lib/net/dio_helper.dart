import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_net_music/host.dart';
import 'package:flutter_net_music/net/cookie.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/redux/reducers/main.dart';

class HttpMethod {
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';
}

typedef ErrorHandler = ActionType Function(DioError error);
typedef SuccessHandler = ActionType Function(Map<String,dynamic> data);

class DioUtils {
  /// global dio object
  static Dio dio;

  /// default options
  static const String API_PREFIX = HOST;
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 8000;

  /// request method
  static Future<Map<String,dynamic>> request(String url,
      {data,
      String method,
      SuccessHandler successHandler,
      ErrorHandler errorHandler}) async {
    data = data ?? {};
    method = method ?? HttpMethod.GET;
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    Dio dio = await createInstance();
    var result;
    try {
      Response response = await dio.request(url,
          data: data, options: new Options(method: method));
      result = response.data;
      if(result["code"]!=null){
        if(result["code"]==200){
          if(successHandler!=null){
            StoreContainer.dispatch(successHandler(result));
          }
        }else if(result["code"]==301){
          //todo 需要登录
        }
      }
    } on DioError catch (e) {
      if (errorHandler != null) {
        StoreContainer.dispatch(errorHandler(e));
      }
    }

    return result;
  }

  /// 创建 dio 实例对象
  static Future<Dio> createInstance() async {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: API_PREFIX,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = new Dio(options);
      var directory = await getCookieDirectory();
      dio.interceptors
        ..add(CookieManager(PersistCookieJar(dir: directory.path)))
        ..add(LogInterceptor());
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }
}
