///格式化数字
///
/// <10000 直接返回
/// 大于万
String formattedNumber(int number) {
  if (number < _TEN_THOUSAND) {
    return number.toString();
  }
  if(number >= _ONE_BILLION){
    return "${number/_ONE_BILLION}亿";
  }
  number = number ~/ _TEN_THOUSAND;
  return "$number万";
}

const int _TEN_THOUSAND = 10000;

const int _ONE_BILLION = 100000000;

String durationFormat(Duration duration) {
  if (duration == null) {
    return "";
  }
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  if (duration.inMilliseconds < 0) {
    return "-${-duration}";
  }
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}