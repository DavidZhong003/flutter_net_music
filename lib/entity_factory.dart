import 'package:flutter_net_music/model/banner_module_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "BannerModuleEntity") {
      return BannerModuleEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}