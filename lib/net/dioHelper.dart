import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_net_music/host.dart';
import 'package:flutter_net_music/net/cookie.dart';

class HttpMethod {
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';
}

typedef ErrorHandler = void Function(DioError error);
typedef SuccessHandler = void Function(Response response);

class DioUtils {
  /// global dio object
  static Dio dio;

  /// default options
  static const String API_PREFIX = HOST;
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

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

    Dio dio = createInstance();
    var result;
    try {
      Response response = await dio.request(url,
          data: data, options: new Options(method: method));
      if (successHandler != null) {
        successHandler(response);
      }
      result = response.data;
    } on DioError catch (e) {
      if (errorHandler != null) {
        errorHandler(e);
      }
    }

    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: API_PREFIX,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = new Dio(options);
      dio.interceptors
        ..add(CookieManager(PersistCookieJar(dir: cookie.path)))
        ..add(LogInterceptor());
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }
}
