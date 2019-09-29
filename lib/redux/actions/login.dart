import 'main.dart';

///登录成功state
class LoginSuccessAction extends ActionType<Map<String,dynamic>> {
  final Map<String,dynamic> data;

  LoginSuccessAction(this.data) : super(payload: data);
}
/// 从sp 获取用户信息
class InitUserAction extends VoidAction {}

class LogoutAction extends VoidAction{}