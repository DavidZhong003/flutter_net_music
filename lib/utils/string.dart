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