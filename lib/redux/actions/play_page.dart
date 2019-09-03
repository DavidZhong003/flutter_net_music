import 'main.dart';
///请求
class RequestMusicsInfoAction extends ActionType<List<String>> {
  final List<String> ids;
  RequestMusicsInfoAction(this.ids) : super(payload: ids);
}