import 'package:flustars/flustars.dart';
import 'dart:convert';

class SpHelper{
  static const _USER = "_user";

  static void init(){
    SpUtil.getInstance();
  }
  ///
  /// 存储sp
  static void saveUserInfo(Map<String,dynamic> user){
    SpUtil.putString(_USER, jsonEncode(user));
  }
  /// 存储sp
  static Map<String,dynamic> getUserInfo(){
    String json= SpUtil.getString(_USER,defValue: "");
    if(json.isEmpty){
      return {};
    }
    return jsonDecode(json);
  }
}