class MapUtils {
  static dynamic getValueSafe(Map<String, dynamic> map, String key) {
    if (map.containsKey(key)) {
      return map[key];
    }
    return null;
  }
}
