import 'package:flustars/flustars.dart';
import 'dart:convert';

class SpHelper {
  static const _USER = "_user";

  static const _USER_SONG_LIST_CREATE = "_user_list_create";

  static void init() {
    SpUtil.getInstance();
  }

  ///
  /// 存储sp
  static void saveUserInfo(Map<String, dynamic> user) {
    SpUtil.putString(_USER, jsonEncode(user));
  }

  /// 存储sp
  static Map<String, dynamic> getUserInfo() {
    String json = SpUtil.getString(_USER, defValue: "");
    if (json.isEmpty) {
      return {};
    }
    return jsonDecode(json);
  }

  static void cleanUserInfo() {
    SpUtil.putString(_USER, "");
  }

  static void saveUserSongListInfo(Map<String, dynamic> user) {
    SpUtil.putString(_USER_SONG_LIST_CREATE, jsonEncode(user));
  }

  static Map<String, dynamic> getUserSongList() {
    String json = SpUtil.getString(_USER_SONG_LIST_CREATE, defValue: "");
    if (json.isEmpty) {
      return {};
    }
    return jsonDecode(json);
  }

  static void cleanUserSongList() {
    SpUtil.putString(_USER_SONG_LIST_CREATE, "");
  }
}
